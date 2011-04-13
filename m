Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab1DMQD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:03:29 -0400
Received: from kroah.org ([198.145.64.141]:54446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab1DMPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:48 2011
Message-Id: <20110413155147.995183731@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hartley Sweeten <hartleys@visionengravers.com>,
        Matthieu Crapet <mcrapet@gmail.com>
Subject: [47/74] drivers/misc/ep93xx_pwm.c: world-writable sysfs files
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit deb187e72470b0382d4f0cb859e76e1ebc3a1082 upstream.

Don't allow everybody to change device settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Hartley Sweeten <hartleys@visionengravers.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/ep93xx_pwm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -248,11 +248,11 @@ static ssize_t ep93xx_pwm_set_invert(str
 
 static DEVICE_ATTR(min_freq, S_IRUGO, ep93xx_pwm_get_min_freq, NULL);
 static DEVICE_ATTR(max_freq, S_IRUGO, ep93xx_pwm_get_max_freq, NULL);
-static DEVICE_ATTR(freq, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(freq, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_freq, ep93xx_pwm_set_freq);
-static DEVICE_ATTR(duty_percent, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(duty_percent, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_duty_percent, ep93xx_pwm_set_duty_percent);
-static DEVICE_ATTR(invert, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(invert, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_invert, ep93xx_pwm_set_invert);
 
 static struct attribute *ep93xx_pwm_attrs[] = {


