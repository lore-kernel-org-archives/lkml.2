Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2GQNxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:53:39 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53159 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab2GQNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:53:36 -0400
Message-ID: <50056E59.4090003@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:53:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-1618-0000-0000-00000214409A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it have no indirect shadow pages we need not protect any gfn,
this is always true for direct mmu without nested

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 28b12e2..a846a9c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2294,6 +2294,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
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

