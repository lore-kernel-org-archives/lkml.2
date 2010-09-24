Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0IXQe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:34:28 -0400
Received: from kroah.org ([198.145.64.141]:38449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab0IXQ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.574907263@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [54/80] KVM: Keep slot ID in memory slot structure
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Avi Kivity <avi@redhat.com>

commit e36d96f7cfaa71870c407131eb4fbd38ea285c01 upstream.

May be used for distinguishing between internal and user slots, or for sorting
slots in size order.

Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    1 +
 2 files changed, 2 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -123,6 +123,7 @@ struct kvm_memory_slot {
 	} *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned long userspace_addr;
 	int user_alloc;
+	int id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -566,6 +566,7 @@ int __kvm_set_memory_region(struct kvm *
 
 	new = old = *memslot;
 
+	new.id = mem->slot;
 	new.base_gfn = base_gfn;
 	new.npages = npages;
 	new.flags = mem->flags;


