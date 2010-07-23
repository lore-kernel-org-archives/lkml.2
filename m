Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0GWFUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:20:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab0GWFUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:20:13 -0400
Message-ID: <4C492597.2000802@cn.fujitsu.com>
Date: Fri, 23 Jul 2010 13:16:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: fix hugepage mapping corrupt caused by regression
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the regression, the bug which is fixed by commit e09e90a5
is active now

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a09e04c..d9a2742 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -374,13 +374,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	     shadow_walk_next(&it)) {
 		gfn_t direct_gfn;
 
+		validate_direct_spte(vcpu, it.sptep, direct_access);
+
 		drop_large_spte(vcpu, it.sptep);
 
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
-		validate_direct_spte(vcpu, it.sptep, direct_access);
-
 		direct_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 
 		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
-- 
1.6.1.2


