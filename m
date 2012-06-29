Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2F2E4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:56:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7755 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2F2E4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:56:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Jun 2012 21:56:30 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] of: return -ENOENT when no property
Date: Fri, 29 Jun 2012 13:57:58 +0900
Message-ID: <1340945879-11712-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1340945879-11712-1-git-send-email-acourbot@nvidia.com>
References: <1340945879-11712-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_parse_phandle_with_args return -ENOENT instead of -EINVAL when
no matching property is found, which allows to discriminate between
absence of property and parsing error.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/of/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7acd785..93165b7a 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -902,7 +902,7 @@ int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 	/* Retrieve the phandle list property */
 	list = of_get_property(np, list_name, &size);
 	if (!list)
-		return -EINVAL;
+		return -ENOENT;
 	list_end = list + size / sizeof(*list);
 
 	/* Loop over the phandles until all the requested entry is found */
-- 
1.7.11.1

