Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab0GWNUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:20:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54478 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0GWNSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N3Cm+21M+bnYuxGAcf0oATV73XINXjBNmx+YFelNriovc8OTtofxs0LVxoOdPmyhH4
         4wPdrxmRZaqHR2aSzkhBooWO6ZdOiKZxLQY1qqlZ+zidGnoMhSQIH/cqiMmwUqn5g64K
         SLlyTXdbEzYEEBhU/wQFL4y3GWROGr7LtHsas=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 3/5] usb: usbnet: use newly introduced hex_to_bin()
Date: Fri, 23 Jul 2010 16:18:08 +0300
Message-Id: <dfeaa560c7a129bd667521be983794a05a12a12e.1279890832.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/net/usb/usbnet.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 7eab407..f5e1639 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -44,6 +44,7 @@
 #include <linux/usb.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 
 #define DRIVER_VERSION		"22-Aug-2005"
 
@@ -158,16 +159,6 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(usbnet_get_endpoints);
 
-static u8 nibble(unsigned char c)
-{
-	if (likely(isdigit(c)))
-		return c - '0';
-	c = toupper(c);
-	if (likely(isxdigit(c)))
-		return 10 + c - 'A';
-	return 0;
-}
-
 int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 {
 	int 		tmp, i;
@@ -183,7 +174,7 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 	}
 	for (i = tmp = 0; i < 6; i++, tmp += 2)
 		dev->net->dev_addr [i] =
-			(nibble(buf [tmp]) << 4) + nibble(buf [tmp + 1]);
+			(hex_to_bin(buf[tmp]) << 4) + hex_to_bin(buf[tmp + 1]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
-- 
1.7.1.1

