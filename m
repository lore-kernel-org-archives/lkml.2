Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1LABxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:53:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60797 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LABxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:53:32 -0500
Message-ID: <1322704405.11560.7.camel@phoenix>
Subject: [PATCH 3/4] mfd: omap-usb-host: Use gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keshava Munegowda <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Dec 2011 09:53:25 +0800
In-Reply-To: <1322704074.11560.3.camel@phoenix>
References: <1322704074.11560.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/omap-usb-host.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 86e1458..6533ecc 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -715,19 +715,13 @@ static int usbhs_enable(struct device *dev)
 	clk_enable(omap->usbtll_ick);
 
 	if (pdata->ehci_data->phy_reset) {
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0])) {
-			gpio_request(pdata->ehci_data->reset_gpio_port[0],
-						"USB1 PHY reset");
-			gpio_direction_output
-				(pdata->ehci_data->reset_gpio_port[0], 0);
-		}
+		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
+			gpio_request_one(pdata->ehci_data->reset_gpio_port[0],
+					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1])) {
-			gpio_request(pdata->ehci_data->reset_gpio_port[1],
-						"USB2 PHY reset");
-			gpio_direction_output
-				(pdata->ehci_data->reset_gpio_port[1], 0);
-		}
+		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
+			gpio_request_one(pdata->ehci_data->reset_gpio_port[1],
+					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
 
 		/* Hold the PHY in RESET for enough time till DIR is high */
 		udelay(10);
-- 
1.7.5.4



