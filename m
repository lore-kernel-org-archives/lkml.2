Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0IMUPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:15:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:46365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0IMUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656856278"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3/5] x86, cpu: Remove gcc 3.x workarounds in <asm/cpufeature.h>
Date: Mon, 13 Sep 2010 13:14:38 -0700
Message-Id: <1284408880-14414-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer support gcc 3.x, so remove the workaround for it.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 781a50b..830a94f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -345,7 +345,6 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #endif
 }
 
-#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
@@ -354,12 +353,6 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
-#else
-/*
- * gcc 3.x is too stupid to do the static test; fall back to dynamic.
- */
-#define static_cpu_has(bit) boot_cpu_has(bit)
-#endif
 
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
-- 
1.7.2.1

