Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2AMBIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:08:10 -0500
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:43884 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756308Ab2AMBIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:08:05 -0500
Subject: [PATCH] KVM: MMU: increment stats after event occurrence
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 13 Jan 2012 02:08:00 +0100
Message-ID: <1326416880.3416.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

It makes more sense to actually increment statistics for tlb flushes and page table entry updates after such _events_ occur, instead of before.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2a2a9b4..0b7008e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3130,8 +3130,8 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	++vcpu->stat.tlb_flush;
 }
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
@@ -3486,8 +3486,8 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
-	++vcpu->kvm->stat.mmu_pte_updated;
 	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new);
+	++vcpu->kvm->stat.mmu_pte_updated;
 }
 
 static bool need_remote_flush(u64 old, u64 new)
-- 
1.7.4.1



