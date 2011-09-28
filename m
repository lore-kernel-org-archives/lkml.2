Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1I1Wpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804Ab1I1Wpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.628446629@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: [126/244] drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7a5caabd090b8f7d782c40fc1c048d798f2b6fd7 upstream.

Fix regression introduced by commit 5ada28bf7675 ("led-class: always
implement blinking") which broke sysfs delay handling by not storing the
updated value.  Consequently it was only possible to set one of the delays
through the sysfs interface as the other delay was automatically restored
to it's default value.  Reading the parameters always gave the defaults.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/ledtrig-timer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -41,6 +41,7 @@ static ssize_t led_delay_on_store(struct
 
 	if (count == size) {
 		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+		led_cdev->blink_delay_on = state;
 		ret = count;
 	}
 
@@ -69,6 +70,7 @@ static ssize_t led_delay_off_store(struc
 
 	if (count == size) {
 		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+		led_cdev->blink_delay_off = state;
 		ret = count;
 	}
 


