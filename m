Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0IGPUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:20:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39857 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab0IGPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FHXH5D5p9+5aVEpTPBgBDKEAAkNhG9OpWSaiI0WlKMtJzZPxW12IGrR4dxsOduwJkr
         wCmmv7VV2TYfb68+g5+6+k0wNb85AKjpcgua6ikl4TfYhodcyfK6FsfA2HrVSAxC+N5v
         U4mInxKGDK9QAW+VeboA2IKX+LblWVKuJm124=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/2] staging: rtl8712: throw away custom hex_to_bin()
Date: Tue,  7 Sep 2010 18:20:21 +0300
Message-Id: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 1529239..eac049b 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -62,17 +62,6 @@ static const char * const iw_operation_mode[] = {
 	 "Monitor"
 };
 
-static int hex2num_i(char c)
-{
-	if (c >= '0' && c <= '9')
-		return c - '0';
-	if (c >= 'a' && c <= 'f')
-		return c - 'a' + 10;
-	if (c >= 'A' && c <= 'F')
-		return c - 'A' + 10;
-	return -1;
-}
-
 /**
  * hwaddr_aton - Convert ASCII string to MAC address
  * @txt: MAC address as a string (e.g., "00:11:22:33:44:55")
@@ -86,10 +75,10 @@ static int hwaddr_aton_i(const char *txt, u8 *addr)
 	for (i = 0; i < 6; i++) {
 		int a, b;
 
-		a = hex2num_i(*txt++);
+		a = hex_to_bin(*txt++);
 		if (a < 0)
 			return -1;
-		b = hex2num_i(*txt++);
+		b = hex_to_bin(*txt++);
 		if (b < 0)
 			return -1;
 		*addr++ = (a << 4) | b;
-- 
1.7.2.2

