Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2AOJ6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:58:44 -0500
Received: from relay03.digicable.hu ([92.249.128.185]:57059 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2AOJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:58:42 -0500
Message-ID: <4F12A317.1060608@freemail.hu>
Date: Sun, 15 Jan 2012 10:57:43 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] gpio-ml-ioh: cleanup NULL pointer checking
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
 drivers/gpio/gpio-ml-ioh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 25da40a..03d6dd5 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -428,7 +428,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	}

 	base = pci_iomap(pdev, 1, 0);
-	if (base == 0) {
+	if (!base) {
 		dev_err(&pdev->dev, "%s : pci_iomap failed", __func__);
 		ret = -ENOMEM;
 		goto err_iomap;
-- 
1.7.2.5

