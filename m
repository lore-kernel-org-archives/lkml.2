Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab2JDVZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:25:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab2JDVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:25:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 33/52] ath9k: Disable ASPM only for AR9285
Date: Thu,  4 Oct 2012 14:21:24 -0700
Message-Id: <20121004210639.493048786@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -122,8 +122,9 @@ static void ath_pci_aspm_init(struct ath
 	if (!parent)
 		return;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		/* Bluetooth coexistance requires disabling ASPM. */
+	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
+	    (AR_SREV_9285(ah))) {
+		/* Bluetooth coexistance requires disabling ASPM for AR9285. */
 		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);


