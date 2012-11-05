Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2KEX0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:26:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45276 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2KEXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:24 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 043/104] drivers/cpufreq: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:00 -0800
Message-Id: <1352156701-4038-44-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/cpufreq/Kconfig.arm |    4 ++--
 drivers/cpufreq/Kconfig.x86 |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 5961e64..b63c335 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -21,8 +21,8 @@ config ARM_S3C2416_CPUFREQ
 	  If in doubt, say N.
 
 config ARM_S3C2416_CPUFREQ_VCORESCALE
-	bool "Allow voltage scaling for S3C2416 arm core (EXPERIMENTAL)"
-	depends on ARM_S3C2416_CPUFREQ && REGULATOR && EXPERIMENTAL
+	bool "Allow voltage scaling for S3C2416 arm core"
+	depends on ARM_S3C2416_CPUFREQ && REGULATOR
 	help
 	  Enable CPU voltage scaling when entering the dvs mode.
 	  It uses information gathered through existing hardware and
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 934854a..0715d8e 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -174,7 +174,7 @@ config X86_SPEEDSTEP_ICH
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
@@ -206,7 +206,7 @@ config X86_P4_CLOCKMOD
 
 config X86_CPUFREQ_NFORCE2
 	tristate "nVidia nForce2 FSB changing"
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
 	  platforms.
@@ -242,7 +242,7 @@ config X86_LONGHAUL
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
 	  does not have any safeguards to prevent operating the CPU out of spec
-- 
1.7.9.5

