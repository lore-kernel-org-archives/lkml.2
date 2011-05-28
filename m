Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1E1RhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:37:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2214 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1E1RhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:09 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 08/15] media: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:28 -0700
Message-Id: <9fdb8894cfb8778948dd9cf15711ec2ca68eb9b6.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/videobuf2-dma-sg.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index b2d9485..15d79a8 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -48,12 +48,10 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 	buf->sg_desc.size = size;
 	buf->sg_desc.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	buf->sg_desc.sglist = vmalloc(buf->sg_desc.num_pages *
+	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
 				      sizeof(*buf->sg_desc.sglist));
 	if (!buf->sg_desc.sglist)
 		goto fail_sglist_alloc;
-	memset(buf->sg_desc.sglist, 0, buf->sg_desc.num_pages *
-	       sizeof(*buf->sg_desc.sglist));
 	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
 
 	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
@@ -136,13 +134,11 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	buf->sg_desc.num_pages = last - first + 1;
 
-	buf->sg_desc.sglist = vmalloc(
+	buf->sg_desc.sglist = vzalloc(
 		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
 	if (!buf->sg_desc.sglist)
 		goto userptr_fail_sglist_alloc;
 
-	memset(buf->sg_desc.sglist, 0,
-		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
 	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
 
 	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
-- 
1.7.5.rc3.dirty

