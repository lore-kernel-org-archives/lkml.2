Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab2C2VPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:15:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33822 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932Ab2C2VNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:13:01 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 08/17] mips: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:25 +0200
Message-Id: <1333055554-31300-8-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/bcm63xx/boards/board_bcm963xx.c |    2 +-
 arch/mips/bcm63xx/dev-pcmcia.c            |    4 ++--
 arch/mips/mti-malta/malta-setup.c         |    2 +-
 arch/mips/pci/fixup-mpc30x.c              |    4 ++--
 arch/mips/powertv/asic/asic-calliope.c    |    2 +-
 arch/mips/powertv/asic/asic-cronus.c      |    2 +-
 arch/mips/powertv/asic/asic-gaia.c        |    2 +-
 arch/mips/powertv/asic/asic-zeus.c        |    2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index 2f1773f..a3fe14e 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -591,7 +591,7 @@ static struct board_info __initdata board_DWVS0 = {
 /*
  * all boards
  */
-static const struct board_info __initdata *bcm963xx_boards[] = {
+static const struct board_info *bcm963xx_boards[] __initconst = {
 #ifdef CONFIG_BCM63XX_CPU_6338
 	&board_96338gw,
 	&board_96338w,
diff --git a/arch/mips/bcm63xx/dev-pcmcia.c b/arch/mips/bcm63xx/dev-pcmcia.c
index de4d917..a551bab 100644
--- a/arch/mips/bcm63xx/dev-pcmcia.c
+++ b/arch/mips/bcm63xx/dev-pcmcia.c
@@ -79,11 +79,11 @@ static int __init config_pcmcia_cs(unsigned int cs,
 	return ret;
 }
 
-static const __initdata struct {
+static const struct {
 	unsigned int	cs;
 	unsigned int	base;
 	unsigned int	size;
-} pcmcia_cs[3] = {
+} pcmcia_cs[3] __initconst = {
 	{
 		.cs	= MPI_CS_PCMCIA_COMMON,
 		.base	= BCM_PCMCIA_COMMON_BASE_PA,
diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
index b7f37d4..2e28f65 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -111,7 +111,7 @@ static void __init pci_clock_check(void)
 	unsigned int __iomem *jmpr_p =
 		(unsigned int *) ioremap(MALTA_JMPRS_REG, sizeof(unsigned int));
 	int jmpr = (__raw_readl(jmpr_p) >> 2) & 0x07;
-	static const int pciclocks[] __initdata = {
+	static const int pciclocks[] __initconst = {
 		33, 20, 25, 30, 12, 16, 37, 10
 	};
 	int pciclock = pciclocks[jmpr];
diff --git a/arch/mips/pci/fixup-mpc30x.c b/arch/mips/pci/fixup-mpc30x.c
index e08f49c..8e4f828 100644
--- a/arch/mips/pci/fixup-mpc30x.c
+++ b/arch/mips/pci/fixup-mpc30x.c
@@ -22,13 +22,13 @@
 
 #include <asm/vr41xx/mpc30x.h>
 
-static const int internal_func_irqs[] __initdata = {
+static const int internal_func_irqs[] __initconst = {
 	VRC4173_CASCADE_IRQ,
 	VRC4173_AC97_IRQ,
 	VRC4173_USB_IRQ,
 };
 
-static const int irq_tab_mpc30x[] __initdata = {
+static const int irq_tab_mpc30x[] __initconst = {
  [12] = VRC4173_PCMCIA1_IRQ,
  [13] = VRC4173_PCMCIA2_IRQ,
  [29] = MQ200_IRQ,
diff --git a/arch/mips/powertv/asic/asic-calliope.c b/arch/mips/powertv/asic/asic-calliope.c
index 0a170e0..7773f3d 100644
--- a/arch/mips/powertv/asic/asic-calliope.c
+++ b/arch/mips/powertv/asic/asic-calliope.c
@@ -28,7 +28,7 @@
 
 #define CALLIOPE_ADDR(x)	(CALLIOPE_IO_BASE + (x))
 
-const struct register_map calliope_register_map __initdata = {
+const struct register_map calliope_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = CALLIOPE_ADDR(0x800000)},
 	.eic_cfg_bits = {.phys = CALLIOPE_ADDR(0x800038)},
 	.eic_ready_status = {.phys = CALLIOPE_ADDR(0x80004c)},
diff --git a/arch/mips/powertv/asic/asic-cronus.c b/arch/mips/powertv/asic/asic-cronus.c
index bbc0c12..da076db 100644
--- a/arch/mips/powertv/asic/asic-cronus.c
+++ b/arch/mips/powertv/asic/asic-cronus.c
@@ -28,7 +28,7 @@
 
 #define CRONUS_ADDR(x)	(CRONUS_IO_BASE + (x))
 
-const struct register_map cronus_register_map __initdata = {
+const struct register_map cronus_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = CRONUS_ADDR(0x000000)},
 	.eic_cfg_bits = {.phys = CRONUS_ADDR(0x000038)},
 	.eic_ready_status = {.phys = CRONUS_ADDR(0x00004C)},
diff --git a/arch/mips/powertv/asic/asic-gaia.c b/arch/mips/powertv/asic/asic-gaia.c
index 91dda68..47683b3 100644
--- a/arch/mips/powertv/asic/asic-gaia.c
+++ b/arch/mips/powertv/asic/asic-gaia.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <asm/mach-powertv/asic.h>
 
-const struct register_map gaia_register_map __initdata = {
+const struct register_map gaia_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = GAIA_IO_BASE + 0x000000},
 	.eic_cfg_bits = {.phys = GAIA_IO_BASE + 0x000038},
 	.eic_ready_status = {.phys = GAIA_IO_BASE + 0x00004C},
diff --git a/arch/mips/powertv/asic/asic-zeus.c b/arch/mips/powertv/asic/asic-zeus.c
index 4a05bb0..6ff4b10 100644
--- a/arch/mips/powertv/asic/asic-zeus.c
+++ b/arch/mips/powertv/asic/asic-zeus.c
@@ -28,7 +28,7 @@
 
 #define ZEUS_ADDR(x)	(ZEUS_IO_BASE + (x))
 
-const struct register_map zeus_register_map __initdata = {
+const struct register_map zeus_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = ZEUS_ADDR(0x000000)},
 	.eic_cfg_bits = {.phys = ZEUS_ADDR(0x000038)},
 	.eic_ready_status = {.phys = ZEUS_ADDR(0x00004c)},
-- 
1.7.9.1

