Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0I3Dux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0I3Duv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FJqTl5yrvGsTmBX7xj0Kfk+wDjOFb/ARbzF/iKopuknZ29yBQRAUtHmVUEKExUkEQ1
         wSmk+rNMGuP4fYDdZefbraC0bSbt88yV86LTIVJbw2gDTepuesP5CKI5Koab9kG9kb9o
         X5gqC/tPUyY7buSRVv7tYEUlHgV4wMDM6YOPQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] rmap: make anon_vma_[chain_]free() static
Date: Thu, 30 Sep 2010 12:50:17 +0900
Message-Id: <1285818621-29890-9-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make anon_vma_free() and anon_vma_chain_free() static. They are
called only in rmap.c and corresponding alloc functions are
already static.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/rmap.h |    1 -
 mm/rmap.c            |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 490206c..be92e78 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -148,7 +148,6 @@ void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
-void anon_vma_free(struct anon_vma *);
 
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
diff --git a/mm/rmap.c b/mm/rmap.c
index 9c900dd..af7dc02 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -70,7 +70,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
 	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 }
 
-void anon_vma_free(struct anon_vma *anon_vma)
+static void anon_vma_free(struct anon_vma *anon_vma)
 {
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
@@ -80,7 +80,7 @@ static inline struct anon_vma_chain *anon_vma_chain_alloc(void)
 	return kmem_cache_alloc(anon_vma_chain_cachep, GFP_KERNEL);
 }
 
-void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
+static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 {
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
-- 
1.7.2.2

