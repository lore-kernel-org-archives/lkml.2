Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab2LLAdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:33:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab2LLAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:33:06 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 5/5] spi: fix return value check in hspi_probe().
Date: Wed, 12 Dec 2012 01:24:54 +0100
Message-Id: <1355271894-5284-6-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to its documentation, clk_get() returns a "valid IS_ERR() condition
containing errno", so we should call IS_ERR() rather than a NULL check.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/spi/spi-sh-hspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-hspi.c b/drivers/spi/spi-sh-hspi.c
index 32f7b55..60cfae5 100644
--- a/drivers/spi/spi-sh-hspi.c
+++ b/drivers/spi/spi-sh-hspi.c
@@ -290,7 +290,7 @@ static int hspi_probe(struct platform_device *pdev)
 	}
 
 	clk = clk_get(NULL, "shyway_clk");
-	if (!clk) {
+	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "shyway_clk is required\n");
 		ret = -EINVAL;
 		goto error0;
-- 
1.7.10.4

