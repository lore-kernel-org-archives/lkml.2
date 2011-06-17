Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1FQLGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:06:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61454 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1FQLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IQ5VaLpMquh9MNocg47jBvTHAWhwEglCujeLoVHF5E5bNf3dKMjuuuVNmhcKdrxiV8
         cmB3cB/jyQRDjGc8J4fCR7+2+ywltRv4rCG6m1xSb3b5M82/1MBEw35+Z2457K5pBqVt
         xbSiR+Od3/SkNyOXZyUs5UFDEGG1UOgsVXH20=
Subject: [PATCH] mtd: onenand: remove redundant mtd_device_unregister
 before onenand_release
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 19:06:33 +0800
Message-ID: <1308308793.2628.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

onenand_release() will call mtd_device_unregister(), thus remove the redundant
mtd_device_unregister() call before onenand_release().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/onenand/generic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index 8152a31..7813095 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -97,7 +97,6 @@ static int __devexit generic_onenand_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	if (info) {
-		mtd_device_unregister(&info->mtd);
 		onenand_release(&info->mtd);
 		release_mem_region(res->start, size);
 		iounmap(info->onenand.base);
-- 
1.7.4.1



