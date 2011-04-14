Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1DNHb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:31:57 -0400
Received: from mail.x-arc.co.uk ([217.6.246.34]:42553 "EHLO root.phytec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab1DNHbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:31:55 -0400
From: Juergen Kilb <J.Kilb@phytec.de>
To: linux-arm-kernel@lists.infradead.org
Cc: dbrownell@users.sourceforge.net, balbi@ti.com, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Juergen Kilb <J.Kilb@phytec.de>
Subject: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
Date: Thu, 14 Apr 2011 09:31:43 +0200
Message-Id: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
X-Mailer: git-send-email 1.7.0.4
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 14.04.2011 09:31:54,
	Serialize by Router on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 14.04.2011 09:31:54,
	Serialize complete at 14.04.2011 09:31:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 19403165 a main part of ehci-omap.c moved to
drivers/mfd/omap-usb-host.c created by commit 17cdd29d.
Due to this reorganisation the polarity used to reset the
external USB phy changed and USB host doesn't recognize
any devices.

Signed-off-by: Juergen Kilb <J.Kilb@phytec.de>
---
 drivers/mfd/omap-usb-host.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 53450f4..491cac5 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -719,14 +719,14 @@ static int usbhs_enable(struct device *dev)
 			gpio_request(pdata->ehci_data->reset_gpio_port[0],
 						"USB1 PHY reset");
 			gpio_direction_output
-				(pdata->ehci_data->reset_gpio_port[0], 1);
+				(pdata->ehci_data->reset_gpio_port[0], 0);
 		}
 
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1])) {
 			gpio_request(pdata->ehci_data->reset_gpio_port[1],
 						"USB2 PHY reset");
 			gpio_direction_output
-				(pdata->ehci_data->reset_gpio_port[1], 1);
+				(pdata->ehci_data->reset_gpio_port[1], 0);
 		}
 
 		/* Hold the PHY in RESET for enough time till DIR is high */
@@ -906,11 +906,11 @@ static int usbhs_enable(struct device *dev)
 
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
 			gpio_set_value
-				(pdata->ehci_data->reset_gpio_port[0], 0);
+				(pdata->ehci_data->reset_gpio_port[0], 1);
 
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
 			gpio_set_value
-				(pdata->ehci_data->reset_gpio_port[1], 0);
+				(pdata->ehci_data->reset_gpio_port[1], 1);
 	}
 
 end_count:
-- 
1.7.0.4

