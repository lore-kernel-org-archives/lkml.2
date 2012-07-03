Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2GCSOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:14:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58326 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2GCSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:14:41 -0400
Message-ID: <1341339276.815.1.camel@mop>
Subject: [PATCH] kmsg: escape the backslash character while exporting data
From: Kay Sievers <kay@vrfy.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 03 Jul 2012 20:14:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: escape the backslash character while exporting data

Non-printable characters in the log data are hex-escaped to ensure safe
post processing. We need to escape a backslash we find in the data, to be
able to distinguish it from a backslash we add for the escaping.

Also escape the non-printable character 127.

Thanks to Miloslav Trmac for the heads up.

Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -465,7 +465,7 @@ static ssize_t devkmsg_read(struct file
 	for (i = 0; i < msg->text_len; i++) {
 		unsigned char c = log_text(msg)[i];
 
-		if (c < ' ' || c >= 128)
+		if (c < ' ' || c >= 127 || c == '\\')
 			len += sprintf(user->buf + len, "\\x%02x", c);
 		else
 			user->buf[len++] = c;
@@ -489,7 +489,7 @@ static ssize_t devkmsg_read(struct file
 				continue;
 			}
 
-			if (c < ' ' || c >= 128) {
+			if (c < ' ' || c >= 127 || c == '\\') {
 				len += sprintf(user->buf + len, "\\x%02x", c);
 				continue;
 			}


