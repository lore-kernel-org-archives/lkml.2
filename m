Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0IGMpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:45:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58126 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0IGMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h6+yl1zdfRsVBsOmlO4v/XhIRT/Lelk8DA1XWpTYZrmMnfhzcVMaWz+hySrxAxtV8+
         cUHD9kryL4bTDNycKFGMWy986h5Fufwm58gFnvcQ5cgFsQiBv1RxL+4OPDnnNAXRXB6F
         t+/qm0QuqZslJj3aZB2tcJ/zrgHE+ZIpxz4/s=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv6 1/3] mmc_test: use API to check card type
Date: Tue,  7 Sep 2010 15:35:24 +0300
Message-Id: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are methods to check card type. Let's use them instead of direct checking
type bits.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index b992725..cd8edf4 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1977,7 +1977,7 @@ static int mmc_test_probe(struct mmc_card *card)
 {
 	int ret;
 
-	if ((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
+	if (!mmc_card_mmc(card) && !mmc_card_sd(card))
 		return -ENODEV;
 
 	ret = device_create_file(&card->dev, &dev_attr_test);
-- 
1.6.3.3

