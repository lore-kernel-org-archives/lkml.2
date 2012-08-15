Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2HOU1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:27:24 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62861 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab2HOTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Manual Munz <freifunk@somakoma.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 044/165] b43: Fix beacon problem in ad-hoc mode
Date: Wed, 15 Aug 2012 15:46:28 -0400
Message-ID: <1345060109-9187-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manual Munz <freifunk@somakoma.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8c23516fbb209ccf8f8c36268311c721faff29ee upstream.

In ad-hoc mode, driver b43 does not issue beacons.

Signed-off-by: Manual Munz <freifunk@somakoma.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/b43/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9a374ef..1f230b8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1538,7 +1538,8 @@ static void handle_irq_beacon(struct b43_wldev *dev)
 	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
-- 
1.7.12.rc2

