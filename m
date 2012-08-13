Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2HMUXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:23:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2HMUXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Bentley <Tim.Bentley@Gmail.com>,
        Felix Bitterli <felixb@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 41/82] ath9k: Add PID/VID support for AR1111
Date: Mon, 13 Aug 2012 13:19:17 -0700
Message-Id: <20120813201750.043238302@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit d4e5979c0da95791aa717c18e162540c7a596360 upstream.

AR1111 is same as AR9485. The h/w
difference between them is quite insignificant,
Felix suggests only very few baseband features
may not be available in AR1111. The h/w code for
AR9485 is already present, so AR1111 should
work fine with the addition of its PID/VID.

Reported-by: Tim Bentley <Tim.Bentley@Gmail.com>
Cc: Felix Bitterli <felixb@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Tested-by: Tim Bentley <Tim.Bentley@Gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c  |    1 +
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -740,6 +740,7 @@ int ath9k_hw_init(struct ath_hw *ah)
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
@@ -37,6 +37,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_i
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
+	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ 0 }
 };
 


