Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2F2UPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:15:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40757 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2F2UPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:15:01 -0400
From: Rabin Vincent <rabin@rab.in>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH] mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP
Date: Sat, 30 Jun 2012 01:44:37 +0530
Message-Id: <1341000877-12068-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
ended up replacing one occurence with a reference to the non-existent
symbol CONFIG_HAVE_MEMBLOCK_NODE.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2427706..1d0a9a3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -773,7 +773,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
-- 
1.7.9.5

