Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2KVVqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:46:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:49605 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eddie Chapman <eddie@ehuk.net>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 030/171] wireless: allow 40 MHz on world roaming channels 12/13
Date: Wed, 21 Nov 2012 16:39:36 -0800
Message-Id: <20121122004036.396672191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -134,9 +134,8 @@ static const struct ieee80211_regdomain
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


