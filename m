Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2FSQWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:22:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2FSQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:22:46 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/3] staging/ft1000: use kzalloc to allocate the ft1000_device structure
Date: Tue, 19 Jun 2012 21:52:38 +0530
Message-Id: <1340122958-8670-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with kzalloc the allocate memory is set to zero, so no need of
calling memset again on the allocated memory

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index a07c504..bfead67 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -67,15 +67,13 @@ static int ft1000_probe(struct usb_interface *interface,
 	struct ft1000_info *pft1000info = NULL;
 	const struct firmware *dsp_fw;
 
-	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
+	ft1000dev = kzalloc(sizeof(struct ft1000_device), GFP_KERNEL);
 
 	if (!ft1000dev) {
 		printk(KERN_ERR "out of memory allocating device structure\n");
 		return -ENOMEM;
 	}
 
-	memset(ft1000dev, 0, sizeof(*ft1000dev));
-
 	dev = interface_to_usbdev(interface);
 	DEBUG("ft1000_probe: usb device descriptor info:\n");
 	DEBUG("ft1000_probe: number of configuration is %d\n",
-- 
1.7.9.5

