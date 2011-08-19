Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1HSKRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:17:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58446 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSKRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:17:44 -0400
From: "Bhandiwad, Hrishikesh" <hrishikesh.b@ti.com>
To: "Bhandiwad, Hrishikesh" <hrishikesh.b@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>, "Premi, Sanjeev" <premi@ti.com>
Date: Fri, 19 Aug 2011 15:47:17 +0530
Subject: RE: [PATCH v2] OMAP3: NAND: Adding NAND support and specifying NAND
 partitions.
Thread-Topic: [PATCH v2] OMAP3: NAND: Adding NAND support and specifying
 NAND partitions.
Thread-Index: AcxN7Rcenppx6jumQrSwPRIeKzi/xQQbBUeG
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D08A0BA@dbde03.ent.ti.com>
References: <1311943396-16710-1-git-send-email-hrishikesh.b@ti.com>
In-Reply-To: <1311943396-16710-1-git-send-email-hrishikesh.b@ti.com>
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

As this patch is trivial can it be upstreamed ?
Thanks & Regards,
Hrishikesh
________________________________________
From: Bhandiwad, Hrishikesh
Sent: Friday, July 29, 2011 6:13 PM
To: linux-mtd@lists.infradead.org; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Bhandiwad, Hrishikesh; Hiremath, Vaibhav; Premi, Sanjeev
Subject: [PATCH v2] OMAP3: NAND: Adding NAND support and specifying NAND partitions.

This patch adds the NAND support on OMAP3EVM board and also allocates
five partitions  on NAND.
Referred to file: arch/arm/mach-omap2/board-omap3beagle.c

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Hrishikesh Bhandiwad <hrishikesh.b@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   37 ++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index b4d4346..3ac96d4 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -30,6 +30,9 @@
 #include <linux/usb/otg.h>
 #include <linux/smsc911x.h>

+#include <linux/mtd/partitions.h>
+#include <linux/mtd/nand.h>
+
 #include <linux/wl12xx.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
@@ -101,6 +104,37 @@ static void __init omap3_evm_get_revision(void)
        }
 }

+static struct mtd_partition omap3evm_nand_partitions[] = {
+       /* All the partition sizes are listed in terms of NAND block size */
+       {
+               .name           = "X-Loader",
+               .offset         = 0,
+               .size           = 4 * NAND_BLOCK_SIZE,
+               .mask_flags     = MTD_WRITEABLE,        /* force read-only */
+       },
+       {
+               .name           = "U-Boot",
+               .offset         = 0x80000,
+               .size           = 15 * NAND_BLOCK_SIZE,
+               .mask_flags     = MTD_WRITEABLE,        /* force read-only */
+       },
+       {
+               .name           = "U-Boot Env",
+               .offset         = 0x260000,
+               .size           = 1 * NAND_BLOCK_SIZE,
+       },
+       {
+               .name           = "Kernel",
+               .offset         = 0x280000,
+               .size           = 32 * NAND_BLOCK_SIZE,
+       },
+       {
+               .name           = "File System",
+               .offset         = 0x680000,
+               .size           = MTDPART_SIZ_FULL,
+       },
+};
+
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
 #include <plat/gpmc-smsc911x.h>

@@ -696,6 +730,9 @@ static void __init omap3_evm_init(void)

        omap_serial_init();

+       omap_nand_flash_init(NAND_BUSWIDTH_16, omap3evm_nand_partitions,
+                       ARRAY_SIZE(omap3evm_nand_partitions));
+
        /* OMAP3EVM uses ISP1504 phy and so register nop transceiver */
        usb_nop_xceiv_register();

--
1.6.2.4

