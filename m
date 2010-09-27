Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab0I0KBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:01:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62602 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932966Ab0I0KBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:01:50 -0400
Message-ID: <4CA06C98.3050402@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:06:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/7] KVM: MMU: audit: fix vcpu's spte walking
References: <4C976CCD.4030406@cn.fujitsu.com> <4C976D0C.1070302@cn.fujitsu.com>
In-Reply-To: <4C976D0C.1070302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After nested nested paging, it may using long mode to shadow 32/PAE paging
guest, so this patch fix it

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu_audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index bd2b1be..dcca3e7 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -51,7 +51,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		sp = page_header(root);
-- 
1.7.0.4

