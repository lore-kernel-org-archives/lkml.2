Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2C1SOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:14:20 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:7880 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2C1SOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:14:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1332958433!2382454!13
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] mips: Use the plat_nand default partition parser
Date: Wed, 28 Mar 2012 11:14:00 -0700
User-Agent: KMail/1.9.9
CC: <linux-mtd@lists.infradead.org>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203281114.00608.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the default partition parser, cmdlinepart, provided by the plat_nand driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ralf Baechle <ralf@linux-mips.org>

---

diff --git a/arch/mips/alchemy/devboards/db1200.c b/arch/mips/alchemy/devboards/db1200.c
index a83302b..48bc422 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -212,8 +212,6 @@ static int au1200_nand_device_ready(struct mtd_info *mtd)
 	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
 }
 
-static const char *db1200_part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition db1200_nand_parts[] = {
 	{
 		.name	= "NAND FS 0",
@@ -234,7 +232,6 @@ struct platform_nand_data db1200_nand_platdata = {
 		.nr_partitions	= ARRAY_SIZE(db1200_nand_parts),
 		.partitions	= db1200_nand_parts,
 		.chip_delay	= 20,
-		.part_probe_types = db1200_part_probes,
 	},
 	.ctrl = {
 		.dev_ready	= au1200_nand_device_ready,
diff --git a/arch/mips/alchemy/devboards/db1300.c b/arch/mips/alchemy/devboards/db1300.c
index 0893f2a..c56e024 100644
--- a/arch/mips/alchemy/devboards/db1300.c
+++ b/arch/mips/alchemy/devboards/db1300.c
@@ -145,8 +145,6 @@ static int au1300_nand_device_ready(struct mtd_info *mtd)
 	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
 }
 
-static const char *db1300_part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition db1300_nand_parts[] = {
 	{
 		.name	= "NAND FS 0",
@@ -167,7 +165,6 @@ struct platform_nand_data db1300_nand_platdata = {
 		.nr_partitions	= ARRAY_SIZE(db1300_nand_parts),
 		.partitions	= db1300_nand_parts,
 		.chip_delay	= 20,
-		.part_probe_types = db1300_part_probes,
 	},
 	.ctrl = {
 		.dev_ready	= au1300_nand_device_ready,
diff --git a/arch/mips/alchemy/devboards/db1550.c b/arch/mips/alchemy/devboards/db1550.c
index 6815d07..9eb7906 100644
--- a/arch/mips/alchemy/devboards/db1550.c
+++ b/arch/mips/alchemy/devboards/db1550.c
@@ -149,8 +149,6 @@ static int au1550_nand_device_ready(struct mtd_info *mtd)
 	return __raw_readl((void __iomem *)MEM_STSTAT) & 1;
 }
 
-static const char *db1550_part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition db1550_nand_parts[] = {
 	{
 		.name	= "NAND FS 0",
@@ -171,7 +169,6 @@ struct platform_nand_data db1550_nand_platdata = {
 		.nr_partitions	= ARRAY_SIZE(db1550_nand_parts),
 		.partitions	= db1550_nand_parts,
 		.chip_delay	= 20,
-		.part_probe_types = db1550_part_probes,
 	},
 	.ctrl = {
 		.dev_ready	= au1550_nand_device_ready,
diff --git a/arch/mips/pnx833x/common/platform.c b/arch/mips/pnx833x/common/platform.c
index 87167dc..05a1d92 100644
--- a/arch/mips/pnx833x/common/platform.c
+++ b/arch/mips/pnx833x/common/platform.c
@@ -244,11 +244,6 @@ static struct platform_device pnx833x_sata_device = {
 	.resource      = pnx833x_sata_resources,
 };
 
-static const char *part_probes[] = {
-	"cmdlinepart",
-	NULL
-};
-
 static void
 pnx833x_flash_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
 {
@@ -268,7 +263,6 @@ static struct platform_nand_data pnx833x_flash_nand_data = {
 	.chip = {
 		.nr_chips		= 1,
 		.chip_delay		= 25,
-		.part_probe_types 	= part_probes,
 	},
 	.ctrl = {
 		.cmd_ctrl 		= pnx833x_flash_nand_cmd_ctrl
