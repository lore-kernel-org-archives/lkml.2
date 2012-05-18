Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731Ab2ERRRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:17:15 -0400
Received: from www.tglx.de ([62.245.132.106]:59996 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654Ab2ERRNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:10 -0400
Message-Id: <20120518163104.760560327@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:44 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 03/24] arm: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=arm-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

Index: linux/arch/arm/Kconfig
===================================================================
--- linux.orig/arch/arm/Kconfig
+++ linux/arch/arm/Kconfig
@@ -34,6 +34,8 @@ config ARM
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
+	select KTIME_SCALAR
+	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -57,22 +59,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config GENERIC_GPIO
 	bool
 
-config ARCH_USES_GETTIMEOFFSET
-	bool
-	default n
-
-config GENERIC_CLOCKEVENTS
-	bool
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	depends on GENERIC_CLOCKEVENTS
-	default y if SMP
-
-config KTIME_SCALAR
-	bool
-	default y
-
 config HAVE_TCM
 	bool
 	select GENERIC_ALLOCATOR


