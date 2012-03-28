Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab2C1SN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:13:59 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:42506 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab2C1SNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:13:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1332958366!17427977!40
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] mtd: plat_nand: Add default partition parser to driver
Date: Wed, 28 Mar 2012 11:13:05 -0700
User-Agent: KMail/1.9.9
CC: <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>,
        <artem.bityutskiy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203281113.05362.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cmdlinepart as the default partition parser and allow the arch setup code
to still use their own partition parsers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

---

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 6404e6e..5856399 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -23,6 +23,8 @@ struct plat_nand_data {
 	void __iomem		*io_base;
 };
 
+static const char *part_probe_types[] = { "cmdlinepart", NULL };
+
 /*
  * Probe for the NAND device.
  */
@@ -31,6 +33,7 @@ static int __devinit plat_nand_probe(struct platform_device *pdev)
 	struct platform_nand_data *pdata = pdev->dev.platform_data;
 	struct plat_nand_data *data;
 	struct resource *res;
+	const char **part_types;
 	int err = 0;
 
 	if (pdata->chip.nr_chips < 1) {
@@ -98,8 +101,9 @@ static int __devinit plat_nand_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	err = mtd_device_parse_register(&data->mtd,
-					pdata->chip.part_probe_types, NULL,
+	part_types = pdata->chip.part_probe_types ? : part_probe_types;
+
+	err = mtd_device_parse_register(&data->mtd, part_types, NULL,
 					pdata->chip.partitions,
 					pdata->chip.nr_partitions);
 
