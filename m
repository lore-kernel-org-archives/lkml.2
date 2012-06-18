Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2FRJ6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:58:10 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4100 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab2FRJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:58:08 -0400
Message-ID: <1340013485.5611.6.camel@x61.thuisdomein>
Subject: [PATCH] OMAP7XX:  Remove omap730.h and omap850.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2012 11:58:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 18 Jun 2012 09:58:05.0740 (UTC) FILETIME=[DB5C9EC0:01CD4D38]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No file includes omap730.h or omap850.h. That's not surprising, as
commit e6684f7132c6e6333e96407b06910bebaa4c1935 ("OMAP7XX: Create
omap7xx.h") created a header that was "intended to replace omap730.h and
omap850.h", while all "values defined [in omap7xx.h] are identical to
those in both the old files". So it seems it was just an oversight to
keep both the old files after commit
7a8f48f8c611ac8c07023260258e2fec312b9242 ("OMAP7XX: omap_uwire.c:
Convert to omap7xx.h") converted the last file still including one of
those two old files.

Convert the last reference to omap730.h to a reference to omap7xx.h too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested only by using various git commands on the (history of the)
tree.

1) A related cleanup could be to remove cpu_is_omap730 and
cpu_is_omap850, as both macros seem unused.

 arch/arm/plat-omap/include/plat/mux.h     |    2 +-
 arch/arm/plat-omap/include/plat/omap730.h |  102 -----------------------------
 arch/arm/plat-omap/include/plat/omap850.h |  102 -----------------------------
 3 files changed, 1 insertions(+), 205 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/omap730.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omap850.h

diff --git a/arch/arm/plat-omap/include/plat/mux.h b/arch/arm/plat-omap/include/plat/mux.h
index aeba717..3239489 100644
--- a/arch/arm/plat-omap/include/plat/mux.h
+++ b/arch/arm/plat-omap/include/plat/mux.h
@@ -99,7 +99,7 @@
 
 /*
  * OMAP730/850 has a slightly different config for the pin mux.
- * - config regs are the OMAP7XX_IO_CONF_x regs (see omap730.h) regs and
+ * - config regs are the OMAP7XX_IO_CONF_x regs (see omap7xx.h) regs and
  *   not the FUNC_MUX_CTRL_x regs from hardware.h
  * - for pull-up/down, only has one enable bit which is is in the same register
  *   as mux config
diff --git a/arch/arm/plat-omap/include/plat/omap730.h b/arch/arm/plat-omap/include/plat/omap730.h
deleted file mode 100644
index 14272bc..0000000
--- a/arch/arm/plat-omap/include/plat/omap730.h
+++ /dev/null
@@ -1,102 +0,0 @@
-/* arch/arm/plat-omap/include/mach/omap730.h
- *
- * Hardware definitions for TI OMAP730 processor.
- *
- * Cleanup for Linux-2.6 by Dirk Behme <dirk.behme@de.bosch.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2 of the License, or (at your
- * option) any later version.
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
- * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
- * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- * You should have received a copy of the  GNU General Public License along
- * with this program; if not, write  to the Free Software Foundation, Inc.,
- * 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __ASM_ARCH_OMAP730_H
-#define __ASM_ARCH_OMAP730_H
-
-/*
- * ----------------------------------------------------------------------------
- * Base addresses
- * ----------------------------------------------------------------------------
- */
-
-/* Syntax: XX_BASE = Virtual base address, XX_START = Physical base address */
-
-#define OMAP730_DSP_BASE	0xE0000000
-#define OMAP730_DSP_SIZE	0x50000
-#define OMAP730_DSP_START	0xE0000000
-
-#define OMAP730_DSPREG_BASE	0xE1000000
-#define OMAP730_DSPREG_SIZE	SZ_128K
-#define OMAP730_DSPREG_START	0xE1000000
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP730 specific configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP730_CONFIG_BASE	0xfffe1000
-#define OMAP730_IO_CONF_0	0xfffe1070
-#define OMAP730_IO_CONF_1	0xfffe1074
-#define OMAP730_IO_CONF_2	0xfffe1078
-#define OMAP730_IO_CONF_3	0xfffe107c
-#define OMAP730_IO_CONF_4	0xfffe1080
-#define OMAP730_IO_CONF_5	0xfffe1084
-#define OMAP730_IO_CONF_6	0xfffe1088
-#define OMAP730_IO_CONF_7	0xfffe108c
-#define OMAP730_IO_CONF_8	0xfffe1090
-#define OMAP730_IO_CONF_9	0xfffe1094
-#define OMAP730_IO_CONF_10	0xfffe1098
-#define OMAP730_IO_CONF_11	0xfffe109c
-#define OMAP730_IO_CONF_12	0xfffe10a0
-#define OMAP730_IO_CONF_13	0xfffe10a4
-
-#define OMAP730_MODE_1		0xfffe1010
-#define OMAP730_MODE_2		0xfffe1014
-
-/* CSMI specials: in terms of base + offset */
-#define OMAP730_MODE2_OFFSET	0x14
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP730 traffic controller configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP730_FLASH_CFG_0	0xfffecc10
-#define OMAP730_FLASH_ACFG_0	0xfffecc50
-#define OMAP730_FLASH_CFG_1	0xfffecc14
-#define OMAP730_FLASH_ACFG_1	0xfffecc54
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP730 DSP control registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP730_ICR_BASE	0xfffbb800
-#define OMAP730_DSP_M_CTL	0xfffbb804
-#define OMAP730_DSP_MMU_BASE	0xfffed200
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP730 PCC_UPLD configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP730_PCC_UPLD_CTRL_BASE	(0xfffe0900)
-#define OMAP730_PCC_UPLD_CTRL		(OMAP730_PCC_UPLD_CTRL_BASE + 0x00)
-
-#endif /*  __ASM_ARCH_OMAP730_H */
-
diff --git a/arch/arm/plat-omap/include/plat/omap850.h b/arch/arm/plat-omap/include/plat/omap850.h
deleted file mode 100644
index c33f679..0000000
--- a/arch/arm/plat-omap/include/plat/omap850.h
+++ /dev/null
@@ -1,102 +0,0 @@
-/* arch/arm/plat-omap/include/mach/omap850.h
- *
- * Hardware definitions for TI OMAP850 processor.
- *
- * Derived from omap730.h by Zebediah C. McClure <zmc@lurian.net>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2 of the License, or (at your
- * option) any later version.
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
- * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
- * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- * You should have received a copy of the  GNU General Public License along
- * with this program; if not, write  to the Free Software Foundation, Inc.,
- * 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __ASM_ARCH_OMAP850_H
-#define __ASM_ARCH_OMAP850_H
-
-/*
- * ----------------------------------------------------------------------------
- * Base addresses
- * ----------------------------------------------------------------------------
- */
-
-/* Syntax: XX_BASE = Virtual base address, XX_START = Physical base address */
-
-#define OMAP850_DSP_BASE	0xE0000000
-#define OMAP850_DSP_SIZE	0x50000
-#define OMAP850_DSP_START	0xE0000000
-
-#define OMAP850_DSPREG_BASE	0xE1000000
-#define OMAP850_DSPREG_SIZE	SZ_128K
-#define OMAP850_DSPREG_START	0xE1000000
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP850 specific configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP850_CONFIG_BASE	0xfffe1000
-#define OMAP850_IO_CONF_0	0xfffe1070
-#define OMAP850_IO_CONF_1	0xfffe1074
-#define OMAP850_IO_CONF_2	0xfffe1078
-#define OMAP850_IO_CONF_3	0xfffe107c
-#define OMAP850_IO_CONF_4	0xfffe1080
-#define OMAP850_IO_CONF_5	0xfffe1084
-#define OMAP850_IO_CONF_6	0xfffe1088
-#define OMAP850_IO_CONF_7	0xfffe108c
-#define OMAP850_IO_CONF_8	0xfffe1090
-#define OMAP850_IO_CONF_9	0xfffe1094
-#define OMAP850_IO_CONF_10	0xfffe1098
-#define OMAP850_IO_CONF_11	0xfffe109c
-#define OMAP850_IO_CONF_12	0xfffe10a0
-#define OMAP850_IO_CONF_13	0xfffe10a4
-
-#define OMAP850_MODE_1		0xfffe1010
-#define OMAP850_MODE_2		0xfffe1014
-
-/* CSMI specials: in terms of base + offset */
-#define OMAP850_MODE2_OFFSET	0x14
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP850 traffic controller configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP850_FLASH_CFG_0	0xfffecc10
-#define OMAP850_FLASH_ACFG_0	0xfffecc50
-#define OMAP850_FLASH_CFG_1	0xfffecc14
-#define OMAP850_FLASH_ACFG_1	0xfffecc54
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP850 DSP control registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP850_ICR_BASE	0xfffbb800
-#define OMAP850_DSP_M_CTL	0xfffbb804
-#define OMAP850_DSP_MMU_BASE	0xfffed200
-
-/*
- * ----------------------------------------------------------------------------
- * OMAP850 PCC_UPLD configuration registers
- * ----------------------------------------------------------------------------
- */
-#define OMAP850_PCC_UPLD_CTRL_BASE	(0xfffe0900)
-#define OMAP850_PCC_UPLD_CTRL		(OMAP850_PCC_UPLD_CTRL_BASE + 0x00)
-
-#endif /*  __ASM_ARCH_OMAP850_H */
-
-- 
1.7.7.6



