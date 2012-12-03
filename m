Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2LCNUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:20:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54278 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2LCNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:20:10 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: devel@driverdev.osuosl.org
Cc: line6linux-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] line6: Use kmemdup rather than duplicating its implementation
Date: Mon,  3 Dec 2012 14:20:25 +0100
Message-Id: <1354540825-17735-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

staging: line6: driver.c
 The semantic patch that makes this output is available
 in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/line6/driver.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index f5c19b2..e1d6241 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -331,14 +331,13 @@ int line6_version_request_async(struct usb_line6 *line6)
 	char *buffer;
 	int retval;
 
-	buffer = kmalloc(sizeof(line6_request_version), GFP_ATOMIC);
+	buffer = kmemdup(line6_request_version,
+			sizeof(line6_request_version), GFP_ATOMIC);
 	if (buffer == NULL) {
 		dev_err(line6->ifcdev, "Out of memory");
 		return -ENOMEM;
 	}
 
-	memcpy(buffer, line6_request_version, sizeof(line6_request_version));
-
 	retval = line6_send_raw_message_async(line6, buffer,
 					      sizeof(line6_request_version));
 	kfree(buffer);
-- 
1.7.10.4

