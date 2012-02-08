Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2BHVYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:24:49 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34240 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab2BHVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:45 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Oliver Neukum <oneukum@suse.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 37/50] usbnet: set addr_assign_type if random_ether_addr() used
Date: Wed,  8 Feb 2012 22:10:44 +0100
Message-Id: <1328735457-29986-38-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736105;5e03e3f8;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set addr_assign_type correctly to NET_ADDR_RANDOM in case
a random MAC address was generated and assigned to the netdevice.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/usb/usbnet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index fae0fbd..7bd07d7 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1365,6 +1365,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->net = net;
 	strcpy (net->name, "usb%d");
 	memcpy (net->dev_addr, node_id, sizeof node_id);
+	net->addr_assign_type |= NET_ADDR_RANDOM;
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
-- 
1.7.7.3

