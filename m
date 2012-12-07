Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423541Ab2LGA7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:59:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44852 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423523Ab2LGA7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 10/27] iwlwifi: fix the basic CCK rates calculation
Date: Thu,  6 Dec 2012 16:58:54 -0800
Message-Id: <20121207005828.556393847@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5edd0b946a0afeb1d0364a3654328b046fb818a2 upstream.

Fix a copy paste error in iwl_calc_basic_rates which leads
to a wrong calculation of CCK basic rates.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/rxon.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1012,12 +1012,12 @@ static void iwl_calc_basic_rates(struct
 	 * As a consequence, it's not as complicated as it sounds, just add
 	 * any lower rates to the ACK rate bitmap.
 	 */
-	if (IWL_RATE_11M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_11M_MASK >> IWL_FIRST_CCK_RATE;
-	if (IWL_RATE_5M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_5M_MASK >> IWL_FIRST_CCK_RATE;
-	if (IWL_RATE_2M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_2M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_11M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_11M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_5M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_5M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_2M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_2M_MASK >> IWL_FIRST_CCK_RATE;
 	/* 1M already there or needed so always add */
 	cck |= IWL_RATE_1M_MASK >> IWL_FIRST_CCK_RATE;
 


