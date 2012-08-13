Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2HMW1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:27:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43626 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2HMWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:16:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Bentley <Tim.Bentley@Gmail.com>,
        Felix Bitterli <felixb@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/65] ath9k: Add PID/VID support for AR1111
Date: Mon, 13 Aug 2012 15:14:11 -0700
Message-Id: <20120813221417.350704797@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -676,6 +676,7 @@ int ath9k_hw_init(struct ath_hw *ah)
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
 


