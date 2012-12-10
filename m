Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2LJLAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:00:43 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753632Ab2LJLAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:41 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIDAJtkv1BbdWObgWdsb2JhbABEg0eCJrg+Fg4BARYmJ4IeAQEFJ1IQIB8SVwYBEogUwimQeAOWA4lNiW0
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Alberto Garcia <agarcia@igalia.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 02/12] ipack/devices/ipoctal: don't check if nb_bytes is < 0
Date: Mon, 10 Dec 2012 11:49:58 +0100
Message-Id: <1355136608-22029-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alberto Garcia <agarcia@igalia.com>

It is an unsigned int so that check is pointless.

Signed-off-by: Alberto Garcia <agarcia@igalia.com>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index b312863..8f699b0 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -183,10 +183,8 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	unsigned char value;
 	unsigned int *pointer_write = &channel->pointer_write;
 
-	if (channel->nb_bytes <= 0) {
-		channel->nb_bytes = 0;
+	if (channel->nb_bytes == 0)
 		return;
-	}
 
 	value = channel->tty_port.xmit_buf[*pointer_write];
 	iowrite8(value, &channel->regs->w.thr);
-- 
1.7.10.4

