Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0GINtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:49:14 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50283 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517Ab0GINtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:49:12 -0400
Date: Fri, 9 Jul 2010 15:49:10 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 03/11] Removing dead PP04
Message-ID: <0e8d9a136ce861c58f204c907ddbe40d4856cd5f.1278682302.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PP04 doesn't exist in Kconfig, therefore removing all references for
it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/68360serial.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index f72972b..ac062a8 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -2495,20 +2495,6 @@ static int __init rs_360_init(void)
 	cp->si_sicr &= ~0x00ffff00;
 	cp->si_sicr |=  0x001b1200;
 
-#ifdef CONFIG_PP04
-	/* Frequentis PP04 forced to RS-232 until we know better.
-	 * Port C 12 and 13 low enables RS-232 on SCC3 and SCC4.
-	 */
-	immap->im_ioport.iop_pcdir |= 0x000c;
-	immap->im_ioport.iop_pcpar &= ~0x000c;
-	immap->im_ioport.iop_pcdat &= ~0x000c;
-
-	/* This enables the TX driver.
-	*/
-	cp->cp_pbpar &= ~0x6000;
-	cp->cp_pbdat &= ~0x6000;
-#endif
-
 	for (i = 0, state = rs_table; i < NR_PORTS; i++,state++) {
 		state->magic = SSTATE_MAGIC;
 		state->line = i;
-- 
1.7.0.4

