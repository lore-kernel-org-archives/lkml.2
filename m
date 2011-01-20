Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1ATDjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:39:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39434 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1ATDjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IRtKfPMLtmcV0Xc43TZpRjj7VroOIsdxeDXsaU6vucZ2rPbVw/ENb5FsPjMtOwFt0A
         hvCXIfcVRTByzECbo9rHfiqbKG0gKFLUEkq55lEz/+3DxspkU41BzeBk0eNW2bHhxN3N
         KhShB99znFmQ79d2ujuobziH3/QOEaQIoqLic=
Subject: [PATCH] leds: leds-pwm: return proper error if pwm_request failed
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Luotao Fu <l.fu@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Jan 2011 11:38:55 +0800
Message-Id: <1295494735.20884.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return PTR_ERR(led_dat->pwm) instead of 0 if pwm_request failed

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-pwm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index da3fa8d..666daf7 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -69,6 +69,7 @@ static int led_pwm_probe(struct platform_device *pdev)
 		led_dat->pwm = pwm_request(cur_led->pwm_id,
 				cur_led->name);
 		if (IS_ERR(led_dat->pwm)) {
+			ret = PTR_ERR(led_dat->pwm);
 			dev_err(&pdev->dev, "unable to request PWM %d\n",
 					cur_led->pwm_id);
 			goto err;
-- 
1.7.2



