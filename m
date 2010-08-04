Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab0HDMl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:41:57 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57171 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748Ab0HDMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:41:53 -0400
Date: Wed, 4 Aug 2010 14:41:51 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>, Jiri Kosina <jkosina@suse.cz>,
        Alexander Kurz <linux@kbdbabel.org>, Michael Roth <mroth@nessie.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Anatolij Gustschin <agust@denx.de>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pcmcia@lists.infradead.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/9] Removing dead CONFIG_RPX(LITE|CLASSIC)
Message-ID: <e173704b7be0070b4adc976f185e89afca566aac.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RPX(LITE|CLASSIC) doesn't exist in Kconfig, therefore removing
all references to it from the source. Because RPX(LITE|CLASSIC) can't
be defined, MTD_RPXLITE can't be defined either. Therfore removing it to.

They were be introduced in 14cf11af6cf608eb8c23e989ddb17a715ddce109 and 
removed in df34403dcaacef541a67c955aebc37c51f53ca7c.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68k/include/asm/commproc.h |   17 --------
 drivers/mtd/maps/Kconfig         |   10 -----
 drivers/mtd/maps/Makefile        |    1 -
 drivers/mtd/maps/rpxlite.c       |   64 ------------------------------
 drivers/pcmcia/m8xx_pcmcia.c     |   81 --------------------------------------
 5 files changed, 0 insertions(+), 173 deletions(-)
 delete mode 100644 drivers/mtd/maps/rpxlite.c

diff --git a/arch/m68k/include/asm/commproc.h b/arch/m68k/include/asm/commproc.h
index b4f1d54..48f5466 100644
--- a/arch/m68k/include/asm/commproc.h
+++ b/arch/m68k/include/asm/commproc.h
@@ -480,23 +480,6 @@ typedef struct scc_enet {
 #define SICR_ENET_CLKRT	((uint)0x0000003d)
 #endif
 
-#ifdef CONFIG_RPXLITE
-/* This ENET stuff is for the MPC850 with ethernet on SCC2.  Some of
- * this may be unique to the RPX-Lite configuration.
- * Note TENA is on Port B.
- */
-#define PA_ENET_RXD	((ushort)0x0004)
-#define PA_ENET_TXD	((ushort)0x0008)
-#define PA_ENET_TCLK	((ushort)0x0200)
-#define PA_ENET_RCLK	((ushort)0x0800)
-#define PB_ENET_TENA	((uint)0x00002000)
-#define PC_ENET_CLSN	((ushort)0x0040)
-#define PC_ENET_RENA	((ushort)0x0080)
-
-#define SICR_ENET_MASK	((uint)0x0000ff00)
-#define SICR_ENET_CLKRT	((uint)0x00003d00)
-#endif
-
 /* SCC Event register as used by Ethernet.
 */
 #define SCCE_ENET_GRA	((ushort)0x0080)	/* Graceful stop complete */
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index f22bc9f..10261fc 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -286,16 +286,6 @@ config MTD_TQM8XXL
 	  code to communicate with the chips on the TQM8xxL board. More at
 	  <http://www.denx.de/embedded-ppc-en.html>.
 
-config MTD_RPXLITE
-	tristate "CFI Flash device mapped on RPX Lite or CLLF"
-	depends on MTD_CFI && (RPXCLASSIC || RPXLITE)
-	help
-	  The RPXLite PowerPC board has CFI-compliant chips mapped in
-	  a strange sparse mapping. This 'mapping' driver supports that
-	  arrangement, allowing the CFI probe and command set driver code
-	  to communicate with the chips on the RPXLite board. More at
-	  <http://www.embeddedplanet.com/>.
-
 config MTD_MBX860
 	tristate "System flash on MBX860 board"
 	depends on MTD_CFI && MBX
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index bb035cd..7821c71 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_MTD_PHYSMAP_OF)	+= physmap_of.o
 obj-$(CONFIG_MTD_PISMO)		+= pismo.o
 obj-$(CONFIG_MTD_PMC_MSP_EVM)   += pmcmsp-flash.o
 obj-$(CONFIG_MTD_PCMCIA)	+= pcmciamtd.o
-obj-$(CONFIG_MTD_RPXLITE)	+= rpxlite.o
 obj-$(CONFIG_MTD_TQM8XXL)	+= tqm8xxl.o
 obj-$(CONFIG_MTD_SA1100)	+= sa1100-flash.o
 obj-$(CONFIG_MTD_SBC_GXX)	+= sbc_gxx.o
