Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0DTKxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:53:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:43026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0DTKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=b0bmSzPtM/VmY1N1SUdXapXG4JTtyBveJv/+mOnQI55/ranYXCH0064dZX33NEaWXA
         6Af3y5ZwgIAm9Osxi5TUHRfujzV11LzIlBUZMnUG3YT2+VkpMBqY/3XGGcxNMQ6bjL/b
         K3y/s3u+3PyyhEQh0FQwHq8kpbaZrdFbm16+k=
From: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
       Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Subject: [PATCH] i2c-s3c2410: Decrease delay after end of transaction
Date: Tue, 20 Apr 2010 13:53:19 +0300
Message-Id: <1271760799-30913-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msleep(1) which has been used for delay after issuing a STOP condition
to bus cause very big delay (min 1/HZ s). This is makes bulk register
update in I2C devices (for instance video camera) very slowly.

Seems that this delay can be safely decreased to few tens of
microseconds.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index d27072b..de20a4e 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -521,7 +521,7 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 
 	/* ensure the stop has been through the bus */
 
-	msleep(1);
+	udelay(50);
 
  out:
 	return ret;
-- 
1.6.6.1

