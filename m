Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2IBM6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 08:58:05 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34788 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab2IBM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 08:57:50 -0400
Message-ID: <504357C7.6060706@linux.vnet.ibm.com>
Date: Sun, 02 Sep 2012 20:57:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/6] KVM: MMU: remove unnecessary check
References: <5043578F.60602@linux.vnet.ibm.com>
In-Reply-To: <5043578F.60602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090212-1396-0000-0000-000001CE65AA
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

