Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882Ab1ETAQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:16:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49906 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934835Ab1ETALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:52 -0400
X-Sasl-enc: TAJU0IadBonale8Z0i+zIf+URh86GtCdWhSE2BFVMKNl 1305850311
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavan Savoy <pavan_savoy@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/44] misc: fix ti-st build issues
Date: Thu, 19 May 2011 17:10:45 -0700
Message-Id: <1305850262-9575-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

st_drv uses skb*() interfaces, so it should depend on NET.
It also uses GPIO interfaces, so it should depend on GPIOLIB.

st_kim.c uses syss_*() calls, so it should #include
<linux/sysfs.h>.

Fixes these observed build errors:
ERROR: "skb_queue_purge" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "skb_pull" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "skb_queue_tail" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "__alloc_skb" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "kfree_skb" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "skb_dequeue" [drivers/misc/ti-st/st_drv.ko] undefined!
ERROR: "skb_put" [drivers/misc/ti-st/st_drv.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/Kconfig  |    1 +
 drivers/misc/ti-st/st_kim.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index 7c3e106..abb5de1 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,6 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
+	depends on NET && GPIOLIB
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index b4488c8..5da93ee 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched.h>
+#include <linux/sysfs.h>
 #include <linux/tty.h>
 
 #include <linux/skbuff.h>
-- 
1.7.4.2

