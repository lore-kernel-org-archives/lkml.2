Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1AFVlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:41:46 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:43171 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab1AFVlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:41:45 -0500
Message-ID: <4D263716.3070802@lougher.demon.co.uk>
Date: Thu, 06 Jan 2011 21:41:42 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] Squashfs: simplify CONFIG_SQUASHFS_LZO handling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Get rid of messy repeated #if(n)def CONFIG_SQUASHFS_LZO code
in decompressor.c

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/decompressor.c |    8 ++------
  fs/squashfs/decompressor.h |    5 +++++
  fs/squashfs/squashfs.h     |    3 ---
  3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index d83e184..1700065 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -40,7 +40,7 @@ static const struct squashfs_decompressor squashfs_lzma_unsupported_comp_ops = {
  };

  #ifndef CONFIG_SQUASHFS_LZO
-static const struct squashfs_decompressor squashfs_lzo_unsupported_comp_ops = {
+static const struct squashfs_decompressor squashfs_lzo_comp_ops = {
  	NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
  };
  #endif
@@ -51,12 +51,8 @@ static const struct squashfs_decompressor squashfs_unknown_comp_ops = {

  static const struct squashfs_decompressor *decompressor[] = {
  	&squashfs_zlib_comp_ops,
-	&squashfs_lzma_unsupported_comp_ops,
-#ifdef CONFIG_SQUASHFS_LZO
  	&squashfs_lzo_comp_ops,
-#else
-	&squashfs_lzo_unsupported_comp_ops,
-#endif
+	&squashfs_lzma_unsupported_comp_ops,
  	&squashfs_unknown_comp_ops
  };

diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 7425f80..805bd0e 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -52,4 +52,9 @@ static inline int squashfs_decompress(struct squashfs_sb_info *msblk,
  	return msblk->decompressor->decompress(msblk, buffer, bh, b, offset,
  		length, srclength, pages);
  }
+
+#ifdef CONFIG_SQUASHFS_LZO
+extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
+#endif
+
  #endif
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 18f187f..ba729d8 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -99,6 +99,3 @@ extern const struct xattr_handler *squashfs_xattr_handlers[];

  /* zlib_wrapper.c */
  extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
-
-/* lzo_wrapper.c */
-extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
-- 
1.6.3.3

