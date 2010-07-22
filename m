Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0GVQ6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:58:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0GVQ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HWFaEXU2tMpQxQtTUp7tQZ8fFA0tLzQvwfRmaCI8Y4/OwbwZ2amYfzAxubDfaN0ZiO
         cKt01dvRcnXFh/FpXIIKuiPXQahEeACzbIS83Ob9FTSWO7p745EIfdZyQ6akaDkEJx8f
         QN/3rARo+ySTv9sFW0RU+Zq8uS/HPXn7Ddgeg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/5] staging: panel: change own pieces of code by strtoul()
Date: Thu, 22 Jul 2010 19:57:08 +0300
Message-Id: <1c9daf151cb12e4267a74236791eeda9b600c240.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
In-Reply-To: <cover.1279817399.git.andy.shevchenko@gmail.com>
References: <cover.1279817399.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have nice method simple_strtoul() to convert string to numbers which
could be used here.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/panel/panel.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 8bd7182..3e07e41 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -48,6 +48,7 @@
 #include <linux/fcntl.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/parport.h>
 #include <linux/version.h>
@@ -1179,22 +1180,16 @@ static inline int handle_lcd_special_code(void)
 			break;
 
 		while (*esc) {
+			char *endp;
+
 			if (*esc == 'x') {
 				esc++;
-				lcd_addr_x = 0;
-				while (isdigit(*esc)) {
-					lcd_addr_x = lcd_addr_x * 10 +
-						     (*esc - '0');
-					esc++;
-				}
+				lcd_addr_x = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else if (*esc == 'y') {
 				esc++;
-				lcd_addr_y = 0;
-				while (isdigit(*esc)) {
-					lcd_addr_y = lcd_addr_y * 10 +
-						     (*esc - '0');
-					esc++;
-				}
+				lcd_addr_y = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else
 				break;
 		}
-- 
1.7.1.1

