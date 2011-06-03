Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1FCOag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:30:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47179 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1FCOaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pPOHJpugi4VZVKcegY8+dlb2azOLt9T/UOIVE5LKtri0A0ib9J54uZotmPucRMlkcB
         aRJ7sYs4cEja6++dLdRbI08J6cTqhYjGn/NJM1vwTBbu1afVJ4M2xjgOVA0DRhaVlcUe
         ye8IwZH6EtksL3EQETVinbrCoJQsx48+ht2uE=
MIME-Version: 1.0
In-Reply-To: <1307110767.3667.51.camel@gandalf.stny.rr.com>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
	<1307110767.3667.51.camel@gandalf.stny.rr.com>
Date: Fri, 3 Jun 2011 22:30:33 +0800
Message-ID: <BANLkTim-tr+LAg1pA-wEFvVGiCvOYdfDoQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 10:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-06-01 at 21:58 +0800, Hillf Danton wrote:
>
>> And checking for cache-hot is also added to confirm the comment there.
>
> Please read that comment.
>
>>       cpu = task_cpu(p);
>> @@ -1253,7 +1253,8 @@ static int find_lowest_rq(struct task_struct *task)
>>        * We prioritize the last cpu that the task executed on since
>>        * it is most likely cache-hot in that location.
>>        */
>> -     if (cpumask_test_cpu(cpu, lowest_mask))
>> +     if (cpumask_test_cpu(cpu, lowest_mask) &&
>> +         task_hot(task, task_rq(task)->clock_task, NULL))
>>               return cpu;
>
> What task_hot() checks for and what we are assuming are two different
> things. In fact, we can disable task_hot() so it always fails. That's
> not what we want.
>
> If the task happens to have ran on a CPU that is in the lowest_mask, we
> want that CPU. Time may not matter. If we know a task ran on a
> particular CPU last, we want to run it there if possible. It may still
> have cache lines for it, even if it has been a long time since it last
> ran.
>
Hi Steve

I note the comment related to cache-hot, it is fine for woken task even though
cache-hot is considered to be nop for RT task, but what dose it help pushing
RT tasks waiting on RQ?

thanks
           Hillf
