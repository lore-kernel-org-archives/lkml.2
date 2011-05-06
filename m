Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1EFArl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:47:41 -0400
Received: from kroah.org ([198.145.64.141]:37023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab1EFAZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002213.947048621@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [089/143] rt2x00: Centralize setting of extra TX headroom requested by rt2x00.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit e6218cc47bd54710dc523e8c983ceddba625e3ae upstream.

Set the value of extra_tx_headroom in a central place, rather than in each
of the drivers. This is preparatory for taking alignment space into account
in the TX headroom requested by rt2x00.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Adjust for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    3 +--
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 +--
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 +++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 8 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1431,7 +1431,6 @@ static int rt2400pci_probe_hw_mode(struc
 			       IEEE80211_HW_SIGNAL_DBM |
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1628,6 +1627,7 @@ static const struct rt2x00_ops rt2400pci
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = 0,
 	.rx		= &rt2400pci_queue_rx,
 	.tx		= &rt2400pci_queue_tx,
 	.bcn		= &rt2400pci_queue_bcn,
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1732,8 +1732,6 @@ static int rt2500pci_probe_hw_mode(struc
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = 0;
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
@@ -1927,6 +1925,7 @@ static const struct rt2x00_ops rt2500pci
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = 0,
 	.rx		= &rt2500pci_queue_rx,
 	.tx		= &rt2500pci_queue_tx,
 	.bcn		= &rt2500pci_queue_bcn,
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1788,8 +1788,6 @@ static int rt2500usb_probe_hw_mode(struc
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
@@ -1962,6 +1960,7 @@ static const struct rt2x00_ops rt2500usb
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = TXD_DESC_SIZE,
 	.rx		= &rt2500usb_queue_rx,
 	.tx		= &rt2500usb_queue_tx,
 	.bcn		= &rt2500usb_queue_bcn,
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2509,7 +2509,6 @@ static int rt2800usb_probe_hw_mode(struc
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2858,6 +2857,7 @@ static const struct rt2x00_ops rt2800usb
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
 	.rx		= &rt2800usb_queue_rx,
 	.tx		= &rt2800usb_queue_tx,
 	.bcn		= &rt2800usb_queue_bcn,
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -579,6 +579,7 @@ struct rt2x00_ops {
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
+	const unsigned int extra_tx_headroom;
 	const struct data_queue_desc *rx;
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -684,6 +684,11 @@ static int rt2x00lib_probe_hw(struct rt2
 	rt2x00dev->hw->queues = rt2x00dev->ops->tx_queues;
 
 	/*
+	 * Initialize extra TX headroom required.
+	 */
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2550,7 +2550,6 @@ static int rt61pci_probe_hw_mode(struct
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2798,6 +2797,7 @@ static const struct rt2x00_ops rt61pci_o
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = 0,
 	.rx		= &rt61pci_queue_rx,
 	.tx		= &rt61pci_queue_tx,
 	.bcn		= &rt61pci_queue_bcn,
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2068,7 +2068,6 @@ static int rt73usb_probe_hw_mode(struct
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2311,6 +2310,7 @@ static const struct rt2x00_ops rt73usb_o
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
 	.tx_queues	= NUM_TX_QUEUES,
+	.extra_tx_headroom = TXD_DESC_SIZE,
 	.rx		= &rt73usb_queue_rx,
 	.tx		= &rt73usb_queue_tx,
 	.bcn		= &rt73usb_queue_bcn,


