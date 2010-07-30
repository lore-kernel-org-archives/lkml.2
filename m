Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab0G3R5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:54 -0400
Received: from kroah.org ([198.145.64.141]:58828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760031Ab0G3R4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.224109105@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [124/205] USB: dont enable remote wakeup by default
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1784,7 +1784,6 @@ int usb_new_device(struct usb_device *ud
 		 * sysfs power/wakeup controls wakeup enabled/disabled
 		 */
 		device_init_wakeup(&udev->dev, 0);
-		device_set_wakeup_enable(&udev->dev, 1);
 	}
 
 	/* Tell the runtime-PM framework the device is active */


