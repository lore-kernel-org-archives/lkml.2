Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0FIKAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:00:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64802 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab0FIKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:00:48 -0400
Date: Wed, 9 Jun 2010 12:00:46 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/5] Removing dead CONFIG_SERIAL_TEXT_DEBUG
Message-ID: <ddcbd960ff300073939bb0c6f20a38118c0875d4.1275925219.git.siccegge@cs.fau.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SERIAL_TEXT_DEBUG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/powerpc/kernel/head_40x.S |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
index a90625f..1a10e4d 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -939,25 +939,6 @@ initial_mmu:
 	tlbwe	r4,r0,TLB_DATA		/* Load the data portion of the entry */
 	tlbwe	r3,r0,TLB_TAG		/* Load the tag portion of the entry */
 
-#if defined(CONFIG_SERIAL_TEXT_DEBUG) && defined(SERIAL_DEBUG_IO_BASE)
-
-	/* Load a TLB entry for the UART, so that ppc4xx_progress() can use
-	 * the UARTs nice and early.  We use a 4k real==virtual mapping. */
-
-	lis	r3,SERIAL_DEBUG_IO_BASE@h
-	ori	r3,r3,SERIAL_DEBUG_IO_BASE@l
-	mr	r4,r3
-	clrrwi	r4,r4,12
-	ori	r4,r4,(TLB_WR|TLB_I|TLB_M|TLB_G)
-
-	clrrwi	r3,r3,12
-	ori	r3,r3,(TLB_VALID | TLB_PAGESZ(PAGESZ_4K))
-
-	li	r0,0			/* TLB slot 0 */
-	tlbwe	r4,r0,TLB_DATA
-	tlbwe	r3,r0,TLB_TAG
-#endif /* CONFIG_SERIAL_DEBUG_TEXT && SERIAL_DEBUG_IO_BASE */
-
 	isync
 
 	/* Establish the exception vector base
-- 
1.6.3.3

