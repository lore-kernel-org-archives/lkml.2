Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2J1IHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:07:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33142 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754128Ab2J1IHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:07:42 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] drivers: base: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:41 -0700
Message-Id: <0d0291f61e04007d9af7eb69138420b46a38eec1.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/base/attribute_container.c |    2 +-
 drivers/base/devres.c              |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 8fc200b..d78b204 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -158,7 +158,7 @@ attribute_container_add_device(struct device *dev,
 
 		ic = kzalloc(sizeof(*ic), GFP_KERNEL);
 		if (!ic) {
-			dev_printk(KERN_ERR, dev, "failed to allocate class container\n");
+			dev_err(dev, "failed to allocate class container\n");
 			continue;
 		}
 
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 8731979..6683906 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -50,8 +50,8 @@ static void devres_log(struct device *dev, struct devres_node *node,
 		       const char *op)
 {
 	if (unlikely(log_devres))
-		dev_printk(KERN_ERR, dev, "DEVRES %3s %p %s (%lu bytes)\n",
-			   op, node, node->name, (unsigned long)node->size);
+		dev_err(dev, "DEVRES %3s %p %s (%lu bytes)\n",
+			op, node, node->name, (unsigned long)node->size);
 }
 #else /* CONFIG_DEBUG_DEVRES */
 #define set_node_dbginfo(node, n, s)	do {} while (0)
-- 
1.7.8.112.g3fd21

