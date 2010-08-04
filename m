Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0HDMmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:42:13 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57196 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761Ab0HDMmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:42:10 -0400
Date: Wed, 4 Aug 2010 14:42:08 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 6/9] arch/m68knommu: Removing dead RELOCATE config option
Message-ID: <16dcf8ad8a41b3e6c55a79d853b82b0e2354284d.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RELOCATE doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68knommu/platform/68328/head-ram.S |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/arch/m68knommu/platform/68328/head-ram.S b/arch/m68knommu/platform/68328/head-ram.S
index 252b80b..7f1aeea 100644
--- a/arch/m68knommu/platform/68328/head-ram.S
+++ b/arch/m68knommu/platform/68328/head-ram.S
@@ -67,33 +67,6 @@ pclp1:
 	beq	pclp1
 #endif /* DEBUG */
 
-#ifdef CONFIG_RELOCATE
-	/* Copy me to RAM */
-	moveal	#__rom_start, %a0
-	moveal	#_stext, %a1
-	moveal	#_edata, %a2
-
-	/* Copy %a0 to %a1 until %a1 == %a2 */
-LD1:
-	movel	%a0@+, %d0
-	movel	%d0, %a1@+
-	cmpal	%a1, %a2
-	bhi	LD1
-	
-#ifdef DEBUG
-	moveq	#74, %d7		/* 'J' */
-	moveb	%d7,0xfffff907          /* No absolute addresses */
-pclp2:
-	movew	0xfffff906, %d7
-	andw	#0x2000, %d7
-	beq	pclp2
-#endif /* DEBUG */
-	/* jump into the RAM copy */
-	jmp     ram_jump
-ram_jump:
-
-#endif /* CONFIG_RELOCATE */
-
 #ifdef DEBUG
 	moveq	#82, %d7		/* 'R' */
 	moveb	%d7,0xfffff907          /* No absolute addresses */
-- 
1.7.0.4

