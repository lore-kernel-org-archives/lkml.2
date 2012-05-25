Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab2EYWJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:09:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:40138 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab2EYWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:08:58 -0400
Message-Id: <20120525214617.051888729@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 May 2012 22:08:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 0/4] timers: Fix get_next_timer_interrupt() proper
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series was inspired by the patch Gilad sent to fix a shortcoming
in get_next_timer_interrupt().

Instead of working around the problem I think it's better to avoid it
completely.

The fix is on top of a consolidation of the mindlessly copied code in
various timer API functions. Even with the added functionality that
makes the obj code footprint shrink

  text	   data	    bss	    dec	    hex	filename
  18589	   3682	   8257	  30528	   7740	../build/kernel/timer.o
  17997	   3682	   8257	  29936	   74f0	../build/kernel/timer.o

Thanks,

	tglx
----
 timer.c |  110 +++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 61 insertions(+), 49 deletions(-)

