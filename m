Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1I1Who (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1I1Whm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.553780293@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [022/244] xHCI: fix port U3 status check condition
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 5ac04bf190e6f8b17238aef179ebd7f2bdfec919 upstream.

Fix the port U3 status check when Clear PORT_SUSPEND Feature.
The port status should be masked with PORT_PLS_MASK to check if it's in
U3 state.

This should be backported to kernels as old as 2.6.37.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -664,7 +664,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 			xhci_dbg(xhci, "PORTSC %04x\n", temp);
 			if (temp & PORT_RESET)
 				goto error;
-			if (temp & XDEV_U3) {
+			if ((temp & PORT_PLS_MASK) == XDEV_U3) {
 				if ((temp & PORT_PE) == 0)
 					goto error;
 


