Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab2IKQMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:12:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45004 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab2IKQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:11:40 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <j-keerthy@ti.com>, <b-cousson@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 3/4] staging: omap-thermal: fix polling period settings
Date: Tue, 11 Sep 2012 19:06:54 +0300
Message-ID: <1347379615-6881-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
References: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While registering the omap thermal zones we need to
properly specify TC1 and TC2, as long as the proper
passive polling period and monitor period.

This patch fixes the parameters passed while registering
the thermal zone.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-thermal-common.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
index 0675a5e..d156424 100644
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/omap-thermal/omap-thermal-common.c
@@ -246,7 +246,9 @@ int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
 	/* Create thermal zone */
 	data->omap_thermal = thermal_zone_device_register(domain,
 				OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
-				0, FAST_TEMP_MONITORING_RATE, 0, 0);
+				1, 2, /*TODO: remove this when FW allows */
+				FAST_TEMP_MONITORING_RATE,
+				FAST_TEMP_MONITORING_RATE);
 	if (IS_ERR_OR_NULL(data->omap_thermal)) {
 		dev_err(bg_ptr->dev, "thermal zone device is NULL\n");
 		return PTR_ERR(data->omap_thermal);
-- 
1.7.7.1.488.ge8e1c

