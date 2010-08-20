Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0HTA3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:29:51 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:52722 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HTA3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:29:49 -0400
X-MXL-Hash: 4c6dcc7c203109a2-740cc25f83912cdee34ce31a4d3a4fbbc31dd573
X-MXL-Hash: 4c6dcc7017cad26d-e7137094067f7b05084c809eeb3b40b93a4a6980
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd/ubi: cleanup and simplify Kconfig
Date: Thu, 19 Aug 2010 17:28:50 -0700
User-Agent: KMail/1.9.9
CC: linux-mtd <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>,
        <dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201008191728.50871.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=9TChiO1DnugA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=pGLkceISAAAA:8 a=uIB-NUVFncx22Onj1VoA:9 a=Wx]
X-AnalysisOut: [dn6nkqjou4DY-avP0A:7 a=PMkJkSTfLHIM9965grQJtCOyA3EA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=MSl-tD]
X-AnalysisOut: [qOz04A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the Kconfig for UBI by using menuconfig to enable/disable the entire
driver. Remove the dependency checks for MTD_UBI and MTD_UBI_DEBUG by
wrapping the options in if/endif blocks and remove any redundant checks.
Remove all default n since that is the Kconfig default. Change menu "Additional
UBI debugging messages" into a comment to remove one menu level.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>

---

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index f702a16..3cf193f 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -1,9 +1,5 @@
-menu "UBI - Unsorted block images"
-	depends on MTD
-
-config MTD_UBI
-	tristate "Enable UBI"
-	depends on MTD
+menuconfig MTD_UBI
+	tristate "Enable UBI - Unsorted block images"
 	select CRC32
 	help
 	  UBI is a software layer above MTD layer which admits of LVM-like
@@ -12,11 +8,12 @@ config MTD_UBI
 	  capabilities. Please, consult the MTD web site for more details
 	  (www.linux-mtd.infradead.org).
 
+if MTD_UBI
+
 config MTD_UBI_WL_THRESHOLD
 	int "UBI wear-leveling threshold"
 	default 4096
 	range 2 65536
-	depends on MTD_UBI
 	help
 	  This parameter defines the maximum difference between the highest
 	  erase counter value and the lowest erase counter value of eraseblocks
@@ -34,7 +31,6 @@ config MTD_UBI_BEB_RESERVE
 	int "Percentage of reserved eraseblocks for bad eraseblocks handling"
 	default 1
 	range 0 25
-	depends on MTD_UBI
 	help
 	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
 	  reserves some amount of physical eraseblocks to handle new bad
@@ -48,8 +44,6 @@ config MTD_UBI_BEB_RESERVE
 
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
-	default n
-	depends on MTD_UBI
 	help
 	   This option enables gluebi - an additional driver which emulates MTD
 	   devices on top of UBI volumes: for each UBI volumes an MTD device is
@@ -59,4 +53,5 @@ config MTD_UBI_GLUEBI
 	   software.
 
 source "drivers/mtd/ubi/Kconfig.debug"
-endmenu
+
+endif # MTD_UBI
diff --git a/drivers/mtd/ubi/Kconfig.debug b/drivers/mtd/ubi/Kconfig.debug
index 2246f15..d508b78 100644
--- a/drivers/mtd/ubi/Kconfig.debug
+++ b/drivers/mtd/ubi/Kconfig.debug
@@ -1,94 +1,73 @@
 comment "UBI debugging options"
-	depends on MTD_UBI
 
 config MTD_UBI_DEBUG
 	bool "UBI debugging"
 	depends on SYSFS
-	depends on MTD_UBI
 	select DEBUG_FS
 	select KALLSYMS_ALL
 	help
 	  This option enables UBI debugging.
 
+if MTD_UBI_DEBUG
+
 config MTD_UBI_DEBUG_MSG
 	bool "UBI debugging messages"
-	depends on MTD_UBI_DEBUG
-	default n
 	help
 	  This option enables UBI debugging messages.
 
 config MTD_UBI_DEBUG_PARANOID
 	bool "Extra self-checks"
-	default n
-	depends on MTD_UBI_DEBUG
 	help
 	  This option enables extra checks in UBI code. Note this slows UBI down
 	  significantly.
 
 config MTD_UBI_DEBUG_DISABLE_BGT
 	bool "Do not enable the UBI background thread"
-	depends on MTD_UBI_DEBUG
-	default n
 	help
 	  This option switches the background thread off by default. The thread
 	  may be also be enabled/disabled via UBI sysfs.
 
 config MTD_UBI_DEBUG_EMULATE_BITFLIPS
 	bool "Emulate flash bit-flips"
-	depends on MTD_UBI_DEBUG
-	default n
 	help
 	  This option emulates bit-flips with probability 1/50, which in turn
 	  causes scrubbing. Useful for debugging and stressing UBI.
 
 config MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES
 	bool "Emulate flash write failures"
-	depends on MTD_UBI_DEBUG
-	default n
 	help
 	  This option emulates write failures with probability 1/100. Useful for
 	  debugging and testing how UBI handlines errors.
 
 config MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES
 	bool "Emulate flash erase failures"
-	depends on MTD_UBI_DEBUG
-	default n
 	help
 	  This option emulates erase failures with probability 1/100. Useful for
 	  debugging and testing how UBI handlines errors.
 
-menu "Additional UBI debugging messages"
-	depends on MTD_UBI_DEBUG
+comment "Additional UBI debugging messages"
 
 config MTD_UBI_DEBUG_MSG_BLD
 	bool "Additional UBI initialization and build messages"
-	default n
-	depends on MTD_UBI_DEBUG
 	help
 	  This option enables detailed UBI initialization and device build
 	  debugging messages.
 
 config MTD_UBI_DEBUG_MSG_EBA
 	bool "Eraseblock association unit messages"
-	default n
-	depends on MTD_UBI_DEBUG
 	help
 	  This option enables debugging messages from the UBI eraseblock
 	  association unit.
 
 config MTD_UBI_DEBUG_MSG_WL
 	bool "Wear-leveling unit messages"
-	default n
-	depends on MTD_UBI_DEBUG
 	help
 	  This option enables debugging messages from the UBI wear-leveling
 	  unit.
 
 config MTD_UBI_DEBUG_MSG_IO
 	bool "Input/output unit messages"
-	default n
-	depends on MTD_UBI_DEBUG
 	help
 	  This option enables debugging messages from the UBI input/output unit.
 
-endmenu # UBI debugging messages
+endif # MTD_UBI_DEBUG
