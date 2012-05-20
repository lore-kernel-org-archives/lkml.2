Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2ETMzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:55:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44096 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2ETMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:55:40 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] drivers/staging/line6/variax.c: Change some strict_strtoul() calls
Date: Sun, 20 May 2012 14:55:08 +0200
Message-Id: <1337518508-23282-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed strict_strtoul() calls which do not result in a need to change
interfaces of called functions.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/variax.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index d366222..efa496d 100644
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
1.7.7.6

