Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1DLOmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:42:31 -0400
Received: from kroah.org ([198.145.64.141]:57810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab1DLOiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143557.599256155@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [090/105] drivers/leds/leds-lp5523.c: world-writable engine* sysfs files
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit ccd7510fd8dea5b4b2af87fb2aef2ebd6b23b76b upstream.

Don't allow everybody to change LED settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/leds-lp5523.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -713,7 +713,7 @@ static ssize_t store_current(struct devi
 }
 
 /* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
 
 static struct attribute *lp5523_led_attributes[] = {
@@ -727,21 +727,21 @@ static struct attribute_group lp5523_led
 };
 
 /* device attributes */
-static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
 		   show_engine1_mode, store_engine1_mode);
-static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUSR,
 		   show_engine2_mode, store_engine2_mode);
-static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUSR,
 		   show_engine3_mode, store_engine3_mode);
-static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUSR,
 		   show_engine1_leds, store_engine1_leds);
-static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUSR,
 		   show_engine2_leds, store_engine2_leds);
-static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUSR,
 		   show_engine3_leds, store_engine3_leds);
-static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {


