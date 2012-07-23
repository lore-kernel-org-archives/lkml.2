Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2GWOFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:05:31 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42875 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2GWOF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:05:28 -0400
Message-ID: <500D5A1E.6000704@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 22:05:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: MMU: using kvm_release_pfn_clean to release pfn
References: <500D59A7.9060503@linux.vnet.ibm.com>
In-Reply-To: <500D59A7.9060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072314-2000-0000-0000-0000086000CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code depends on fault_page is the normal page, but we will
use the error code instead of dummy page in the later patch, so using
kvm_release_pfn_clean to release pfn which will release error code probably

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

