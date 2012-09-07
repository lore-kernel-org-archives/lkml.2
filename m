Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2IGGPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:15:17 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46610 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2IGGPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:15:13 -0400
Message-ID: <504990E7.6040604@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 14:15:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: MMU: remove unnecessary check
References: <5049908A.7070501@linux.vnet.ibm.com>
In-Reply-To: <5049908A.7070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090706-7014-0000-0000-000001DB479F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the return of kvm_mmu_get_page is unnecessary since it is
guaranteed by memory cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3c10bca..98cf4bf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2625,11 +2625,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
 					      iterator.level - 1,
 					      1, ACC_ALL, iterator.sptep);
-			if (!sp) {
-				pgprintk("nonpaging_map: ENOMEM\n");
-				mmu_release_pfn_clean(pfn);
-				return -ENOMEM;
-			}

 			mmu_spte_set(iterator.sptep,
 				     __pa(sp->spt)
-- 
1.7.7.6

