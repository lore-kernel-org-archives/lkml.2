Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1DHDTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:19:32 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25464 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab1DHDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:19:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=bZYcQ2sdW-UA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=n3DLBDIp2lSvWb96zoUu4Q==:17 a=47LbCVvxAAAA:8 a=fafJCDcsQne61fsRHy4A:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Wood <simon@mungewell.org>
Subject: [PatchV3 3/3] usb: plusb: Add debug to reset function
Date: Thu,  7 Apr 2011 00:40:15 -0700
Message-Id: <1302162015-22504-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302162015-22504-1-git-send-email-simon@mungewell.org>
References: <1301456667-1648-1-git-send-email-simon@mungewell.org>
 <1302162015-22504-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: simon <simon@ubuntu.(none)>

This patch adds some debug to the reset function to print out the
reason why it fails.

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/net/usb/plusb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index f46aa07..217aec8 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -94,11 +94,15 @@ pl_set_QuickLink_features(struct usbnet *dev, int val)
 
 static int pl_reset(struct usbnet *dev)
 {
+	int status;
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
1.7.4.1

