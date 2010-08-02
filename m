Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0HBQB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:01:28 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64460 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab0HBQB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:01:27 -0400
Date: Mon, 2 Aug 2010 18:01:24 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>, Robin Getz <robin.getz@analog.com>,
        Graf Yang <graf.yang@analog.com>, Yi Li <yi.li@analog.com>,
        Barry Song <barry.song@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/6] arch/blackfin: Remove dead CONFIG_BF535
Message-ID: <50761c10ce6cccfbb9f1394641c761f57f4b80c8.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_BF535 doesn't exist in Kconfig, therefore removing all
references to it from the source. In the past[0] there was also removed
code for this kind of CPU, reasoning, that it's not supported at all.

[0] 986d6c1e05642edac81cb8cc99f36a26d16ef220

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/include/asm/traps.h |    2 +-
 arch/blackfin/kernel/traps.c      |   11 +----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/include/asm/traps.h b/arch/blackfin/include/asm/traps.h
index 9fe0da6..113da1d 100644
--- a/arch/blackfin/include/asm/traps.h
+++ b/arch/blackfin/include/asm/traps.h
@@ -36,7 +36,7 @@
 #define VEC_CPLB_M	(38)
 #define VEC_CPLB_MHIT	(39)
 #define VEC_WATCH	(40)
-#define VEC_ISTRU_VL	(41)	/*ADSP-BF535 only (MH) */
+/* VEC_ISTRU_VL was defined here as (41), but BF535 is not supported */
 #define VEC_MISALI_I	(42)
 #define VEC_CPLB_I_VL	(43)
 #define VEC_CPLB_I_M	(44)
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 59c1df7..2361e67 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -280,17 +280,8 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 			goto traps_done;
 		else
 			break;
-#ifdef CONFIG_BF535
-	/* 0x29 - Instruction fetch access error (535 only) */
-	case VEC_ISTRU_VL:      /* ADSP-BF535 only (MH) */
-		info.si_code = BUS_OPFETCH;
-		sig = SIGBUS;
-		strerror = KERN_NOTICE "BF535: VEC_ISTRU_VL\n";
-		CHK_DEBUGGER_TRAP_MAYBE();
-		break;
-#else
+
 	/* 0x29 - Reserved, Caught by default */
-#endif
 	/* 0x2A - Instruction fetch misaligned, handled here */
 	case VEC_MISALI_I:
 		info.si_code = BUS_ADRALN;
-- 
1.7.0.4

