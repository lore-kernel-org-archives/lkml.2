Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2BJFqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:46:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2BJFqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:46:45 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 47/60] kdb: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:08 +0800
Message-Id: <1328852421-19678-48-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 kernel/debug/kdb/kdb_support.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 7d6fb40..d35cc2d 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -384,9 +384,9 @@ static int kdb_getphys(void *res, unsigned long addr, size_t size)
 	if (!pfn_valid(pfn))
 		return 1;
 	page = pfn_to_page(pfn);
-	vaddr = kmap_atomic(page, KM_KDB);
+	vaddr = kmap_atomic(page);
 	memcpy(res, vaddr + (addr & (PAGE_SIZE - 1)), size);
-	kunmap_atomic(vaddr, KM_KDB);
+	kunmap_atomic(vaddr);
 
 	return 0;
 }
-- 
1.7.7.6

