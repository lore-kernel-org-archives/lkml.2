Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab2IUTAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:00:01 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:34728 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab2IUS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:59:59 -0400
Date: Fri, 21 Sep 2012 18:59:58 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1209211855500.8839@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com> <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com> <20120920232114.GO2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Just did a test with CONFIG_NO_HZ=n, and no rcu_sched stall messages 
appeared for 60 minutes.

Following is the diff from omap2plus_defconfig.

- Paul

--- .config	2012-09-21 12:51:19.114938954 -0600
+++ .testconfig	2012-09-21 12:51:15.686926318 -0600
@@ -69,7 +69,7 @@
 # Timers subsystem
 #
 CONFIG_TICK_ONESHOT=y
-CONFIG_NO_HZ=y
+# CONFIG_NO_HZ is not set
 CONFIG_HIGH_RES_TIMERS=y
 
 #
@@ -80,7 +80,6 @@
 CONFIG_RCU_FANOUT=32
 CONFIG_RCU_FANOUT_LEAF=16
 # CONFIG_RCU_FANOUT_EXACT is not set
-# CONFIG_RCU_FAST_NO_HZ is not set
 # CONFIG_TREE_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -2535,7 +2534,7 @@
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
-# CONFIG_RCU_CPU_STALL_INFO is not set
+CONFIG_RCU_CPU_STALL_INFO=y
 # CONFIG_RCU_TRACE is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set

