Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1ADH2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:28:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63017 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1ADH2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BcswVZHRXKtp8M56agqh/EEGGxAq7lpguFaj8c26U0EuL0shWISlE1MuYGU0thzZfG
         mgIeLaOIFcW9aGeQogoM1H2LsfHbQvZ7e4Y1BR8qGr0Nbnn8pJnPGnpFRQm+RD2Z26eZ
         4QnAj9AQiMWy1dvZv2BXQuhr13vTmVaS3Tdb0=
MIME-Version: 1.0
In-Reply-To: <20110103154918.GB7632@redhat.com>
References: <20101224122338.172750730@chello.nl>
	<20101224123742.887559254@chello.nl>
	<20101229143136.GC2728@zhy>
	<1294053409.2016.59.camel@laptop>
	<20110103145902.GA7632@redhat.com>
	<1294068061.2016.84.camel@laptop>
	<20110103154918.GB7632@redhat.com>
Date: Tue, 4 Jan 2011 15:27:59 +0800
Message-ID: <AANLkTikj=t0s9MfiG85gR+JkTSBa_F9yFmu1R2rTuHv_@mail.gmail.com>
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to sched_class::select_task_rq()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 11:49 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Ah, sorry for the confusion, I only meant sched_exec() case.
> set_cpus_allowed_ptr() does need need_migrate_task(), of course.
>
>
> As for set_cpus_allowed_ptr()->need_migrate_task() path, I have another
> question,
>
>        static bool need_migrate_task(struct task_struct *p)
>        {
>                /*
>                 * If the task is not on a runqueue (and not running), then
>                 * the next wake-up will properly place the task.
>                 */
>                smp_rmb(); /* finish_lock_switch() */
>                return p->on_rq || p->on_cpu;
>        }
>
> I don't understand this smp_rmb(). Yes, finish_lock_switch() does
> wmb() before it clears ->on_cpu, but how these 2 barriers can pair?
>
> In fact, I am completely confused. I do not understand why do we
> check task_running() at all. If we see on_rq == 0 && on_cpu == 1,
> then this task is going to clear its on_cpu soon, once it finishes
> context_switch().
>
> Probably, this check was needed before, try_to_wake_up() could
> activate the task_running() task without migrating. But, at first
> glance, this is no longer possible after this series?

Yeah, task_running() is not needed after patch 13 which
may be the suitable place to poke :)

Thanks,
Yong

-- 
Only stand for myself
