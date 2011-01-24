Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1AXKps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:45:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60515 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1AXKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:45:46 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging/ste_rmi4: Remove obsolete cleanup for clientdata
Date: Mon, 24 Jan 2011 11:44:29 +0100
Message-Id: <1295865880-27672-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
---

Compile tested only.

 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index e8f047e..c9207de 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -989,7 +989,7 @@ static int __devinit synaptics_rmi4_probe
 	retval = input_register_device(rmi4_data->input_dev);
 	if (retval) {
 		dev_err(&client->dev, "%s:input register failed\n", __func__);
-		goto err_input_register;
+		goto err_query_dev;
 	}
 
 	/* Clear interrupts */
@@ -1011,8 +1011,6 @@ static int __devinit synaptics_rmi4_probe
 err_request_irq:
 	free_irq(platformdata->irq_number, rmi4_data);
 	input_unregister_device(rmi4_data->input_dev);
-err_input_register:
-	i2c_set_clientdata(client, NULL);
 err_query_dev:
 	if (platformdata->regulator_en) {
 		regulator_disable(rmi4_data->regulator);
-- 
1.7.2.3

