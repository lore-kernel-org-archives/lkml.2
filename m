Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1KQKIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:08:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1KQKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:08:35 -0500
Message-ID: <4EC4DD20.6080201@evidence.eu.com>
Date: Thu, 17 Nov 2011 11:08:32 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] drivers/base/node.c: fix compilation error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	the current mainline kernel gives a "directives may not be used
inside a macro argument" error message when compiled for the
cris architecture.

It happened for the /fs/proc/meminfo.c file, for which a patch has been
already sent to LKML.

It happens for drivers/base/node.c too. The patch below fixes the
problem.

Best regards,

	Claudio


Subject: /drivers/base/node.c: fix compilation error
From: Claudio Scordino <claudio@evidence.eu.com>

Patch to fix the error message "directives may not be used inside a macro
argument" which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
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
1.7.1

