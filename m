Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2EUJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2EUJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:09:58 -0400
Date: Mon, 21 May 2012 02:09:25 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-3d92a71a4467681ef6a47e10447d200b52c78af8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163104.760560327@glx-um.de>
References: <20120518163104.760560327@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] arm: Use generic time config
Git-Commit-ID: 3d92a71a4467681ef6a47e10447d200b52c78af8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:09:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d92a71a4467681ef6a47e10447d200b52c78af8
Gitweb:     http://git.kernel.org/tip/3d92a71a4467681ef6a47e10447d200b52c78af8
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:41 +0200

arm: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Russell King <linux@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20120518163104.760560327@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/Kconfig |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 36586dba..feccc1d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
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
