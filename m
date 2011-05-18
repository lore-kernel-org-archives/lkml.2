Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1ERQfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:35:20 -0400
Received: from mail.tpi.com ([70.99.223.143]:1161 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012Ab1ERQfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:35:18 -0400
To: viro@zeniv.linux.org.uk
Subject: [PATCH 1/1] 2.6.39-rc7+ fs: Fix spinlock recursion in get_active_super()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20110518163500.5CA99F912D@sepang.rtg.net>
Date: Wed, 18 May 2011 10:35:00 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7d9161350188c8132210eea5c7f6edff94e6c9c Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 18 May 2011 10:30:02 -0600
Subject: [PATCH] fs: Fix spinlock recursion in get_active_super()

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 8a06881..e203e2d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -503,8 +503,8 @@ struct super_block *get_active_super(struct block_device *bdev)
 	if (!bdev)
 		return NULL;
 
-restart:
 	spin_lock(&sb_lock);
+restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (list_empty(&sb->s_instances))
 			continue;
-- 
1.7.0.4

