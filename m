Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0IFIMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:12:05 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:62514 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0IFIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:12:03 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv5 2/3] mmc_test: change simple_strtol() to strict_strtol()
Date: Mon,  6 Sep 2010 11:12:18 +0300
Message-Id: <59ad4bca0f707b11525dcdbe65dd117d964e4523.1283760476.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
References: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
References: <3fa57fe7152b608279ec56dcfe969a42b672a197.1283760476.git.ext-andriy.shevchenko@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to use strict_strtol() to convert user's input and strictly check
it. At least it forbids to interpret wrong input as a 0 and prevents to run all
tests.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index cd8edf4..6bffb33 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1937,9 +1937,10 @@ static ssize_t mmc_test_store(struct device *dev,
 {
 	struct mmc_card *card = mmc_dev_to_card(dev);
 	struct mmc_test_card *test;
-	int testcase;
+	long testcase;
 
-	testcase = simple_strtol(buf, NULL, 10);
+	if (strict_strtol(buf, 10, &testcase))
+		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
 	if (!test)
-- 
1.6.3.3

