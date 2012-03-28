Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab2C1SNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:13:46 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:48894 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab2C1SNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:13:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1332958412!6798794!28
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] blackfin: Use the plat_nand default partition parser
Date: Wed, 28 Mar 2012 11:13:19 -0700
User-Agent: KMail/1.9.9
CC: <linux-mtd@lists.infradead.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203281113.19827.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the default partition parser, cmdlinepart, provided by the plat_nand driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mike Frysinger <vapier@gentoo.org>

---

diff --git a/arch/blackfin/mach-bf561/boards/acvilon.c b/arch/blackfin/mach-bf561/boards/acvilon.c
index f6ffd6f..0b74218 100644
--- a/arch/blackfin/mach-bf561/boards/acvilon.c
+++ b/arch/blackfin/mach-bf561/boards/acvilon.c
@@ -248,8 +248,6 @@ static struct platform_device bfin_uart0_device = {
 
 #if defined(CONFIG_MTD_NAND_PLATFORM) || defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
 
-const char *part_probes[] = { "cmdlinepart", NULL };
-
 static struct mtd_partition bfin_plat_nand_partitions[] = {
 	{
 	 .name = "params(nand)",
@@ -289,7 +287,6 @@ static struct platform_nand_data bfin_plat_nand_data = {
 	.chip = {
 		 .nr_chips = 1,
 		 .chip_delay = 30,
-		 .part_probe_types = part_probes,
 		 .partitions = bfin_plat_nand_partitions,
 		 .nr_partitions = ARRAY_SIZE(bfin_plat_nand_partitions),
 		 },
