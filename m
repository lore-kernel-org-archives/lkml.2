Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1IGRIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:08:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:9086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1IGQ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45953881"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCHv4 14/19] arm: imx: Start using struct usb_otg
Date: Wed,  7 Sep 2011 10:16:07 +0300
Message-Id: <1315379772-8830-15-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/mx31moboard-devboard.c |    2 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
index 9cd4a97..cb792d0 100644
--- a/arch/arm/mach-imx/mx31moboard-devboard.c
+++ b/arch/arm/mach-imx/mx31moboard-devboard.c
@@ -203,7 +203,7 @@ static int __init devboard_usbh1_init(void)
 
 	otg->label	= "ISP1105";
 	otg->init	= devboard_isp1105_init;
-	otg->set_vbus	= devboard_isp1105_set_vbus;
+	otg->otg->set_vbus	= devboard_isp1105_set_vbus;
 
 	usbh1_pdata.otg = otg;
 
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index 2be769b..f921e47 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -317,7 +317,7 @@ static int __init marxbot_usbh1_init(void)
 
 	otg->label	= "ISP1105";
 	otg->init	= marxbot_isp1105_init;
-	otg->set_vbus	= marxbot_isp1105_set_vbus;
+	otg->otg->set_vbus	= marxbot_isp1105_set_vbus;
 
 	usbh1_pdata.otg = otg;
 
-- 
1.7.4.1

