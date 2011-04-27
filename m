Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab1D0PlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:41:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59163 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab1D0PlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VDmybYWxWQHDPccZhDlhCKDC4h6vMySpaZHVvV+wAuzmv8jsRhJ8Y3xbBqslHBnuI/
         KnDAZtwEMS96StWT0UpKErX59hNuAKSHy4sBtEu2TR2+uGKhoaPqChsjf17Y2UtSmS8i
         uizDiAMAxJMvOa5CmDR3isMUv1A4fcgZTU21A=
From: Rabin Vincent <rabin@rab.in>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv2] echi: remove structure packing from ehci_def
Date: Wed, 27 Apr 2011 21:07:28 +0530
Message-Id: <1303918648-7196-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4DB832FB.8030805@ru.mvista.com>
References: <4DB832FB.8030805@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Arnd Bergmann, in include/linux/usb/ehci_def.h, struct
ehci_caps is defined with __attribute__((packed)) for no good reason,
and this triggers undefined behaviour when using ARM's readl() on
pointers to elements of this structure:

http://lkml.kernel.org/r/201102021700.20683.arnd@arndb.de

The same problem exists with the other two structures in ehci_def.h too,
so remove the __attribute__((packed)) from all of them.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
v2: clarify that the problem is not just with struct ehci_caps

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

