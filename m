Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab1EaNVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:21:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63384 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1EaNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AABKhvEdhGbbBXuJ6AbvuYB8E6A4qHpmqFsma8HIRiQ0MT+PDRu3818/urvJ0HoD/T
         ctrY1oPh/yvs8UYXgeiEeJNp/5mkibLJ7DlSWfhcA/MvmXE1asGNztZ+T1JAAO623zsw
         uRsjGz7gIG2GpAQkC3Ukn7uu8Vr/pFKGyk8HY=
Subject: [PATCH] mtd: OneNAND: OMAP2: Return proper error if regulator_get
 fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 21:20:53 +0800
Message-ID: <1306848053.13412.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/onenand/omap2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index a916dec..0d9073d 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -741,6 +741,7 @@ static int __devinit omap2_onenand_probe(struct platform_device *pdev)
 		c->regulator = regulator_get(&pdev->dev, "vonenand");
 		if (IS_ERR(c->regulator)) {
 			dev_err(&pdev->dev,  "Failed to get regulator\n");
+			r = PTR_ERR(c->regulator);
 			goto err_release_dma;
 		}
 		c->onenand.enable = omap2_onenand_enable;
-- 
1.7.4.1



