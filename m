Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab0HESbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:16 -0400
Received: from xenotime.net ([72.52.115.56]:50736 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758346Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: matt mooney <mfm@muteddisk.com>
Subject: [PATCH 5/7] Documentation: update kbuild make typos/grammar/text flow
Message-ID: <12810325911297@xenotime.net>
In-Reply-To: <12810325911230@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Update section 3.7 examples to reflect the current state of the
Makefiles used. Fix spelling and grammar errors along with flow of text.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 Documentation/kbuild/makefiles.txt |   53 ++++++++++++---------------
 1 file changed, 25 insertions(+), 28 deletions(-)

--- linux-2.6.35-rc3.orig/Documentation/kbuild/makefiles.txt
+++ linux-2.6.35-rc3/Documentation/kbuild/makefiles.txt
@@ -285,45 +285,42 @@ more details, with real examples.
 --- 3.7 Compilation flags
 
     ccflags-y, asflags-y and ldflags-y
-	The three flags listed above applies only to the kbuild makefile
-	where they are assigned. They are used for all the normal
-	cc, as and ld invocation happenign during a recursive build.
+	The three flags listed above apply only to the kbuild makefile where
+	they are assigned (i.e., per-directory). They are used for all the
+	normal cc, as and ld invocation happening during a recursive build.
 	Note: Flags with the same behaviour were previously named:
-	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
-	They are yet supported but their use are deprecated.
+	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS. They are still
+	supported but their use is deprecated.
 
-	ccflags-y specifies options for compiling C files with $(CC).
+	ccflags-y specifies options for compiling with $(CC).
 
 	Example:
-		# drivers/sound/emu10k1/Makefile
-		ccflags-y += -I$(obj)
-		ccflags-$(DEBUG) += -DEMU10K1_DEBUG
-
+		# drivers/acpi/Makefile
+		ccflags-y := -Os
+		ccflags-$(CONFIG_ACPI_DEBUG) += -DACPI_DEBUG_OUTPUT
 
 	This variable is necessary because the top Makefile owns the
 	variable $(KBUILD_CFLAGS) and uses it for compilation flags for the
 	entire tree.
 
-	asflags-y is a similar string for per-directory options
-	when compiling assembly language source.
+	asflags-y specifies options for assembling with $(AS).
 
 	Example:
-		#arch/x86_64/kernel/Makefile
-		asflags-y := -traditional
-
+		#arch/sparc/kernel/Makefile
+		asflags-y := -ansi
 
-	ldflags-y is a string for per-directory options to $(LD).
+	ldflags-y specifies options for linking with $(LD).
 
 	Example:
-		#arch/m68k/fpsp040/Makefile
-		ldflags-y := -x
+		#arch/cris/boot/compressed/Makefile
+		ldflags-y += -T $(srctree)/$(src)/decompress_$(arch-y).lds
 
     subdir-ccflags-y, subdir-asflags-y
-	The two flags listed above are similar to ccflags-y and as-falgs-y.
-	The difference is that the subdir- variants has effect for the kbuild
-	file where tey are present and all subdirectories.
-	Options specified using subdir-* are added to the commandline before
-	the options specified using the non-subdir variants.
+	The two flags listed above are similar to ccflags-y and asflags-y.
+	The difference is that the subdir- variants affect the kbuild
+	file where they are present and all subdirectories. Options specified
+	using subdir-* are added to the commandline before the options
+	specified using the non-subdir variants.
 
 	Example:
 		subdir-ccflags-y := -Werror
@@ -341,18 +338,18 @@ more details, with real examples.
 		CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 		CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ \
 				     -DGDTH_STATISTICS
-		CFLAGS_seagate.o =   -DARBITRATE -DPARITY -DSEAGATE_USE_ASM
 
-	These three lines specify compilation flags for aha152x.o,
-	gdth.o, and seagate.o
+	These two lines specify compilation flags for aha152x.o and gdth.o.
 
 	$(AFLAGS_$@) is a similar feature for source files in assembly
 	languages.
 
 	Example:
 		# arch/arm/kernel/Makefile
-		AFLAGS_head-armv.o := -DTEXTADDR=$(TEXTADDR) -traditional
-		AFLAGS_head-armo.o := -DTEXTADDR=$(TEXTADDR) -traditional
+		AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
+		AFLAGS_crunch-bits.o := -Wa,-mcpu=ep9312
+		AFLAGS_iwmmxt.o      := -Wa,-mcpu=iwmmxt
+
 
 --- 3.9 Dependency tracking
 


-- 

