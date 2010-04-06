Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0DFKbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:31:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62356 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0DFKbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:31:37 -0400
Message-ID: <4BBB0CF1.6040204@cn.fujitsu.com>
Date: Tue, 06 Apr 2010 18:29:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] KVM MMU: remove unused field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_page.oos_link is not used, so remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/mmu.c              |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26c629a..0c49c88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -187,8 +187,6 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 
-	struct list_head oos_link;
-
 	/*
 	 * The following two entries are used to key the shadow page in the
 	 * hash table.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d7700bb..8dfe8eb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -922,7 +922,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	INIT_LIST_HEAD(&sp->oos_link);
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-- 
1.6.1.2

