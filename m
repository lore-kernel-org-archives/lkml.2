Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2LPR1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:27:47 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43762 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2LPRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:55 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 04/14] shmobile-iommu: Use devm_* managed functions
Date: Sun, 16 Dec 2012 18:25:50 +0100
Message-Id: <1355678760-27357-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-ipmmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
index 2339f91..d6df0b4 100644
--- a/drivers/iommu/shmobile-ipmmu.c
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -116,16 +116,16 @@ static int ipmmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "cannot get platform resources\n");
 		return -ENOENT;
 	}
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&pdev->dev, "cannot allocate device data\n");
 		return -ENOMEM;
 	}
 	mutex_init(&priv->flush_lock);
-	priv->ipmmu_base = ioremap_nocache(res->start, resource_size(res));
+	priv->ipmmu_base = devm_ioremap_nocache(&pdev->dev, res->start,
+						resource_size(res));
 	if (!priv->ipmmu_base) {
 		dev_err(&pdev->dev, "ioremap_nocache failed\n");
-		kfree(priv);
 		return -ENOMEM;
 	}
 	platform_set_drvdata(pdev, priv);
-- 
1.7.8.6

