Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1HSKQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:16:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40303 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab1HSKQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:16:49 -0400
From: "Bhandiwad, Hrishikesh" <hrishikesh.b@ti.com>
To: "Bhandiwad, Hrishikesh" <hrishikesh.b@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Fri, 19 Aug 2011 15:44:59 +0530
Subject: RE: [PATCH] AM3517: NAND: Adding NAND support and specifying NAND
 partitions.
Thread-Topic: [PATCH] AM3517: NAND: Adding NAND support and specifying NAND
 partitions.
Thread-Index: AcxTYm3Bvmpx7tciQDuFo+wfz50GUQK9mxz4
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D08A0B9@dbde03.ent.ti.com>
References: <1312543549-31869-1-git-send-email-hrishikesh.b@ti.com>
In-Reply-To: <1312543549-31869-1-git-send-email-hrishikesh.b@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

As this patch is trivial , can it be upstreamed .

Thanks & Regards,
Hrishikesh
________________________________________
From: Bhandiwad, Hrishikesh
Sent: Friday, August 05, 2011 4:55 PM
To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-mtd@lists.infradead.org
Cc: Bhandiwad, Hrishikesh
Subject: [PATCH] AM3517: NAND: Adding NAND support and specifying NAND partitions.

This patch adds the NAND support on AM3517 platform and creates the partitions.
Referred to file: arch/arm/mach-omap2/board-omap3beagle.c

Signed-off-by: Hrishikesh Bhandiwad <hrishikesh.b@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c |   38 +++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 63af417..dceb996 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -24,6 +24,8 @@
 #include <linux/i2c/pca953x.h>
 #include <linux/can/platform/ti_hecc.h>
 #include <linux/davinci_emac.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/nand.h>

 #include <mach/hardware.h>
 #include <mach/am35xx.h>
@@ -39,6 +41,7 @@

 #include "mux.h"
 #include "control.h"
+#include "common-board-devices.h"

 #define AM35XX_EVM_MDIO_FREQUENCY      (1000000)

@@ -460,6 +463,37 @@ static void am3517_evm_hecc_init(struct ti_hecc_platform_data *pdata)
 static struct omap_board_config_kernel am3517_evm_config[] __initdata = {
 };

+static struct mtd_partition am3517_nand_partitions[] = {
+       /* All the partition sizes are listed in terms of NAND block size */
+       {
+               .name           = "X-Loader",
+               .offset         = 0,
+               .size           = 4 * NAND_BLOCK_SIZE,
+               .mask_flags     = MTD_WRITEABLE,        /* force read-only */
+       },
+       {
+               .name           = "U-Boot",
+               .offset         = MTDPART_OFS_APPEND,   /* Offset = 0x80000 */
+               .size           = 15 * NAND_BLOCK_SIZE,
+               .mask_flags     = MTD_WRITEABLE,        /* force read-only */
+       },
+       {
+               .name           = "U-Boot Env",
+               .offset         = MTDPART_OFS_APPEND,   /* Offset = 0x260000 */
+               .size           = 1 * NAND_BLOCK_SIZE,
+       },
+       {
+               .name           = "Kernel",
+               .offset         = MTDPART_OFS_APPEND,   /* Offset = 0x280000 */
+               .size           = 32 * NAND_BLOCK_SIZE,
+       },
+       {
+               .name           = "File System",
+               .offset         = MTDPART_OFS_APPEND,   /* Offset = 0x680000 */
+               .size           = MTDPART_SIZ_FULL,
+       },
+};
+
 static void __init am3517_evm_init(void)
 {
        omap_board_config = am3517_evm_config;
@@ -473,6 +507,10 @@ static void __init am3517_evm_init(void)
        /* Configure GPIO for EHCI port */
        omap_mux_init_gpio(57, OMAP_PIN_OUTPUT);
        usbhs_init(&usbhs_bdata);
+       /*NAND*/
+       omap_nand_flash_init(NAND_BUSWIDTH_16, am3517_nand_partitions,
+                               ARRAY_SIZE(am3517_nand_partitions));
+
        am3517_evm_hecc_init(&am3517_evm_hecc_pdata);
        /* DSS */
        am3517_evm_display_init();
--
1.6.2.4
This patch has dependency on following patchset :
http://marc.info/?l=linux-omap&m=131247357813228&w=2

