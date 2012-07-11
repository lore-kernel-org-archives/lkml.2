Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2GKI6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:58:48 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:65524 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab2GKI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:58:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,567,1336341600"; 
   d="scan'208";a="166407244"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>, Stefan Roese <sr@denx.de>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/devices/spear_smi.c: failure test for null rather than negative integer
Date: Wed, 11 Jul 2012 10:58:38 +0200
Message-Id: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

dev_get_platdata returns a pointer, so the failure value would be NULL
rather than a negative integer.

The semantic match that finds this problem is: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
statement S1,S2;
@@

*x = dev_get_platdata(...)
... when != x = e
*if (x < 0) S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/devices/spear_smi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index b85f183..7c10466 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -935,7 +935,7 @@ static int __devinit spear_smi_probe(struct platform_device *pdev)
 		}
 	} else {
 		pdata = dev_get_platdata(&pdev->dev);
-		if (pdata < 0) {
+		if (!pdata) {
 			ret = -ENODEV;
 			dev_err(&pdev->dev, "no platform data\n");
 			goto err;

