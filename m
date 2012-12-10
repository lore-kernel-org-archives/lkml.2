Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2LJLCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:02:41 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754612Ab2LJLAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:49 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIDAJtkv1BbdWObgWdsb2JhbABEg0eCJrg+Fg4BARYmJ4IfAQUnUhA/ElcGARKIFMIpjECEOAOWA4lNiW2BYg
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 05/12] ipack/devices/ipoctal: setup TTY_NORMAL flag for each character.
Date: Mon, 10 Dec 2012 11:50:01 +0100
Message-Id: <1355136608-22029-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of several characters present in RxFIFO, they will have the flag of the
previous one, no matter if the actual character was received properly or not.

This patch fixes this bug.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 5bbcb16..88aca90 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -121,11 +121,12 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 			   struct tty_struct *tty, u8 sr)
 {
 	unsigned char value;
-	unsigned char flag = TTY_NORMAL;
+	unsigned char flag;
 	u8 isr;
 
 	do {
 		value = ioread8(&channel->regs->r.rhr);
+		flag = TTY_NORMAL;
 		/* Error: count statistics */
 		if (sr & SR_ERROR) {
 			iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-- 
1.7.10.4

