Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1HQKet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:34:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59438 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1HQKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:34:48 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH] Media controller: Define media_entity_init() and media_entity_cleanup() conditionally
Date: Wed, 17 Aug 2011 16:04:36 +0530
Message-ID: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Defines the two functions only when CONFIG_MEDIA_CONTROLLER
is enabled.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 include/media/media-entity.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cd8bca6..c90916e 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -121,9 +121,18 @@ struct media_entity_graph {
 	int top;
 };
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
+#else
+static inline int media_entity_init(struct media_entity *entity, u16 num_pads,
+		struct media_pad *pads, u16 extra_links)
+{
+	return 0;
+}
+static inline void media_entity_cleanup(struct media_entity *entity) {}
+#endif
 
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
-- 
1.7.0.4

