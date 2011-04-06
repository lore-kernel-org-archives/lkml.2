Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1DFERc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:17:32 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3497 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1DFEQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:16:54 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=c/XFevczzUoebyvqT+jDkQbuJdAAxuTGoZVbuGUMSf4= c=1 sm=1
 a=ru9eIxniI8wA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=Ws5gsmkKQTjFCfEsnHkA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>,
        Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Simon Wood <simon@mungewell.org>
Subject: [PatchV2 : PL25A1 Support - 3/3] reset_debug
Date: Tue,  5 Apr 2011 22:16:46 -0600
Message-Id: <1302063406-13077-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1301456667-1648-1-git-send-email-simon@mungewell.org>
References: <1301456667-1648-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds some debug in the event that reseting chip fails for some reason

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/net/usb/plusb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index b9649e0..11ff297 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -94,11 +94,15 @@ pl_set_QuickLink_features(struct usbnet *dev, int val)
 
 static int pl_reset(struct usbnet *dev)
 {
+	int     status;
+
 	/* some units seem to need this reset, others reject it utterly.
 	 * FIXME be more like "naplink" or windows drivers.
 	 */
-	(void) pl_set_QuickLink_features(dev,
+	status = pl_set_QuickLink_features(dev,
 		PL_S_EN|PL_RESET_OUT|PL_RESET_IN|PL_PEER_E);
+	if (status != 0 && netif_msg_probe(dev))
+		netif_dbg(dev, link, dev->net, "pl_reset --> %d\n", status);
 	return 0;
 }
 
-- 
1.7.0.4

