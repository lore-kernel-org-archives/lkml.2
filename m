Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1L0IEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:04:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54280 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750976Ab1L0IEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:04:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//gvNqwJ3/vky5gx/40QG7Kp8WVYjf5PhvdxslqG
	voG8c/P9BDzimQ
Subject: Re: Commit 1e5a74059f9 broke utime measurement of ptraced()
 processes
From: Mike Galbraith <efault@gmx.de>
To: =?UTF-8?Q?=D0=90=D1=80=D1=82=D0=B5=D0=BC_?=
	 =?UTF-8?Q?=D0=90=D0=BD=D0=B8=D1=81=D0=B8=D0=BC=D0=BE=D0=B2?= 
	<aanisimov@inbox.ru>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <201112271130.36907.aanisimov@inbox.ru>
References: <201112191519.40901.aanisimov@inbox.ru>
	 <201112241026.35726.aanisimov@inbox.ru>
	 <1324712566.5025.12.camel@marge.simson.net>
	 <201112271130.36907.aanisimov@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Dec 2011 09:04:11 +0100
Message-ID: <1324973051.5217.112.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 11:30 +0300, Артем Анисимов wrote:
> On Saturday 24 December 2011 10:42:46, Mike Galbraith wrote :
> 
> > 
> > >   Also I'd like to know if there is a way to get reliable utime
> > >   measurements in recent kernels.
> > 
> > If wakeup preemption is undesirable, you could run SCHED_BATCH.
> 
> > CPU utilization shifts with wakeup preemption, so there will be visible
> > effect when you change wakeup preemption in any way.
> 
>   Thanks, SCHED_BATCH does solve my problem. I'd like to modify the man page 
> times (2) so that it includes a warning on utime of processes that wake each 
> other. Do you find the following note correct?

Yeah, guess so.  I'd leave out the "hand a few wakeup expense...",
that's just a small side effect of not wasting cycles doing very nearly
back to back clock updates for no good reason.  The important thing to
note is that utilization is affected by sleep/wakeup patterns.

> ----- to be added to times (2) -----
>   On Linux, the user time of a process depends on pattern of wakeups of the 
> process. The scheduler is permitted to cut waker's CPU usage and hand a few 
> wakeup expense cycles to the wakee that preempted. As a consequence, if two 
> processes A and B wake each other frequently (e.g., they communicate via 
> pipes, or by sending signals) then only the collective user time of A and B is 
> well defined; individual user times of A and B can be arbitrarily 
> redistributed between them. If this behaviour is undesirable then both 
> processes need to use the SCHED_BATCH scheduler class, see 
> sched_setscheduler(2).
> ----- to be added to times (2) -----


