Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1HEWuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:50:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42216 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1HEWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:50:54 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Ben Dooks <ben-i2c@fluff.org>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, John Bonesio <bones@secretlab.ca>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dt: add empty of_get_property for non-dt
Date: Fri,  5 Aug 2011 16:50:30 -0600
Message-Id: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds empty function of_get_property for non-dt build, so that
drivers migrating to dt can save some '#ifdef CONFIG_OF'.

This also fixes the current Tegra compile problem in linux-next.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/of.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 0085bb0..9180dc5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -256,6 +256,13 @@ static inline int of_property_read_string(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline const void *of_get_property(const struct device_node *node,
+				const char *name,
+				int *lenp)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 
 static inline int of_property_read_u32(const struct device_node *np,
-- 
1.7.0.4

