Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0EQArf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:47:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45434 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0EQArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sq0hBzDub3n+qWulkE5O8ddMtGK9jgFqcDfMRs6Mq9129ci5bjb9CRLUtUzQEFh/MZ
         KNuVa4+sARh49CY9/NHo70FqcyngfG91MfVo/VjThEOjCtCIddHMmh29AaDi+9iAeakS
         ZHYdhZkVsrL/gvsezAeQLY6eFiz1uXb4+LhoY=
Subject: [PATCH] led-class: set permissions on max_brightness file to 0444
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@linux.intel.com>, John Lenz <lenz@cs.wisc.edu>
Content-Type: text/plain
Date: Mon, 17 May 2010 08:48:28 +0800
Message-Id: <1274057308.9060.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_brightness is not writable, thus set permissions to 0444.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/led-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 69e7d86..2606600 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -74,7 +74,7 @@ static ssize_t led_max_brightness_show(struct device *dev,
 
 static struct device_attribute led_class_attrs[] = {
 	__ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
-	__ATTR(max_brightness, 0644, led_max_brightness_show, NULL),
+	__ATTR(max_brightness, 0444, led_max_brightness_show, NULL),
 #ifdef CONFIG_LEDS_TRIGGERS
 	__ATTR(trigger, 0644, led_trigger_show, led_trigger_store),
 #endif
-- 
1.5.4.3



