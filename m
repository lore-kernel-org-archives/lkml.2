Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DCHfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:35:45 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:24087 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab2DCHdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:33:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 02/13] USB: ohci-at91: fix vbus_pin_active_low handling
Date: Tue,  3 Apr 2012 09:32:46 +0200
Message-Id: <9dbb6af7686b5604dec5eebbc54b39be895b1e74.1333437885.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The information is not properly taken into account
for {get|set}_power() functions.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable <stable@vger.kernel.org>		[3.2+]
---
 drivers/usb/host/ohci-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index db8963f..4d266ae 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -247,7 +247,7 @@ static void ohci_at91_usb_set_power(struct at91_usbh_data *pdata, int port, int
 		return;
 
 	gpio_set_value(pdata->vbus_pin[port],
-		       !pdata->vbus_pin_active_low[port] ^ enable);
+		       pdata->vbus_pin_active_low[port] ^ enable);
 }
 
 static int ohci_at91_usb_get_power(struct at91_usbh_data *pdata, int port)
@@ -259,7 +259,7 @@ static int ohci_at91_usb_get_power(struct at91_usbh_data *pdata, int port)
 		return -EINVAL;
 
 	return gpio_get_value(pdata->vbus_pin[port]) ^
-		!pdata->vbus_pin_active_low[port];
+		pdata->vbus_pin_active_low[port];
 }
 
 /*
-- 
1.7.9.4

