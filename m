Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2K2E6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:58:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55904 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2K2E6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:58:09 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in serqt_usb2.c
Date: Thu, 29 Nov 2012 13:57:56 +0900
Message-Id: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improved position to increment variable i,
And typo fixes.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 1b3e995..095d6f2 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -309,26 +309,26 @@ static void qt_status_change_check(struct tty_struct *tty,
 			case 0x00:
 				if (i > (RxCount - 4)) {
 					dev_dbg(&port->dev,
-						"Illegal escape seuences in received data\n");
+						"Illegal escape sequence in received data\n");
 					break;
 				}
 
-				ProcessLineStatus(qt_port, data[i + 3]);
-
 				i += 3;
+				ProcessLineStatus(qt_port, data[i]);
+
 				flag = 1;
 				break;
 
 			case 0x01:
 				if (i > (RxCount - 4)) {
 					dev_dbg(&port->dev,
-						"Illegal escape seuences in received data\n");
+						"Illegal escape sequence in received data\n");
 					break;
 				}
 
-				ProcessModemStatus(qt_port, data[i + 3]);
-
 				i += 3;
+				ProcessModemStatus(qt_port, data[i]);
+
 				flag = 1;
 				break;
 
-- 
1.7.9.5

