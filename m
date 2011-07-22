Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1GVTrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:47:35 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:35866 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067Ab1GVTrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:47:33 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] of: address: use resource_size helper
Date: Fri, 22 Jul 2011 22:47:21 +0300
Message-Id: <1311364042-8325-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that should be the approved way of calculating
the size of resources. No functional changes.

Cc: Grant Likely <grant.likely@secretlab.ca>
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
1.7.6

