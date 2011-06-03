Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1FCDYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 23:24:15 -0400
Received: from mta21.charter.net ([216.33.127.81]:64404 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FCDYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 23:24:13 -0400
X-Greylist: delayed 4333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jun 2011 23:24:13 EDT
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=GctcgdcX2JkA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=ktzgDYZ5B3lAIbh_B8IA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 5/5 v2] iwlegacy: add missing null check
Date: Thu,  2 Jun 2011 22:24:06 -0500
Message-Id: <1307071446-28730-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110603030746.GA4834@joana>
References: <20110603030746.GA4834@joana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lq_sta has other null checks in this function.
assuming they are correct, this additional null check
should be added too.

Incorporating suggestion from Gustavo Padovan.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 24d1499..9b65153 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -2275,6 +2275,9 @@ iwl4965_rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
+	if (!lq_sta)
+		return;
+
 	rate_idx  = lq_sta->last_txrate_idx;
 
 	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
-- 
1.7.2.5

