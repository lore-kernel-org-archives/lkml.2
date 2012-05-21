Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2EUJL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:11:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab2EUJLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:11:25 -0400
Date: Mon, 21 May 2012 02:11:05 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-dfbaec06bd80117f8ed944236efab8fb32cd4f68@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vapier@gentoo.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163105.026597932@glx-um.de>
References: <20120518163105.026597932@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] blackfin: Use generic time config
Git-Commit-ID: dfbaec06bd80117f8ed944236efab8fb32cd4f68
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:11:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfbaec06bd80117f8ed944236efab8fb32cd4f68
Gitweb:     http://git.kernel.org/tip/dfbaec06bd80117f8ed944236efab8fb32cd4f68
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:41 +0200

blackfin: Use generic time config

Use seperate selector for clockevents.

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/20120518163105.026597932@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/blackfin/Kconfig |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 373a690..bc21de2 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
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
