Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1K0Fh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1K0FhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:37:24 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 49/62] kdb: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:29 +0800
Message-Id: <1322371662-26166-50-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 kernel/debug/kdb/kdb_support.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 5532dd3..e593fd7 100644
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
1.7.4.4

