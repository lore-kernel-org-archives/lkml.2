Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab0FVIUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:20:05 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:42968 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758282Ab0FVIUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:20:02 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <linux-mmc@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
       Hanumath Prasad <hanumath.prasad@stericsson.com>,
       Rabin Vincent <rabin.vincent@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] mmc: only set blockaddressed for > 2GiB cards
Date: Tue, 22 Jun 2010 13:49:22 +0530
Message-ID: <1277194762-21399-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hanumath Prasad <hanumath.prasad@stericsson.com>

A non-zero value of SEC_COUNT does not indicate that the card is sector
addressed.  According to the MMC specification, cards with a density
greater than 2GiB are sector addressed.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Hanumath Prasad <hanumath.prasad@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/mmc/core/mmc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 89f7a25..1dc784e 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -222,7 +222,9 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 			ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
 			ext_csd[EXT_CSD_SEC_CNT + 2] << 16 |
 			ext_csd[EXT_CSD_SEC_CNT + 3] << 24;
-		if (card->ext_csd.sectors)
+
+		/* Cards with density > 2GiB are sector addressed */
+		if (card->ext_csd.sectors > (2u * 1024 * 1024 * 1024) / 512)
 			mmc_card_set_blockaddr(card);
 	}
 
-- 
1.7.0

