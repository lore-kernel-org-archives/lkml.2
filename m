Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1CVUjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:39:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56668 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1CVUjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:39:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: cast away printk format warning
Date: Tue, 22 Mar 2011 16:39:48 -0400
Message-Id: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit systems which don't happen to implicitly define or cast
VMALLOC_START and/or VMALLOC_END to long in their arch headers, the
printk in the percpu code will cause a warning to be emitted:

mm/percpu.c: In function 'pcpu_embed_first_chunk':
mm/percpu.c:1648: warning: format '%lx' expects type 'long unsigned int',
	but argument 3 has type 'unsigned int'

So add an explicit cast to unsigned long here.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3f93001..6897e02 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1647,7 +1647,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
 		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n",
-			   max_distance, VMALLOC_END - VMALLOC_START);
+			   max_distance, (unsigned long)(VMALLOC_END - VMALLOC_START));
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
 		rc = -EINVAL;
-- 
1.7.4.1

