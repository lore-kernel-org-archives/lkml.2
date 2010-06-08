Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0FHMJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:09:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0FHMJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:09:29 -0400
Message-ID: <4C0E3225.5060001@cn.fujitsu.com>
Date: Tue, 08 Jun 2010 20:05:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: MMU: using wrapper function to flush local tlb
References: <4C0E31F1.70803@cn.fujitsu.com>
In-Reply-To: <4C0E31F1.70803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_flush_tlb() function instead of calling
kvm_x86_ops->tlb_flush(vcpu) directly

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 959c248..7319098 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1982,7 +1982,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		      reset_host_protection)) {
 		if (write_fault)
 			*ptwrite = 1;
-		kvm_x86_ops->tlb_flush(vcpu);
+		kvm_mmu_flush_tlb(vcpu);
 	}
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
-- 
1.6.1.2


