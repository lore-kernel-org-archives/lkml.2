Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1BUD4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:56:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32974 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1BUD4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:56:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ClzYrrfS41V1K0gKPGyzx3dVTjYEU7WvKDeYjLHG92lRdZpCh0GLkRQI1gMdVeppem
         m1nJ+2ZCyJkfBhNGKQdryfTKR0yRETstREUspJ9kEwL1wj7XgfDhkIbHjvbS1JkXo30A
         zzgXcJoEm8DcoWdETMACFHtOeNeBOt71COEJw=
From: Changli Gao <xiaosuo@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] mem: clean up the code
Date: Mon, 21 Feb 2011 11:56:08 +0800
Message-Id: <1298260568-5485-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the lines of code and simply the logic.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 drivers/char/mem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1256454..436a990 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -47,10 +47,7 @@ static inline unsigned long size_inside_page(unsigned long start,
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
 static inline int valid_phys_addr_range(unsigned long addr, size_t count)
 {
-	if (addr + count > __pa(high_memory))
-		return 0;
-
-	return 1;
+	return addr + count <= __pa(high_memory);
 }
 
 static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
