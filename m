Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1EALHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 07:07:41 -0400
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:42748
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753268Ab1EALHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 07:07:39 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 May 2011 07:07:38 EDT
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: dgiagio@gmail.com, dborca@yahoo.com, davem@davemloft.net,
        pmcenery@gmail.com, david.hill@ubisoft.com,
        linux-usb@vger.kernel.org (open list:USB SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH] ipheth.c: Enable IP header alignment
Date: Sun,  1 May 2011 13:00:55 +0200
Message-Id: <1304247656-21086-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Hill <david.hill@ubisoft.com>

Since commit ea812ca1b06113597adcd8e70c0f84a413d97544, NET_IP_ALIGN changed from
2 to 0. Some people have reported that tethering stopped working and David Hill
submited a patch that seems to fix the problem.

I have no more an iPhone device to test it, so it is only compile-tested.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/net/usb/ipheth.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 7d42f9a..711346b 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -54,6 +54,9 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 
+#undef  NET_IP_ALIGN
+#define NET_IP_ALIGN 2
+
 #define USB_VENDOR_APPLE        0x05ac
 #define USB_PRODUCT_IPHONE      0x1290
 #define USB_PRODUCT_IPHONE_3G   0x1292
-- 
1.7.5

