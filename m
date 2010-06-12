Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0FLMRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 08:17:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0FLMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 08:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=Fy1e0kfgjEcBcPArpnMMaUbklAKolVIETs/0vf2f682QkLbRrXa932895gG+vvc+5s
         twI3saCugKRJdNky2vDm0YelRgIuBM1fEnLfp1XDrPJ+IqCh/LB+jUU/RuOO9IlSQa7q
         nlmfuPQeImK9n8bVTEqkrs30q0CdLGjCyJMc4=
MIME-Version: 1.0
Date: Sat, 12 Jun 2010 14:17:28 +0200
X-Google-Sender-Auth: 4mZrjrxC466eZRzJD0mP01Zt9Pw
Message-ID: <AANLkTinUhfVvK7UOC6FiW9nG6xXRwCpDlAaedbSwFo7d@mail.gmail.com>
Subject: [PATCH] These are my first patches to the kernel
From: "K.de Jong" <k.dejong@undifined.nl>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6b9ac8708d856a425a9aaa598acdea3d89485bde Mon Sep 17 00:00:00 2001
From: UndiFineD <k.dejong@undifined.nl>
Date: Sat, 12 Jun 2010 00:24:28 +0200
Subject: [PATCH] These are my first patches to the kernel
Janitor patches to kvm
Linus2.6: virt/kvm/

Signed-off-by: UndiFineD <k.dejong@undifined.nl>
---
 virt/kvm/assigned-dev.c   |    6 +++---
 virt/kvm/coalesced_mmio.h |    4 ++--
 virt/kvm/ioapic.c         |   17 ++++++++---------
 virt/kvm/ioapic.h         |   14 +++++++-------
 virt/kvm/iodev.h          |    2 +-
 virt/kvm/irq_comm.c       |    4 ++--
 virt/kvm/kvm_main.c       |   28 +++++++++++++---------------
 7 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 4d10b1e..81b0e36 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -19,8 +19,8 @@
 #include <linux/slab.h>
 #include "irq.h"

-static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct
list_head *head,
-						      int assigned_dev_id)
+static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(
+    struct list_head *head, int assigned_dev_id)
 {
 	struct list_head *ptr;
 	struct kvm_assigned_dev_kernel *match;
@@ -791,7 +791,7 @@ long kvm_vm_ioctl_assigned_device(struct kvm *kvm,
unsigned ioctl,
 			goto out_free_irq_routing;
 		r = kvm_set_irq_routing(kvm, entries, routing.nr,
 					routing.flags);
-	out_free_irq_routing:
+out_free_irq_routing:
 		vfree(entries);
 		break;
 	}
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 8a5959e..d45c5bc 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -25,9 +25,9 @@ struct kvm_coalesced_mmio_dev {
 int kvm_coalesced_mmio_init(struct kvm *kvm);
 void kvm_coalesced_mmio_free(struct kvm *kvm);
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-                                       struct kvm_coalesced_mmio_zone *zone);
+    struct kvm_coalesced_mmio_zone *zone);
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
-                                         struct kvm_coalesced_mmio_zone *zone);
+    struct kvm_coalesced_mmio_zone *zone);

 #else

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 3500dee..80f00fd 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -44,22 +44,21 @@
 #include "irq.h"

 #if 0
-#define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
+#define ioapic_debug(fmt, arg...) printk(KERN_WARNING fmt, ##arg)
 #else
 #define ioapic_debug(fmt, arg...)
 #endif
 static int ioapic_deliver(struct kvm_ioapic *vioapic, int irq);

 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
-					  unsigned long addr,
-					  unsigned long length)
+    unsigned long addr, unsigned long length)
 {
 	unsigned long result = 0;

 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
 		result = ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
-			  | (IOAPIC_VERSION_ID & 0xff));
+			| (IOAPIC_VERSION_ID & 0xff));
 		break;

 	case IOAPIC_REG_APIC_ID:
@@ -110,7 +109,7 @@ static void update_handled_vectors(struct
kvm_ioapic *ioapic)
 	for (i = 0; i < IOAPIC_NUM_PINS; ++i)
 		__set_bit(ioapic->redirtbl[i].fields.vector, handled_vectors);
 	memcpy(ioapic->handled_vectors, handled_vectors,
-	       sizeof(handled_vectors));
+	    sizeof(handled_vectors));
 	smp_wmb();
 }

@@ -221,7 +220,7 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic,
int irq, int level)
 }

 static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
-				     int trigger_mode)
+    int trigger_mode)
 {
 	int i;

@@ -277,7 +276,7 @@ static inline int ioapic_in_range(struct
kvm_ioapic *ioapic, gpa_t addr)
 }

 static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
-			    void *val)
+    void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 result;
@@ -320,7 +319,7 @@ static int ioapic_mmio_read(struct kvm_io_device
*this, gpa_t addr, int len,
 }

 static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
