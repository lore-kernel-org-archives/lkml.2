Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0ICIDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:03:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11511 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0ICIDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:03:40 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L85VMG-02-0NB-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@amd.com>,
        "<stable"@kernel.org, "[.32.x.34.x>, \".35.x]"@domain.invalid
Subject: [PATCH 1/4] x86: Fix misnamed AMD CPUID feature bit
Date: Fri, 3 Sep 2010 10:03:05 +0200
Message-ID: <1283500988-32409-2-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
References: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD SSE5 feature set as-it has been replaced by some extensions
to the AVX instruction set. Thus the bit formerly advertised as SSE5
is re-used for one of these extensions (XOP).
Although this changes the /proc/cpuinfo output, it is not user visible, as
there are no CPUs (yet) having this feature.
To avoid confusion this should be added to the stable series, too.

Cc: stable@kernel.org [.32.x .34.x, .35.x]
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 781a50b..c9c73d8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -152,7 +152,7 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
-- 
1.6.4


