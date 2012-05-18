Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab2ERRSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:18:07 -0400
Received: from www.tglx.de ([62.245.132.106]:59992 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606Ab2ERRNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:00 -0400
Message-Id: <20120518163105.026597932@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:45 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Frysinger <vapier@gentoo.org>
Subject: [patch 05/24] blackfin: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=blackfin-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seperate selector for clockevents.

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux/arch/blackfin/Kconfig
===================================================================
--- linux.orig/arch/blackfin/Kconfig
+++ linux/arch/blackfin/Kconfig
@@ -37,6 +37,7 @@ config BLACKFIN
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
+	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 
 config GENERIC_CSUM
 	def_bool y
@@ -593,9 +594,10 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_CLOCKEVENTS
+config SET_GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
 	default y
+	select GENERIC_CLOCKEVENTS
 
 menu "Clock event device"
 	depends on GENERIC_CLOCKEVENTS
@@ -629,10 +631,6 @@ config GPTMR0_CLOCKSOURCE
 	depends on !TICKSOURCE_GPTMR0
 endmenu
 
-config ARCH_USES_GETTIMEOFFSET
-	depends on !GENERIC_CLOCKEVENTS
-	def_bool y
-
 source kernel/time/Kconfig
 
 comment "Misc"


