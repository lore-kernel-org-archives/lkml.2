Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2F0T1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:27:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2F0T1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:05 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 2/9] staging: line6: Changed some strict_strtouls to kstrtou8
Date: Wed, 27 Jun 2012 21:25:56 +0200
Message-Id: <1340825163-32568-3-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusted strict_strtoul calls to kstrtou8 in order to take the changes of
line6_transmit_parameter() into account.

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/variax.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index efa496d..f97416b 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -319,10 +319,10 @@ static ssize_t variax_set_volume(struct device *dev,
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
 
@@ -418,10 +418,10 @@ static ssize_t variax_set_tone(struct device *dev,
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

