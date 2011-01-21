Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1AUKVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:21:13 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:37621 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab1AUKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:21:12 -0500
From: Naveen Kumar G <naveen.gaddipati@stericsson.com>
To: <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 1/2] staging:synaptics: Update with the kernel object name of touch device
Date: Fri, 21 Jan 2011 15:50:16 +0530
Message-ID: <1295605216-25281-1-git-send-email-naveen.gaddipati@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>

Update with the kernel object name of touch device for getting
the regulator of the synaptics rmi4 touch device.

Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    6 ++----
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 80183a7..21c1efd 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -924,10 +924,8 @@ static int __devinit synaptics_rmi4_probe
 		goto err_input;
 	}
 
-	dev_set_name(&client->dev, platformdata->name);
-
 	if (platformdata->regulator_en) {
-		rmi4_data->regulator = regulator_get(&client->dev, "v-touch");
+		rmi4_data->regulator = regulator_get(&client->dev, "vdd");
 		if (IS_ERR(rmi4_data->regulator)) {
 			dev_err(&client->dev, "%s:get regulator failed\n",
 								__func__);
@@ -993,7 +991,7 @@ static int __devinit synaptics_rmi4_probe
 	retval = request_threaded_irq(platformdata->irq_number, NULL,
 					synaptics_rmi4_irq,
 					platformdata->irq_type,
-					platformdata->name, rmi4_data);
+					DRIVER_NAME, rmi4_data);
 	if (retval) {
 		dev_err(&client->dev, "%s:Unable to get attn irq %d\n",
 				__func__, platformdata->irq_number);
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
index 820ae27..3686a2f 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
@@ -39,7 +39,6 @@
  * This structure gives platform data for rmi4.
  */
 struct synaptics_rmi4_platform_data {
-	const char *name;
 	int irq_number;
 	int irq_type;
 	bool x_flip;
-- 
1.7.2.dirty

