Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775Ab2ERRRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:17:17 -0400
Received: from www.tglx.de ([62.245.132.106]:59995 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965621Ab2ERRNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:08 -0400
Message-Id: <20120518163106.595607369@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:52 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 17/24] s390: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=s390-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc:  Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/Kconfig |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux/arch/s390/Kconfig
===================================================================
--- linux.orig/arch/s390/Kconfig
+++ linux/arch/s390/Kconfig
@@ -28,12 +28,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y if BUG
 
@@ -122,6 +116,9 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
+	select KTIME_SCALAR if 32BIT
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
@@ -146,9 +143,6 @@ config 64BIT
 config 32BIT
 	def_bool y if !64BIT
 
-config KTIME_SCALAR
-	def_bool 32BIT
-
 config SMP
 	def_bool y
 	prompt "Symmetric multi-processing support"


