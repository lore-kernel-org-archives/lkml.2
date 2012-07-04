Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2GDDLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:11:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57554 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2GDDLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:11:42 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: <mchehab@infradead.org>
Cc: <anssi.hannula@iki.fi>, <gregkh@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] media: gpio-ir-recv: add allowed_protos for platform data
Date: Wed, 4 Jul 2012 11:11:32 +0800
Message-ID: <4ff3b46c.06da440a.6345.ffff8730@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1ZkrYo3CtP+NjYTlSsR3bv5mZeZw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to specify allowed RC protocols through the device's
platform data.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
For v2:
	Keymap has already done by another patch.
---
 drivers/media/rc/gpio-ir-recv.c |    2 +-
 include/media/gpio-ir-recv.h    |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c
b/drivers/media/rc/gpio-ir-recv.c
index 59fe60c..38da91e 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -84,7 +84,7 @@ static int __devinit gpio_ir_recv_probe(struct
platform_device *pdev)
 
 	rcdev->priv = gpio_dev;
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
-	rcdev->allowed_protos = RC_TYPE_ALL;
+	rcdev->allowed_protos = pdata->allowed_protos ?: RC_TYPE_ALL;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
index 91546f3..0142736 100644
--- a/include/media/gpio-ir-recv.h
+++ b/include/media/gpio-ir-recv.h
@@ -14,9 +14,10 @@
 #define __GPIO_IR_RECV_H__
 
 struct gpio_ir_recv_platform_data {
-	int gpio_nr;
-	bool active_low;
-	const char *map_name;
+	int		gpio_nr;
+	bool		active_low;
+	u64		allowed_protos;
+	const char	*map_name;
 };
 
 #endif /* __GPIO_IR_RECV_H__ */
-- 
1.7.9.5


