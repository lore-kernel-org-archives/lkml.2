Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab0FCAq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:46:28 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:60995 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab0FCAq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tk4LPxt0qYRj7AZo8e5qkzQkEBs1DKMKw6oB4a11w0FbHmtNAeixHjwU/Q/cRolKZo
         l3Xjmvp1w8vs1BDhSSUSu84fpgAmplF/8dyZT8pwX8lIE3zVrv2lYa9pntGpZGr4jWyF
         K2ftLN30pWAbhTB0HTR2+uO6zK+2Lc3Cy2wxY=
MIME-Version: 1.0
In-Reply-To: <20100603093548.7237.A69D9226@jp.fujitsu.com>
References: <20100603084829.7234.A69D9226@jp.fujitsu.com>
	<AANLkTilBq_dRXW1u56gbqc3Z5fU1I66UiFiQbbRU_2Ur@mail.gmail.com>
	<20100603093548.7237.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 09:46:24 +0900
Message-ID: <AANLkTinez8RX4rADp42f03AocWe2c0zimLQ7aT65nM1d@mail.gmail.com>
Subject: Re: [PATCH 5/5] oom: dump_tasks() use find_lock_task_mm() too
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:41 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Thu, Jun 3, 2010 at 9:06 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > -           mm = p->mm;
>> >> > -           if (!mm) {
>> >> > -                   /*
>> >> > -                    * total_vm and rss sizes do not exist for tasks with no
>> >> > -                    * mm so there's no need to report them; they can't be
>> >> > -                    * oom killed anyway.
>> >> > -                    */
>> >>
>> >> Please, do not remove the comment for mm newbies unless you think it's useless.
>> >
>> > How is this?
>> >
>> >               task = find_lock_task_mm(p);
>> >               if (!task)
>> >                        /*
>> >                         * Probably oom vs task-exiting race was happen and ->mm
>> >                         * have been detached. thus there's no need to report them;
>> >                         * they can't be oom killed anyway.
>> >                         */
>> >                        continue;
>> >
>>
>> Looks good to adding story about racing. but my point was "total_vm
>> and rss sizes do not exist for tasks with no mm". But I don't want to
>> bother you due to trivial.
>> It depends on you. :)
>
>
> old ->mm check have two intention.
>
>   a) the task is kernel thread?
>   b) the task have alredy detached ->mm
> but a) is not strictly correct check because we should think use_mm().
> therefore we appended PF_KTHREAD check. then, here find_lock_task_mm()
> focus exiting race, I think.
>

No objection.

-- 
Kind regards,
Minchan Kim
