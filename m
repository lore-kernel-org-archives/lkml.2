Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1ABHxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:53:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:35570 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1ABHX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Guillem Jover <guillem@hadrons.org>,
        Riku Voipio <riku.voipio@iki.fi>, Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 100/260] hwmon: (f75375s) Do not overwrite values read from registers
Date: Sun,  2 Jan 2011 02:16:36 -0500
Message-Id: <1293952756-15010-101-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:00.0086 (UTC) FILETIME=[BED27B60:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillem Jover <guillem@hadrons.org>

commit c3b327d60bbba3f5ff8fd87d1efc0e95eb6c121b upstream.

All bits in the values read from registers to be used for the next
write were getting overwritten, avoid doing so to not mess with the
current configuration.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
Cc: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/f75375s.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 303160c..72afd06 100644
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
1.7.3.3

