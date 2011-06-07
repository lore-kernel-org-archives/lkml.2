Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab1FGSzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:55:32 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34868 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1FGSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:55:30 -0400
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] of: address: use resource_size helper
Date: Tue,  7 Jun 2011 21:55:24 +0300
Message-Id: <1307472924-10907-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6.rc0
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that should be the approved way of calculating
the size of resources. No functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/of/address.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index deefc0c..6e7b2cf 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -624,6 +624,6 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	if (of_address_to_resource(np, index, &res))
 		return NULL;
 
-	return ioremap(res.start, 1 + res.end - res.start);
+	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
-- 
1.7.6.rc0

