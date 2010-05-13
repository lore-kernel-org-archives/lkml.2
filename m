Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab0EMQmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:42:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31925 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0EMQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:42:21 -0400
Date: Thu, 13 May 2010 09:41:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] usb: fix functionfs for CONFIG_NET disabled
Message-Id: <20100513094112.86acf7c2.randy.dunlap@oracle.com>
In-Reply-To: <20100513171540.54b308d0.sfr@canb.auug.org.au>
References: <20100513171540.54b308d0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BEC2BE2.0002:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix functionfs build to handle CONFIG_NET not enabled, to prevent
these build errors:

ERROR: "netif_carrier_on" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "netif_carrier_off" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_realloc_headroom" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_trim" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "netif_rx" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "alloc_etherdev_mq" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "ethtool_op_get_link" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "free_netdev" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "register_netdev" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_push" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_pull" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "dev_kfree_skb_any" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_queue_tail" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "__alloc_skb" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "eth_type_trans" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "eth_validate_addr" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_dequeue" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "unregister_netdev" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "__netif_schedule" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "skb_put" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "eth_mac_addr" [drivers/usb/gadget/g_ffs.ko] undefined!
ERROR: "dev_get_stats" [drivers/usb/gadget/g_ffs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20100513.orig/drivers/usb/gadget/Kconfig
+++ linux-next-20100513/drivers/usb/gadget/Kconfig
@@ -726,7 +726,7 @@ config USB_FUNCTIONFS
 
 config USB_FUNCTIONFS_ETH
 	bool "Include CDC ECM (Ethernet) function"
-	depends on USB_FUNCTIONFS
+	depends on USB_FUNCTIONFS && NET
 	help
 	  Include an CDC ECM (Ethernet) funcion in the CDC ECM (Funcion)
 	  Filesystem.  If you also say "y" to the RNDIS query below the
@@ -734,7 +734,7 @@ config USB_FUNCTIONFS_ETH
 
 config USB_FUNCTIONFS_RNDIS
 	bool "Include RNDIS (Ethernet) function"
-	depends on USB_FUNCTIONFS
+	depends on USB_FUNCTIONFS && NET
 	help
 	  Include an RNDIS (Ethernet) funcion in the Funcion Filesystem.
 	  If you also say "y" to the CDC ECM query above the gadget will
