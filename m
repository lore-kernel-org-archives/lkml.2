Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0J3VJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:53 -0400
Received: from mail.perches.com ([173.55.12.10]:3802 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0J3VJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:49 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 34/39] mm: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:51 -0700
Message-Id: <01d3ac1297677b782018d82a25e2ca82f7d1ca09.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/percpu.c  |    4 ++--
 mm/vmalloc.c |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..0aef392 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -715,8 +715,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	unsigned long flags;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
-		WARN(true, "illegal size (%zu) or align (%zu) for "
-		     "percpu allocation\n", size, align);
+		WARN(true, "illegal size (%zu) or align (%zu) for percpu allocation\n",
+		     size, align);
 		return NULL;
 	}
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a3d66b3..bf71c20 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1371,14 +1371,13 @@ static void __vunmap(const void *addr, int deallocate_pages)
 		return;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
-		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
+		WARN(1, "Trying to vfree() bad address (%p)\n", addr);
 		return;
 	}
 
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
-		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
-				addr);
+		WARN(1, "Trying to vfree() nonexistent vm area (%p)\n", addr);
 		return;
 	}
 
-- 
1.7.3.1.g432b3.dirty

