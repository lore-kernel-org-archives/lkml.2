Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2LJLAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:00:55 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607Ab2LJLAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:51 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIDAJtkv1BbdWObgWdsb2JhbABEg0eCJrg+Fg4BARYmJ4IfAQUnUhA/ElcGARKIFMIpjECEOAOWA4lNiW2BYg
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 10/12] ipack/devices/ipoctal: remove redundant tty_flip_buffer_push()
Date: Mon, 10 Dec 2012 11:50:06 +0100
Message-Id: <1355136608-22029-10-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is already called in ipoctal_irq_rx()

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 8dff66e..f2284ec 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -216,7 +216,6 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
 		ipoctal_irq_tx(channel);
 
-	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 	spin_unlock(&channel->lock);
 }
-- 
1.7.10.4

