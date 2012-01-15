Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2AOKdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:33:32 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:35058 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2AOKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:33:29 -0500
Message-ID: <4F12AB3E.4010103@freemail.hu>
Date: Sun, 15 Jan 2012 11:32:30 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] gpio-pch: cleanup NULL pointer checking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.94.24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

This patch will remove the following sparse warning ("make C=1"):
 * warning: Using plain integer as NULL pointer

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/gpio/gpio-pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 9061b55..68fa55e 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -376,7 +376,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 	}

 	chip->base = pci_iomap(pdev, 1, 0);
-	if (chip->base == 0) {
+	if (!chip->base) {
 		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
 		ret = -ENOMEM;
 		goto err_iomap;
-- 
1.7.2.5

