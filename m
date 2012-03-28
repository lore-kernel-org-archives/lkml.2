Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab2C1SOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:14:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51385 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab2C1SOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:14:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1332958433!2382454!14
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] sh: Use the plat_nand default partition parser
Date: Wed, 28 Mar 2012 11:14:04 -0700
User-Agent: KMail/1.9.9
CC: <linux-mtd@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203281114.04557.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the default partition parser, cmdlinepart, provided by the plat_nand driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index ff6f69c..de3e0f6 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -187,7 +187,6 @@ static struct platform_nand_data migor_nand_flash_data = {
 		.partitions = migor_nand_flash_partitions,
 		.nr_partitions = ARRAY_SIZE(migor_nand_flash_partitions),
 		.chip_delay = 20,
-		.part_probe_types = (const char *[]) { "cmdlinepart", NULL },
 	},
 	.ctrl = {
 		.dev_ready = migor_nand_flash_ready,
