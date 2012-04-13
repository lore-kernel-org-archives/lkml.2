Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab2DMKOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:14:20 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51421 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2DMKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:14:18 -0400
Message-ID: <4F87FC62.3020003@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:13:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 09/16] KVM: MMU: fast mmu_need_write_protect path for hard
 mmu
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-1396-0000-0000-000000F95BBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On direct mmu without nested, all the page is not write-protected by
shadow page table protection

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 53e92de..0c6e92d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2293,6 +2293,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct hlist_node *node;
 	bool need_unsync = false;

+	if (!vcpu->kvm->arch.indirect_shadow_pages)
+		return 0;
+
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (!can_unsync)
 			return 1;
-- 
1.7.7.6

