Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1DRW56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:57:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:52675 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1DRW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911338170"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
        mingo@elte.hu, "H. Peter Anvin" <hpa@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] x86, percpu: Use ASM_NOP4 instead of hardcoding P6_NOP4
Date: Mon, 18 Apr 2011 15:35:58 -0700
Message-Id: <1303166160-10315-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use in assembly constants, use the ASM_NOP* defines.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d475b43..751e7f3 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -517,7 +517,7 @@ do {									\
 	typeof(o2) __o2 = o2;						\
 	typeof(o2) __n2 = n2;						\
 	typeof(o2) __dummy;						\
-	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
+	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP4,	\
 		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
 		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
-- 
1.7.3.4

