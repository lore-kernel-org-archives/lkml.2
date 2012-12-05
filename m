Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2LESo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:44:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36691 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2LESow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:44:52 -0500
Date: Wed, 5 Dec 2012 21:43:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Johannes Thumshirn <morbidrsa@googlemail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] staging: line6: delete an unused function
Message-ID: <20121205184316.GA18227@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

line6_send_sysex_message_async() isn't called from anywhere.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index f0be5a2..1dd768c2 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -208,8 +208,6 @@ extern int line6_send_raw_message_async(struct usb_line6 *line6,
 					const char *buffer, int size);
 extern int line6_send_sysex_message(struct usb_line6 *line6,
 				    const char *buffer, int size);
-extern int line6_send_sysex_message_async(struct usb_line6 *line6,
-					  const char *buffer, int size);
 extern ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count);
 extern void line6_start_timer(struct timer_list *timer, unsigned int msecs,
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 1e4ce500..8a5d89e 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -333,17 +333,6 @@ int line6_send_sysex_message(struct usb_line6 *line6, const char *buffer,
 }
 
 /*
-	Send sysex message in pieces of wMaxPacketSize bytes.
-*/
-int line6_send_sysex_message_async(struct usb_line6 *line6, const char *buffer,
-				   int size)
-{
-	return line6_send_raw_message_async(line6, buffer,
-					    size + SYSEX_EXTRA_SIZE) -
-	    SYSEX_EXTRA_SIZE;
-}
-
-/*
 	Allocate buffer for sysex message and prepare header.
 	@param code sysex message code
 	@param size number of bytes between code and sysex end
