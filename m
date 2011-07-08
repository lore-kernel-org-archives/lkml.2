Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1GHHWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:22:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34418 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1GHHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:22:32 -0400
Date: Fri, 8 Jul 2011 10:21:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] NFC: pn533: use after free in pn533_disconnect()
Message-ID: <20110708072115.GR18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We freed "dev" on the line before.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 0372315..c77e054 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1596,7 +1596,7 @@ static void pn533_disconnect(struct usb_interface *interface)
 	usb_free_urb(dev->out_urb);
 	kfree(dev);
 
-	nfc_dev_info(&dev->interface->dev, "NXP PN533 NFC device disconnected");
+	nfc_dev_info(&interface->dev, "NXP PN533 NFC device disconnected");
 }
 
 static struct usb_driver pn533_driver = {