-			     const void *val)
+    const void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 data;
@@ -328,7 +327,7 @@ static int ioapic_mmio_write(struct kvm_io_device
*this, gpa_t addr, int len,
 		return -EOPNOTSUPP;

 	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
-		     (void*)addr, len, val);
+		     (void *)addr, len, val);
 	ASSERT(!(addr & 0xf));	/* check alignment */

 	if (len == 4 || len == 8)
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 0b190c3..9036de4 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -50,13 +50,13 @@ struct kvm_ioapic {
 };

 #ifdef DEBUG
-#define ASSERT(x)  							\
-do {									\
-	if (!(x)) {							\
-		printk(KERN_EMERG "assertion failed %s: %d: %s\n",	\
-		       __FILE__, __LINE__, #x);				\
-		BUG();							\
-	}								\
+#define ASSERT(x)\
+do {\
+	if (!(x)) {\
+		printk(KERN_EMERG "assertion failed %s: %d: %s\n",\
+		       __FILE__, __LINE__, #x);\
+		BUG();\
+	}
 } while (0)
 #else
 #define ASSERT(x) do { } while (0)
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 12fd3ca..92f436b 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -17,7 +17,7 @@
 #define __KVM_IODEV_H__

 #include <linux/kvm_types.h>
-#include <asm/errno.h>
+#include <linux/errno.h>

 struct kvm_io_device;

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a0e8880..3a5075d 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -163,7 +163,7 @@ int kvm_set_irq(struct kvm *kvm, int
irq_source_id, u32 irq, int level)
 			irq_set[i++] = *e;
 	rcu_read_unlock();

-	while(i--) {
+	while (i--) {
 		int r;
 		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level);
 		if (r < 0)
@@ -426,7 +426,7 @@ out:
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
 	  .u.irqchip.irqchip = SELECT_PIC(irq), .u.irqchip.pin = (irq) % 8 }
 #  define ROUTING_ENTRY2(irq) \
-	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
+	{ IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq) }
 #else
 #  define ROUTING_ENTRY2(irq) \
 	IOAPIC_ROUTING_ENTRY(irq)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f032806..7945231 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -48,8 +48,8 @@
 #include <linux/slab.h>

 #include <asm/processor.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm-generic/bitops/le.h>

@@ -64,7 +64,7 @@ MODULE_LICENSE("GPL");
 /*
  * Ordering of locks:
  *
- * 		kvm->lock --> kvm->slots_lock --> kvm->irq_lock
+ * kvm->lock --> kvm->slots_lock --> kvm->irq_lock
  */

 DEFINE_SPINLOCK(kvm_lock);
@@ -625,7 +625,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			     KVM_PAGES_PER_HPAGE(level);
 		lpages -= base_gfn / KVM_PAGES_PER_HPAGE(level);

-		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
+		new.lpage_info[i] = vmalloc(lpages *
+		    sizeof(*new.lpage_info[i]));

 		if (!new.lpage_info[i])
 			goto out_free;
@@ -686,8 +687,8 @@ skip_lpage:
 		 * memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
-		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-		 * 	- kvm_is_visible_gfn (mmu_check_roots)
+		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+		 *	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow(kvm);
 		kfree(old_memslots);
@@ -759,9 +760,7 @@ int kvm_set_memory_region(struct kvm *kvm,
 EXPORT_SYMBOL_GPL(kvm_set_memory_region);

 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
-				   struct
-				   kvm_userspace_memory_region *mem,
-				   int user_alloc)
+    struct kvm_userspace_memory_region *mem, int user_alloc)
 {
 	if (mem->slot >= KVM_MEMORY_SLOTS)
 		return -EINVAL;
@@ -769,7 +768,7 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 }

 int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty)
+    struct kvm_dirty_log *log, int *is_dirty)
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
@@ -998,7 +997,6 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	get_page(bad_page);
 	return bad_page;
 }
-
 EXPORT_SYMBOL_GPL(gfn_to_page);

 void kvm_release_page_clean(struct page *page)
@@ -1171,7 +1169,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa,
unsigned long len)
 	int offset = offset_in_page(gpa);
 	int ret;

-        while ((seg = next_segment(len, offset)) != 0) {
+	while ((seg = next_segment(len, offset)) != 0) {
 		ret = kvm_clear_guest_page(kvm, gfn, offset, seg);
 		if (ret < 0)
 			return ret;
@@ -1284,7 +1282,7 @@ static int kvm_vcpu_release(struct inode *inode,
struct file *filp)
 	return 0;
 }

-static struct file_operations kvm_vcpu_fops = {
+static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.compat_ioctl   = kvm_vcpu_ioctl,
@@ -1738,7 +1736,7 @@ static int kvm_vm_mmap(struct file *file, struct
vm_area_struct *vma)
 	return 0;
 }

-static struct file_operations kvm_vm_fops = {
+static const struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 #ifdef CONFIG_COMPAT
@@ -1835,7 +1833,7 @@ out:
 	return r;
 }

-static struct file_operations kvm_chardev_ops = {
+static const struct file_operations kvm_chardev_ops = {
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.compat_ioctl   = kvm_dev_ioctl,
 };
-- 
1.7.0.4
