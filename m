Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1HAIxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:53:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35256 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1HAIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:53:13 -0400
Subject: [PATCH] leds: led-bd2802: bd2802_unregister_led_classdev should
 unregister all registered leds
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kim Kyuwon <q1.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 16:53:04 +0800
Message-ID: <1312188784.27249.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bd2802_unregister_led_classdev() should unregister all instances of
led_classdev class that had registered by bd2802_register_led_classdev().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-bd2802.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 3ebe382..ea21855 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -662,6 +662,11 @@ failed_unregister_led1_R:
 static void bd2802_unregister_led_classdev(struct bd2802_led *led)
 {
 	cancel_work_sync(&led->work);
+	led_classdev_unregister(&led->cdev_led2b);
+	led_classdev_unregister(&led->cdev_led2g);
+	led_classdev_unregister(&led->cdev_led2r);
+	led_classdev_unregister(&led->cdev_led1b);
+	led_classdev_unregister(&led->cdev_led1g);
 	led_classdev_unregister(&led->cdev_led1r);
 }
 
-- 
1.7.4.1



