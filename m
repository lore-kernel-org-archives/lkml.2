Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab1FPMMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:12:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40344 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300Ab1FPMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:12:49 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 08:12:49 EDT
Date: Thu, 16 Jun 2011 14:12:47 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Duncan Sands <duncan.sands@free.fr>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 07/11] drivers/usb/atm: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <98558b2a3dbb8b14a3bc90e0a73ca7d61dd10a53.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/usb/atm/usbatm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 989e16e..d3448ca 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -81,6 +81,7 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/kthread.h>
+#include <linux/ratelimit.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -668,8 +669,7 @@ static int usbatm_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	/* racy disconnection check - fine */
 	if (!instance || instance->disconnected) {
 #ifdef DEBUG
-		if (printk_ratelimit())
-			printk(KERN_DEBUG "%s: %s!\n", __func__, instance ? "disconnected" : "NULL instance");
+		printk_ratelimited(KERN_DEBUG "%s: %s!\n", __func__, instance ? "disconnected" : "NULL instance");
 #endif
 		err = -ENODEV;
 		goto fail;
-- 
1.7.4.1

