Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1EFAh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:37:27 -0400
Received: from kroah.org ([198.145.64.141]:37408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1EFA0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:19 2011
Message-Id: <20110506002218.927682512@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [139/143] usb: musb: core: set has_tt flag
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1792,6 +1792,7 @@ allocate_instance(struct device *dev,
 	INIT_LIST_HEAD(&musb->out_bulk);
 
 	hcd->uses_new_polling = 1;
+	hcd->has_tt = 1;
 
 	musb->vbuserr_retry = VBUSERR_RETRY_COUNT;
 	musb->a_wait_bcon = OTG_TIME_A_WAIT_BCON;


