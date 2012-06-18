Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab2FREff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:35:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64158 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2FREfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:35:34 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Renata Sayakhova <rsayakhova@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ds2781_battery: w1_ds2781_read() should be static
Date: Sun, 17 Jun 2012 21:32:40 -0700
Message-Id: <1339993960-15093-1-git-send-email-cbouatmailru@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warning:

  CHECK   drivers/power/ds2781_battery.c
drivers/power/ds2781_battery.c:72:5: warning: symbol 'w1_ds2781_read' was not declared. Should it be static?

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/ds2781_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
index 975684a..0e87e54 100644
--- a/drivers/power/ds2781_battery.c
+++ b/drivers/power/ds2781_battery.c
@@ -69,7 +69,7 @@ static inline int ds2781_battery_io(struct ds2781_device_info *dev_info,
 		return w1_ds2781_io(dev_info->w1_dev, buf, addr, count, io);
 }
 
-int w1_ds2781_read(struct ds2781_device_info *dev_info, char *buf,
+static int w1_ds2781_read(struct ds2781_device_info *dev_info, char *buf,
 		int addr, size_t count)
 {
 	return ds2781_battery_io(dev_info, buf, addr, count, 0);
-- 
1.7.10.4

