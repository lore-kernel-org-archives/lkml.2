Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1K1Mnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:43:41 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47001 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1K1Mnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:43:39 -0500
Message-ID: <4ED381E6.4070309@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 20:43:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/5] KVM: MMU: remove oos_shadow parameter
References: <4ED3811F.1070101@linux.vnet.ibm.com>
In-Reply-To: <4ED3811F.1070101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112802-9264-0000-0000-00000048B453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unsync code should be stable now, maybe it is the time to remove this
parameter to cleanup the code a little bit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt |    3 ---
 arch/x86/kvm/mmu.c                  |    5 -----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..7402a24 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1178,9 +1178,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
 			Default is 0 (don't ignore, but inject #GP)

-	kvm.oos_shadow=	[KVM] Disable out-of-sync shadow paging.
-			Default is 1 (enabled)
-
 	kvm.mmu_audit=	[KVM] This is a R/W parameter which allows audit
 			KVM MMU at runtime.
 			Default is 0 (off)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 262a3af..b1178d1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -93,9 +93,6 @@ static int dbg = 0;
 module_param(dbg, bool, 0644);
 #endif

-static int oos_shadow = 1;
-module_param(oos_shadow, bool, 0644);
-
 #ifndef MMU_DEBUG
 #define ASSERT(x) do { } while (0)
 #else
@@ -2196,8 +2193,6 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 			return 1;

 		if (!need_unsync && !s->unsync) {
-			if (!oos_shadow)
-				return 1;
 			need_unsync = true;
 		}
 	}
-- 
1.7.7.3

