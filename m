Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HAWDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:03:31 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15253 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HAWD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:03:26 -0400
Date: Tue, 2 Aug 2011 00:03:24 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH][Resend] USB: Remove test for NULL that'll never happen in
 usb_disconnect()
Message-ID: <alpine.LNX.2.00.1108020001310.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/core/hub.c::usb_disconnect(), 'udev' will never be
NULL, so remove the test and printing of debug message.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hub.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a428aa0..99fff6b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1636,11 +1636,6 @@ void usb_disconnect(struct usb_device **pdev)
 	int			i;
 	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
 
-	if (!udev) {
-		pr_debug ("%s nodev\n", __func__);
-		return;
-	}
-
 	/* mark the device as inactive, so any further urb submissions for
 	 * this device (and any of its children) will fail immediately.
 	 * this quiesces everything except pending urbs.
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

