Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2JNOn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46678 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932298Ab2JNOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:52 -0400
Message-Id: <20121014143541.719122603@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <c_manoha@qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 058/147] ath9k: Disable ASPM only for AR9285
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qualcomm.com>

commit 046b6802c8d3c8a57448485513bf7291633e0fa3 upstream.

Currently, ASPM is disabled for all WLAN+BT combo chipsets
when BTCOEX is enabled. This is incorrect since the workaround
is required only for WB195, which is a AR9285+AR3011 combo
solution. Fix this by checking for the HW version when enabling
the workaround.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Tested-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: ath9k_hw_get_btcoex_scheme() function is missing]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -122,8 +122,9 @@ static void ath_pci_aspm_init(struct ath
 	if (!parent)
 		return;
 
-	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
-		/* Bluetooth coexistance requires disabling ASPM. */
+	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
+	    (AR_SREV_9285(ah))) {
+		/* Bluetooth coexistance requires disabling ASPM for AR9285. */
 		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);


