Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2DQQr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:47:26 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:36088 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2DQQrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:47:23 -0400
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>
Subject: [RFC][PATCH 1/3] vfs: add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 00:53:36 +0800
Message-Id: <1334681618-9452-2-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

FALLOC_FL_NO_HIDE_STALE flag is defined in fallocate for avoiding a
uninitialized->initialized conversion.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/open.c              |    2 +-
 include/linux/falloc.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5720854..1d3117f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~FALLOC_FL_SUPPORTED_FLAGS)
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 73e0b62..0d5d5aa 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -3,6 +3,11 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
+#define FALLOC_FL_NO_HIDE_STALE	0x04 /* no stale allocation */
+
+#define FALLOC_FL_SUPPORTED_FLAGS (FALLOC_FL_KEEP_SIZE | \
+				    FALLOC_FL_PUNCH_HOLE | \
+				    FALLOC_FL_NO_HIDE_STALE)
 
 #ifdef __KERNEL__
 
-- 
1.7.4.1

