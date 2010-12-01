Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0LAPLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:11:37 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:47595 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab0LAPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:11:36 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] cramfs: hide function prototypes behind __KERNEL__ macro
Date: Wed,  1 Dec 2010 17:10:43 +0200
Message-Id: <1291216245-18574-3-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, 3 kernel function prototypes are present in a header
file exported to userland. This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
---
 include/linux/cramfs_fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/cramfs_fs.h b/include/linux/cramfs_fs.h
index 6fc2bed..0e7bf27 100644
--- a/include/linux/cramfs_fs.h
+++ b/include/linux/cramfs_fs.h
@@ -84,9 +84,11 @@ struct cramfs_super {
 				| CRAMFS_FLAG_WRONG_SIGNATURE \
 				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
 
+#ifdef __KERNEL__
 /* Uncompression interfaces to the underlying zlib */
 int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
 int cramfs_uncompress_init(void);
 void cramfs_uncompress_exit(void);
+#endif /* __KERNEL__ */
 
 #endif
-- 
1.7.2.1.45.gb66c2

