Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2B1BUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:20:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965562Ab2B1BTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.224.133 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010432.950874863@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 40/72] xhci: Fix oops caused by more USB2 ports than USB3 ports.
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 3278a55a1aebe2bbd47fbb5196209e5326a88b56 upstream.

The code to set the device removable bits in the USB 2.0 roothub
descriptor was accidentally looking at the USB 3.0 port registers
instead of the USB 2.0 registers.  This can cause an oops if there are
more USB 2.0 registers than USB 3.0 registers.

This should be backported to kernels as old as 2.6.39, that contain the
commit 4bbb0ace9a3de8392527e3c87926309d541d3b00 "xhci: Return a USB 3.0
hub descriptor for USB3 roothub."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -95,7 +95,7 @@ static void xhci_usb2_hub_descriptor(str
 	 */
 	memset(port_removable, 0, sizeof(port_removable));
 	for (i = 0; i < ports; i++) {
-		portsc = xhci_readl(xhci, xhci->usb3_ports[i]);
+		portsc = xhci_readl(xhci, xhci->usb2_ports[i]);
 		/* If a device is removable, PORTSC reports a 0, same as in the
 		 * hub descriptor DeviceRemovable bits.
 		 */


