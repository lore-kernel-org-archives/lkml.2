Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2ACWjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2ACWjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.435800462@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Philipp Dreimann <philipp@dreimann.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [17/75] rtl8192{ce,cu,de,se}: avoid problems because of possible ERFOFF -> ERFSLEEP transition
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Dreimann <philipp@dreimann.net>

commit 91ddff8a3b9cc7ac2252aca138220939cf6cc2cf upstream.

In drivers rtl8192ce, rtl8192cu, rtl8192se, and rtl8192de, break
statements would allow ppsc->rfpwr_state to be changed to ERFSLEEP
even though the device is actually in ERFOFF.

Signed-off-by: Philipp Dreimann <philipp@dreimann.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -569,7 +569,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 		}
 	case ERFSLEEP:{
 			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
 			for (queue_id = 0, i = 0;
 			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
 				ring = &pcipriv->dev.tx_ring[queue_id];
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -548,7 +548,7 @@ static bool _rtl92cu_phy_set_rf_power_st
 		break;
 	case ERFSLEEP:
 		if (ppsc->rfpwr_state == ERFOFF)
-			break;
+			return false;
 		for (queue_id = 0, i = 0;
 		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
 			ring = &pcipriv->dev.tx_ring[queue_id];
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3374,7 +3374,7 @@ bool rtl92d_phy_set_rf_power_state(struc
 		break;
 	case ERFSLEEP:
 		if (ppsc->rfpwr_state == ERFOFF)
-			break;
+			return false;
 
 		for (queue_id = 0, i = 0;
 		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -602,7 +602,7 @@ bool rtl92s_phy_set_rf_power_state(struc
 		}
 	case ERFSLEEP:
 			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
 
 			for (queue_id = 0, i = 0;
 			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {


