Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156Ab1KJDtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:49:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966012Ab1KJDtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.036137191@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [253/264] ath9k_hw: Fix regression of register offset for AR9003 chips
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 52d6d4ef5e6d1517688e27c11c01ab303ec681dd upstream.

My recent commits (3782c69d, 324c74a) introduced regression
for register offset selection that based on the macversion.
Not using parentheses in proper manner for ternary operator
leads to select wrong offset for the registers.

This issue was observed with AR9462 chip that immediate disconnect
after the association with the following message

ieee80211 phy3: wlan0: Failed to send nullfunc to AP 00:23:69:12:ea:47
after 500ms, disconnecting.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -572,12 +572,12 @@
 
 #define AR_PHY_TXGAIN_TABLE      (AR_SM_BASE + 0x300)
 
-#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3c8 : 0x448)
-#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3c4 : 0x440)
-#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3f0 : 0x48c)
+#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3c8 : 0x448))
+#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3c4 : 0x440))
+#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3f0 : 0x48c))
 #define AR_PHY_TX_IQCAL_CORR_COEFF_B0(_i)    (AR_SM_BASE + \
 					     (AR_SREV_9485(ah) ? \
 					      0x3d0 : 0x450) + ((_i) << 2))


