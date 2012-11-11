Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2KKMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2KKMZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:10 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 6/8] staging: line6: replace deprecated strict_strtol() in toneport.c
Date: Sun, 11 Nov 2012 13:24:44 +0100
Message-Id: <1352636686-31170-7-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LED value is an int, so replace strict_strtol() with kstrtoint().
It's safe to pass in the actual variable instead of a local temporary
because strto*() doesn't write to the result unless the function returns
success.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/toneport.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 31b624b..a529dd3 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -127,13 +127,11 @@ static ssize_t toneport_set_led_red(struct device *dev,
 				    const char *buf, size_t count)
 {
 	int retval;
-	long value;
 
-	retval = strict_strtol(buf, 10, &value);
+	retval = kstrtoint(buf, 10, &led_red);
 	if (retval)
 		return retval;
 
-	led_red = value;
 	toneport_update_led(dev);
 	return count;
 }
@@ -143,13 +141,11 @@ static ssize_t toneport_set_led_green(struct device *dev,
 				      const char *buf, size_t count)
 {
 	int retval;
-	long value;
 
-	retval = strict_strtol(buf, 10, &value);
+	retval = kstrtoint(buf, 10, &led_green);
 	if (retval)
 		return retval;
 
-	led_green = value;
 	toneport_update_led(dev);
 	return count;
 }
-- 
1.7.12.1

