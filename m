Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1DZVXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:23:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1DZVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831923"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: hans.rosenfeld@amd.com, ak@linux.intel.com, hpa@zytor.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [78/106] x86, cpu: Fix regression in AMD errata checking code
Message-Id: <20110426211359.D21C83E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans Rosenfeld <hans.rosenfeld@amd.com>

commit 07a7795ca2e6e66d00b184efb46bd0e23d90d3fe upstream.

A bug in the family-model-stepping matching code caused the presence of
errata to go undetected when OSVW was not used. This causes hangs on
some K8 systems because the E400 workaround is not enabled.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1282141190-930137-1-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -687,7 +687,7 @@ bool cpu_has_amd_erratum(const int *erra
 	}
 
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	ms = (cpu->x86_model << 4) | cpu->x86_mask;
 	while ((range = *erratum++))
 		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >= AMD_MODEL_RANGE_START(range)) &&
