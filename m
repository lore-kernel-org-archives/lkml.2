Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2ERRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:16:26 -0400
Received: from www.tglx.de ([62.245.132.106]:60001 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965720Ab2ERRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:19 -0400
Message-Id: <20120518163106.987564297@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:54 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/24] sparc: Use: generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=sparc-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/Kconfig |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux/arch/sparc/Kconfig
===================================================================
--- linux.orig/arch/sparc/Kconfig
+++ linux/arch/sparc/Kconfig
@@ -30,11 +30,13 @@ config SPARC
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
+	select GENERIC_CMOS_UPDATE
 
 config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select ARCH_USES_GETTIMEOFFSET
 
 config SPARC64
 	def_bool 64BIT
@@ -61,6 +63,7 @@ config SPARC64
 	select IRQ_PREFLOW_FASTEOI
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
+	select GENERIC_CLOCKEVENTS
 
 config ARCH_DEFCONFIG
 	string
@@ -73,18 +76,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config ARCH_USES_GETTIMEOFFSET
-	bool
-	default y if SPARC32
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y if SPARC64
-
 config IOMMU_HELPER
 	bool
 	default y if SPARC64


