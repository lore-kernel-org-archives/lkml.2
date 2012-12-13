Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2LMOvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:51:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2LMOGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 088/241] wireless: allow 40 MHz on world roaming channels 12/13
Date: Thu, 13 Dec 2012 11:57:33 -0200
Message-Id: <1355407206-17100-89-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 43c771a1963ab461a2f194e3c97fded1d5fe262f upstream.

When in world roaming mode, allow 40 MHz to be used
on channels 12 and 13 so that an AP that is, e.g.,
using HT40+ on channel 9 (in the UK) can be used.

Reported-by: Eddie Chapman <eddie@ehuk.net>
Tested-by: Eddie Chapman <eddie@ehuk.net>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/wireless/reg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b01449f..4dc8347 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -134,9 +134,8 @@ static const struct ieee80211_regdomain world_regdom = {
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-		/* IEEE 802.11b/g, channels 12..13. No HT40
-		 * channel fits here. */
-		REG_RULE(2467-10, 2472+10, 20, 6, 20,
+		/* IEEE 802.11b/g, channels 12..13. */
+		REG_RULE(2467-10, 2472+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
 		/* IEEE 802.11 channel 14 - Only JP enables
-- 
1.7.9.5

