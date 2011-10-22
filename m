Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1JVKT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:19:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61756 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1JVKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:19:26 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 49/49] genirq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:57:01 +0800
Message-Id: <1319277421-9203-50-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no stuff which depends on IRQF_DISABLED after we
made the tree-wide cleanup. Time to remove it completely.

No too late than 2.6.36 :)

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    7 -------
 include/linux/interrupt.h                  |    3 ---
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3d84912..ad6aac6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -400,13 +400,6 @@ Who:	Netfilter developer team <netfilter-devel@vger.kernel.org>
 
 ----------------------------
 
-What:	IRQF_DISABLED
-When:	2.6.36
-Why:	The flag is a NOOP as we run interrupt handlers with interrupts disabled
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
-----------------------------
-
 What: 	PCI DMA unmap state API
 When:	August 2012
 Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 664544f..74970b0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -42,8 +42,6 @@
  * These flags used only by the kernel as part of the
  * irq handling routines.
  *
- * IRQF_DISABLED - keep irqs disabled when calling the action handler.
- *                 DEPRECATED. This flag is a NOOP and scheduled to be removed
  * IRQF_SAMPLE_RANDOM - irq is used to feed the random generator
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
@@ -60,7 +58,6 @@
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  */
-#define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
-- 
1.7.1

