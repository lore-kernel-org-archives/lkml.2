Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab1FVRwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:52:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:50485 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab1FVRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:52:15 -0400
Message-Id: <20110622174659.496793734@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 17:52:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 0/4] sched: Move work out of the scheduler core
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block-IO and workqueues have hooks in the scheduler core which have no
strict requirements for being called from irq disabled, preempt
disabled and rq->lock held regions.

The following series moves them outside.

Thanks,

	tglx
---

 block/blk-core.c         |   20 +++-----
 kernel/sched.c           |  106 +++++++++++++++++------------------------------
 kernel/workqueue.c       |   67 ++++++++++++-----------------
 kernel/workqueue_sched.h |    5 --
 4 files changed, 79 insertions(+), 119 deletions(-)


