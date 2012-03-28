Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2C1Svq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:51:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:20450 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506Ab2C1Svo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134222695"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] x86: Use -mno-avx when available
Date: Wed, 28 Mar 2012 11:51:17 -0700
Message-Id: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On gccs that support AVX it's a good idea to disable that too, similar to
how SSE2, SSE1 etc. are already disabled. This prevents the compiler
from generating AVX ever implicitely.

No failure observed, just from review.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba12..2c8aefd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -113,6 +113,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
-- 
1.7.7.6

