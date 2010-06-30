Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0F3IHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:07:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51498 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0F3IHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:07:52 -0400
Message-ID: <4C2AFA76.8030702@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:04:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3 4/11] KVM: MMU: fix forgot to flush all vcpu's tlb
References: <4C2AF9FA.9020601@cn.fujitsu.com>
In-Reply-To: <4C2AF9FA.9020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After remove a rmap, we should flush all vcpu's tlb

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24290f8..a0c5c31 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1941,6 +1941,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			pgprintk("hfn old %lx new %lx\n",
 				 spte_to_pfn(*sptep), pfn);
 			rmap_remove(vcpu->kvm, sptep);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
 			was_rmapped = 1;
 	}
-- 
1.6.1.2


