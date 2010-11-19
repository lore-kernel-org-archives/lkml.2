Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab0KSFWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:22:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53880 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0KSFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:22:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TuJQGbykRj4IECzbfJiCBH3v8opq2e8OMVKMaJ3DLBRhP4XS/29bO2TDIkZQWBxl9A
         d/x4/DsoM1SH/GRX0kf1y+LsHvalSDdXg7vIALdCo3NCBRIotSuE7zsXYfHQeCI/1hVU
         3Q6KwH04TL71tviLtSR9JG1wBXutk9pPASYi0=
Subject: [PATCH] misc/isl29020: Remove incorrect kfree in isl29020_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
        Liu Hong <hong.liu@intel.com>, Kalhan Trisal <kalhan.trisal@intel.com>
Content-Type: text/plain
Date: Fri, 19 Nov 2010 13:27:17 +0800
Message-Id: <1290144437.23599.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct als_data *data is not used in this driver at all.

Also add a missing ">" character for MODULE_AUTHOR.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/isl29020.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index ca47e62..307aada 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -183,9 +183,7 @@ static int  isl29020_probe(struct i2c_client *client,
 
 static int isl29020_remove(struct i2c_client *client)
 {
-	struct als_data *data = i2c_get_clientdata(client);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
-	kfree(data);
 	return 0;
 }
 
@@ -245,6 +243,6 @@ static void  __exit sensor_isl29020_exit(void)
 module_init(sensor_isl29020_init);
 module_exit(sensor_isl29020_exit);
 
-MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com>");
 MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.2



