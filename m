Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1DEPAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:00:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab1DEO7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:42 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marc Singer <elf@buici.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH 33/34] usb/lh7a40x_udc: Drop __DATE__ usage
Date: Tue,  5 Apr 2011 16:59:20 +0200
Message-Id: <1302015561-21047-34-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Marc Singer <elf@buici.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/usb/gadget/lh7a40x_udc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index 6b58bd8..1e99e03 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -42,7 +42,6 @@
 #endif
 
 #define	DRIVER_DESC			"LH7A40x USB Device Controller"
-#define	DRIVER_VERSION		__DATE__
 
 #ifndef _BIT			/* FIXME - what happended to _BIT in 2.6.7bk18? */
 #define _BIT(x) (1<<(x))
@@ -209,10 +208,10 @@ udc_proc_read(char *page, char **start, off_t off, int count,
 	/* basic device status */
 	t = scnprintf(next, size,
 		      DRIVER_DESC "\n"
-		      "%s version: %s\n"
+		      "%s\n"
 		      "Gadget driver: %s\n"
 		      "Host: %s\n\n",
-		      driver_name, DRIVER_VERSION,
+		      driver_name,
 		      dev->driver ? dev->driver->driver.name : "(none)",
 		      is_usb_connected()? "full speed" : "disconnected");
 	size -= t;
@@ -2134,7 +2133,7 @@ static struct platform_driver udc_driver = {
 
 static int __init udc_init(void)
 {
-	DEBUG("%s: %s version %s\n", __func__, driver_name, DRIVER_VERSION);
+	DEBUG("%s: %s\n", __func__, driver_name);
 	return platform_driver_register(&udc_driver);
 }
 
-- 
1.7.4.1

