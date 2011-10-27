Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1J0JIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:08:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:46743 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1J0JH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:07:59 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dt: add empty of_alias_get_id() for non-dt builds
Date: Thu, 27 Oct 2011 11:07:28 +0200
Message-Id: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function of_alias_get_id() reporting -ENOSYS
for non-dt builds, so that drivers migrating to dt
can save some '#ifdef CONFIG_OF'.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Grant,

Another empty function for non-dt builds. Can we consider
queuing it for 3.1?

Best regards,

 include/linux/of.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 92c40a1..34d8338 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -302,6 +302,11 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
 	return NULL;
 }
 
+static inline int of_alias_get_id(struct device_node *np, const char *stem)
+{
+	return -ENOSYS;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
-- 
1.7.5.4

