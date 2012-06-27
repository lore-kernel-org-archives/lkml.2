Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2F0T1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:27:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65337 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab2F0T1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:09 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 6/9] staging: line6: control.c eliminate strict_strtoul() in pod_set_param_int()
Date: Wed, 27 Jun 2012 21:26:00 +0200
Message-Id: <1340825163-32568-7-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exchange strict_strtoul() with kstrtou8() and make "value" a u8 instead of a
unsigned long. This is also needed for the changed
line6_pod_transmit_parameter().

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/control.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
index 67e23b6..f8326f5 100644
--- a/drivers/staging/line6/control.c
+++ b/drivers/staging/line6/control.c
@@ -55,10 +55,10 @@ static ssize_t pod_set_param_int(struct device *dev, const char *buf,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	unsigned long value;
+	u8 value;
 	int retval;
 
-	retval = strict_strtoul(buf, 10, &value);
+	retval = kstrtou8(buf, 10, &value);
 	if (retval)
 		return retval;
 
-- 
1.7.7.6

