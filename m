Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1BDM0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:26:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1BDMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RTaIM7LaB/zOWf0QIjdvdb7BzvXVT/gIv6JBKDeMT6Lsx6pwVyDR74MQw6zL9bRjSR
         1vob8tS1RR75m+IituXUYaWloTT70hwArqT5ws+3wI010ZkyDW8CQ0drpeGpNPsDgOzb
         e7ifDQViW+EQEdsoaGDnlNBiFsUYZzDOcdwok=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/20] misc: ep93xx_pwm: world-writable sysfs files
Date: Fri,  4 Feb 2011 15:23:46 +0300
Message-Id: <395da4be9c65a9fd5027c571f99e3b0c21b2411c.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to change device settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile the driver, so it is not tested at all.

 drivers/misc/ep93xx_pwm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 46b3439..16d7179 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -249,11 +249,11 @@ static ssize_t ep93xx_pwm_set_invert(struct device *dev,
 
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
-- 
1.7.0.4

