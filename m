Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0HDMll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:41:41 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57095 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932711Ab0HDMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:41:37 -0400
Date: Wed, 4 Aug 2010 14:41:34 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, John Stultz <johnstul@us.ibm.com>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/9] arch/m68k: Removing dead GG2 config option
Message-ID: <fdc11b1532157d10fb58d3642565d496da794195.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GG2 doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68k/Kconfig               |    4 ++--
 arch/m68k/include/asm/amigahw.h |    1 -
 arch/m68k/include/asm/io_mm.h   |   37 -------------------------------------
 arch/m68k/kernel/setup.c        |    6 ------
 4 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2e3737b..2df0de5 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -437,7 +437,7 @@ config PROC_HARDWARE
 
 config ISA
 	bool
-	depends on Q40 || AMIGA_PCMCIA || GG2
+	depends on Q40 || AMIGA_PCMCIA
 	default y
 	help
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
@@ -448,7 +448,7 @@ config ISA
 
 config GENERIC_ISA_DMA
 	bool
-	depends on Q40 || AMIGA_PCMCIA || GG2
+	depends on Q40 || AMIGA_PCMCIA
 	default y
 
 config ZONE_DMA
diff --git a/arch/m68k/include/asm/amigahw.h b/arch/m68k/include/asm/amigahw.h
index 5ca5dd9..7a19b56 100644
--- a/arch/m68k/include/asm/amigahw.h
+++ b/arch/m68k/include/asm/amigahw.h
@@ -102,7 +102,6 @@ struct amiga_hw_present {
     AMIGAHW_DECLARE(ALICE_NTSC);	/* NTSC Alice (8374) */
     AMIGAHW_DECLARE(MAGIC_REKICK);	/* A3000 Magic Hard Rekick */
     AMIGAHW_DECLARE(PCMCIA);		/* PCMCIA Slot */
-    AMIGAHW_DECLARE(GG2_ISA);		/* GG2 Zorro2ISA Bridge */
     AMIGAHW_DECLARE(ZORRO);		/* Zorro AutoConfig */
     AMIGAHW_DECLARE(ZORRO3);		/* Zorro III */
 };
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index 9e673e3..63f5c54 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -49,23 +49,6 @@
 #define MULTI_ISA 0
 #endif /* Q40 */
 
-/* GG-II Zorro to ISA bridge */
-#ifdef CONFIG_GG2
-
-extern unsigned long gg2_isa_base;
-#define GG2_ISA_IO_B(ioaddr) (gg2_isa_base+1+((unsigned long)(ioaddr)*4))
-#define GG2_ISA_IO_W(ioaddr) (gg2_isa_base+  ((unsigned long)(ioaddr)*4))
-#define GG2_ISA_MEM_B(madr)  (gg2_isa_base+1+(((unsigned long)(madr)*4) & 0xfffff))
-#define GG2_ISA_MEM_W(madr)  (gg2_isa_base+  (((unsigned long)(madr)*4) & 0xfffff))
-
-#ifndef MULTI_ISA
-#define MULTI_ISA 0
-#else
-#undef MULTI_ISA
-#define MULTI_ISA 1
-#endif
-#endif /* GG2 */
-
 #ifdef CONFIG_AMIGA_PCMCIA
 #include <asm/amigayle.h>
 
@@ -89,7 +72,6 @@ extern unsigned long gg2_isa_base;
 #endif
 
 #define ISA_TYPE_Q40 (1)
-#define ISA_TYPE_GG2 (2)
 #define ISA_TYPE_AG  (3)
 
 #if defined(CONFIG_Q40) && !defined(MULTI_ISA)
@@ -100,10 +82,6 @@ extern unsigned long gg2_isa_base;
 #define ISA_TYPE ISA_TYPE_AG
 #define ISA_SEX  1
 #endif
-#if defined(CONFIG_GG2) && !defined(MULTI_ISA)
-#define ISA_TYPE ISA_TYPE_GG2
-#define ISA_SEX  0
-#endif
 
 #ifdef MULTI_ISA
 extern int isa_type;
@@ -125,9 +103,6 @@ static inline u8 __iomem *isa_itb(unsigned long addr)
 #ifdef CONFIG_Q40
     case ISA_TYPE_Q40: return (u8 __iomem *)Q40_ISA_IO_B(addr);
 #endif
-#ifdef CONFIG_GG2
-    case ISA_TYPE_GG2: return (u8 __iomem *)GG2_ISA_IO_B(addr);
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
     case ISA_TYPE_AG: return (u8 __iomem *)AG_ISA_IO_B(addr);
 #endif
@@ -141,9 +116,6 @@ static inline u16 __iomem *isa_itw(unsigned long addr)
 #ifdef CONFIG_Q40
     case ISA_TYPE_Q40: return (u16 __iomem *)Q40_ISA_IO_W(addr);
 #endif
-#ifdef CONFIG_GG2
-    case ISA_TYPE_GG2: return (u16 __iomem *)GG2_ISA_IO_W(addr);
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
     case ISA_TYPE_AG: return (u16 __iomem *)AG_ISA_IO_W(addr);
 #endif
@@ -167,9 +139,6 @@ static inline u8 __iomem *isa_mtb(unsigned long addr)
 #ifdef CONFIG_Q40
     case ISA_TYPE_Q40: return (u8 __iomem *)Q40_ISA_MEM_B(addr);
 #endif
-#ifdef CONFIG_GG2
-    case ISA_TYPE_GG2: return (u8 __iomem *)GG2_ISA_MEM_B(addr);
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
     case ISA_TYPE_AG: return (u8 __iomem *)addr;
 #endif
@@ -183,9 +152,6 @@ static inline u16 __iomem *isa_mtw(unsigned long addr)
 #ifdef CONFIG_Q40
     case ISA_TYPE_Q40: return (u16 __iomem *)Q40_ISA_MEM_W(addr);
 #endif
-#ifdef CONFIG_GG2
-    case ISA_TYPE_GG2: return (u16 __iomem *)GG2_ISA_MEM_W(addr);
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
     case ISA_TYPE_AG: return (u16 __iomem *)addr;
 #endif
@@ -217,9 +183,6 @@ static inline void isa_delay(void)
 #ifdef CONFIG_Q40
     case ISA_TYPE_Q40: isa_outb(0,0x80); break;
 #endif
-#ifdef CONFIG_GG2
-    case ISA_TYPE_GG2: break;
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
     case ISA_TYPE_AG: break;
 #endif
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index 303730a..b3963ab 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -359,12 +359,6 @@ void __init setup_arch(char **cmdline_p)
 		isa_type = ISA_TYPE_Q40;
 		isa_sex = 0;
 	}
-#ifdef CONFIG_GG2
-	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(GG2_ISA)) {
-		isa_type = ISA_TYPE_GG2;
-		isa_sex = 0;
-	}
-#endif
 #ifdef CONFIG_AMIGA_PCMCIA
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(PCMCIA)) {
 		isa_type = ISA_TYPE_AG;
-- 
1.7.0.4

