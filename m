Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab0HSC2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:28:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0HSC2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:28:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51500925"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCHv2 2/1] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Date: Wed, 18 Aug 2010 19:28:18 -0700
Message-Id: <1282184898-30599-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1.66.g0d0ba
In-Reply-To: <201008181428.45029.arnd@arndb.de>
References: <201008181428.45029.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help text for this config is duplicated across the x86,
parisc, s390, and arm Kconfig.debug files. Arnd Bergman noted
that the help text was slightly misleading and should be fixed to
state that enabling this option isn't a problem when using pre 4.4
gcc.

To simplify the rewording, consolidate the text into
lib/Kconfig.debug and modify it there to be more explicit about
when you should say N to this config.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
---

This depends on a patch sent to the arm mailing list adding
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS to ARM.

LKML: http://lkml.org/lkml/2010/8/17/535

 arch/arm/Kconfig.debug    |   15 ++-------------
 arch/parisc/Kconfig.debug |   15 ++-------------
 arch/s390/Kconfig.debug   |   14 ++------------
 arch/x86/Kconfig.debug    |   15 ++-------------
 lib/Kconfig.debug         |   16 ++++++++++++++++
 5 files changed, 24 insertions(+), 51 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 64e33b8..326c7f1 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -128,18 +128,7 @@ config DEBUG_S3C_UART
 	  The uncompressor code port configuration is now handled
 	  by CONFIG_S3C_LOWLEVEL_UART_PORT.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict user copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	help
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time errors.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	def_bool y
 
 endmenu
diff --git a/arch/parisc/Kconfig.debug b/arch/parisc/Kconfig.debug
index 7305ac8..b13e8d0 100644
--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -12,18 +12,7 @@ config DEBUG_RODATA
          portion of the kernel code won't be covered by a TLB anymore.
          If in doubt, say "N".
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	def_bool y
 
 endmenu
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 45e0c61..6df8e30 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -6,17 +6,7 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict user copy size checks"
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time warnings.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	def_bool y
 
 endmenu
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7508508..d24afa3 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -285,18 +285,7 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	def_bool y
 
 endmenu
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9e06b7f..bbb1ac5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1013,6 +1013,22 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict user copy size checks"
+	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	help
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time warnings/errors.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, or if you run an older (pre 4.4) gcc where this option
+	  is a no-op, say N.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

