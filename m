Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383Ab2GKWGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:06:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:35499 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2GKWFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:20 -0400
Message-Id: <20120711215611.837510935@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: [patch RT 3/7] Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
References: <20120711214552.036760674@linutronix.de>
Content-Disposition: inline;
 filename=disable-rt_group_sched-in-preempt_rt_full.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strange CPU stalls have been observed in RT when RT_GROUP_SCHED
was configured.

Disable it for now.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.4.4-rt13-64+/init/Kconfig
===================================================================
--- linux-3.4.4-rt13-64+.orig/init/Kconfig
+++ linux-3.4.4-rt13-64+/init/Kconfig
@@ -746,6 +746,7 @@ config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
+	depends on !PREEMPT_RT_FULL
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth





