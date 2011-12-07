Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1LGT5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:57:07 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41662 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab1LGT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:57:05 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Heikki Krogerus <krohei@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] omap: rx51: initialize isp1704 properly
Date: Wed,  7 Dec 2011 21:56:56 +0200
Message-Id: <1323287816-2809-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <20111207193141.GG31337@atomide.com>
References: <20111207193141.GG31337@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <krohei@gmail.com>

Without this USB networking doesn't work as the link is never detected.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index a1d0257..faac1fc 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -193,7 +193,7 @@ static struct platform_device rx51_charger_device = {
 static void __init rx51_charger_init(void)
 {
 	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
-		GPIOF_OUT_INIT_LOW, "isp1704_reset"));
+		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
 
 	platform_device_register(&rx51_charger_device);
 }
-- 
1.7.8.rc1.14.g248db

