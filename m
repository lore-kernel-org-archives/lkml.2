Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2BHK5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:57:10 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38101 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab2BHK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:57:08 -0500
From: Luciano Coelho <coelho@ti.com>
To: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
Date: Wed,  8 Feb 2012 12:56:52 +0200
Message-Id: <1328698612-18661-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
i2c_omap.c breaks if CONFIG_OF is not set:

drivers/i2c/busses/i2c-omap.c: In function 'omap_i2c_probe':
drivers/i2c/busses/i2c-omap.c:1021: error: 'omap_i2c_of_match' undeclared (first use in this function)
drivers/i2c/busses/i2c-omap.c:1021: error: (Each undeclared identifier is reported only once
drivers/i2c/busses/i2c-omap.c:1021: error: for each function it appears in.)

This is because the definition of omap_i2c_of_match is #ifdef'd on
CONFIG_OF, but the usage of it is not.

Since the places where omap_ic2_of_match are prepared to get NULL
pointers if CONFIG_OF is not defined, we can simply define it to NULL.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index f713eac..fd200eb 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -979,6 +979,8 @@ static const struct of_device_id omap_i2c_of_match[] = {
 	{ },
 };
 MODULE_DEVICE_TABLE(of, omap_i2c_of_match);
+#else
+static const struct of_device_id *omap_i2c_of_match = NULL;
 #endif
 
 static int __devinit
-- 
1.7.5.4

