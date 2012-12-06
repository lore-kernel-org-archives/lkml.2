Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab2LFWVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:21:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964856Ab2LFWU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:20:58 -0500
Subject: [PATCH 05/10] kvm: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 06 Dec 2012 15:20:57 -0700
Message-ID: <20121206222056.24968.83490.stgit@bling.home>
In-Reply-To: <20121206214722.24968.6043.stgit@bling.home>
References: <20121206214722.24968.6043.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easy to confuse KVM_MEMORY_SLOTS and KVM_MEM_SLOTS_NUM.  One is
the user accessible slots and the other is user + private.  Make this
more obvious.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h    |    2 +-
 arch/ia64/kvm/kvm-ia64.c            |    2 +-
 arch/powerpc/include/asm/kvm_host.h |    4 ++--
 arch/powerpc/kvm/book3s_hv.c        |    2 +-
 arch/s390/include/asm/kvm_host.h    |    2 +-
 arch/x86/include/asm/kvm_host.h     |    4 ++--
 arch/x86/include/asm/vmx.h          |    6 +++---
 arch/x86/kvm/x86.c                  |    6 +++---
 include/linux/kvm_host.h            |    2 +-
 virt/kvm/kvm_main.c                 |    8 ++++----
 10 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 6d6a5ac..48d7b0e 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -23,7 +23,7 @@
 #ifndef __ASM_KVM_HOST_H
 #define __ASM_KVM_HOST_H
 
-#define KVM_MEMORY_SLOTS 32
+#define KVM_USER_MEM_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 8b3a9c0..f1a46bd 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1831,7 +1831,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 28e8f5e..5eb1dd8 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -37,10 +37,10 @@
 
 #define KVM_MAX_VCPUS		NR_CPUS
 #define KVM_MAX_VCORES		NR_CPUS
-#define KVM_MEMORY_SLOTS 32
+#define KVM_USER_MEM_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
-#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #ifdef CONFIG_KVM_MMIO
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 721d460..75ce80e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1262,7 +1262,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index b784154..ac33432 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -20,7 +20,7 @@
 #include <asm/cpu.h>
 
 #define KVM_MAX_VCPUS 64
-#define KVM_MEMORY_SLOTS 32
+#define KVM_USER_MEM_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2e11f4..e619519 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,10 +31,10 @@
 
 #define KVM_MAX_VCPUS 254
 #define KVM_SOFT_MAX_VCPUS 160
-#define KVM_MEMORY_SLOTS 32
+#define KVM_USER_MEM_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
-#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_MMIO_SIZE 16
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 36ec21c..72932d2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -427,9 +427,9 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define TSS_PRIVATE_MEMSLOT			(KVM_MEMORY_SLOTS + 0)
-#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 1)
-#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 2)
+#define TSS_PRIVATE_MEMSLOT			(KVM_USER_MEM_SLOTS + 0)
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 1)
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 2)
 
 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f76417..1aa3fae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2204,7 +2204,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	case KVM_CAP_NR_MEMSLOTS:
-		r = KVM_MEMORY_SLOTS;
+		r = KVM_USER_MEM_SLOTS;
 		break;
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
@@ -3135,7 +3135,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
@@ -6449,7 +6449,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
 
 	/* Prevent internal slot pages from being moved by fork()/COW. */
-	if (memslot->id >= KVM_MEMORY_SLOTS)
+	if (memslot->id >= KVM_USER_MEM_SLOTS)
 		map_flags = MAP_SHARED | MAP_ANONYMOUS;
 
 	/*To keep backward compatibility with older userspace,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecc5543..fb9354d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -299,7 +299,7 @@ struct kvm_irq_routing_table {};
 #endif
 
 #ifndef KVM_MEM_SLOTS_NUM
-#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 #endif
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 24a67f0..0a866c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -766,7 +766,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Check for overlaps */
 	r = -EEXIST;
 	kvm_for_each_memslot(slot, kvm->memslots) {
-		if (slot->id >= KVM_MEMORY_SLOTS || slot == memslot)
+		if (slot->id >= KVM_USER_MEM_SLOTS || slot == memslot)
 			continue;
 		if (!((base_gfn + npages <= slot->base_gfn) ||
 		      (base_gfn >= slot->base_gfn + slot->npages)))
@@ -900,7 +900,7 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   kvm_userspace_memory_region *mem,
 				   int user_alloc)
 {
-	if (mem->slot >= KVM_MEMORY_SLOTS)
+	if (mem->slot >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
@@ -914,7 +914,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long any = 0;
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
@@ -960,7 +960,7 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);
 
-	if (!memslot || memslot->id >= KVM_MEMORY_SLOTS ||
+	if (!memslot || memslot->id >= KVM_USER_MEM_SLOTS ||
 	      memslot->flags & KVM_MEMSLOT_INVALID)
 		return 0;
 

