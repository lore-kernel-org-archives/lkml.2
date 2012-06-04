Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2FDTUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:20:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:57140 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948Ab2FDTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:20:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ohci-hub: Mark ohci_finish_controller_resume() as __maybe_unused
Date: Mon,  4 Jun 2012 21:20:08 +0200
Message-Id: <1338837608-23976-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ohci_finish_controller_resume() is intended to be used in platform specific
drivers ohci-*.c, included from ohci-hcd.c. Some of them don't actually use
ohci_finish_controller_resume(), so mark it as __maybe_unused.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/usb/host/ohci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/usb/host/ohci-hub.c
+++ linux-2.6/drivers/usb/host/ohci-hub.c
@@ -317,7 +317,7 @@ static int ohci_bus_resume (struct usb_h
 }
 
 /* Carry out the final steps of resuming the controller device */
-static void ohci_finish_controller_resume(struct usb_hcd *hcd)
+static void __maybe_unused ohci_finish_controller_resume(struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
 	int			port;
