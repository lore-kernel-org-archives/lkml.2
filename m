Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0LFWF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:57 -0500
Received: from mail.perches.com ([173.55.12.10]:2336 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/29] mm: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:16 -0800
Message-Id: <755232e8ff5d8f5a83ba671ca980df7efd1e27c9.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
index 0962e47..855c21c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -711,8 +711,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	unsigned long flags;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
-		WARN(true, "illegal size (%zu) or align (%zu) for "
-		     "percpu allocation\n", size, align);
+		WARN(true, "illegal size (%zu) or align (%zu) for percpu allocation\n",
+		     size, align);
 		return NULL;
 	}
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eb5cc7d..eb58343 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1377,14 +1377,13 @@ static void __vunmap(const void *addr, int deallocate_pages)
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
1.7.3.2.245.g03276.dirty

