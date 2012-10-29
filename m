Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab2J2RRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:17:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab2J2RRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:17:45 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dwmw2@infradead.org
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] mtd: map: Fix compilation warning
Date: Mon, 29 Oct 2012 22:47:26 +0530
Message-Id: <dd11b4d47ab566931cb943dea34e67c1ce2c3e59.1351530856.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an attempt to fix following compilation warning.

In file included from drivers/mtd/chips/cfi_cmdset_0001.c:35:0:
drivers/mtd/chips/cfi_cmdset_0001.c: In function 'cfi_intelext_write_words':
include/linux/mtd/map.h:331:11: warning: 'r.x[0]' may be used uninitialized in this function [-Wmaybe-uninitialized]

I could have used uninitialized_var() too, but didn't used it as the final else
part of map_word_load() is missing. So there is a chance that it might be passed
uninitialized. Better initialize to zero.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/mtd/map.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 3595a02..56c7936 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -328,7 +328,7 @@ static inline int map_word_bitsset(struct map_info *map, map_word val1, map_word
 
 static inline map_word map_word_load(struct map_info *map, const void *ptr)
 {
-	map_word r;
+	map_word r = {{0} };
 
 	if (map_bankwidth_is_1(map))
 		r.x[0] = *(unsigned char *)ptr;
-- 
1.7.12.rc2.18.g61b472e

