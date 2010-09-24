Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab0IXVcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:32:09 -0400
Received: from king.tilera.com ([72.1.168.226]:59933 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab0IXVcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:32:07 -0400
Message-Id: <201009242132.o8OLW5H9002651@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 24 Sep 2010 17:19:20 -0400
Subject: [PATCH] arch/tile: remove dead code from intvec_32.S
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 24 Sep 2010 21:32:06.0313 (UTC) FILETIME=[EF981190:01CB5C2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This "bpt_code" instruction was killed off in our development line a while
ago (the actual definition of bpt_code that is used is in kernel/traps.c)
but I didn't push it for 2.6.36 because it seemed harmless and I didn't
want to try to push more than absolutely necessary.

However, we recently fixed a bug in our gcc that had been causing
"-gdwarf2" not to be passed to the assembler, and passing this flag causes
an erroneous assembler failure in the presence of code in a data section,
sometimes.  While we'd like to track down the bug in the assembler,
we'd also like to make sure 2.6.36 builds with the current toolchain,
so I'm removing this dead code as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 84f296c..8f58bdf 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1506,13 +1506,6 @@ handle_ill:
 	}
 	STD_ENDPROC(handle_ill)
 
-	.pushsection .rodata, "a"
-	.align  8
-bpt_code:
-	bpt
-	ENDPROC(bpt_code)
-	.popsection
-
 /* Various stub interrupt handlers and syscall handlers */
 
 STD_ENTRY_LOCAL(_kernel_double_fault)
-- 
1.6.5.2

