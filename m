Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0EJW7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:59:44 -0400
Received: from kroah.org ([198.145.64.141]:51657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab0EJW5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:43 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.401710639@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [22/98] USB: OHCI: dont look at the root hub to get the number of ports
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit fcf7d2141f4a363a4a8454c4a0f26bb69e766c5f upstream.

This patch (as1371) fixes a small bug in ohci-hcd.  The HCD already
knows how many ports the controller has; there's no need to go looking
at the root hub's usb_device structure to find out.  Especially since
the root hub's maxchild value is set correctly only while the root hub
is bound to the hub driver.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -697,7 +697,7 @@ static int ohci_hub_control (
 	u16		wLength
 ) {
 	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
-	int		ports = hcd_to_bus (hcd)->root_hub->maxchild;
+	int		ports = ohci->num_ports;
 	u32		temp;
 	int		retval = 0;
 


