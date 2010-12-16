Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0LPPOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:14:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:40705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0LPPOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:14:20 -0500
Message-Id: <20101216145602.899838254@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 16 Dec 2010 15:56:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here a new posting of my scary patch(es) ;-)

These actually survive a sembench run (and everything else I threw at it).
The discussion between Mike and Frank over the task_running() check made me
realize what was wrong with the previous one.

As it turns out, what was needed (p->oncpu) was something Thomas wanted me
to do for an entirely different reason (see patch #2).

Frank's patch, while encouraging me to poke at it again, has a number of
very fundamental problems with it, the most serious one being that it
completely wrecks the wake-up load-balancing.

I'll try and come up with a way to unwreck the 32bit select_task_rq_fair()
problem, but for now inspiration in that departments seems lacking, yet I
still wanted to share these patches so that others can have a go at them.

If all you care about is the numbers, skip to patch #5.

