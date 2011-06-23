Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab1FWRwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:52:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:35391 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710Ab1FWRiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 202/247] mmc: sdio: remember new card RCA when redetecting card
Date: Thu, 23 Jun 2011 13:34:30 -0400
Message-Id: <1308850515-15242-143-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0aab3995485b8a994bf29a995a008c9ea4a28054 upstream.

During redetection of a SDIO card, a request for a new card RCA
was submitted to the card, but was then overwritten by the old RCA.
This caused the card to be deselected instead of selected when using
the incorrect RCA.  This bug's been present since the "oldcard"
handling was introduced in 2.6.32.

Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Reviewed-by: Ulf Hansson <ulf.hansson@stericsson.com>
Reviewed-by: Pawel Wieczorkiewicz <pawel.wieczorkiewicz@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/core/sdio.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2dd4cfe..ed7620b 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -303,6 +303,14 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 		if (err)
 			goto remove;
 
+		/*
+		 * Update oldcard with the new RCA received from the SDIO
+		 * device -- we're doing this so that it's updated in the
+		 * "card" struct when oldcard overwrites that later.
+		 */
+		if (oldcard)
+			oldcard->rca = card->rca;
+
 		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
 	}
 
-- 
1.7.4.4

