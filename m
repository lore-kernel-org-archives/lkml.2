Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2F0T1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:27:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65337 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2F0T1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:07 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 4/9] staging: line6: adjusted interface of line6_send_program()
Date: Wed, 27 Jun 2012 21:25:58 +0200
Message-Id: <1340825163-32568-5-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusted interface of line6_send_program() to clarify internal working

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/driver.c |    2 +-
 drivers/staging/line6/driver.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index d861230..b8358ca 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -490,7 +490,7 @@ static void line6_data_received(struct urb *urb)
 /*
 	Send channel number (i.e., switch to a different sound).
 */
-int line6_send_program(struct usb_line6 *line6, int value)
+int line6_send_program(struct usb_line6 *line6, u8 value)
 {
 	int retval;
 	unsigned char *buffer;
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 140ccfe..a3029eb 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -209,7 +209,7 @@ extern int line6_read_data(struct usb_line6 *line6, int address, void *data,
 			   size_t datalen);
 extern int line6_read_serial_number(struct usb_line6 *line6,
 				    int *serial_number);
-extern int line6_send_program(struct usb_line6 *line6, int value);
+extern int line6_send_program(struct usb_line6 *line6, u8 value);
 extern int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
 				  int size);
 extern int line6_send_raw_message_async(struct usb_line6 *line6,
-- 
1.7.7.6

