Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2GYMIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:08:54 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:46763 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932906Ab2GYMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:08:50 -0400
From: Felipe Balbi <balbi@ti.com>
To: zbr@ioremap.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/6] w1: omap-hdq: don't hardcode resource size
Date: Wed, 25 Jul 2012 15:05:28 +0300
Message-Id: <1343217932-25372-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.11
In-Reply-To: <1343217932-25372-1-git-send-email-balbi@ti.com>
References: <1343217932-25372-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have the helpful resource_size() macro to
calculate the size of the memory resource for
us, let's use it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/w1/masters/omap_hdq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 46e1f6f..404a4de 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -568,7 +568,7 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 		goto err_resource;
 	}
 
-	hdq_data->hdq_base = ioremap(res->start, SZ_4K);
+	hdq_data->hdq_base = ioremap(res->start, resource_size(res));
 	if (!hdq_data->hdq_base) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		ret = -EINVAL;
-- 
1.7.11

