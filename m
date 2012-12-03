Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2LCO51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:57:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2LCOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:47 -0500
Message-Id: <20121203143148.127286902@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Eddie Chapman <eddie@ehuk.net>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [ 09/89] wireless: allow 40 MHz on world roaming channels 12/13
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/reg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bcc7d7e..b75756b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -141,9 +141,8 @@ static const struct ieee80211_regdomain world_regdom = {
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


