Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab2C2N3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:29:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4003 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2C2N1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 07/12] USB: ohci-at91: coding style modifications with one-line ifs
Date: Thu, 29 Mar 2012 15:27:18 +0200
Message-Id: <ebf89ca2b0cb635d900e5fd3cc350935e41918ea.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 drivers/usb/host/ohci-at91.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index cf9707d..dd58b555 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -327,9 +327,8 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: OVER_CURRENT\n");
 
-			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
+			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin))
 				pdata->overcurrent_status[wIndex-1] = 0;
-			}
 
 			goto out;
 
@@ -382,17 +381,14 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		dev_dbg(hcd->self.controller, "GetPortStatus(%d)\n", wIndex);
 
 		if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
-			if (! ohci_at91_usb_get_power(pdata, wIndex-1)) {
+			if (! ohci_at91_usb_get_power(pdata, wIndex-1))
 				*data &= ~cpu_to_le32(RH_PS_PPS);
-			}
 
-			if (pdata->overcurrent_changed[wIndex-1]) {
+			if (pdata->overcurrent_changed[wIndex-1])
 				*data |= cpu_to_le32(RH_PS_OCIC);
-			}
 
-			if (pdata->overcurrent_status[wIndex-1]) {
+			if (pdata->overcurrent_status[wIndex-1])
 				*data |= cpu_to_le32(RH_PS_POCI);
-			}
 		}
 	}
 
-- 
1.7.9.4

