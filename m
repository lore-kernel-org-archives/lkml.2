Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1EXNu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:50:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52274 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1EXNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PJaZ55HdPcnpcblMIk5I0js0VR4SC54rh93FnCQi159QlLz79RxR4W7+CGkMoSigC9
         WatEjy6cS5LsLwTwpZHB2O2M/2OpULQhQSmrUhetPNBf0yDtwuyGW2x6hjcoLlHcHrSU
         wzuq/CpVHH/BJnebUXhYk4el+UcSzGU0qP7+w=
MIME-Version: 1.0
In-Reply-To: <1306244383.1465.59.camel@gandalf.stny.rr.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	<1306244383.1465.59.camel@gandalf.stny.rr.com>
Date: Tue, 24 May 2011 21:50:56 +0800
Message-ID: <BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix need_resched() when checking peempt
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 9:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
>> When checking if current task could be preempted by a newly woken task,
>> further check could be bypassed if the current thread is different from
>> the current task of run-queue, and it is corrected accordingly.
>
> Ug, that change log is an obfuscated mess. But looking at the actual
> patch, I figured what you wanted to say. How about this:
>
> ----
> The RT preempt check tests the wrong task if NEED_RESCHED is set. It
> currently checks the local CPU task. It is suppose to check the task
> that is running on the run queue we are about to wake another task on.
> ----
>
Thanks, it is great changelog:)

Hillf
