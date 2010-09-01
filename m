Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0IAG0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:26:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39920 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0IAG0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ou17LXmfH+sSsvZvKEZ8r6Gbzzas9gMwmBxojxwcAmapTd4SPiZ3ZlYf4W50j0LQYh
         gmOrON4IAAK97UeSITne4ld1QK3RY/51XqyDcMtH2HZu1JQBHL+OKw7mvjsS5W63BEb4
         GaLd3gXmuzrW39cjR3/Li4Cq8cs34O701TZlo=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 1/3] mmc_test: use API to check card type
Date: Wed,  1 Sep 2010 09:26:45 +0300
Message-Id: <756943b35144532a3c8de22c6dcfb179e5a7f69f.1283276161.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 7aaa4b2..359fae9 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1960,7 +1960,7 @@ static int mmc_test_probe(struct mmc_card *card)
 {
 	int ret;
 
-	if ((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
+	if (!mmc_card_mmc(card) && !mmc_card_sd(card))
 		return -ENODEV;
 
 	ret = device_create_file(&card->dev, &dev_attr_test);
-- 
1.6.3.3

