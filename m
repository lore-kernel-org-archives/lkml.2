Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1DZQTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:19:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59111 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1DZQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:19:05 -0400
Date: Tue, 26 Apr 2011 09:18:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Pavan Savoy <pavan_savoy@ti.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de
Subject: [PATCH -next] misc: fix ti-st build issues
Message-Id: <20110426091851.87edcef3.randy.dunlap@oracle.com>
In-Reply-To: <20110426202605.c66ce0ea.sfr@canb.auug.org.au>
References: <20110426202605.c66ce0ea.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DB6F071.0092:SCFMA4539811,ss=1,fgs=0
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
---
 drivers/misc/ti-st/Kconfig  |    1 +
 drivers/misc/ti-st/st_kim.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20110426.orig/drivers/misc/ti-st/Kconfig
+++ linux-next-20110426/drivers/misc/ti-st/Kconfig
@@ -5,6 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
+	depends on NET && GPIOLIB
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
--- linux-next-20110426.orig/drivers/misc/ti-st/st_kim.c
+++ linux-next-20110426/drivers/misc/ti-st/st_kim.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched.h>
+#include <linux/sysfs.h>
 #include <linux/tty.h>
 
 #include <linux/skbuff.h>
