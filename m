Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0FHMKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:10:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60782 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0FHMKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:10:33 -0400
Message-ID: <4C0E3265.4020601@cn.fujitsu.com>
Date: Tue, 08 Jun 2010 20:07:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: MMU: delay local tlb flush
References: <4C0E31F1.70803@cn.fujitsu.com>
In-Reply-To: <4C0E31F1.70803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delay local tlb flush until enter guest moden, it can reduce vpid flush
frequency and reduce remote tlb flush IPI(if KVM_REQ_TLB_FLUSH bit is
already set, IPI is not sent)

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7319098..75ddaa1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2362,7 +2362,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops->tlb_flush(vcpu);
+	set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests);
 }
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
-- 
1.6.1.2


