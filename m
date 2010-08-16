Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab0HPB25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:28:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63348 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0HPB24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=T40oBCFvJOl458e6T2J66plRa3yPlo3azHRPArkFcm56SE7OnGXJNrt3GJaJFiK6SZ
         YK9aks/7ix2ptvOsKLxMZgDbeO8hgwWkloyQZVpcPOASyNYbzfIUerb84lHvwinOm44z
         /DBV/Qzeqq40bP5aPog6xvnbcjqdLqGVzzJMU=
Subject: [PATCH] hwmon: (ads7871) Fix ads7871_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Thomas <pthomas8589@gmail.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain
Date: Mon, 16 Aug 2010 09:31:17 +0800
Message-Id: <1281922277.26991.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call hwmon_device_unregister() if an error is detected after
sucessfully register hwmon device.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/ads7871.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index b300a20..303db92 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -201,11 +201,13 @@ static int __devinit ads7871_probe(struct spi_device *spi)
 	we need to make sure we really have a chip*/
 	if (val != ret) {
 		err = -ENODEV;
-		goto error_remove;
+		goto error_unregister;
 	}
 
 	return 0;
 
+error_unregister:
+	hwmon_device_unregister(pdata->hwmon_dev);
 error_remove:
 	sysfs_remove_group(&spi->dev.kobj, &ads7871_group);
 error_free:
-- 
1.7.2



