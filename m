Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0ICDDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:03:03 -0400
Received: from smtp14.ono.com ([62.42.230.176]:23639 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754629Ab0ICDDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:03:01 -0400
Date: Fri, 3 Sep 2010 05:01:32 +0200
From: Guillem Jover <guillem@hadrons.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwmon: (f75375s) Do not overwrite values read from
 registers
Message-ID: <20100903030132.GA16049@gaara.hadrons.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All bits in the values read from registers to be used for the next
write were getting overwritten, avoid doing so to not mess with the
current configuration.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
---
 drivers/hwmon/f75375s.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index e5828c0..9638d58 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -298,7 +298,7 @@ static int set_pwm_enable_direct(struct i2c_client *client, int nr, int val)
 		return -EINVAL;
 
 	fanmode = f75375_read8(client, F75375_REG_FAN_TIMER);
-	fanmode = ~(3 << FAN_CTRL_MODE(nr));
+	fanmode &= ~(3 << FAN_CTRL_MODE(nr));
 
 	switch (val) {
 	case 0: /* Full speed */
@@ -350,7 +350,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	conf = f75375_read8(client, F75375_REG_CONFIG1);
-	conf = ~(1 << FAN_CTRL_LINEAR(nr));
+	conf &= ~(1 << FAN_CTRL_LINEAR(nr));
 
 	if (val == 0)
 		conf |= (1 << FAN_CTRL_LINEAR(nr)) ;
-- 
1.7.1

