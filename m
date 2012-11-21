Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2KUCeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:34:44 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2KUC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 14/42] sh-pfc: Remove unused resource and num_resources platform data fields
Date: Wed, 21 Nov 2012 03:27:15 +0100
Message-Id: <1353464863-10281-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fields are now unused, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c  |   17 ++++-------------
 include/linux/sh_pfc.h |    3 ---
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index eeec76f..68b40d8 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -41,31 +41,22 @@ static void pfc_iounmap(struct sh_pfc *pfc)
 
 static int pfc_ioremap(struct sh_pfc *pfc, struct platform_device *pdev)
 {
-	unsigned int num_resources;
 	struct resource *res;
 	int k;
 
-	if (pdev->num_resources) {
-		num_resources = pdev->num_resources;
-		res = pdev->resource;
-	} else {
-		num_resources = pfc->pdata->num_resources;
-		res = pfc->pdata->resource;
-	}
-
-	if (num_resources == 0) {
+	if (pdev->num_resources == 0) {
 		pfc->num_windows = 0;
 		return 0;
 	}
 
-	pfc->window = kzalloc(num_resources * sizeof(*pfc->window),
+	pfc->window = kzalloc(pdev->num_resources * sizeof(*pfc->window),
 			      GFP_NOWAIT);
 	if (!pfc->window)
 		goto err1;
 
-	pfc->num_windows = num_resources;
+	pfc->num_windows = pdev->num_resources;
 
-	for (k = 0; k < num_resources; k++, res++) {
+	for (k = 0, res = pdev->resource; k < pdev->num_resources; k++, res++) {
 		WARN_ON(resource_type(res) != IORESOURCE_MEM);
 		pfc->window[k].phys = res->start;
 		pfc->window[k].size = resource_size(res);
diff --git a/include/linux/sh_pfc.h b/include/linux/sh_pfc.h
index fa1fec0..4f94233 100644
--- a/include/linux/sh_pfc.h
+++ b/include/linux/sh_pfc.h
@@ -111,9 +111,6 @@ struct sh_pfc_platform_data {
 	struct pinmux_irq *gpio_irq;
 	unsigned int gpio_irq_size;
 
-	struct resource *resource;
-	unsigned int num_resources;
-
 	unsigned long unlock_reg;
 };
 
-- 
1.7.8.6

