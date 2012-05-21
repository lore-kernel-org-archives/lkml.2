Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2EUJYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:24:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2EUJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:24:10 -0400
Date: Mon, 21 May 2012 02:23:42 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-ded1cc5cfc3b4bc007fe3bb8fbfd9e66d8d667d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, anna-maria@glx-um.de,
        davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, anna-maria@glx-um.de,
        davem@davemloft.net
In-Reply-To: <20120518163106.987564297@glx-um.de>
References: <20120518163106.987564297@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] sparc: Use: generic time config
Git-Commit-ID: ded1cc5cfc3b4bc007fe3bb8fbfd9e66d8d667d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:23:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ded1cc5cfc3b4bc007fe3bb8fbfd9e66d8d667d7
Gitweb:     http://git.kernel.org/tip/ded1cc5cfc3b4bc007fe3bb8fbfd9e66d8d667d7
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:54 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

sparc: Use: generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120518163106.987564297@glx-um.de
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/Kconfig |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6c0683d..33399d3 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
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
