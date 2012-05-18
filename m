Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754Ab2ERRNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:23 -0400
Received: from www.tglx.de ([62.245.132.106]:59997 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680Ab2ERRNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:11 -0400
Message-Id: <20120518163104.499615021@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:43 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 01/24] timers: Provide generic Kconfig switches
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=timers-add-generic-kconfig-options.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We really don't want all the arch code defining stuff
over and over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
---
 kernel/time/Kconfig |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: tip/kernel/time/Kconfig
===================================================================
--- tip.orig/kernel/time/Kconfig
+++ tip/kernel/time/Kconfig
@@ -33,3 +33,34 @@ config GENERIC_CLOCKEVENTS_BUILD
 
 config GENERIC_CLOCKEVENTS_MIN_ADJUST
 	bool
+
+# Options selectable by arch Kconfig
+
+# Watchdog function for clocksources to detect instabilities
+config CLOCKSOURCE_WATCHDOG
+	bool
+
+# Architecture has extra clocksource data
+config ARCH_CLOCKSOURCE_DATA
+	bool
+
+# Timekeeping vsyscall support
+config GENERIC_TIME_VSYSCALL
+	bool
+
+# ktime_t scalar 64bit nsec representation
+config KTIME_SCALAR
+	bool
+
+# Old style timekeeping
+config ARCH_USES_GETTIMEOFFSET
+	bool
+
+# The generic clock events infrastructure
+config GENERIC_CLOCKEVENTS
+	bool
+
+# Clockevents broadcasting infrastructure
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	depends on GENERIC_CLOCKEVENTS


