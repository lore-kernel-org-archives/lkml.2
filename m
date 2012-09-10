Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2IJQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:04:15 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51739 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757998Ab2IJQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:04:11 -0400
Message-ID: <504E0F5D.7040803@xenotime.net>
Date: Mon, 10 Sep 2012 09:03:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mike Lockwood <lockwood@android.com>
Subject: [PATCH -next] staging: fix ccg build when NET is not enabled
References: <20120910172407.c5ad953c008165fcd862bd3c@canb.auug.org.au>
In-Reply-To: <20120910172407.c5ad953c008165fcd862bd3c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors in ccg when CONFIG_NET is not enabled
by adding "depends on NET":

ERROR: "netif_carrier_on" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "netif_carrier_off" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_realloc_headroom" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_trim" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "netif_rx" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "ethtool_op_get_link" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "free_netdev" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "register_netdev" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_push" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_pull" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "dev_kfree_skb_any" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_queue_tail" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "__alloc_skb" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "eth_type_trans" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "eth_validate_addr" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_dequeue" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "unregister_netdev" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "__netif_schedule" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "skb_put" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "eth_mac_addr" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "dev_get_stats" [drivers/staging/ccg/g_ccg.ko] undefined!
ERROR: "alloc_etherdev_mqs" [drivers/staging/ccg/g_ccg.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Mike Lockwood <lockwood@android.com>
---
 drivers/staging/ccg/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120910.orig/drivers/staging/ccg/Kconfig
+++ linux-next-20120910/drivers/staging/ccg/Kconfig
@@ -2,7 +2,7 @@ if USB_GADGET
 
 config USB_G_CCG
 	tristate "Configurable Composite Gadget (STAGING)"
-	depends on STAGING && BLOCK && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
+	depends on STAGING && BLOCK && NET && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
 	help
 	  The Configurable Composite Gadget supports multiple USB
 	  functions: acm, mass storage, rndis and FunctionFS.
