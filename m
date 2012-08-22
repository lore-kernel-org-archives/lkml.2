Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2HVHIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:08:07 -0400
Received: from mail.telros.ru ([83.136.244.21]:53156 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab2HVHG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:06:57 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 07/10] staging: media: go7007: README TODO
Date: Wed, 22 Aug 2012 14:45:16 +0400
Message-Id: <1345632319-23224-7-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/README |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
index aeba132..237f45d 100644
--- a/drivers/staging/media/go7007/README
+++ b/drivers/staging/media/go7007/README
@@ -5,6 +5,32 @@ Todo:
 	  and added to the build.
 	- testing?
 	- handle churn in v4l layer.
+	- Some features for wis-tw2804 subdev control (comb filter,coring,IF comp,peak,more over...)
+	- Cropping&Scaling on tw2804
+	- Motion detector on tw2804, spatial&temporal sensitivity & masks control,velocity
+	- Control Output Format on tw2804
+	- go7007-v4l2.c need rewrite with new v4l2 style without nonstandard IO controls (set detector & bitrate)
+
+13/05/2012 3.4.0-rc+:
+Changes:
+	- Convert to V4L2 control framework
+
+05/05/2012 3.4.0-rc+:
+Changes:
+	- When go7007 reset device, i2c was not working (need rewrite GPIO5)
+	- As wis2804 has i2c_addr=0x00/*really*/, so need to set I2C_CLIENT_TEN flag for validity
+	- Some main nonzero initialization, rewrites with kzalloc instead kmalloc
+	- STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
+		failed v4l2_device_unregister with kernel panic (OOPS)
+	- Some new v4l2 style features as call_all(...s_stream...) for using subdev calls
+	- wis-tw2804.ko module code was incompatible with 3.4.x branch in initialization v4l2_subdev parts.
+		now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standard wis_tw2804 struct
+
+Adds:
+	- Switch between 2 composite video inputs on channel: VIN[1,2,3,4]A and VIN[1,2,3,4]B
+	- Additional chipset wis2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances,
+		for all 4 channels (from tw2804.pdf)
+	- Power control for each 4 ADC up when s_stream(...,1), down otherwise in wis-tw2804 module
 
 Please send patches to Greg Kroah-Hartman <greg@linuxfoundation.org> and Cc: Ross
 Cohen <rcohen@snurgle.org> as well.
-- 
1.7.7.6

