Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2HOU2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:28:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:36716 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab2HOTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 045/165] wireless: Reset beacon_found while updating regulatory
Date: Wed, 15 Aug 2012 15:46:29 -0400
Message-ID: <1345060109-9187-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit aa3d7eef398dd4f29045e9889b817d5161afe03e upstream.

During the association, the regulatory is updated by country IE
that reaps the previously found beacons. The impact is that
after a STA disconnects *or* when for any reason a regulatory
domain change happens the beacon hint flag is not cleared
therefore preventing future beacon hints to be learned.
This is important as a regulatory domain change or a restore
of regulatory settings would set back the passive scan and no-ibss
flags on the channel. This is the right place to do this given that
it covers any regulatory domain change.

Reviewed-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 422da20..3ed40f7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1302,6 +1302,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		return;
 	}
 
+	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-- 
1.7.12.rc2

