Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0D0NSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:18:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55632 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0D0NSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=igNQ3GkEi9sMrjWKxLF7Kd1xw7c3rcb7wAcLe3uQxg4TEbmyH56b80AwyMJC6RRztb
         LNRgohyNiQdJBPcOIxWDo8Q0xzkEDXtohVqSJ2ppdRF7DmfsRjezQeHKK00DvNHpmyPr
         RXjwjeLF94Ta2GTMLLpah03QhBDYecrSgQAFk=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] tosa_battery: fix FTBFS bug due to driver_data access
Date: Tue, 27 Apr 2010 17:18:22 +0400
Message-Id: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/power/tosa_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
index 2eab35a..ee04936 100644
--- a/drivers/power/tosa_battery.c
+++ b/drivers/power/tosa_battery.c
@@ -61,7 +61,7 @@ static unsigned long tosa_read_bat(struct tosa_bat *bat)
 	mutex_lock(&bat_lock);
 	gpio_set_value(bat->gpio_bat, 1);
 	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+	value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
 			bat->adc_bat);
 	gpio_set_value(bat->gpio_bat, 0);
 	mutex_unlock(&bat_lock);
@@ -81,7 +81,7 @@ static unsigned long tosa_read_temp(struct tosa_bat *bat)
 	mutex_lock(&bat_lock);
 	gpio_set_value(bat->gpio_temp, 1);
 	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+	value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
 			bat->adc_temp);
 	gpio_set_value(bat->gpio_temp, 0);
 	mutex_unlock(&bat_lock);
-- 
1.7.0

