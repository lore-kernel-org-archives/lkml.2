Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2EOHvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:51:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63578 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2EOHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:51:35 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-35-4fb20b05cf4f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/7] backlight: use pr_warn instead of printk
Date: Tue, 15 May 2012 16:51:33 +0900
Message-id: <000c01cd326f$8c3a92e0$a4afb8a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yb4veayb4uZ0ZTj675c5WX+JoGQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_warn instead of printk to allow dynamic debugging.
It also fixes checkpatch warnings as below:

WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |    4 ++--
 drivers/video/backlight/lcd.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index bf5b1ec..ba56075 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -378,8 +378,8 @@ static int __init backlight_class_init(void)
 {
 	backlight_class = class_create(THIS_MODULE, "backlight");
 	if (IS_ERR(backlight_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(backlight_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(backlight_class));
 		return PTR_ERR(backlight_class);
 	}
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 1c298d5..291f1a1 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -263,8 +263,8 @@ static int __init lcd_class_init(void)
 {
 	lcd_class = class_create(THIS_MODULE, "lcd");
 	if (IS_ERR(lcd_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(lcd_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(lcd_class));
 		return PTR_ERR(lcd_class);
 	}
 
-- 
1.7.1


