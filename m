Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0FJLPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:15:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0FJLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:43 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/23] x86 boot: Set ax register in boot vga query
Message-Id: <20100610111040.F1781B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think the ax register should be input to the
BIOS call, not be unused, but not fully sure.  hpa?

Found by gcc 4.6's new warnings.

Cc: hpa@zytor.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/boot/video-vga.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/boot/video-vga.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/boot/video-vga.c
+++ linux-2.6.35-rc2-gcc/arch/x86/boot/video-vga.c
@@ -41,13 +41,12 @@ static __videocard video_vga;
 static u8 vga_set_basic_mode(void)
 {
 	struct biosregs ireg, oreg;
-	u16 ax;
 	u8 mode;
 
 	initregs(&ireg);
 
 	/* Query current mode */
-	ax = 0x0f00;
+	ireg.ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
 
