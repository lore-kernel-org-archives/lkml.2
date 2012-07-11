Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2GKA3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:29:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GKA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:29:13 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] usb/host/ehci-hub: Fix the issue EG20T USB host controller has long resuming time, when pen drive is attached.
Date: Wed, 11 Jul 2012 09:28:31 +0900
Message-Id: <1341966511-4373-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/host/ehci-hub.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index fc9e7cc..d596d0f 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -207,6 +207,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	int			port;
 	int			mask;
 	int			changed;
+	int			temp;
 
 	ehci_dbg(ehci, "suspend root hub\n");
 
@@ -324,6 +325,9 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	 * want, and so we must delete any pending watchdog timer events.
 	 */
 	del_timer_sync(&ehci->watchdog);
+	temp = ehci_readl(ehci, &ehci->regs->status);
+	if (temp & STS_FLR)
+		ehci_writel(ehci, STS_FLR, &ehci->regs->status);
 	return 0;
 }
 
-- 
1.7.4.4

