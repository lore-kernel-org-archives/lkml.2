Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1ALHgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:36:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44556 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1ALHgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fxJRX5d7Lfn5Z/8xEEKH7esCINK/ejgHeOSVJpyiAofZXSvjBRqZI4OFx8vzL9LSAL
         a6VaiJ0hjYAP0SjDxjDmPzjG75gCeYXhNUy6uJBVV6cq8sZlbAeoywSESmU2Nsof5Tm3
         CE96LsVsLrS0ON4a54prElTzg+c+dbJ1B5CWA=
Subject: [PATCH] rtc: rtc-max6902 - set driver data in max6902_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Content-Type: text/plain
Date: Wed, 12 Jan 2011 15:36:34 +0800
Message-Id: <1294817794.6904.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation does not set driver data in max6902_probe(),
thus calling platform_get_drvdata(spi) in max6902_remove() returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-max6902.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 657403e..0ec3f58 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -139,12 +139,13 @@ static int __devinit max6902_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	dev_set_drvdata(&spi->dev, rtc);
 	return 0;
 }
 
 static int __devexit max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
 	rtc_device_unregister(rtc);
 	return 0;
-- 
1.7.2



