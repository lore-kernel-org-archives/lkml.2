Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab2IJSMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:12:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:2469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab2IJSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191253182"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 5/5] x86, fpu: remove cpu_has_xmm check in the fx_finit()
Date: Mon, 10 Sep 2012 11:11:05 -0700
Message-Id: <1347300665-6209-6-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUs with FXSAVE but no XMM/MXCSR (Pentium II from Intel,
Crusoe/TM-3xxx/5xxx from Transmeta, and presumably some of the K6
generation from AMD) ever looked at the mxcsr field during
fxrstor/fxsave. So remove the cpu_has_xmm check in the fx_finit()

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/fpu-internal.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index df023b4..9fa1a0e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -109,8 +109,7 @@ static inline void fx_finit(struct i387_fxsave_struct *fx)
 {
 	memset(fx, 0, xstate_size);
 	fx->cwd = 0x37f;
-	if (cpu_has_xmm)
-		fx->mxcsr = MXCSR_DEFAULT;
+	fx->mxcsr = MXCSR_DEFAULT;
 }
 
 extern void __sanitize_i387_state(struct task_struct *);
-- 
1.7.6.5

