Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2GZD6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:58:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43912 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2GZD61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:58:27 -0400
Message-ID: <5010C037.6070604@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 11:57:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/3] KVM: MMU: use kvm_release_pfn_clean to release pfn
References: <5010C008.4030304@linux.vnet.ibm.com>
In-Reply-To: <5010C008.4030304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072603-0260-0000-0000-000001936D97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code depends on the fact that fault_page is the normal page,
however, we will use the error code instead of these dummy pages in the
later patch, so we use kvm_release_pfn_clean to release pfn which will
release the error code properly

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2419934..a9a2052 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3275,7 +3275,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	if (!async)
 		return false; /* *pfn has correct page already */

-	put_page(pfn_to_page(*pfn));
+	kvm_release_pfn_clean(*pfn);

 	if (!prefault && can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(gva, gfn);
-- 
1.7.7.6

