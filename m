Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab1HFAHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab1HFAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:51 2011
Message-Id: <20110806000250.995019824@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [21/55] USB: dummy-hcd needs the has_tt flag
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c5c69f3f0dcf9b569c8f3ad67f3af92cfcedac43 upstream.

Like with other host controllers capable of operating at both high
speed and full speed, we need to indicate that the emulated controller
presented by dummy-hcd has this ability.  Otherwise usbcore will not
accept full-speed gadgets under dummy-hcd.  This patch (as1469) sets
the appropriate has_tt flag.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/dummy_hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1886,6 +1886,7 @@ static int dummy_hcd_probe(struct platfo
 	if (!hcd)
 		return -ENOMEM;
 	the_controller = hcd_to_dummy (hcd);
+	hcd->has_tt = 1;
 
 	retval = usb_add_hcd(hcd, 0, 0);
 	if (retval != 0) {


