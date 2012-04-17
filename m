Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2DQQra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:47:30 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:64735 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2DQQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:47:27 -0400
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>
Subject: [RFC][PATCH 3/3] ext4: add FALLOC_FL_NO_HIDE_STALE support
Date: Wed, 18 Apr 2012 00:53:38 +0800
Message-Id: <1334681618-9452-4-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

When FALLOC_FL_NO_HIDE_STALE flag is marked, we create an initialized
extent directly.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1421938..efb5150 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4291,7 +4291,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~FALLOC_FL_SUPPORTED_FLAGS)
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
@@ -4316,7 +4316,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 		return ret;
 	}
-	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
+	if (mode & FALLOC_FL_NO_HIDE_STALE)
+		flags = EXT4_GET_BLOCKS_CREATE;
+	else
+		flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 	/*
-- 
1.7.4.1

