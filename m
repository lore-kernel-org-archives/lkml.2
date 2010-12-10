Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0LJKAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:00:09 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:60415 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0LJKAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BB25Q25ea33Q0qgtv02ZPLp7pWUxEb4EOFSBF9h2T3Na6s6/XL/UmAc60TcSL7qZCQ
         xToI0SGr7g//LRaVN6fpwvg41x4hCaU0CZ7olFirP4IGIBOxBTgEnXxBoO7ESZ9wgYsS
         93jfIHKAU6G6wIthXnqSNRifs9ca3A+kStzk8=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] LEDs: fix check for return value of blink_set callback
Date: Fri, 10 Dec 2010 11:58:53 +0200
Message-Id: <1291975133-25671-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blink_set callback should return 0 on success, but check in
led-class.c is invalid. It results in software fallback even if
hw support is available.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/leds/led-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 211e21f..d5a4ade 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -267,7 +267,7 @@ void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_off)
 {
 	if (led_cdev->blink_set &&
-	    led_cdev->blink_set(led_cdev, delay_on, delay_off))
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
 
 	/* blink with 1 Hz as default if nothing specified */
-- 
1.7.3.2

