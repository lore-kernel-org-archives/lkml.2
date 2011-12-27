Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1L0H1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 02:27:25 -0500
Received: from info.dorms.msu.net ([93.180.4.5]:39633 "EHLO dorms.msu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1L0H1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 02:27:18 -0500
From: =?utf-8?b?0JDRgNGC0LXQvCDQkNC90LjRgdC40LzQvtCy?= 
	<aanisimov@inbox.ru>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Commit 1e5a74059f9 broke utime measurement of ptraced() processes
Date: Tue, 27 Dec 2011 11:30:36 +0300
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc7+; KDE/4.5.95; i686; ; )
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
References: <201112191519.40901.aanisimov@inbox.ru> <201112241026.35726.aanisimov@inbox.ru> <1324712566.5025.12.camel@marge.simson.net>
In-Reply-To: <1324712566.5025.12.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112271130.36907.aanisimov@inbox.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 December 2011 10:42:46, Mike Galbraith wrote :

> 
> >   Also I'd like to know if there is a way to get reliable utime
> >   measurements in recent kernels.
> 
> If wakeup preemption is undesirable, you could run SCHED_BATCH.

> CPU utilization shifts with wakeup preemption, so there will be visible
> effect when you change wakeup preemption in any way.

  Thanks, SCHED_BATCH does solve my problem. I'd like to modify the man page 
times (2) so that it includes a warning on utime of processes that wake each 
other. Do you find the following note correct?

----- to be added to times (2) -----
  On Linux, the user time of a process depends on pattern of wakeups of the 
process. The scheduler is permitted to cut waker's CPU usage and hand a few 
wakeup expense cycles to the wakee that preempted. As a consequence, if two 
processes A and B wake each other frequently (e.g., they communicate via 
pipes, or by sending signals) then only the collective user time of A and B is 
well defined; individual user times of A and B can be arbitrarily 
redistributed between them. If this behaviour is undesirable then both 
processes need to use the SCHED_BATCH scheduler class, see 
sched_setscheduler(2).
----- to be added to times (2) -----
