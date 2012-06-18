Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2FREzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:55:09 -0400
Received: from linux-sh.org ([111.68.239.195]:57562 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2FREzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:55:07 -0400
Date: Mon, 18 Jun 2012 13:55:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Makefile: fix up CROSS_COMPILE and READABLE_ASM interaction.
Message-ID: <20120618045500.GC19803@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Apologies for the re-send, forgot to Cc linux-kernel)

When the READABLE_ASM cc-option tests were added they were done so prior
to the arch Makefile include, resulting in cc-option being run on the
host cc instead of the factoring in the cross prefix set up by the
architecture.

This bumps the include back up so that cc-option actually runs on the
compiler that we're building with.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d845c2a..f5d4f47 100644
--- a/Makefile
+++ b/Makefile
@@ -561,6 +561,8 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
@@ -571,8 +573,6 @@ KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
                  $(call cc-option,-fno-partial-inlining)
 endif
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
