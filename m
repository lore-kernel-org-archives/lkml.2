Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430Ab1CEBNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:13:24 -0500
Received: from kroah.org ([198.145.64.141]:50273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396Ab1CEBAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.027276711@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [35/73] usb: musb: core: set has_tt flag
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit ec95d35a6bd0047f05fe8a21e6c52f8bb418da55 upstream.

MUSB is a non-standard host implementation which
can handle all speeds with the same core. We need
to set has_tt flag after commit
d199c96d41d80a567493e12b8e96ea056a1350c1 (USB: prevent
buggy hubs from crashing the USB stack) in order for
MUSB HCD to continue working.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Michael Jones <michael.jones@matrix-vision.de>
Tested-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1880,6 +1880,7 @@ allocate_instance(struct device *dev,
 	INIT_LIST_HEAD(&musb->out_bulk);
 
 	hcd->uses_new_polling = 1;
+	hcd->has_tt = 1;
 
 	musb->vbuserr_retry = VBUSERR_RETRY_COUNT;
 	musb->a_wait_bcon = OTG_TIME_A_WAIT_BCON;


