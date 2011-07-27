Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1G0Aig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:38:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1G0AfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380433"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [24/98] USB: fix regression in usbip by setting has_tt flag
Message-Id: <20110727003516.64DCE2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit cee6a262550f53a13acfefbc1e3e5ff35c96182c upstream.

This patch (as1460) fixes a regression in the usbip driver caused by
the new check for Transaction Translators in USB-2 hubs.  The root hub
registered by vhci_hcd needs to have the has_tt flag set, because it
can connect to low- and full-speed devices as well as high-speed
devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_hcd.c
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
@@ -1135,7 +1135,7 @@ static int vhci_hcd_probe(struct platfor
 		usbip_uerr("create hcd failed\n");
 		return -ENOMEM;
 	}
-
+	hcd->has_tt = 1;
 
 	/* this is private data for vhci_hcd */
 	the_controller = hcd_to_vhci(hcd);
