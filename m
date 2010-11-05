Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0KEDKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:10:22 -0400
Received: from mail.perches.com ([173.55.12.10]:4207 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0KEDJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:13 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 49/49] virt/kvm/kvm_main.c: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:13 -0700
Message-Id: <e57b4ed114851004b2839cb449937fc657634362.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 virt/kvm/kvm_main.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5225052..c2a08e6e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -604,13 +604,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate if a slot is being created */
 #ifndef CONFIG_S390
 	if (npages && !new.rmap) {
-		new.rmap = vmalloc(npages * sizeof(*new.rmap));
-
+		new.rmap = vzalloc(npages * sizeof(*new.rmap));
 		if (!new.rmap)
 			goto out_free;
 
-		memset(new.rmap, 0, npages * sizeof(*new.rmap));
-
 		new.user_alloc = user_alloc;
 		new.userspace_addr = mem->userspace_addr;
 	}
@@ -633,14 +630,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			     >> KVM_HPAGE_GFN_SHIFT(level));
 		lpages -= base_gfn >> KVM_HPAGE_GFN_SHIFT(level);
 
-		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
+		new.lpage_info[i] = vzalloc(lpages * sizeof(*new.lpage_info[i]));
 
 		if (!new.lpage_info[i])
 			goto out_free;
 
-		memset(new.lpage_info[i], 0,
-		       lpages * sizeof(*new.lpage_info[i]));
-
 		if (base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
 			new.lpage_info[i][0].write_count = 1;
 		if ((base_gfn+npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
@@ -663,10 +657,9 @@ skip_lpage:
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(&new);
 
-		new.dirty_bitmap = vmalloc(dirty_bytes);
+		new.dirty_bitmap = vzalloc(dirty_bytes);
 		if (!new.dirty_bitmap)
 			goto out_free;
-		memset(new.dirty_bitmap, 0, dirty_bytes);
 		/* destroy any largepage mappings for dirty tracking */
 		if (old.npages)
 			flush_shadow = 1;
-- 
1.7.3.1.g432b3.dirty

