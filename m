Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab2J2OCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:02:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2J2OCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:02:08 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH] percpu: change a method freeing a chunk for consistency.
Date: Mon, 29 Oct 2012 22:59:58 +0900
Message-Id: <1351519198-5075-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 099a19d9('allow limited allocation before slab is online') changes a method
allocating a chunk from kzalloc to pcpu_mem_alloc.
But, it missed changing matched free operation.
It may not be a problem for now, but fix it for consistency.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>

diff --git a/mm/percpu.c b/mm/percpu.c
index ddc5efb..ec25896 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -631,7 +631,7 @@ static void pcpu_free_chunk(struct pcpu_chunk *chunk)
 	if (!chunk)
 		return;
 	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
-	kfree(chunk);
+	pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 }
 
 /*
-- 
1.7.9.5

