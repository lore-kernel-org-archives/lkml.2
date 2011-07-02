Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab1GBTAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:00:09 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:35394 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1GBS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:59:59 -0400
From: Matthieu CASTET <castet.matthieu@free.fr>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Subject: [PATCH 2/2] ehci-msm : use ehci_setup
Date: Sat,  2 Jul 2011 20:59:46 +0200
Message-Id: <1309633186-31693-2-git-send-email-castet.matthieu@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309633186-31693-1-git-send-email-castet.matthieu@free.fr>
References: <1309633186-31693-1-git-send-email-castet.matthieu@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Tested-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/host/ehci-msm.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index b5a0bf6..592d5f7 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -40,27 +40,9 @@ static int ehci_msm_reset(struct usb_hcd *hcd)
 	int retval;
 
 	ehci->caps = USB_CAPLENGTH;
-	ehci->regs = USB_CAPLENGTH +
-		HC_LENGTH(ehci, ehci_readl(ehci, &ehci->caps->hc_capbase));
-	dbg_hcs_params(ehci, "reset");
-	dbg_hcc_params(ehci, "reset");
-
-	/* cache the data to minimize the chip reads*/
-	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
-
 	hcd->has_tt = 1;
-	ehci->sbrn = HCD_USB2;
-
-	retval = ehci_halt(ehci);
-	if (retval)
-		return retval;
-
-	/* data structure init */
-	retval = ehci_init(hcd);
-	if (retval)
-		return retval;
 
-	retval = ehci_reset(ehci);
+	retval = ehci_setup(hcd);
 	if (retval)
 		return retval;
 
-- 
1.7.5.4

