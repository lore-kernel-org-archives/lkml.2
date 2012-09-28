Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab2I1S6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2I1S54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Mario Isidoro <Mario.Isidoro@tecmic.pt>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 082/262] usb: gadget: at91udc: dont overwrite driver data
Date: Fri, 28 Sep 2012 11:50:11 -0700
Message-Id: <20120928183007.844576331@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 8b7dda554cf61e87523dee412eaf598f8646bd79 upstream.

The driver was converted to the new start/stop interface in f3d8bf34c2
("usb: gadget: at91_udc: convert to new style start/stop interface").
I overlooked that the driver is overwritting the private data which is
used by the composite framework. The udc driver doesn't read it, it is
only written here.

Tested-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Tested-by: Mario Isidoro <Mario.Isidoro@tecmic.pt>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/at91_udc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1634,7 +1634,6 @@ static int at91_start(struct usb_gadget
 	udc = container_of(gadget, struct at91_udc, gadget);
 	udc->driver = driver;
 	udc->gadget.dev.driver = &driver->driver;
-	dev_set_drvdata(&udc->gadget.dev, &driver->driver);
 	udc->enabled = 1;
 	udc->selfpowered = 1;
 
@@ -1655,7 +1654,6 @@ static int at91_stop(struct usb_gadget *
 	spin_unlock_irqrestore(&udc->lock, flags);
 
 	udc->gadget.dev.driver = NULL;
-	dev_set_drvdata(&udc->gadget.dev, NULL);
 	udc->driver = NULL;
 
 	DBG("unbound from %s\n", driver->driver.name);


