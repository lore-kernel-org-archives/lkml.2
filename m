Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab1KWAlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab1KWAlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:07 2011
Message-Id: <20111123002407.135220686@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Claudio Scordino <claudio@evidence.eu.com>,
        David Rientjes <rientjes@google.com>
Subject: [27/53] drivers/base/node.c: fix compilation error with older versions of gcc
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Scordino <claudio@evidence.eu.com>

commit 91a13c281d7d4648c0b32dede11a0144c4e7984c upstream.

Patch to fix the error message "directives may not be used inside a macro
argument" which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/node.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -127,12 +127,13 @@ static ssize_t node_read_meminfo(struct
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
@@ -143,13 +144,14 @@ static ssize_t node_read_meminfo(struct
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


