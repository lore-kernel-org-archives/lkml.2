Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1LWGjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 01:39:16 -0500
Received: from asix.com.tw ([113.196.140.82]:50594 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1LWGjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 01:39:15 -0500
From: "allan" <allan@asix.com.tw>
To: <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Freddy Xin'" <freddy@asix.com.tw>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Eugene'" <elubarsky@gmail.com>,
        "=?utf-8?Q?'ASIX_Louis_=5B=E8=98=87=E5=A8=81=E9=99=B8=5D'?=" 
	<louis@asix.com.tw>
Subject: [PATCH v2] drivers/net/usb/asix: fixed asix_get_wol reported wrong wol status issue
Date: Fri, 23 Dec 2011 14:38:51 +0800
Message-ID: <005001ccc13d$8c9850e0$a5c8f2a0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AczBPYhAF7QIiFH4T+iduZtxrZDECw==
Importance: High
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the asix_get_wol() routine reported wrong wol status issue. 

Signed-off-by: Allan Chou <allan@asix.com.tw>
Tested-by: Eugene <elubarsky@gmail.com>; Allan Chou <allan@asix.com.tw>
---
This fix had been verified on x86 Linux kernel 3.0.0-12-generic system with AX88772A/AX88772/Belkin AX88178 USB dongles, and the wol function works fine (can be waked up by receiving the magic packets).

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c	2011-12-15 14:01:49.000000000 +0800
+++ b/drivers/net/usb/asix.c	2011-12-22 18:20:39.000000000 +0800
@@ -36,7 +36,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION "08-Nov-2011"
+#define DRIVER_VERSION "22-Dec-2011"
 #define DRIVER_NAME "asix"
 
 /* ASIX AX8817X based USB 2.0 Ethernet Devices */
@@ -689,6 +689,10 @@ asix_get_wol(struct net_device *net, str
 	}
 	wolinfo->supported = WAKE_PHY | WAKE_MAGIC;
 	wolinfo->wolopts = 0;
+	if (opt & AX_MONITOR_LINK)
+		wolinfo->wolopts |= WAKE_PHY;
+	if (opt & AX_MONITOR_MAGIC)
+		wolinfo->wolopts |= WAKE_MAGIC;
 }
 
 static int



