Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1LMJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:33:26 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:41487 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab1LMJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:33:23 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Joachim Foerster <joachim.foerster@missinglinkelectronics.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] ISP1760: Add flags for interrupt polarity and edge/level trigger
Date: Tue, 13 Dec 2011 10:33:13 +0100
Message-Id: <1323768793-20633-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/usb/host/isp1760-if.c |    4 ++++
 include/linux/usb/isp1760.h   |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index a7dc1e1..0ef9867 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -388,6 +388,10 @@ static int __devinit isp1760_plat_probe(struct platform_device *pdev)
 			devflags |= ISP1760_FLAG_DACK_POL_HIGH;
 		if (priv->dreq_polarity_high)
 			devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
+		if (priv->interrupt_polarity_high)
+			devflags |= ISP1760_FLAG_INTR_POL_HIGH;
+		if (priv->interrupt_edge_triggered)
+			devflags |= ISP1760_FLAG_INTR_EDGE_TRIG;
 	}
 
 	hcd = isp1760_register(mem_res->start, mem_size, irq_res->start,
diff --git a/include/linux/usb/isp1760.h b/include/linux/usb/isp1760.h
index de7de53..c5edbc8 100644
--- a/include/linux/usb/isp1760.h
+++ b/include/linux/usb/isp1760.h
@@ -13,6 +13,8 @@ struct isp1760_platform_data {
 	unsigned analog_oc:1;			/* Analog overcurrent */
 	unsigned dack_polarity_high:1;		/* DACK active high */
 	unsigned dreq_polarity_high:1;		/* DREQ active high */
+	unsigned interrupt_polarity_high:1;
+	unsigned interrupt_edge_triggered:1;
 };
 
 #endif /* __LINUX_USB_ISP1760_H */
-- 
1.7.3.4

