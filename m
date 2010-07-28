Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0G1FhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:37:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0G1FhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NupyZgrYq9AcYbg3DuTx8Cv6Odg5e1eecwKbzRaCr3esWgaaY34lHb1L2qLFKY0MyZ
         bruCek8mPiEavsl+uW5B3TemywxNRx4fu0kgpoRH21/I/l8gRS5Twuf1kkFw1yqI0bgh
         udDaiRh5xODyfxw2UVLi5fIlliZHVXsBfU4SE=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
        dwmw2@infradead.org, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] gen_nand: Fix support for multiple chips
Date: Wed, 28 Jul 2010 07:36:54 +0200
Message-Id: <1280295414-3354-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects a problem where gen_nand driver assumed there can be only
one chip and ignored the pdata->chip.nr_chips value.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/mtd/nand/plat_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 8d46731..90e143e 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -91,7 +91,7 @@ static int __devinit plat_nand_probe(struct platform_device *pdev)
 	}
 
 	/* Scan to find existance of the device */
-	if (nand_scan(&data->mtd, 1)) {
+	if (nand_scan(&data->mtd, pdata->chip.nr_chips)) {
 		err = -ENXIO;
 		goto out;
 	}
-- 
1.7.1

