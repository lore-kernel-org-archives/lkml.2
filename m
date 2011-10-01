Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1JAUIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:08:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab1JAUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
Date: Sat,  1 Oct 2011 22:03:49 +0200
Message-Id: <1317499438-14058-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TilcBFSy7cLdintIMjs4MlTR4OZDTMR4TLkE6c42ght
 icie32DvHpB719MeDFS/hQ8cud6K1TKL10PSrSAkdYVVnJR0H1
 diJ1afBeGIh+GblV79+jDEo30ohXZk3ttwkh/Ip96XmqArlRGf
 Hp6WiiJTSUhNbKmAlnhzBgZaPzXIoa0lVYGu4vUnGxTxd4ey7/
 GasegMZjL5auhtZe75NQdw8cakWHLZTS6A2uejlb2a2N0iRL9T
 KC5RXMsPczRH+4SoVmfQI9YIBkc0/qIZrv+LThquZ4T91wntSX
 9CwEMebPIOlxemcdRCgT851AIDL/8IgLsTgLKhEFCjCQ+gzVF0
 ULXCmKBGOlOxm3ym8HyUfsoChgscKPF0rl0Cjq2yU4oJLeUghO
 aSYdbu8p0E/8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot support ARMv5 and ARMv7 based boards in a single kernel,
so introduce a new option in mach-pxa to select between the two.

The PJ4 (ARMv7) based boards are now only visible when
CONFIG_ARCH_PXA_V7 is set, the other boards are only visible
when it's not set.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index cd19309..bb310d0 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -2,6 +2,27 @@ if ARCH_PXA
 
 menu "Intel PXA2xx/PXA3xx Implementations"
 
+config ARCH_PXA_V7
+	bool "ARMv7 (PXA95x) based systems"
+
+if ARCH_PXA_V7
+comment "Marvell Dev Platforms (sorted by hardware release time)"
+config MACH_TAVOREVB3
+	bool "PXA95x Development Platform (aka TavorEVB III)"
+	select CPU_PXA955
+
+config MACH_SAARB
+	bool "PXA955 Handheld Platform (aka SAARB)"
+	select CPU_PXA955
+endif
+
+config PXA_V7_MACH_AUTO
+	def_bool y
+	depends on ARCH_PXA_V7
+	depends on !MACH_SAARB
+	select MACH_TAVOREVB3
+
+if !ARCH_PXA_V7
 comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 
 config ARCH_LUBBOCK
@@ -41,19 +62,11 @@ config MACH_TAVOREVB
 	select PXA3xx
 	select CPU_PXA930
 
-config MACH_TAVOREVB3
-	bool "PXA95x Development Platform (aka TavorEVB III)"
-	select CPU_PXA950
-
 config MACH_SAAR
 	bool "PXA930 Handheld Platform (aka SAAR)"
 	select PXA3xx
 	select CPU_PXA930
 
-config MACH_SAARB
-	bool "PXA955 Handheld Platform (aka SAARB)"
-	select CPU_PXA955
-
 comment "Third Party Dev Platforms (sorted by vendor name)"
 
 config ARCH_PXA_IDP
@@ -598,7 +611,7 @@ config MACH_ZIPIT2
 	bool "Zipit Z2 Handheld"
 	select PXA27x
 	select HAVE_PWM
-
+endif
 endmenu
 
 config PXA25x
-- 
1.7.5.4

