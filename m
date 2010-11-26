Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0KZRGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0KZRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=JTjoEhVh8WhlB1/aI1Q1xyKZq/U/FHdhgczLhwbrckihF/c+hlNqF8Lzz13HUWcoT6
         1ULXzDp0Dp+xFwVS1a3NX+f8+6FBfQcmDUxYEU46BzoZ9/44ATR85Is2xCtWxSKpRcft
         ZkTEQZfLRYHNk8JDjJCHs8oRjMOizb7s3VFSo=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] avr32: boards: setup: use IS_ERR() instead of NULL check
Date: Fri, 26 Nov 2010 20:06:12 +0300
Message-Id: <1290791179-21298-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns ERR_PTR() on error, not NULL.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/avr32/boards/atngw100/setup.c      |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c |    2 +-
 arch/avr32/boards/favr-32/setup.c       |    2 +-
 arch/avr32/boards/hammerhead/setup.c    |    2 +-
 arch/avr32/boards/merisc/setup.c        |    2 +-
 arch/avr32/boards/mimc200/setup.c       |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index 8c6a244..659d119 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -188,7 +188,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	 */
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 2adc261..6ce30fb 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -203,7 +203,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	 */
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index 75f19f4..86fab77 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -206,7 +206,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	 */
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
diff --git a/arch/avr32/boards/hammerhead/setup.c b/arch/avr32/boards/hammerhead/setup.c
index dd00987..da14fbd 100644
--- a/arch/avr32/boards/hammerhead/setup.c
+++ b/arch/avr32/boards/hammerhead/setup.c
@@ -150,7 +150,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
 
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
diff --git a/arch/avr32/boards/merisc/setup.c b/arch/avr32/boards/merisc/setup.c
index 623b077..e61bc94 100644
--- a/arch/avr32/boards/merisc/setup.c
+++ b/arch/avr32/boards/merisc/setup.c
@@ -134,7 +134,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
diff --git a/arch/avr32/boards/mimc200/setup.c b/arch/avr32/boards/mimc200/setup.c
index 523d8e1..c4da5cb 100644
--- a/arch/avr32/boards/mimc200/setup.c
+++ b/arch/avr32/boards/mimc200/setup.c
@@ -162,7 +162,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	 */
 	regs = (void __iomem __force *)res->start;
 	pclk = clk_get(&pdev->dev, "pclk");
-	if (!pclk)
+	if (IS_ERR(pclk))
 		return;
 
 	clk_enable(pclk);
-- 
1.7.0.4

