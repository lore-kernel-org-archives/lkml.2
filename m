Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3AHKng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:43:36 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:57327 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3AHKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:43:34 -0500
Date: Tue, 8 Jan 2013 19:44:09 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] KVM: MMU: Remove unused parameter level from
 __rmap_write_protect()
Message-Id: <20130108194409.563b2a74.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer need to care about the mapping level in this function.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 01d7c2a..bee3509 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1142,7 +1142,7 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 }
 
 static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
-				 int level, bool pt_protect)
+				 bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1180,7 +1180,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmapp = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 				      PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);
+		__rmap_write_protect(kvm, rmapp, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1199,7 +1199,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i, true);
+		write_protected |= __rmap_write_protect(kvm, rmapp, true);
 	}
 
 	return write_protected;
-- 
1.7.5.4

