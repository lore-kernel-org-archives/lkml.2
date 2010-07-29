Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0G2JFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:05:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61299 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0G2JEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:04:47 -0400
Message-ID: <4C513C95.3080403@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 16:32:21 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] btrfs: fix a wrong error check in add_ra_bio_pages()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <liubo2009@cn.fujitsu.com>

Only when a page is not found by page_index, we'll go to the error check.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/compression.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index cb3877c..8458840 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -467,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, page_index);
 		rcu_read_unlock();
-		if (page) {
+		if (!page) {
 check_misses:
 			misses++;
 			if (misses > 4)
-- 
1.7.0.1
