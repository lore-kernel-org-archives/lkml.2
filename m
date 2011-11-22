Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab1KVBMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757793Ab1KVBMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:12:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Claudio Scordino <claudio@evidence.eu.com>,
        stable <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] drivers/base/node.c: fix compilation error with older versions of gcc
Date: Mon, 21 Nov 2011 17:11:24 -0800
Message-Id: <1321924284-26414-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924284-26414-1-git-send-email-gregkh@suse.de>
References: <20111122005858.GB25420@kroah.com>
 <1321924284-26414-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>

Patch to fix the error message "directives may not be used inside a macro
argument" which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/node.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 793f796..5693ece 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -127,12 +127,13 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)
 			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR
+			HPAGE_PMD_NR),
+#else
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
 #endif
-		       ),
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
@@ -143,13 +144,14 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 			, nid,
 			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR)
+			HPAGE_PMD_NR));
+#else
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
 #endif
-		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
-- 
1.7.7.3

