Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab0I0HKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:10:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46469 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0I0HKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GpWiK/5ASY/T71sBv56mW2vsPFcZ3FGVFXQa6yNi5dTAMu/JXnp5wTxn5qzrRqDOPV
         4Cbyv8TZXHMnylwJLrLitiyTBKoBKWPI54iJZpGGZl4m6ENwB624sjmTWtqSho2y/I0U
         9A+dMB+6pdjerMFF+sFL0pqdd2uicdRo2Tk9Q=
Subject: [PATCH 3/3] drivers/power: add missing kfree(wm831x_power) in
	wm831x_power_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1285571232.31251.1.camel@mola>
References: <1285571232.31251.1.camel@mola>
Content-Type: text/plain
Date: Mon, 27 Sep 2010 15:10:11 +0800
Message-Id: <1285571411.31251.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/wm831x_power.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index a57a941..ddf8cf5 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -611,6 +611,7 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
 	power_supply_unregister(&wm831x_power->battery);
 	power_supply_unregister(&wm831x_power->wall);
 	power_supply_unregister(&wm831x_power->usb);
+	kfree(wm831x_power);
 	return 0;
 }
 
-- 
1.7.2



