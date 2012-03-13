Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab2CMAVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:21:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:46857 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2CMASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 029/196] ath9k: fix a chip wakeup related crash in ath9k_start
Date: Mon, 12 Mar 2012 20:12:37 -0400
Message-Id: <1331597724-31358-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f62d816fc4324afbb7cf90110c70b6a14139b225 upstream.

When the chip is still asleep when ath9k_start is called,
ath9k_hw_configpcipowersave can trigger a data bus error.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 115e1ae..b9585fb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1090,6 +1090,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
 
+	ath9k_ps_wakeup(sc);
+
 	mutex_lock(&sc->mutex);
 
 	if (ath9k_wiphy_started(sc)) {
@@ -1199,6 +1201,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
+	ath9k_ps_restore(sc);
+
 	return r;
 }
 
-- 
1.7.9.3

