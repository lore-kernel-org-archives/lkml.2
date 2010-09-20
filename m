Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab0ITOHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:07:09 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:53452 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0ITOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:07:07 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2cKzz1202hzz8275bh8275dh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L91TUJ-02-9J6-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 16:06:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH 2/2] x86, CPUID: Correct operator precedence when
 generating mask
Message-ID: <20100920140621.GA4920@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NEED_<cpufeature> masks used in the CPU feature testing macros are
cutoff at the last 5 bits to prevent overflow since the cpu feature
words are 32-bit-wide bitfields. Fix this for the PSE and PGE masks too.

This wasn't a real problem since the PSE and PGE bits are nicely < 31.

Cc: stable@kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/required-features.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6c7fc25..0df924d 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -53,8 +53,8 @@
 #define NEED_PSE	0
 #define NEED_PGE	0
 #else
-#define NEED_PSE	(1<<(X86_FEATURE_PSE) & 31)
-#define NEED_PGE	(1<<(X86_FEATURE_PGE) & 31)
+#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
+#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #endif
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

