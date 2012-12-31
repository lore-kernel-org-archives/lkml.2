Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2LaLJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:09:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55516 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab2LaLJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:40 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 05/10] mfd: twl-core: Do not try to call legacy mfd add_children() when booted with DT
Date: Mon, 31 Dec 2012 12:09:26 +0100
Message-ID: <1356952171-6109-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is really no point to retry to add children devices in case the
of_platform_populate() fails.
We do not have any information provided via pdata in this case anyways.
Depending on the boot type (legacy or DT) only execute either one.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index fbff830..86cca9e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1305,10 +1305,9 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		twl_i2c_write_u8(TWL4030_MODULE_INTBR, temp, REG_GPPUPDCTR1);
 	}
 
-	status = -ENODEV;
 	if (node)
 		status = of_platform_populate(node, NULL, NULL, &client->dev);
-	if (status)
+	else
 		status = add_children(pdata, irq_base, id->driver_data);
 
 fail:
-- 
1.8.0.2

