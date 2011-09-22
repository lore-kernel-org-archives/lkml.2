Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1IVIyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:54:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab1IVIyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:54:50 -0400
Message-ID: <4E7AF85A.4050102@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:56:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 08/11] KVM: MMU: remove unnecessary kvm_mmu_free_some_pages
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:53:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:53:24,
	Serialize complete at 2011-09-22 16:53:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kvm_mmu_pte_write, we do not need to alloc shadow page, so calling
kvm_mmu_free_some_pages is really unnecessary

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4128aba..7b22f3a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3589,7 +3589,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 */
 	mmu_topup_memory_caches(vcpu);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 	if (gfn == vcpu->arch.last_pt_write_gfn
-- 
1.7.5.4

