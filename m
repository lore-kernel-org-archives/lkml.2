Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0CYUCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:02:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0CYUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:02:47 -0400
Message-ID: <4BABC184.2070401@vlnb.net>
Date: Thu, 25 Mar 2010 23:03:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH]: Remove dead copy_io_context()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ZDSh5kWrtBz+8p9GKRRpY18tj618FXXpRpdn
 MTMcZXB1d3sxPEq9ej3bsYWRLGAi/t0XwqwMRXKdLJhxRPVZj+
 Jb2yTW3rY7/GhGLAt0aSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since anticipatory IO scheduler was removed, copy_io_context() function
isn't used anymore, so this patch removes it.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 block/blk-ioc.c           |   14 --------------
 include/linux/iocontext.h |    1 -
 2 files changed, 15 deletions(-)

diff -upkr linux-2.6.33/block/blk-ioc.c linux-2.6.33/block/blk-ioc.c
--- linux-2.6.33/block/blk-ioc.c	2010-02-24 21:52:17.000000000 +0300
+++ linux-2.6.33/block/blk-ioc.c	2010-03-25 22:49:30.000000000 +0300
@@ -152,20 +152,6 @@ struct io_context *get_io_context(gfp_t 
 }
 EXPORT_SYMBOL(get_io_context);
 
-void copy_io_context(struct io_context **pdst, struct io_context **psrc)
-{
-	struct io_context *src = *psrc;
-	struct io_context *dst = *pdst;
-
-	if (src) {
-		BUG_ON(atomic_long_read(&src->refcount) == 0);
-		atomic_long_inc(&src->refcount);
-		put_io_context(dst);
-		*pdst = src;
-	}
-}
-EXPORT_SYMBOL(copy_io_context);
-
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
diff -upkr linux-2.6.33/include/linux/iocontext.h linux-2.6.33/include/linux/iocontext.h
--- linux-2.6.33/include/linux/iocontext.h	2010-02-24 21:52:17.000000000 +0300
+++ linux-2.6.33/include/linux/iocontext.h	2010-03-25 22:49:16.000000000 +0300
@@ -77,7 +77,6 @@ int put_io_context(struct io_context *io
 void exit_io_context(struct task_struct *task);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
-void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(struct task_struct *task)
 {
