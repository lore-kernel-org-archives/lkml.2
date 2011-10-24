Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1JXJxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:53:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51345 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1JXJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:53:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dt: Add empty of_match_node() macro
Date: Mon, 24 Oct 2011 11:53:32 +0200
Message-Id: <1319450012-13033-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an empty macro for of_match_node() that will save
some '#ifdef CONFIG_OF' for non-dt builds.

I have chosen to use a macro instead of a function to
be able to avoid defining the first parameter.
In fact, this "struct of_device_id *" first parameter
is usualy not defined as well on non-dt builds.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 include/linux/of.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 736b747..92c40a1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -303,6 +303,7 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
 }
 
 #define of_match_ptr(_ptr)	NULL
+#define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
 
 static inline int of_property_read_u32(const struct device_node *np,
-- 
1.7.5.4

