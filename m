Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312Ab0FKNdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:33:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59947 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760268Ab0FKNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:33:15 -0400
Message-ID: <4C123A46.5010307@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:29:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/7] KVM: MMU: cleanup for dirty page judgment
References: <4C1239EE.3090904@cn.fujitsu.com>
In-Reply-To: <4C1239EE.3090904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using wrap function to cleanup page dirty judgment

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 8d00bb2..876e705 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -287,7 +287,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, PT_PAGE_TABLE_LEVEL,
+		     is_dirty_gpte(gpte), NULL, PT_PAGE_TABLE_LEVEL,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
@@ -319,7 +319,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
-				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
+				     is_dirty_gpte(gw->ptes[gw->level-1]),
 				     ptwrite, level,
 				     gw->gfn, pfn, false, true);
 			break;
-- 
1.6.1.2


