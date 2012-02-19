Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2BSRkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 12:40:09 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:57265 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2BSRkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 12:40:07 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 12:40:07 EST
From: Bernhard Walle <bernhard@bwalle.de>
To: christoph.mair@gmail.com
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: bmp085: Handle jiffies overflow correctly
Date: Sun, 19 Feb 2012 18:28:01 +0100
Message-Id: <1329672481-19583-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.7.9.1
X-Df-Sender: MTIyNzgwNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the time_is_before_jiffies() macro instead of normal
arithmetic, the jiffies overflow is handled correctly.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/misc/bmp085.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index b29a2be..7cfc598 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -234,7 +234,8 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 	int status;
 
 	/* alt least every second force an update of the ambient temperature */
-	if (data->last_temp_measurement + 1*HZ < jiffies) {
+	if (data->last_temp_measurement == 0 ||
+			time_is_before_jiffies(data->last_temp_measurement + 1*HZ)) {
 		status = bmp085_get_temperature(data, NULL);
 		if (status != 0)
 			goto exit;
-- 
1.7.9.1

