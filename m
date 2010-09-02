Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0IBIXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:23:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55367 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0IBIXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rD3F8pK+ErUxrzf1U4OidAj3HCRiWapWpRl8Z1KsmagNZw41l8AKn1AhDaoGdib6j4
         xugLH/G+Zg1YCxonjZA5qBJ2KcwjkiyrcwRkgerRqAMwMuV+8DmbwUbpg7APyqxv5r+m
         Hw+0y9Tgg3qDfLTQZ85mXIGBgiwyisWIRQRD4=
Subject: [PATCH] Input: wm97xx-core - use platform_device_del instead of
	platform_device_unregister for error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 02 Sep 2010 16:27:09 +0800
Message-Id: <1283416029.19272.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/wm97xx-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index cbfef1e..770537c 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -684,8 +684,7 @@ static int wm97xx_probe(struct device *dev)
  touch_reg_err:
 	platform_device_put(wm->touch_dev);
  touch_err:
-	platform_device_unregister(wm->battery_dev);
-	wm->battery_dev = NULL;
+	platform_device_del(wm->battery_dev);
  batt_reg_err:
 	platform_device_put(wm->battery_dev);
  batt_err:
-- 
1.7.2



