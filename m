Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2BNOso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:48:44 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:35111 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760781Ab2BNOsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:48:42 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danny Kukawka <dkukawka@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bcm: move DRIVER_HALT into enum LedEvents
Date: Tue, 14 Feb 2012 15:48:37 +0100
Message-Id: <1329230917-27567-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230922;1d62f1c7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move DRIVER_HALT into enum LedEvents to fix:
drivers/staging/bcm/led_control.c: In function ‘LEDControlThread’:
drivers/staging/bcm/led_control.c:817:3: warning: case value ‘255’
  not in enumerated type ‘LedEventInfo_t’ [-Wswitch]

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/bcm/led_control.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/led_control.h b/drivers/staging/bcm/led_control.h
index 0711ac2..57c8c45 100644
--- a/drivers/staging/bcm/led_control.h
+++ b/drivers/staging/bcm/led_control.h
@@ -63,12 +63,10 @@ typedef enum LedEvents {
 	IDLEMODE_CONTINUE = 0x40,
 	IDLEMODE_EXIT = 0x80,
 	LED_THREAD_INACTIVE = 0x100,  //Makes the LED thread Inactivce. It wil be equivallent to putting the thread on hold.
-	LED_THREAD_ACTIVE = 0x200    //Makes the LED Thread Active back.
+	LED_THREAD_ACTIVE = 0x200,    /*Makes the LED Thread Active back*/
+	DRIVER_HALT = 0xff
 } LedEventInfo_t;			/*Enumerated values of different driver states*/
 
-#define DRIVER_HALT 0xff
-
-
 /*Structure which stores the information of different LED types
  *  and corresponding LED state information of driver states*/
 typedef struct LedStateInfo_t
-- 
1.7.7.3

