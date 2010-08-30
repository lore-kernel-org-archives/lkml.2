Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0H3PjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:39:03 -0400
Received: from wsip-70-167-241-26.dc.dc.cox.net ([70.167.241.26]:47964 "EHLO
	firewall1" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751590Ab0H3PjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:39:01 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Liu Yu <yu.liu@freescale.com>, Kyle Moffett <kyle@moffetthome.net>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: [PATCH] powerpc/kvm/e500_tlb: Fix a minor copy-paste tracing bug
Date: Mon, 30 Aug 2010 11:38:39 -0400
Message-Id: <1283182719-4621-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvmppc_e500_stlbe_invalidate() function was trying to pass too many
parameters to trace_kvm_stlb_inval().  This appears to be a bad
copy-paste from a call to trace_kvm_stlb_write().

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

---
Alex,

This is the rebased patch to re-enable the tracepoint.

I also pushed a tree with this patch on top of kvm-ppc-next out to:
  git://opensource.exmeritus.com/hww-1u-1a/linux.git kvm-ppc-patches
  http://opensource.exmeritus.com/git/hww-1u-1a/linux.git/kvm-ppc-patches

Thanks again!

Cheers,
Kyle Moffett

---
 arch/powerpc/kvm/e500_tlb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 66845a5..a413883 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -226,11 +226,7 @@ static void kvmppc_e500_stlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	kvmppc_e500_shadow_release(vcpu_e500, tlbsel, esel);
 	stlbe->mas1 = 0;
-	/* XXX doesn't compile */
-#if 0
-	trace_kvm_stlb_inval(index_of(tlbsel, esel), stlbe->mas1, stlbe->mas2,
-			     stlbe->mas3, stlbe->mas7);
-#endif
+	trace_kvm_stlb_inval(index_of(tlbsel, esel));
 }
 
 static void kvmppc_e500_tlb1_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
-- 
1.7.1

