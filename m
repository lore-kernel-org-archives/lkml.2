Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0HTBSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:18:51 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:42946 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HTBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:18:48 -0400
X-MXL-Hash: 4c6dd7f85c85fd8b-357ae17a263c1f625d96f968b3d9f20adb42ee6a
X-MXL-Hash: 4c6dd7e87a797ddb-2fc838627cf3cc341e53cb35b757f25ee675ecb7
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd/chips: cleanup Kconfig dependencies
Date: Thu, 19 Aug 2010 18:18:21 -0700
User-Agent: KMail/1.9.9
CC: linux-mtd <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201008191818.21506.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=SnmHQsryzfMA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=Kuj6gQ5TI_N63CyjU5gA:9 a=WgFylBIpiPT_QLbOI9U]
X-AnalysisOut: [A:7 a=qxTSG_z5F1mX0QmufnZhPxlQnS0A:4 a=QEXdDO2ut3YA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=TiShS-fLkSPzlZ3B:21 a=c]
X-AnalysisOut: [oZgvj_JelsRThZn:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the MTD!=n dependency since that is handled by drivers/mtd/Kconfig.
Simplify the dependency checks for mtd/chips by using if/endif blocks. Remove
all default n since that is the Kconfig default.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index 35c6a23..baac353 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -1,5 +1,4 @@
 menu "RAM/ROM/Flash chip drivers"
-	depends on MTD!=n
 
 config MTD_CFI
 	tristate "Detect flash chips by Common Flash Interface (CFI) probe"
@@ -27,9 +26,10 @@ config MTD_JEDECPROBE
 config MTD_GEN_PROBE
 	tristate
 
+if MTD_GEN_PROBE
+
 config MTD_CFI_ADV_OPTIONS
 	bool "Flash chip driver advanced configuration options"
-	depends on MTD_GEN_PROBE
 	help
 	  If you need to specify a specific endianness for access to flash
 	  chips, or if you wish to reduce the size of the kernel by including
@@ -39,9 +39,10 @@ config MTD_CFI_ADV_OPTIONS
 
 	  If unsure, say 'N'.
 
+if MTD_CFI_ADV_OPTIONS
+
 choice
 	prompt "Flash cmd/query data swapping"
-	depends on MTD_CFI_ADV_OPTIONS
 	default MTD_CFI_NOSWAP
 
 config MTD_CFI_NOSWAP
@@ -72,7 +73,6 @@ endchoice
 
 config MTD_CFI_GEOMETRY
 	bool "Specific CFI Flash geometry selection"
-	depends on MTD_CFI_ADV_OPTIONS
 	help
 	  This option does not affect the code directly, but will enable
 	  some other configuration options which would allow you to reduce
@@ -80,81 +80,78 @@ config MTD_CFI_GEOMETRY
 	  arrangements of CFI chips. If unsure, say 'N' and all options
 	  which are supported by the current code will be enabled.
 
+if MTD_CFI_GEOMETRY
+
 config MTD_MAP_BANK_WIDTH_1
-	bool "Support  8-bit buswidth" if MTD_CFI_GEOMETRY
+	bool "Support  8-bit buswidth"
 	default y
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  8 bits wide, say 'Y'.
 
 config MTD_MAP_BANK_WIDTH_2
-	bool "Support 16-bit buswidth" if MTD_CFI_GEOMETRY
+	bool "Support 16-bit buswidth"
 	default y
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  16 bits wide, say 'Y'.
 
 config MTD_MAP_BANK_WIDTH_4
-	bool "Support 32-bit buswidth" if MTD_CFI_GEOMETRY
+	bool "Support 32-bit buswidth"
 	default y
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  32 bits wide, say 'Y'.
 
 config MTD_MAP_BANK_WIDTH_8
-	bool "Support 64-bit buswidth" if MTD_CFI_GEOMETRY
-	default n
+	bool "Support 64-bit buswidth"
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  64 bits wide, say 'Y'.
 
 config MTD_MAP_BANK_WIDTH_16
-	bool "Support 128-bit buswidth" if MTD_CFI_GEOMETRY
-	default n
+	bool "Support 128-bit buswidth"
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  128 bits wide, say 'Y'.
 
 config MTD_MAP_BANK_WIDTH_32
-	bool "Support 256-bit buswidth" if MTD_CFI_GEOMETRY
-	default n
+	bool "Support 256-bit buswidth"
 	help
 	  If you wish to support CFI devices on a physical bus which is
 	  256 bits wide, say 'Y'.
 
 config MTD_CFI_I1
-	bool "Support 1-chip flash interleave" if MTD_CFI_GEOMETRY
+	bool "Support 1-chip flash interleave"
 	default y
 	help
 	  If your flash chips are not interleaved - i.e. you only have one
 	  flash chip addressed by each bus cycle, then say 'Y'.
 
 config MTD_CFI_I2
-	bool "Support 2-chip flash interleave" if MTD_CFI_GEOMETRY
+	bool "Support 2-chip flash interleave"
 	default y
 	help
 	  If your flash chips are interleaved in pairs - i.e. you have two
 	  flash chips addressed by each bus cycle, then say 'Y'.
 
 config MTD_CFI_I4
-	bool "Support 4-chip flash interleave" if MTD_CFI_GEOMETRY
-	default n
+	bool "Support 4-chip flash interleave"
 	help
 	  If your flash chips are interleaved in fours - i.e. you have four
 	  flash chips addressed by each bus cycle, then say 'Y'.
 
 config MTD_CFI_I8
-	bool "Support 8-chip flash interleave" if MTD_CFI_GEOMETRY
-	default n
+	bool "Support 8-chip flash interleave"
 	help
 	  If your flash chips are interleaved in eights - i.e. you have eight
 	  flash chips addressed by each bus cycle, then say 'Y'.
 
+endif # MTD_CFI_GEOMETRY
+
 config MTD_OTP
 	bool "Protection Registers aka one-time programmable (OTP) bits"
-	depends on MTD_CFI_ADV_OPTIONS
 	select HAVE_MTD_OTP
-	default n
 	help
 	  This enables support for reading, writing and locking so called
 	  "Protection Registers" present on some flash chips.
@@ -176,9 +173,10 @@ config MTD_OTP
 	  This feature should therefore be used with extreme care. Any mistake
 	  in the programming of OTP bits will waste them.
 
+endif # MTD_CFI_ADV_OPTIONS
+
 config MTD_CFI_INTELEXT
 	tristate "Support for Intel/Sharp flash chips"
-	depends on MTD_GEN_PROBE
 	select MTD_CFI_UTIL
 	help
 	  The Common Flash Interface defines a number of different command
@@ -188,7 +186,6 @@ config MTD_CFI_INTELEXT
 
 config MTD_CFI_AMDSTD
 	tristate "Support for AMD/Fujitsu/Spansion flash chips"
-	depends on MTD_GEN_PROBE
 	select MTD_CFI_UTIL
 	help
 	  The Common Flash Interface defines a number of different command
@@ -198,13 +195,14 @@ config MTD_CFI_AMDSTD
 
 config MTD_CFI_STAA
 	tristate "Support for ST (Advanced Architecture) flash chips"
-	depends on MTD_GEN_PROBE
 	select MTD_CFI_UTIL
 	help
 	  The Common Flash Interface defines a number of different command
 	  sets which a CFI-compliant chip may claim to implement. This code
 	  provides support for one of those command sets.
 
+endif # MTD_GEN_PROBE
+
 config MTD_CFI_UTIL
 	tristate
 
