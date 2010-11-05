Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0KEDJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:14 -0400
Received: from mail.perches.com ([173.55.12.10]:4181 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0KEDJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:07 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 41/49] fs/xfs: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:05 -0700
Message-Id: <10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/linux-2.6/kmem.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index f7c8f7a..292eff1 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -61,12 +61,7 @@ extern void  kmem_free(const void *);
 
 static inline void *kmem_zalloc_large(size_t size)
 {
-	void *ptr;
-
-	ptr = vmalloc(size);
-	if (ptr)
-		memset(ptr, 0, size);
-	return ptr;
+	return vzalloc(size);
 }
 static inline void kmem_free_large(void *ptr)
 {
-- 
1.7.3.1.g432b3.dirty

