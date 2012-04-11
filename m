Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab2DLAAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:00:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916Ab2DKXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:39 -0400
Message-Id: <20120411231027.136691227@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 52/78] USB: ohci-at91: fix vbus_pin_active_low handling
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 1e7caf8bcf1b49eae152ad7cf442775472dd587c upstream.

The information is not properly taken into account
for {get|set}_power() functions.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ohci-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -245,7 +245,7 @@ static void ohci_at91_usb_set_power(stru
 		return;
 
 	gpio_set_value(pdata->vbus_pin[port],
-		       !pdata->vbus_pin_active_low[port] ^ enable);
+		       pdata->vbus_pin_active_low[port] ^ enable);
 }
 
 static int ohci_at91_usb_get_power(struct at91_usbh_data *pdata, int port)
@@ -257,7 +257,7 @@ static int ohci_at91_usb_get_power(struc
 		return -EINVAL;
 
 	return gpio_get_value(pdata->vbus_pin[port]) ^
-		!pdata->vbus_pin_active_low[port];
+		pdata->vbus_pin_active_low[port];
 }
 
 /*


