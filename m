Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0H0TPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:15:54 -0400
Received: from wsip-70-167-241-26.dc.dc.cox.net ([70.167.241.26]:37098 "EHLO
	firewall1" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773Ab0H0TPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:15:50 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 15:15:50 EDT
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Liu Yu <yu.liu@freescale.com>, Kyle Moffett <kyle@moffetthome.net>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: [PATCH] powerpc/kvm/e500_tlb: Fix a minor copy-paste tracing bug
Date: Fri, 27 Aug 2010 15:06:45 -0400
Message-Id: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvmppc_e500_stlbe_invalidate() function was trying to pass too many
parameters to trace_kvm_stlb_inval().  This appears to be a bad
copy-paste from a call to trace_kvm_stlb_write().

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/kvm/e500_tlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 21011e1..1261a21 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -226,8 +226,7 @@ static void kvmppc_e500_stlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	kvmppc_e500_shadow_release(vcpu_e500, tlbsel, esel);
 	stlbe->mas1 = 0;
-	trace_kvm_stlb_inval(index_of(tlbsel, esel), stlbe->mas1, stlbe->mas2,
-			     stlbe->mas3, stlbe->mas7);
+	trace_kvm_stlb_inval(index_of(tlbsel, esel));
 }
 
 static void kvmppc_e500_tlb1_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
-- 
1.7.1

