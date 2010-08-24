Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab0HXXEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:04:08 -0400
Received: from kroah.org ([198.145.64.141]:32888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab0HXXDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:49 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:10 2010
Message-Id: <20100824224510.685733969@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Wileczka <mikewileczka@yahoo.com>
Subject: [108/114] USB: ftdi_sio: fix endianess of max packet size
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Wileczka <mikewileczka@yahoo.com>

commit d1ab903d2552b2362339b19203c7f01c797cb316 upstream.

The USB max packet size (always little-endian) was not being byte
swapped on big-endian systems.

Applicable since [USB: ftdi_sio: fix hi-speed device packet size calculation] approx 2.6.31

Signed-off-by: Michael Wileczka <mikewileczka@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1376,7 +1376,7 @@ static void ftdi_set_max_packet_size(str
 	}
 
 	/* set max packet size based on descriptor */
-	priv->max_packet_size = ep_desc->wMaxPacketSize;
+	priv->max_packet_size = le16_to_cpu(ep_desc->wMaxPacketSize);
 
 	dev_info(&udev->dev, "Setting MaxPacketSize %d\n", priv->max_packet_size);
 }


