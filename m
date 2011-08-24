Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1HXLKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:10:47 -0400
Received: from d1.icnet.pl ([212.160.220.21]:41974 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1HXLKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:10:45 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3.1-rc1] ARM: entry: fix wrong parameter used in do_thumb_abort
Date: Wed, 24 Aug 2011 13:07:20 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241307.21056.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit be020f8618ca, "ARM: entry: abort-macro: specify registers to be
used for macros", while replacing register numbers with macro parameter
names, mismatched the parameter used for r1. For me, this resulted in 
user space, built for EABI with -march=armv4t -mtune=arm920t -mthumb-
interwork -mthumb, broken on my OMAP1510 based Amstrad Delta (old ABI 
with -mno-thumb still worked for me though).

Fix this by using correct parameter, fsr, instead of mismatched psr, 
used by callers for another purpose.

Tested on OMAP1510 Amstrad Delta

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mm/abort-macro.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/abort-macro.S b/arch/arm/mm/abort-macro.S
index 52162d5..2cbf68e 100644
--- a/arch/arm/mm/abort-macro.S
+++ b/arch/arm/mm/abort-macro.S
@@ -17,7 +17,7 @@
 	cmp	\tmp, # 0x5600			@ Is it ldrsb?
 	orreq	\tmp, \tmp, #1 << 11		@ Set L-bit if yes
 	tst	\tmp, #1 << 11			@ L = 0 -> write
-	orreq	\psr, \psr, #1 << 11		@ yes.
+	orreq	\fsr, \fsr, #1 << 11		@ yes.
 	b	do_DataAbort
 not_thumb:
 	.endm
-- 
1.7.3.4

