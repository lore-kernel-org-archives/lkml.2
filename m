Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2FUHFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:05:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60817 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2FUHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:05:00 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anatolij Gustschin <agust@denx.de>,
        Andreas Dumberger <andreas.dumberger@tqs.de>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] rtc/r9701: avoid second call to the rtc_valid_tm
Date: Thu, 21 Jun 2012 12:34:40 +0530
Message-Id: <1340262280-15096-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r9701_get_datetime will call the rtc_valid_tm and it returns the
value returned by rtc_valid_tm, which anyway can be used in the if

so calling rtc_valid_tm is not required.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---


This change is compiled tested only using gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3 on x86_64 (intel core i3).

 drivers/rtc/rtc-r9701.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 33b6ba0..e6c34c0 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -138,8 +138,7 @@ static int __devinit r9701_probe(struct spi_device *spi)
 	 * contain invalid values. If so, try to write a default date:
 	 * 2000/1/1 00:00:00
 	 */
-	r9701_get_datetime(&spi->dev, &dt);
-	if (rtc_valid_tm(&dt)) {
+	if (r9701_get_datetime(&spi->dev, &dt)) {
 		dev_info(&spi->dev, "trying to repair invalid date/time\n");
 		dt.tm_sec  = 0;
 		dt.tm_min  = 0;
-- 
1.7.9.5

