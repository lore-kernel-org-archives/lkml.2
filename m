Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab2BXNtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:49:20 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43964 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386Ab2BXNqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:38 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Oliver Neukum <oneukum@suse.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] usb/cdc_ncm: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:59 +0100
Message-Id: <1330091162-8141-9-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091198;055059f7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/usb/cdc_ncm.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 3a539a9..81f86b8 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -579,11 +579,7 @@ advance:
 	if (temp)
 		goto error2;
 
-	dev_info(&dev->udev->dev, "MAC-Address: "
-				"0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-				dev->net->dev_addr[0], dev->net->dev_addr[1],
-				dev->net->dev_addr[2], dev->net->dev_addr[3],
-				dev->net->dev_addr[4], dev->net->dev_addr[5]);
+	dev_info(&dev->udev->dev, "MAC-Address: %pM\n", dev->net->dev_addr);
 
 	dev->in = usb_rcvbulkpipe(dev->udev,
 		ctx->in_ep->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
-- 
1.7.8.3

