Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2LJRdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:33:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2LJRd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:33:27 -0500
Subject: [PATCH v2 08/10] kvm: struct kvm_memory_slot.flags -> u32
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:33:26 -0700
Message-ID: <20121210173326.10461.74366.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct kvm_userspace_memory_region.flags is a u32 with a comment that
bits 0 ~ 15 are visible to userspace and the other bits are reserved
for kvm internal use.  KVM_MEMSLOT_INVALID is the only internal use
flag and it has a comment that bits 16 ~ 31 are internally used and
the other bits are visible to userspace.

Therefore, let's define this as a u32 so we don't waste bytes on LP64
systems.  Move to the end of the struct for alignment.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ff30f2..641f5fb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -251,10 +251,10 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
-	unsigned long flags;
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
+	u32 flags;
 	int id;
 	bool user_alloc;
 };

