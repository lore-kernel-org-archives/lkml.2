Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab0JSLSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:18:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996Ab0JSLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:18:04 -0400
X-IronPort-AV: E=Sophos;i="4.57,350,1283745600"; 
   d="scan'208";a="118686979"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 10/10] xen: mask the MTRR feature from the cpuid
Date: Tue, 19 Oct 2010 12:17:18 +0100
Message-Id: <1287487038-6643-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
X-OriginalArrivalTime: 19 Oct 2010 11:18:04.0484 (UTC) FILETIME=[4C7AD840:01CB6F7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

We don't want Linux to think that the cpu supports MTRRs when running
under Xen because MTRR operations could only be performed through
hypercalls.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9efb004..d48a32b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -243,6 +243,7 @@ static __init void xen_init_cpuid_mask(void)
 	cpuid_leaf1_edx_mask =
 		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
 		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
+		  (1 << X86_FEATURE_MTRR) |  /* disable MTRR */
 		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	if (!xen_initial_domain())
-- 
1.5.6.5

