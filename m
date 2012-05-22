Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2EVQrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:47:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2EVQrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:47:31 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: EHCI: Fix build warning in xilinx ehci driver
Date: Tue, 22 May 2012 13:47:25 -0300
Message-Id: <1337705245-6237-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning:
In file included from drivers/usb/host/ehci-hcd.c:1246:0:
drivers/usb/host/ehci-xilinx-of.c:293:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/usb/host/ehci-xilinx-of.c:293:2: warning: (near initialization for 'ehci_hcd_xilinx_of_driver.shutdown') [enabled by default]

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/ehci-xilinx-of.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 9c2cc46..e9713d5 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -270,14 +270,12 @@ static int ehci_hcd_xilinx_of_remove(struct platform_device *op)
  *
  * Properly shutdown the hcd, call driver's shutdown routine.
  */
-static int ehci_hcd_xilinx_of_shutdown(struct platform_device *op)
+static void ehci_hcd_xilinx_of_shutdown(struct platform_device *op)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(&op->dev);
 
 	if (hcd->driver->shutdown)
 		hcd->driver->shutdown(hcd);
-
-	return 0;
 }
 
 
-- 
1.7.9.5

