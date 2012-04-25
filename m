Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab2DYUAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:00:14 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33280 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab2DYUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:00:13 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 2/2] mm: memblock - Handled failure of debug fs entries creation
Date: Thu, 26 Apr 2012 01:29:52 +0530
Message-Id: <1335383992-19419-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Removed already created debug fs entries on failure

2) Fixed coding style 80 char per line

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 mm/memblock.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a44eab3..5553723 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -966,11 +966,19 @@ static int __init memblock_init_debugfs(void)
 {
 	struct dentry *root = debugfs_create_dir("memblock", NULL);
 	if (!root)
-		return -ENXIO;
-	debugfs_create_file("memory", S_IRUGO, root, &memblock.memory, &memblock_debug_fops);
-	debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved, &memblock_debug_fops);
+		return -ENOMEM;
+
+	if (!debugfs_create_file("memory", S_IRUGO, root, &memblock.memory,
+				&memblock_debug_fops))
+		goto fail;
+	if (!debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved,
+				&memblock_debug_fops))
+		goto fail;
 
 	return 0;
+fail:
+	debugfs_remove_recursive(root);
+	return -ENOMEM;
 }
 __initcall(memblock_init_debugfs);
 
-- 
1.7.3.4

