Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2A3CzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:55:05 -0500
Received: from cronus.persephoneslair.org ([216.254.15.24]:59433 "EHLO
	cronus.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab2A3CzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:55:03 -0500
Date: Sun, 29 Jan 2012 18:54:31 -0800
From: Andrea Shepard <andrea@persephoneslair.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz,
        joe@perches.com, justinmattock@gmail.com, gregkh@suse.de,
        alan@linux.intel.com, jdmason@kudzu.us
Subject: [13/22] Cyclades PC300 driver: alignment fix for portability
Message-ID: <20120130025431.GN10262@cronus.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an unaligned memory access to one of the device registers which was
causing a kernel panic on sparc64.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 14500eb..8249038 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -3277,8 +3277,10 @@ static int ch_config(pc300dev_t * d)
 		   IR0_DTX(IR0_EFT | IR0_DMIA | IR0_DMIB, ch));
 	cpc_writeb(scabase + M_REG(IE0, ch),
 		   cpc_readl(scabase + M_REG(IE0, ch)) | IE0_RXINTA);
+
+	/* Was cpc_readl(), changed for unaligned access */
 	cpc_writeb(scabase + M_REG(IE1, ch),
-		   cpc_readl(scabase + M_REG(IE1, ch)) | IE1_CDCD);
+		   cpc_readb(scabase + M_REG(IE1, ch)) | IE1_CDCD);
 
 	return 0;
 }
