Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1EFAN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:29 -0400
Received: from kroah.org ([198.145.64.141]:32878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1EFAN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.259032288@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 20/38] USB: fix regression in usbip by setting has_tt flag
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cee6a262550f53a13acfefbc1e3e5ff35c96182c upstream.

This patch (as1460) fixes a regression in the usbip driver caused by
the new check for Transaction Translators in USB-2 hubs.  The root hub
registered by vhci_hcd needs to have the has_tt flag set, because it
can connect to low- and full-speed devices as well as high-speed
devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1135,7 +1135,7 @@ static int vhci_hcd_probe(struct platfor
 		usbip_uerr("create hcd failed\n");
 		return -ENOMEM;
 	}
-
+	hcd->has_tt = 1;
 
 	/* this is private data for vhci_hcd */
 	the_controller = hcd_to_vhci(hcd);


