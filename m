Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0IDXHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:07:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57452 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0IDXHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=QznQvZPSxFy6ZiAqIVX0qHOQrGoIxFcq47+tcbCR//ePdQoJK2yJ+FyYz0QJtQdlEV
         n5NnzLUCAULz3zNn0PSYeTvnsq0JG/A4xGkhpmDZPyVLFvpDWtVXhhwLm35KttFAwoFb
         /NC9ypP5E271mevueFpZ7Bgy9RaUPUbPTh//o=
Subject: [PATCH 2/4] staging: xgifb: Add compilation conditionals
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Arnaud Patard <apatard@mandriva.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Huang Weiyi <weiyi.huang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 19:07:48 -0400
Message-ID: <1283641668.9641.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main.h    |    2 ++
 drivers/staging/xgifb/XGI_main_26.c |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 72448e8..93837f3 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -345,7 +345,9 @@ static int XGIfb_userom = 0;
 static int XGIfb_registered;
 static int XGIfb_tvmode = 0;
 static int XGIfb_mem = 0;
+#ifndef MODULE
 static int XGIfb_pdc = 0;
+#endif
 static int enable_dstn = 0;
 static int XGIfb_ypan = -1;
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3c80191..2cba4c4 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -843,6 +843,7 @@ static int XGIfb_validate_mode(int myindex)
 
 }
 
+#ifndef MODULE
 static void XGIfb_search_crt2type(const char *name)
 {
 	int i = 0;
@@ -861,7 +862,9 @@ static void XGIfb_search_crt2type(const char *name)
 	if(XGIfb_crt2type < 0)
 		printk(KERN_INFO "XGIfb: Invalid CRT2 type: %s\n", name);
 }
+#endif
 
+#ifndef MODULE
 static void XGIfb_search_queuemode(const char *name)
 {
 	int i = 0;
@@ -879,6 +882,7 @@ static void XGIfb_search_queuemode(const char *name)
 	if (XGIfb_queuemode < 0)
 		printk(KERN_INFO "XGIfb: Invalid queuemode type: %s\n", name);
 }
+#endif
 
 static u8 XGIfb_search_refresh_rate(unsigned int rate)
 {
@@ -926,6 +930,7 @@ static u8 XGIfb_search_refresh_rate(unsigned int rate)
 	}
 }
 
+#ifndef MODULE
 static void XGIfb_search_tvstd(const char *name)
 {
 	int i = 0;
@@ -941,6 +946,7 @@ static void XGIfb_search_tvstd(const char *name)
 		i++;
 	}
 }
+#endif
 
 static unsigned char XGIfb_bridgeisslave(void)
 {
-- 
1.7.0.4



