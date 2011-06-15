Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1FPHhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:37:21 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47648 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab1FPHAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:51 -0400
X-Sasl-enc: 31XyqH6W2jpilp0KDx1lA8O60bekYfWvpvVAXbUKFBuT 1308207649
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.330398035@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Metzmacher <metze@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [34/89] usbnet/cdc_ncm: add missing .reset_resume hook
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 85e3c65fa3a1d0542c181510a950a2be7733ff29 upstream.

This avoids messages like this after suspend:

   cdc_ncm 2-1.4:1.6: no reset_resume for driver cdc_ncm?
   cdc_ncm 2-1.4:1.7: no reset_resume for driver cdc_ncm?
   cdc_ncm 2-1.4:1.6: usb0: unregister 'cdc_ncm' usb-0000:00:1d.0-1.4, CDC NCM

This is important for the Ericsson F5521gw GSM/UMTS modem.
Otherwise modemmanager looses the fact that the cdc_ncm and cdc_acm devices
belong together.

The cdc_ether module does the same.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc_ncm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1254,6 +1254,7 @@ static struct usb_driver cdc_ncm_driver
 	.disconnect = cdc_ncm_disconnect,
 	.suspend = usbnet_suspend,
 	.resume = usbnet_resume,
+	.reset_resume =	usbnet_resume,
 	.supports_autosuspend = 1,
 };
 


