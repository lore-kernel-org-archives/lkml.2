Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2A3WAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:00:45 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45879 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH v2 03/16] mmc: fix for some -Wuninitialized warning
Date: Mon, 30 Jan 2012 23:00:07 +0100
Message-Id: <1327960820-11867-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings, by moving the
retry block up so that from, nr and arg variables get set correctly
if the code jumps from the out-block.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/mmc/card/block.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 0cad48a..c9350ae 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -889,6 +889,7 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 		goto out;
 	}
 
+retry:
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
@@ -896,7 +897,7 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 		arg = MMC_SECURE_TRIM1_ARG;
 	else
 		arg = MMC_SECURE_ERASE_ARG;
-retry:
+
 	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 				 INAND_CMD38_ARG_EXT_CSD,
-- 
1.7.7.3

