Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2GIHHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:07:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37875 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2GIHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <1341816515.3462.3.camel@twins>
References: <87zk7cgm6u.fsf@sejong.aot.lge.com> <1341710959.2783.2.camel@acer.local.home>
 <87obnp92r8.fsf@sejong.aot.lge.com> <1341816515.3462.3.camel@twins>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 9 Jul 2012 16:07:23 +0900
X-Google-Sender-Auth: 1iOJq8-Czgdgx6yEIXAjwfpXMQ8
Message-ID: <CAM9d7cheHNq19oa9baHWbNogqmgeMHUkvcYwGqQ_Co1OhTUkRw@mail.gmail.com>
Subject: Re: [Question] sched/rt_mutex: re-enqueue_task on rt_mutex_setprio()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 3:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-07-09 at 09:50 +0900, Namhyung Kim wrote:
>> On Sat, 07 Jul 2012 21:29:19 -0400, Steven Rostedt wrote:
>> > On Sat, 2012-07-07 at 14:44 +0900, Namhyung Kim wrote:
>> >> Hi,
>> >>
>> >> I have a question on the code below:
>> >>
>> >> void rt_mutex_setprio(struct task_struct *p, int prio)
>> >> {
>> >>         ...
>> >>    if (on_rq)
>> >>            enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
>> >>
>> >> When enqueueing @p with new @prio, it seems put @p at the head of a
>> >> rq if appropriate. I guess it's the case of boosting @p with higher
>> >> priority, right?
>> >
>> > Actually, no. We put @p at the head of the queue when unboosting. If a
>> > task is going from a high priority into a lower priority, it is still
>> > treated as "important" for that priority, and is put to the front of the
>> > queue (it was just higher than everything else on that queue). But if we
>> > are boosting a task from a low priority, why put it to the head of other
>> > tasks of its new priority, when those tasks were just higher than this
>> > task, and this task is now just an "equal".
>>
>> Thanks for the explanation. (Isn't it worth getting commented?) :)
>
> Possibly, note that this part is well spec'ed by POSIX, see
>
> http://pubs.opengroup.org/onlinepubs/009695299/functions/xsh_chap02_08.html
>
> SCHED_FIFO.8

Thanks for the pointer. I need to educate myself a lot more!

Thanks,
Namhyung
