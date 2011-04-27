Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1D0Odp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:33:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33403 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1D0Odn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=EMJv58IpK70L+GEVzY2dsLu8Lm9/9jD+1D5eZTk9Cv/YXeF8KRxBcFy7jMM+FJxy5q
         K5CNVvzk8mz0WexzoXQeDuc/7N0S0ZE/EfQLbfKcFsutZcygeBt43ZOO6MjdRze7m9EX
         KZb/dNe64jIbDHTU5Swt0YIFY4QliHeFjGRvc=
From: Rabin Vincent <rabin@rab.in>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] echi: remove structure packing from ehci_def
Date: Wed, 27 Apr 2011 20:04:01 +0530
Message-Id: <1303914841-6379-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Arnd Bergmann, in include/linux/usb/ehci_def.h, struct
ehci_caps is defined with __attribute__((packed)) for no good reason,
and this triggers undefined behaviour when using ARM's readl() on
pointers to elements of this structure:

http://lkml.kernel.org/r/201102021700.20683.arnd@arndb.de

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/usb/ehci_def.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index e49dfd4..7879943 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -52,7 +52,7 @@ struct ehci_caps {
 #define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
 #define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
 	u8		portroute[8];	 /* nibbles for routing - offset 0xC */
-} __attribute__ ((packed));
+};
 
 
 /* Section 2.3 Host Controller Operational Registers */
@@ -150,7 +150,7 @@ struct ehci_regs {
 #define PORT_CSC	(1<<1)		/* connect status change */
 #define PORT_CONNECT	(1<<0)		/* device connected */
 #define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
-} __attribute__ ((packed));
+};
 
 #define USBMODE		0x68		/* USB Device mode */
 #define USBMODE_SDIS	(1<<3)		/* Stream disable */
@@ -194,7 +194,7 @@ struct ehci_dbg_port {
 	u32	data47;
 	u32	address;
 #define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
-} __attribute__ ((packed));
+};
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
 #include <linux/init.h>
-- 
1.7.4.1

