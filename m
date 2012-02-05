Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2BEWmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:42:54 -0500
Received: from 1wt.eu ([62.212.114.60]:61922 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2BEW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:25 -0500
Message-Id: <20120205220950.217210270@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 18/91] usb: musb: core: set has_tt flag
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/usb/musb/musb_core.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/musb/musb_core.c	2012-02-05 22:34:34.480915184 +0100
+++ longterm-2.6.27/drivers/usb/musb/musb_core.c	2012-02-05 22:34:37.452915834 +0100
@@ -1792,6 +1792,7 @@
 	INIT_LIST_HEAD(&musb->out_bulk);
 
 	hcd->uses_new_polling = 1;
+	hcd->has_tt = 1;
 
 	musb->vbuserr_retry = VBUSERR_RETRY_COUNT;
 #else


