Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2DETTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:19:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab2DETTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:19:44 -0400
From: mathieu.poirier@linaro.org
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH] drivers: correct __devexit annotations
Date: Thu,  5 Apr 2012 13:19:38 -0600
Message-Id: <1333653578-15212-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

__devexit functions are discarded without CONFIG_HOTPLUG,
so they need to be referenced carefully.  A __devexit
function may also not be called from a __devinit
function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/leds/leds-netxbig.c |    4 ++--
 drivers/leds/leds-ns2.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index d8433f2..73973fd 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -112,7 +112,7 @@ err_free_addr:
 	return err;
 }
 
-static void __devexit gpio_ext_free(struct netxbig_gpio_ext *gpio_ext)
+static void gpio_ext_free(struct netxbig_gpio_ext *gpio_ext)
 {
 	int i;
 
@@ -294,7 +294,7 @@ static ssize_t netxbig_led_sata_show(struct device *dev,
 
 static DEVICE_ATTR(sata, 0644, netxbig_led_sata_show, netxbig_led_sata_store);
 
-static void __devexit delete_netxbig_led(struct netxbig_led_data *led_dat)
+static void delete_netxbig_led(struct netxbig_led_data *led_dat)
 {
 	if (led_dat->mode_val[NETXBIG_LED_SATA] != NETXBIG_LED_INVALID_MODE)
 		device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index 2f0a144..01cf89e 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -255,7 +255,7 @@ err_free_cmd:
 	return ret;
 }
 
-static void __devexit delete_ns2_led(struct ns2_led_data *led_dat)
+static void delete_ns2_led(struct ns2_led_data *led_dat)
 {
 	device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
 	led_classdev_unregister(&led_dat->cdev);
-- 
1.7.5.4

