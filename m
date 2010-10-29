Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090Ab0J2WIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:08:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14642 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab0J2WIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:08:49 -0400
Date: Fri, 29 Oct 2010 23:58:39 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] Zero memory more efficiently in
 mm/percpu.c::pcpu_mem_alloc()
Message-ID: <alpine.LNX.2.00.1010292354060.24561@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't do vmalloc() + memset() when vzalloc() will do.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 percpu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..8d75223 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -294,9 +294,7 @@ static void *pcpu_mem_alloc(size_t size)
 	if (size <= PAGE_SIZE)
 		return kzalloc(size, GFP_KERNEL);
 	else {
-		void *ptr = vmalloc(size);
-		if (ptr)
-			memset(ptr, 0, size);
+		void *ptr = vzalloc(size);
 		return ptr;
 	}
 }


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

