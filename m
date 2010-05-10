Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0EJB3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:29:43 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48253 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0EJB3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mSBP/QrTiq+xA60WGJoFEzx9z55KCP8CgU1JlDswluLuIjMha63egtxiq5k1Iv5/vZ
         25L8xD9mbzPNWbXt3Cu+T5kUVGOPEUlxAztNpkl2vJUV7G0UDTPBe3cyn6x3GdUpDfhs
         k3QbvacfzkqWj6+/UtWe7UHcxptD4GpApp0fI=
Subject: [PATCH] 88pm860x_bl: fix error handling in pm860x_backlight_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 10 May 2010 09:29:58 +0800
Message-Id: <1273454998.6536.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. fixes a memory leak by kfree(data) in the case of data->port < 0.
2. properly unregisters a previously registered backlight device object
in error handling

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/88pm860x_bl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c
b/drivers/video/backlight/88pm860x_bl.c
index 68d2518..38ffc3f 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -222,6 +222,7 @@ static int pm860x_backlight_probe(struct
platform_device *pdev)
 	data->port = __check_device(pdata, name);
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "wrong platform data is assigned");
+		kfree(data);
 		return -EINVAL;
 	}
 
@@ -266,6 +267,7 @@ static int pm860x_backlight_probe(struct
platform_device *pdev)
 	backlight_update_status(bl);
 	return 0;
 out:
+	backlight_device_unregister(bl);
 	kfree(data);
 	return ret;
 }
-- 
1.5.4.3



