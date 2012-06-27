Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2F0T32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:29:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2F0T1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:00 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 1/9] staging: line6: changed interface of line6_transmit_parameter()
Date: Wed, 27 Jun 2012 21:25:55 +0200
Message-Id: <1340825163-32568-2-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interface of line6_transmit_parameter() adjusted to clarify internal workings

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/driver.c |    2 +-
 drivers/staging/line6/driver.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 4513f78..d861230 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -526,7 +526,7 @@ int line6_send_program(struct usb_line6 *line6, int value)
 /*
 	Transmit Line6 control parameter.
 */
-int line6_transmit_parameter(struct usb_line6 *line6, int param, int value)
+int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
 {
 	int retval;
 	unsigned char *buffer;
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 117bf99..140ccfe 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -224,7 +224,7 @@ extern void line6_start_timer(struct timer_list *timer, unsigned int msecs,
 			      void (*function) (unsigned long),
 			      unsigned long data);
 extern int line6_transmit_parameter(struct usb_line6 *line6, int param,
-				    int value);
+				    u8 value);
 extern int line6_version_request_async(struct usb_line6 *line6);
 extern int line6_write_data(struct usb_line6 *line6, int address, void *data,
 			    size_t datalen);
-- 
1.7.7.6

