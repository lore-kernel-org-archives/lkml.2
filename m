Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2CFDAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:00:16 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:50675
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964921Ab2CFDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:00:14 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        <scottwood@freescale.com>, <galak@kernel.crashing.org>,
        <paul.gortmaker@windriver.com>, Liu Gang <Gang.Liu@freescale.com>
Subject: [PATCH] powerpc/srio: Fix the relocation errors when building with 64bit
Date: Tue, 6 Mar 2012 10:58:12 +0800
Message-ID: <1331002692-9061-1-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the file "arch/powerpc/sysdev/fsl_rio.c", there will be some relocation
errors while using the corenet64_smp_defconfig:

WARNING: modpost: Found 6 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/sysdev/built-in.o:(__ex_table+0x0):
	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3208
arch/powerpc/sysdev/built-in.o:(__ex_table+0x2):
	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'
arch/powerpc/sysdev/built-in.o:(__ex_table+0x4):
	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3230
arch/powerpc/sysdev/built-in.o:(__ex_table+0x6):
	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'+c
arch/powerpc/sysdev/built-in.o:(__ex_table+0x8):
	relocation truncated to fit: R_PPC64_ADDR16 against `.text'+3250
arch/powerpc/sysdev/built-in.o:(__ex_table+0xa):
	relocation truncated to fit: R_PPC64_ADDR16 against `.fixup'+18

Rewrote the corresponding code with the support of 64bit building.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index a4c4f4a..5b6f556 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -66,8 +66,8 @@
 		"	li %0,%3\n"			\
 		"	b 2b\n"				\
 		".section __ex_table,\"a\"\n"		\
-		"	.align 2\n"			\
-		"	.long 1b,3b\n"			\
+			PPC_LONG_ALIGN "\n"		\
+			PPC_LONG "1b,3b\n"		\
 		".text"					\
 		: "=r" (err), "=r" (x)			\
 		: "b" (addr), "i" (-EFAULT), "0" (err))
-- 
1.7.0.4


