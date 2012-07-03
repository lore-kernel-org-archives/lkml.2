Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2GCK11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:27:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab2GCK1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:27:25 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: <mchehab@infradead.org>
Cc: <tsoni@codeaurora.org>, <dan.carpenter@oracle.com>,
        <kumarrav@codeaurora.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: gpio-ir-recv: add allowed_protos and map_name for platform data
Date: Tue, 3 Jul 2012 18:27:19 +0800
Message-ID: <4ff2c90c.83e6440a.48b4.3727@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AQHNWQS+6jbr7l/lsESpjlaQ5peinJcXWhTwgAAAL8A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to give platform code a chance to specify the allowed
protocols and which keymap to use.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 drivers/media/rc/gpio-ir-recv.c |   10 ++++++++--
 include/media/gpio-ir-recv.h    |    6 ++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c
b/drivers/media/rc/gpio-ir-recv.c
index 0d87545..f0d09af 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -83,11 +83,17 @@ static int __devinit gpio_ir_recv_probe(struct
platform_device *pdev)
 	}
 
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
-	rcdev->allowed_protos = RC_TYPE_ALL;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
-	rcdev->map_name = RC_MAP_EMPTY;
+	if (pdata->allowed_protos)
+		rcdev->allowed_protos = pdata->allowed_protos;
+	else
+		rcdev->allowed_protos = RC_TYPE_ALL;
+	if (pdata->map_name)
+		rcdev->map_name = pdata->map_name;
+	else
+		rcdev->map_name = RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
 	gpio_dev->gpio_nr = pdata->gpio_nr;
diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
index 67797bf..0142736 100644
--- a/include/media/gpio-ir-recv.h
+++ b/include/media/gpio-ir-recv.h
@@ -14,8 +14,10 @@
 #define __GPIO_IR_RECV_H__
 
 struct gpio_ir_recv_platform_data {
-	int gpio_nr;
-	bool active_low;
+	int		gpio_nr;
+	bool		active_low;
+	u64		allowed_protos;
+	const char	*map_name;
 };
 
 #endif /* __GPIO_IR_RECV_H__ */
-- 
1.7.9.5


