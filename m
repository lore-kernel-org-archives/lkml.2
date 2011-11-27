Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1K0F3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:29:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1K0F3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:29:40 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Kevin Cernekee <cernekee@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: [PATCH 04/62] mips: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:44 +0800
Message-Id: <1322371662-26166-5-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/mips/mm/c-r4k.c |    4 ++--
 arch/mips/mm/init.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index a79fe9a..e37585b 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -498,7 +498,7 @@ static inline void local_r4k_flush_cache_page(void *args)
 		if (map_coherent)
 			vaddr = kmap_coherent(page, addr);
 		else
-			vaddr = kmap_atomic(page, KM_USER0);
+			vaddr = kmap_atomic(page);
 		addr = (unsigned long)vaddr;
 	}
 
@@ -521,7 +521,7 @@ static inline void local_r4k_flush_cache_page(void *args)
 		if (map_coherent)
 			kunmap_coherent();
 		else
-			kunmap_atomic(vaddr, KM_USER0);
+			kunmap_atomic(vaddr);
 	}
 }
 
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index b7ebc4f..fbc70f3 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -207,21 +207,21 @@ void copy_user_highpage(struct page *to, struct page *from,
 {
 	void *vfrom, *vto;
 
-	vto = kmap_atomic(to, KM_USER1);
+	vto = kmap_atomic(to);
 	if (cpu_has_dc_aliases &&
 	    page_mapped(from) && !Page_dcache_dirty(from)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
 		kunmap_coherent();
 	} else {
-		vfrom = kmap_atomic(from, KM_USER0);
+		vfrom = kmap_atomic(from);
 		copy_page(vto, vfrom);
-		kunmap_atomic(vfrom, KM_USER0);
+		kunmap_atomic(vfrom);
 	}
 	if ((!cpu_has_ic_fills_f_dc) ||
 	    pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)vto);
-	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vto);
 	/* Make sure this page is cleared on other CPU's too before using it */
 	smp_wmb();
 }
-- 
1.7.4.4

