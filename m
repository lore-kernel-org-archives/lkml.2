Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2LKPFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:05:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2LKPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:05:08 -0500
From: Borislav Petkov <bp@alien8.de>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH] dma_buf: Cleanup dma_buf_fd
Date: Tue, 11 Dec 2012 16:05:26 +0100
Message-Id: <1355238326-9482-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant 'error' variable.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/base/dma-buf.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 460e22dee36d..a384b63be757 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -134,15 +134,14 @@ EXPORT_SYMBOL_GPL(dma_buf_export);
  */
 int dma_buf_fd(struct dma_buf *dmabuf, int flags)
 {
-	int error, fd;
+	int fd;
 
 	if (!dmabuf || !dmabuf->file)
 		return -EINVAL;
 
-	error = get_unused_fd_flags(flags);
-	if (error < 0)
-		return error;
-	fd = error;
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
 
 	fd_install(fd, dmabuf->file);
 
-- 
1.8.0

