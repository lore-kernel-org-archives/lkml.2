Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2JTTks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:40:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:34016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2JTTkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:40:46 -0400
Date: Sat, 20 Oct 2012 21:40:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.2-rt4
Message-ID: <alpine.LFD.2.02.1210202133470.2719@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.2-rt4 release. rt4 is just an update
to 3.6.2. The not announced 3.6.1-rt3 is an intermediate release with
a single change.

Changes since 3.6.1-rt2:

	* Remove the softirq noise printk

The delta patch against 3.6.1-rt2 is appended below and can be found here

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.1-rt2-rt3.patch.xz

The RT patch against 3.6.2 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.2-rt4.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.2-rt4.tar.xz

Enjoy,

	tglx

---------->

Index: linux-stable/kernel/softirq.c
===================================================================
--- linux-stable.orig/kernel/softirq.c
+++ linux-stable/kernel/softirq.c
@@ -468,8 +468,6 @@ static void do_single_softirq(int which,
  */
 static void do_current_softirqs(int need_rcu_bh_qs)
 {
-	int retry = 0;
-
 	while (current->softirqs_raised) {
 		int i = __ffs(current->softirqs_raised);
 		unsigned int pending, mask = (1U << i);
@@ -496,10 +494,6 @@ static void do_current_softirqs(int need
 		}
 		unlock_softirq(i);
 		WARN_ON(current->softirq_nestcnt != 1);
-		if (++retry == 20) {
-			printk(KERN_ERR "Crap, %s looping forever in softirq\n",
-			       current->comm);
-		}
 	}
 }
 
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt2
+-rt3
