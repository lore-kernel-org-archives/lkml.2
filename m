Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2KEMJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:09:35 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46770 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2KEMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:09:32 -0500
Message-ID: <5097AC70.1080904@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 20:09:20 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/5] KVM: MMU: cleanup mapping-level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110512-3568-0000-0000-000002B80136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use min() to cleanup mapping_level

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1d8869c..692ebb1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -831,8 +831,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;

-	max_level = kvm_x86_ops->get_lpage_level() < host_level ?
-		kvm_x86_ops->get_lpage_level() : host_level;
+	max_level = min(kvm_x86_ops->get_lpage_level(), host_level);

 	for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level)
 		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
-- 
1.7.7.6

