Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1ISGzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:55:23 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1409 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1ISGzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:55:21 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: "Dmitry Kravkov" <dmitry@broadcom.com>
Reply-to: dmitry@broadcom.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yaniv Rosner" <yaniv.rosner@broadcom.com>,
        "Eilon Greenstein" <eilong@broadcom.com>,
        "Joe Perches" <joe@perches.com>
In-Reply-To: <20110919145103.6c3e73edf51599eaa703294a@canb.auug.org.au>
References: <20110919145103.6c3e73edf51599eaa703294a@canb.auug.org.au>
Organization: BROADCOM
Date: Mon, 19 Sep 2011 09:55:18 +0300
Message-ID: <1316415318.26848.4.camel@lb-tlvb-dmitry>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2
X-WSS-ID: 626837273KO21012780-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-18 at 21:51 -0700, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c between commit
> c482e6c06461 ("bnx2x: Fix ETS bandwidth") from Linus' tree and commit
> 94f05b0f60de ("bnx2x: Coalesce pr_cont uses and fix DP typos") from the
> net tree.
> 
> The former removes the code cleaned up by the latter, so I used the
> former (see below).

Can you use this one instead?
Contains spell fixes and some formatting.

Signed-off-by: Dmitry Kravkov <dmitry@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c |   34 ++++++++-------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 8e9b87b..733ace0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -850,32 +850,24 @@ static int bnx2x_ets_e3b0_get_total_bw(
 
 	*total_bw = 0 ;
 	/* Calculate total BW requested */
-	for (cos_idx = 0; cos_idx < ets_params->num_of_cos; cos_idx++) {
-		if (bnx2x_cos_state_bw == ets_params->cos[cos_idx].state) {
+	for (cos_idx = 0; cos_idx < ets_params->num_of_cos; cos_idx++)
+		if (bnx2x_cos_state_bw == ets_params->cos[cos_idx].state)
+			*total_bw +=
+				ets_params->cos[cos_idx].params.bw_params.bw;
 
-			if (0 == ets_params->cos[cos_idx].params.bw_params.bw) {
-				DP(NETIF_MSG_LINK,
-				   "bnx2x_ets_E3B0_config BW was set to 0\n");
-			return -EINVAL;
-		}
-		*total_bw +=
-		    ets_params->cos[cos_idx].params.bw_params.bw;
-	    }
-	}
-
-	/*Check taotl BW is valid */
+	/* Check total BW is valid */
 	if ((100 != *total_bw) || (0 == *total_bw)) {
 		if (0 == *total_bw) {
-			DP(NETIF_MSG_LINK,
-			   "bnx2x_ets_E3B0_config toatl BW shouldn't be 0\n");
+			DP(NETIF_MSG_LINK, "bnx2x_ets_E3B0_config total BW"
+					   "shouldn't be 0\n");
 			return -EINVAL;
 		}
-		DP(NETIF_MSG_LINK,
-		   "bnx2x_ets_E3B0_config toatl BW should be 100\n");
-		/**
-		*   We can handle a case whre the BW isn't 100 this can happen
-		*   if the TC are joined.
-		*/
+		DP(NETIF_MSG_LINK, "bnx2x_ets_E3B0_config total BW should be"
+				   "100\n");
+		/*
+		 * We can handle a case where the BW isn't 100 this can happen
+		 * if the TC are joined.
+		 */
 	}
 	return 0;
 }
-- 
1.7.2.2




