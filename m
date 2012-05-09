Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2EIGK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:10:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab2EIFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:32 -0400
Message-Id: <20120509055045.979354170@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 118/167] [PATCH] usb: gadget: dummy: do not call pullup() on udc_stop()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 15b120d67019d691e4389372967332d74a80522a upstream.

pullup() is already called properly by udc-core.c and
there's no need to call it from udc_stop(), in fact that
will cause issues.

Reviewed-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/dummy_hcd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index a6dfd21..170cbe8 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -927,7 +927,6 @@ static int dummy_udc_stop(struct usb_gadget *g,
 
 	dum->driver = NULL;
 
-	dummy_pullup(&dum->gadget, 0);
 	return 0;
 }
 
-- 
1.7.10