diff --git a/drivers/mtd/maps/rpxlite.c b/drivers/mtd/maps/rpxlite.c
deleted file mode 100644
index 3e3ef53..0000000
--- a/drivers/mtd/maps/rpxlite.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Handle mapping of the flash on the RPX Lite and CLLF boards
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <asm/io.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-
-
-#define WINDOW_ADDR 0xfe000000
-#define WINDOW_SIZE 0x800000
-
-static struct mtd_info *mymtd;
-
-static struct map_info rpxlite_map = {
-	.name = "RPX",
-	.size = WINDOW_SIZE,
-	.bankwidth = 4,
-	.phys = WINDOW_ADDR,
-};
-
-static int __init init_rpxlite(void)
-{
-	printk(KERN_NOTICE "RPX Lite or CLLF flash device: %x at %x\n", WINDOW_SIZE*4, WINDOW_ADDR);
-	rpxlite_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE * 4);
-
-	if (!rpxlite_map.virt) {
-		printk("Failed to ioremap\n");
-		return -EIO;
-	}
-	simple_map_init(&rpxlite_map);
-	mymtd = do_map_probe("cfi_probe", &rpxlite_map);
-	if (mymtd) {
-		mymtd->owner = THIS_MODULE;
-		add_mtd_device(mymtd);
-		return 0;
-	}
-
-	iounmap((void *)rpxlite_map.virt);
-	return -ENXIO;
-}
-
-static void __exit cleanup_rpxlite(void)
-{
-	if (mymtd) {
-		del_mtd_device(mymtd);
-		map_destroy(mymtd);
-	}
-	if (rpxlite_map.virt) {
-		iounmap((void *)rpxlite_map.virt);
-		rpxlite_map.virt = 0;
-	}
-}
-
-module_init(init_rpxlite);
-module_exit(cleanup_rpxlite);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arnold Christensen <AKC@pel.dk>");
-MODULE_DESCRIPTION("MTD map driver for RPX Lite and CLLF boards");
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 25e5e30..e56dd87 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -71,12 +71,6 @@ MODULE_LICENSE("Dual MPL/GPL");
 
 #if !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B)
 
-/* The RPX series use SLOT_B */
-#if defined(CONFIG_RPXCLASSIC) || defined(CONFIG_RPXLITE)
-#define CONFIG_PCMCIA_SLOT_B
-#define CONFIG_BD_IS_MHZ
-#endif
-
 /* The ADS board use SLOT_A */
 #ifdef CONFIG_ADS
 #define CONFIG_PCMCIA_SLOT_A
@@ -256,81 +250,6 @@ static irqreturn_t m8xx_interrupt(int irq, void *dev);
 
 #define PCMCIA_BMT_LIMIT (15*4)	/* Bus Monitor Timeout value */
 
-/* ------------------------------------------------------------------------- */
-/* board specific stuff:                                                     */
-/* voltage_set(), hardware_enable() and hardware_disable()                   */
-/* ------------------------------------------------------------------------- */
-/* RPX Boards from Embedded Planet                                           */
-
-#if defined(CONFIG_RPXCLASSIC) || defined(CONFIG_RPXLITE)
-
-/* The RPX boards seems to have it's bus monitor timeout set to 6*8 clocks.
- * SYPCR is write once only, therefore must the slowest memory be faster
- * than the bus monitor or we will get a machine check due to the bus timeout.
- */
-
-#define PCMCIA_BOARD_MSG "RPX CLASSIC or RPX LITE"
-
-#undef PCMCIA_BMT_LIMIT
-#define PCMCIA_BMT_LIMIT (6*8)
-
-static int voltage_set(int slot, int vcc, int vpp)
-{
-	u32 reg = 0;
-
-	switch (vcc) {
-	case 0:
-		break;
-	case 33:
-		reg |= BCSR1_PCVCTL4;
-		break;
-	case 50:
-		reg |= BCSR1_PCVCTL5;
-		break;
-	default:
-		return 1;
-	}
-
-	switch (vpp) {
-	case 0:
-		break;
-	case 33:
-	case 50:
-		if (vcc == vpp)
-			reg |= BCSR1_PCVCTL6;
-		else
-			return 1;
-		break;
-	case 120:
-		reg |= BCSR1_PCVCTL7;
-	default:
-		return 1;
-	}
-
-	if (!((vcc == 50) || (vcc == 0)))
-		return 1;
-
-	/* first, turn off all power */
-
-	out_be32(((u32 *) RPX_CSR_ADDR),
-		 in_be32(((u32 *) RPX_CSR_ADDR)) & ~(BCSR1_PCVCTL4 |
-						     BCSR1_PCVCTL5 |
-						     BCSR1_PCVCTL6 |
-						     BCSR1_PCVCTL7));
-
-	/* enable new powersettings */
-
-	out_be32(((u32 *) RPX_CSR_ADDR), in_be32(((u32 *) RPX_CSR_ADDR)) | reg);
-
-	return 0;
-}
-
-#define socket_get(_slot_) PCMCIA_SOCKET_KEY_5V
-#define hardware_enable(_slot_)	/* No hardware to enable */
-#define hardware_disable(_slot_)	/* No hardware to disable */
-
-#endif				/* CONFIG_RPXCLASSIC */
-
 /* FADS Boards from Motorola                                               */
 
 #if defined(CONFIG_FADS)
-- 
1.7.0.4

