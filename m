Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2K2Gls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:41:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42216 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2K2Glo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:41:44 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "tony@atomide.com" <tony@atomide.com>
CC: "paul@pwsan.com" <paul@pwsan.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "srinath@mistralsolutions.com" <srinath@mistralsolutions.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] omap: craneboard: support NAND device
Thread-Topic: [PATCH 1/3] omap: craneboard: support NAND device
Thread-Index: Ac3N/JO+DMulpR+rTCaDo4me8z+9bg==
Date: Thu, 29 Nov 2012 06:41:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F138@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch enables the NAND device on the AM3517 Craneboard.

 MTD partitions are created as below.
 0x000000000000-0x000000080000 : "X-Loader"
 0x000000080000-0x000000240000 : "U-Boot"
 0x000000240000-0x000000280000 : "U-Boot Env"
 0x000000280000-0x000000780000 : "Kernel"
 0x000000780000-0x000010000000 : "File System"

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   38 +++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 51b96a1..37646e5 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -20,12 +20,17 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
 #include "common.h"
+#include "common-board-devices.h"
+#include "board-flash.h"
 
 #include "am35xx-emac.h"
 #include "mux.h"
@@ -51,6 +56,36 @@ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
 	.reset_gpio_port[2]  = -EINVAL
 };
 
+static struct mtd_partition crane_nand_partitions[] = {
+	{
+		.name		= "X-Loader",
+		.offset		= 0,
+		.size		= 4 * NAND_BLOCK_SIZE,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	{
+		.name		= "U-Boot",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 14 * NAND_BLOCK_SIZE,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	{
+		.name		= "U-Boot Env",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 2 * NAND_BLOCK_SIZE,
+	},
+	{
+		.name		= "Kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 40 * NAND_BLOCK_SIZE,
+	},
+	{
+		.name		= "File System",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+	},
+};
+
 static void __init am3517_crane_init(void)
 {
 	int ret;
@@ -58,6 +93,9 @@ static void __init am3517_crane_init(void)
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
+	board_nand_init(crane_nand_partitions,
+			ARRAY_SIZE(crane_nand_partitions), 0,
+			NAND_BUSWIDTH_16, NULL);
 
 	/* Configure GPIO for EHCI port */
 	if (omap_mux_init_gpio(GPIO_USB_NRESET, OMAP_PIN_OUTPUT)) {
-- 
1.7.9.5


Best Regards,
Milo


