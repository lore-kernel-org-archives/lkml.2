Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2EDUqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:04 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2EDUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:59 -0400
Message-Id: <20120504204227.121929711@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 32/75] usb: gadget: dummy: do not call pullup() on udc_stop()
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 15b120d67019d691e4389372967332d74a80522a upstream.

pullup() is already called properly by udc-core.c and
there's no need to call it from udc_stop(), in fact that
will cause issues.

Reviewed-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/dummy_hcd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -924,7 +924,6 @@ static int dummy_udc_stop(struct usb_gad
 
 	dum->driver = NULL;
 
-	dummy_pullup(&dum->gadget, 0);
 	return 0;
 }
 


