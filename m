Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab0FEQFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:05:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35602 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637Ab0FEQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HK1h6JZIzLFNmbQIHL+L5DnPS8W0nuXodu8wo0WSovcP90BBy/0BQ+QkF92jlLXYHc
         0Waj0+iNLEL3csQAlV5Ami5iS0CVvFzYJYCY5IsXTJCvCzsgJTF06gxG6T98QHqXiHfz
         ny0J9wQyZ4TlN4y+lqu1wceAGv5zQrh3XWJVY=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 7/7] Fixup compile warnings on x86-64.
Date: Sat,  5 Jun 2010 18:04:25 +0200
Message-Id: <1275753865-5435-8-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI_main.h    |    2 ++
 drivers/staging/xgifb/XGI_main_26.c |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 6d3a870..c05bade 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -348,7 +348,9 @@ static int XGIfb_userom = 0;
 static int XGIfb_registered;
 static int XGIfb_tvmode = 0;
 static int XGIfb_mem = 0;
+#ifndef MODULE
 static int XGIfb_pdc = 0;
+#endif
 static int enable_dstn = 0;
 static int XGIfb_ypan = -1;
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 0487a1e..05e4603 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -849,6 +849,7 @@ static int XGIfb_validate_mode(int myindex)
 
 }
 
+#ifndef MODULE
 static void XGIfb_search_crt2type(const char *name)
 {
 	int i = 0;
@@ -885,6 +886,7 @@ static void XGIfb_search_queuemode(const char *name)
 	if (XGIfb_queuemode < 0)
 		printk(KERN_INFO "XGIfb: Invalid queuemode type: %s\n", name);
 }
+#endif
 
 static u8 XGIfb_search_refresh_rate(unsigned int rate)
 {
@@ -932,6 +934,7 @@ static u8 XGIfb_search_refresh_rate(unsigned int rate)
 	}
 }
 
+#ifndef MODULE
 static void XGIfb_search_tvstd(const char *name)
 {
 	int i = 0;
@@ -947,6 +950,7 @@ static void XGIfb_search_tvstd(const char *name)
 		i++;
 	}
 }
+#endif
 
 static BOOLEAN XGIfb_bridgeisslave(void)
 {
@@ -3485,7 +3489,7 @@ int __devinit xgifb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		XGIfb_registered = 1;
 
-		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%x)\n", XGIFB_GET_INFO);
+		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%lx)\n", XGIFB_GET_INFO);
 
 /*		printk(KERN_INFO "XGIfb: 2D acceleration is %s, scrolling mode %s\n",
 		     XGIfb_accel ? "enabled" : "disabled",
@@ -3551,7 +3555,6 @@ module_init(xgifb_init);
 static char         *mode = NULL;
 static int          vesa = 0;
 static unsigned int rate = 0;
-static unsigned int crt1off = 1;
 static unsigned int mem = 0;
 static char         *forcecrt2type = NULL;
 static int          forcecrt1 = -1;
-- 
1.7.1

