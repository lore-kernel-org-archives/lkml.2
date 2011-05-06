Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1EFAwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:52:55 -0400
Received: from kroah.org ([198.145.64.141]:36825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab1EFAZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.413187950@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [063/143] USB: dont enable remote wakeup by default
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 7aba8d014341341590ecb64050b7a026642a62eb upstream.

This patch (as1364) avoids enabling remote wakeup by default on all
non-root-hub USB devices.  Individual drivers or userspace will have
to enable it wherever it is needed, such as for keyboards or network
interfaces.  Note: This affects only system sleep, not autosuspend.

External hubs will continue to relay wakeup requests received from
downstream through their upstream port, even when remote wakeup is not
enabled for the hub itself.  Disabling remote wakeup on a hub merely
prevents it from generating wakeup requests in response to connect,
disconnect, and overcurrent events.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1795,7 +1795,6 @@ int usb_new_device(struct usb_device *ud
 		 * sysfs power/wakeup controls wakeup enabled/disabled
 		 */
 		device_init_wakeup(&udev->dev, 0);
-		device_set_wakeup_enable(&udev->dev, 1);
 	}
 
 	err = usb_enumerate_device(udev);	/* Read descriptors */


