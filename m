Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2LKIMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:12:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2LKIMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:12:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,258,1355068800"; 
   d="scan'208";a="6374417"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, yinghai@kernel.org, hpa@zytor.com
Cc: davem@davemloft.net, hannes@cmpxchg.org, eric.dumazet@gmail.com,
        tj@kernel.org, shangw@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()
Date: Tue, 11 Dec 2012 16:12:03 +0800
Message-Id: <1355213523-15698-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 16:11:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 16:11:47,
	Serialize complete at 2012/12/11 16:11:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapper fucntion reserve_bootmem_generic() currently have no caller,
so clean it up.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 include/linux/bootmem.h |    3 ---
 mm/bootmem.c            |    6 ------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 6d6795d..bfc742c 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -137,9 +137,6 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 
-extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
-				   int flags);
-
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
 #else
diff --git a/mm/bootmem.c b/mm/bootmem.c
index f468185..2812730 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -439,12 +439,6 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
 	return mark_bootmem(start, end, 1, flags);
 }
 
-int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
-				   int flags)
-{
-	return reserve_bootmem(phys, len, flags);
-}
-
 static unsigned long __init align_idx(struct bootmem_data *bdata,
 				      unsigned long idx, unsigned long step)
 {
-- 
1.7.1

