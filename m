Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab0KHFHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:07:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49809 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0KHFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nPL+pmBdwOujCYDxclwNdv8mRRyac3p20vwb3w4gyemzWZNTjwYUKu/G4TQuV50nV9
         79FwXcZwL9btGwWf/TpmBBIcRewClU4263sRxrKphlAu6mekoy+r5HQ4lyxIzK/D42nq
         O3PSobpDR38BF7RM9Gpl4PVFi9Ubjykmb/gY0=
Subject: [PATCH] hwmon: (adt7470) Return proper error code for
	adt7470_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain
Date: Mon, 08 Nov 2010 13:11:33 +0800
Message-Id: <1289193093.682.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/adt7470.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 9e77571..87d92a5 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1286,8 +1286,10 @@ static int adt7470_probe(struct i2c_client *client,
 	init_completion(&data->auto_update_stop);
 	data->auto_update = kthread_run(adt7470_update_thread, client,
 					dev_name(data->hwmon_dev));
-	if (IS_ERR(data->auto_update))
+	if (IS_ERR(data->auto_update)) {
+		err = PTR_ERR(data->auto_update);
 		goto exit_unregister;
+	}
 
 	return 0;
 
-- 
1.7.2



