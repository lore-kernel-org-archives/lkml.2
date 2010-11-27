Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0K0SmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:42:12 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:60824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0K0SmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:42:11 -0500
Subject: [PATCH 2.6.37] led_class: fix typo in blink API
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 19:42:08 +0100
Message-ID: <1290883328.3700.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When I added led_blink_set I had a typo: the
return value of the hw offload is a regular
error code that is zero when succesful, and
in that case software emulation should not
be used, rather than the other way around.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
It'd be nice to get this into 2.6.37 since the patch
that has the bug is in there. Sorry about that -- I
had tested the software implementation extensively but
apparently never tested the hw offload part.

 drivers/leds/led-class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/leds/led-class.c	2010-11-27 19:32:24.000000000 +0100
+++ wireless-testing/drivers/leds/led-class.c	2010-11-27 19:35:41.000000000 +0100
@@ -267,7 +267,7 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_off)
 {
 	if (led_cdev->blink_set &&
-	    led_cdev->blink_set(led_cdev, delay_on, delay_off))
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
 
 	/* blink with 1 Hz as default if nothing specified */


