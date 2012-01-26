Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2AZVVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:21:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34738 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2AZVVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <1327486224.2614.45.camel@laptop>
References: <1324633794.24803.48.camel@twins> <20111223154137.GA27901@redhat.com>
 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com> <20111226171151.GA4472@redhat.com>
 <4EFB8523.6080708@gmail.com> <1327486224.2614.45.camel@laptop>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 26 Jan 2012 16:21:30 -0500
Message-ID: <CAHGf_=pLJcoSuKZb+P0c_7uW16hO35cMkQfJQB1SUJt8uLkGYw@mail.gmail.com>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/25 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2011-12-28 at 16:07 -0500, KOSAKI Motohiro wrote:
>>
>> CPU0                    CPU1
>> --------------------------------------------------------
>> deactivate_task()
>>                         task->state = TASK_UNINTERRUPTIBLE;
>> activate_task()
>>    rq->nr_uninterruptible--;
>>
>>                         schedule()
>>                           deactivate_task()
>>                             rq->nr_uninterruptible++;
>>
>>
>
> Hmm, I think you're right, when CPU0 does __sched_setscheduler() on the
> task running on CPU1 and CPU1's @task is current.
>
> I think only __sched_setscheduler() is really a problem, the other
> activate/deactivate users not schedule or wakeup are __migrate_task()
> and normalize_task().
>
> __migrate_task() will only run on tasks that aren't actually running
> anywhere so the above scenario can't happen, normalize_task() is never
> used on normal systems (sysrq-n).
>
> So I guess the below cures things and cleans up a bit.. no?

Sorry for the delay. Yeah, I think this should work. (even though I
don't understand __migrate_task() detail)

Thank you!

Ack-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
