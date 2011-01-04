Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1ADF7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:59:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42084 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1ADF7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sMv35vAzay32MfOnp9SjFuGz7Ih+TaGvkgjwOPIeALmX9qQdUFEIs4ve7toFJTaTGP
         0b0LZrDj4E+wnPx0PTBrAESZ35cYzVJ1zy5CupkELvsBDzKlX0wSEpdnM+jgwYq5S7BX
         bLtQXENXHwpRPbUFcGhvdp5tLShsOTcr/VNWI=
MIME-Version: 1.0
In-Reply-To: <1294053409.2016.59.camel@laptop>
References: <20101224122338.172750730@chello.nl>
	<20101224123742.887559254@chello.nl>
	<20101229143136.GC2728@zhy>
	<1294053409.2016.59.camel@laptop>
Date: Tue, 4 Jan 2011 13:59:18 +0800
Message-ID: <AANLkTimZB8M7BXfNmOmwN4aeP+YtWLp=WgdDOzKUOKOF@mail.gmail.com>
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to sched_class::select_task_rq()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 7:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-29 at 22:31 +0800, Yong Zhang wrote:
>> On Fri, Dec 24, 2010 at 01:23:46PM +0100, Peter Zijlstra wrote:
>> > In preparation of calling select_task_rq() without rq->lock held, drop
>> > the dependency on the rq argument.
>> >
>> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> > ---
>> > @@ -3416,27 +3409,22 @@ void sched_exec(void)
>> >  {
>> >     struct task_struct *p = current;
>> >     unsigned long flags;
>> > -   struct rq *rq;
>> >     int dest_cpu;
>> >
>> > -   rq = task_rq_lock(p, &flags);
>> > -   dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
>> > +   raw_spin_lock_irqsave(&p->pi_lock, flags);
>>
>> Seems this should go to patch 07/17 ;)
>
> Ah, the reason its here is that this patch removes the rq argument and
> thus we no longer need rq->lock. So this part relies on the property
> introduced by patch 7.

What I mean is we could firstly add pi_lock in patch 7 and then remove
the rq argument in this patch. :)

Thanks,
Yong

-- 
Only stand for myself
