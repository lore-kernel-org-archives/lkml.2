Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2ARJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:23:29 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:35811 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab2ARJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:23:27 -0500
Message-ID: <4F168F8C.8090504@gmail.com>
Date: Wed, 18 Jan 2012 04:23:24 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon> <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com> <20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com> <m1obu29fnf.fsf@fess.ebiederm.org> <20120118080103.GA2889@moon> <4F168CF3.5090400@gmail.com> <4F168E93.5010000@parallels.com>
In-Reply-To: <4F168E93.5010000@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/18/12 4:19 AM), Pavel Emelyanov wrote:
>> I think Eric only said gt/lt compare is useful. We don't need to expose bare
>> pointer order. example, kcmp(rotate(ptr, per-task-random-value)) is enough
>> hide the critical information. I think.
>
> The per-task might break thinks up in case
>
> (tsk1->file != tsk2->file)&&  (rotate(tsk1->file, tsk1->random) == rotate(tsk2->file, tsk2->rotate))

I meant,

(tsk1->file != tsk2->file) && (rotate(tsk1->file, caller_task->random) == rotate(tsk2->file, caller_task->random))



>
> but I agree, that the overall idea of comparing not bare pointers, but those poisoned with
> some global value can address the Peter's concerns about rootkits.


