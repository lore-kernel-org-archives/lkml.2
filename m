Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab2DKUci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:32:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62955 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761227Ab2DKUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:32:35 -0400
From: Philippe De Swert <philippedeswert@gmail.com>
To: philippedeswert@gmail.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.calixto@modsystems.com,
        prakity@marvell.com, cjb@laptop.org
Subject: [PATCH 2/2] mmc: Remove dead code
Date: Wed, 11 Apr 2012 23:32:05 +0300
Message-Id: <1334176325-6221-1-git-send-email-philippedeswert@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bus_width is passed to the function and when 0 (MMC_BUS_WIDTH_1)
will cause the function to return. So in in the second test it 
definitly is different from 0, and the third test is redundant.

Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
---
 drivers/mmc/core/mmc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 54df5ad..4a1bf8f 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -556,14 +556,10 @@ static int mmc_compare_ext_csds(struct mmc_card *card, unsigned bus_width)
 	err = mmc_get_ext_csd(card, &bw_ext_csd);
 
 	if (err || bw_ext_csd == NULL) {
-		if (bus_width != MMC_BUS_WIDTH_1)
-			err = -EINVAL;
+		err = -EINVAL;
 		goto out;
 	}
 
-	if (bus_width == MMC_BUS_WIDTH_1)
-		goto out;
-
 	/* only compare read only fields */
 	err = !((card->ext_csd.raw_partition_support ==
 			bw_ext_csd[EXT_CSD_PARTITION_SUPPORT]) &&
-- 
1.7.9.5

