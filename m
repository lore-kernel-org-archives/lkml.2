Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2BHLSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:18:33 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45033 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750Ab2BHLSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:18:32 -0500
From: Luciano Coelho <coelho@ti.com>
To: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 3.3 v2] I2C: OMAP: fix build breakage when CONFIG_OF is not set
Date: Wed,  8 Feb 2012 13:18:21 +0200
Message-Id: <1328699901-19488-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6145197 (i2c: OMAP: Add DT support for i2c controller),
building i2c_omap.c breaks if CONFIG_OF is not set:

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
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
v2: changed the commit log to use abbrev sha and include the commit subject

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

