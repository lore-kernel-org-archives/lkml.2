Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1DZVem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:34:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:65464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769Ab1DZVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327143"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, hartleys@visionengravers.com, ak@linux.intel.com,
        mcrapet@gmail.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [36/106] drivers/misc/ep93xx_pwm.c: world-writable sysfs files
Message-Id: <20110426211315.A2B903E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit deb187e72470b0382d4f0cb859e76e1ebc3a1082 upstream.

Don't allow everybody to change device settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Hartley Sweeten <hartleys@visionengravers.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/ep93xx_pwm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/misc/ep93xx_pwm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/misc/ep93xx_pwm.c
+++ linux-2.6.35.y/drivers/misc/ep93xx_pwm.c
@@ -249,11 +249,11 @@ static ssize_t ep93xx_pwm_set_invert(str
 
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
