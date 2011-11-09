Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1KILhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:37:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1KILhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:37:19 -0500
Message-ID: <4EBA65E5.1050506@gmail.com>
Date: Wed, 09 Nov 2011 19:37:09 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3][RESEND] mm/memblock.c: return -ENOMEM instead of -ENXIO
 on failure of debugfs_create_dir in memblock_init_debugfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the failure of debugfs_create_dir, we should return -ENOMEM
instead of -ENXIO.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index ccbf973..4d4d5ee 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -852,7 +852,7 @@ static int __init memblock_init_debugfs(void)
 {
 	struct dentry *root = debugfs_create_dir("memblock", NULL);
 	if (!root)
-		return -ENXIO;
+		return -ENOMEM;
 	debugfs_create_file("memory", S_IRUGO, root, &memblock.memory, &memblock_debug_fops);
 	debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved, &memblock_debug_fops);
 
-- 
1.7.1

