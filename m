Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab0I0J5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:57:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab0I0J5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:57:47 -0400
Message-ID: <4CA06BA4.4090303@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:02:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/7] KVM: MMU: update 'root_hpa' out of loop in PAE shadow
 path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of 'vcpu->arch.mmu.pae_root' is not modified, so we can update 'root_hpa'
out of the loop

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c94c432..3630046 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2393,8 +2393,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			++sp->root_count;
 			spin_unlock(&vcpu->kvm->mmu_lock);
 			vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
-			vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 		}
+		vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 	} else
 		BUG();
 
@@ -2466,8 +2466,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
 		vcpu->arch.mmu.pae_root[i] = root | pm_mask;
-		vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 	}
+	vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
 
 	/*
 	 * If we shadow a 32 bit page table with a long mode page
-- 
1.7.0.4
