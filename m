Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694Ab2HQD2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:28:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030689Ab2HQD1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:10 -0400
Message-Id: <20120817030246.717762955@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Felix Bitterli <felixb@qca.qualcomm.com>,
        Tim Bentley <Tim.Bentley@Gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 19/37] ath9k: Add PID/VID support for AR1111
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit d4e5979c0da95791aa717c18e162540c7a596360 upstream.

AR1111 is same as AR9485. The h/w
difference between them is quite insignificant,
Felix suggests only very few baseband features
may not be available in AR1111. The h/w code for
AR9485 is already present, so AR1111 should
work fine with the addition of its PID/VID.

Cc: Felix Bitterli <felixb@qca.qualcomm.com>
Reported-by: Tim Bentley <Tim.Bentley@Gmail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Tested-by: Tim Bentley <Tim.Bentley@Gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    1 +
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -674,6 +674,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9340:
 	case AR9300_DEVID_AR9580:
 	case AR9300_DEVID_AR9462:
+	case AR9485_DEVID_AR1111:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -48,6 +48,7 @@
 #define AR9300_DEVID_AR9580	0x0033
 #define AR9300_DEVID_AR9462	0x0034
 #define AR9300_DEVID_AR9330	0x0035
+#define AR9485_DEVID_AR1111	0x0037
 
 #define AR5416_AR9100_DEVID	0x000b
 
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -35,6 +35,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_i
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
+	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ 0 }
 };
 


