Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2L1TUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:20:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55656 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932431Ab2L1TTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:43 -0500
Message-Id: <20121228190337.870533255@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 038/173] ath9k_hw: Enable hw PLL power save for AR9462
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 1680260226a8fd2aab590319da83ad8e610da9bd upstream.

This reduced the power consumption to half in full and network sleep.

Cc: Paul Stewart <pstew@chromium.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - INIT_INI_ARRAY macro requires an explicit size argument
 - Remove the now-redundant macro PCIE_PLL_ON_CREQ_DIS_L1_2P0]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -34,9 +34,6 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-#define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
-		ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-
 #define AR9462_BB_CTX_COEFJ(x)	\
 		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
 
@@ -369,13 +366,13 @@ static void ar9003_hw_init_mode_regs(str
 
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
 
 		/* Fast clock modal settings */


