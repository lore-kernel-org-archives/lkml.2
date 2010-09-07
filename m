Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0IGMfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:35:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51504 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab0IGMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OkdaVjCFsnNO36I/gCGUzNbYYvP9IqmqhCWxRxdBAXq6uPJfrCPo0JWrvQ4NGJij8h
         iPtZQmbhZhP+PtoB9RwSQxDnPzux/2bitADu+yq+WMyGlYgo7Pd1mq676lTWjltLwXfw
         5k5lKU/th+uEmjK4cLhkMcO4P3eCdV0o6Z/iQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv6 2/3] mmc_test: change simple_strtol() to strict_strtol()
Date: Tue,  7 Sep 2010 15:35:25 +0300
Message-Id: <ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
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

