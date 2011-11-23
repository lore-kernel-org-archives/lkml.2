Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab1KWWnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:43:04 -0500
Received: from nm7-vm0.bullet.mail.ird.yahoo.com ([77.238.189.222]:29602 "HELO
	nm7-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756531Ab1KWWm6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:42:58 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 17:42:58 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 377542.94548.bm@omp1008.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bt+ZkkRgxIg5o+VlChzjkVnoI5/N0ZAPioEaJYL7UznpDpl0PgE2BMy+w7p2rF/evuUVSC9uba+4N+Aq7sD+0zR6qVGJk+BwWVmoayvEAlVYF/f44sQTrAPeFUZKL4TGBWek6+F8ZYYYgGpgSyeNfhXpmRb0h+KWKBA00C5x5Dw=;
X-YMail-OSG: XNUTJH8VM1nDfk8tTZAiSgfOT3oef6_GMrU21rUdZracO9p
 ZOoBfu_1igJ2EcAZo8yFVHBsvU5Ds9w0WNH8H93uIsn7sZd0rA0SZ70EEDMF
 HwzDmtjGUI2oP_PlYOPyZbpw9jan_n04vOtUAC5n2CCkUJXDEzTJctSdFmdA
 QrDth4ZYb4_CJch_zJ7OISpdJSRVwOgFeQ8L1DeD14279o2tda9CvbjQmgGD
 PxzLwuH4cpE0kQjpUAUULaosFR6Y5UQeNDCAhKoI8Ku5OUqW_ZFe5GTKpvY0
 _2TJWAxcxekb3kPcnJ2eJbioHoAseiGD145KYwjFgtY_ntgF0VlxV8WyhmPk
 Khy4Ry.2xsjD7ZnSnsnSDzO14G56emYc9PNUyFSQug77XzC_sEjYSaCT8d3R
 aF2YuH_3c3oJx7UGV8RrZkQ--
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.325013
Message-ID: <1322087835.12141.YahooMailClassic@web29020.mail.ird.yahoo.com>
Date: Wed, 23 Nov 2011 22:37:15 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH] power/ds2760_battery: Add rated capacity of the hx4700 3600mAh battery
To: linux-kernel@vger.kernel.org
Cc: philipp.zabel@gmail.com, mad_soft@inbox.ru, koen@dominion.thruhere.net,
        cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rated capacity of the HP iPAQ hx4700 3.7V 3600mAh (359114-001) battery.
For this battery the value of the rated capacity EEPROM register at 0x32 is 14;
thus rated_capacities[14] = 3600.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
diff -uprN clean-3.2-rc2/drivers/power/ds2760_battery.c linux-3.2-rc2/drivers/power/ds2760_battery.c
--- clean-3.2-rc2/drivers/power/ds2760_battery.c	2011-11-15 17:02:59.000000000 +0000
+++ linux-3.2-rc2/drivers/power/ds2760_battery.c	2011-11-23 22:06:46.816841888 +0000
@@ -95,7 +95,11 @@ static int rated_capacities[] = {
 	2880,	/* Samsung */
 	2880,	/* BYD */
 	2880,	/* Lishen */
-	2880	/* NEC */
+	2880,	/* NEC */
+#ifdef CONFIG_MACH_H4700
+	0,
+	3600,	/* HP iPAQ hx4700 3.7V 3600mAh (359114-001) */
+#endif
 };
 
 /* array is level at temps 0°C, 10°C, 20°C, 30°C, 40°C

