Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2HNSXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:23:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43496 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2HNSXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:23:02 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        morbidrsa@googlemail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: line6: variax.c: Eliminated remaining strict_stroul()s
Date: Tue, 14 Aug 2012 20:22:48 +0200
Message-Id: <1344968568-4613-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminated remaining calls to strict_stroul() and replaced them with
strict_kstrtou8().

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/variax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index bb99ee4..f97416b 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -353,10 +353,10 @@ static ssize_t variax_set_model(struct device *dev,
 {
 	struct usb_line6_variax *variax =
 	    usb_get_intfdata(to_usb_interface(dev));
-	unsigned long value;
+	u8 value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtou8(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -387,10 +387,10 @@ static ssize_t variax_set_active(struct device *dev,
 {
 	struct usb_line6_variax *variax =
 	    usb_get_intfdata(to_usb_interface(dev));
-	unsigned long value;
+	u8 value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtou8(buf, 10, &value);
 	if (ret)
 		return ret;
 
-- 
1.7.11.2

