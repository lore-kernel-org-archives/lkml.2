Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1HRKom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:44:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab1HRKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:44:40 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: Anand Gadiyar <gadiyar@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Date: Thu, 18 Aug 2011 16:14:31 +0530
Message-ID: <1313664271-694-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code section seems to have been accidentally copy pasted.
It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
register and prevents the TLL mode from working correctly.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Against v3.1-rc2; tested against linux-next as of 20110817 as well.

This probably needs to go to -stable as well. The original code
by me worked fine but this was broken during the code reorganization
Keshava did.

 drivers/mfd/omap-usb-host.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/mfd/omap-usb-host.c
===================================================================
--- linux-2.6.orig/drivers/mfd/omap-usb-host.c
+++ linux-2.6/drivers/mfd/omap-usb-host.c
@@ -676,7 +676,6 @@ static void usbhs_omap_tll_init(struct d
 				| OMAP_TLL_CHANNEL_CONF_ULPINOBITSTUFF
 				| OMAP_TLL_CHANNEL_CONF_ULPIDDRMODE);
 
-			reg |= (1 << (i + 1));
 		} else
 			continue;
 
