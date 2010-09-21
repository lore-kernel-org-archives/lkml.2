Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0IUQhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:37:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0IUQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:37:29 -0400
Date: Tue, 21 Sep 2010 09:35:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, ohee Ko <noheek@broadcom.com>
Subject: [PATCH -next] staging: brcm80211 depends on MAC80211
Message-Id: <20100921093549.a39a2a8d.randy.dunlap@oracle.com>
In-Reply-To: <20100921170055.4512dd19.sfr@canb.auug.org.au>
References: <20100921170055.4512dd19.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix brcm890211 build: it should depend on MAC80211.
MAC80211 depends on CFG80211, which takes care of <regulatory_hint>
below.

ERROR: "ieee80211_rx_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_unregister_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_stop_queues" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_wake_queues" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_stop_tx_ba_cb_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_tx_status_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_register_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "regulatory_hint" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_alloc_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_free_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
ERROR: "ieee80211_start_tx_ba_cb_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Nohee Ko <noheek@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100921.orig/drivers/staging/brcm80211/Kconfig
+++ linux-next-20100921/drivers/staging/brcm80211/Kconfig
@@ -1,6 +1,6 @@
 menuconfig BRCM80211
 	tristate "Broadcom 802.11 WLAN driver for bcm43xx chips"
-	depends on PCI && WLAN
+	depends on PCI && WLAN && MAC80211
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	default N
