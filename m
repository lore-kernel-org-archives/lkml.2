Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1CDK5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:57:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDK5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:57:12 -0500
Message-ID: <4D70C5BA.1000604@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 18:58:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/10] KVM: MMU: set spte accessed bit properly
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:55:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:55:56,
	Serialize complete at 2011-03-04 18:55:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set spte accessed bit only if guest_initiated == 1 that means the really
accessed

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 10e0982..6e9cb35 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3307,11 +3307,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
 		gentry = 0;
-	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 	if (guest_initiated) {
+		kvm_mmu_access_page(vcpu, gfn);
 		if (gfn == vcpu->arch.last_pt_write_gfn
 		    && !last_updated_pte_accessed(vcpu)) {
 			++vcpu->arch.last_pt_write_count;
-- 
1.7.4

