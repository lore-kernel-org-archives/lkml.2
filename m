Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1DMQYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:24:46 -0400
Received: from kroah.org ([198.145.64.141]:52831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab1DMQM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:45 2011
Message-Id: <20110413161045.313634085@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [27/71] ath9k: fix a chip wakeup related crash in ath9k_start
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f62d816fc4324afbb7cf90110c70b6a14139b225 upstream.

When the chip is still asleep when ath9k_start is called,
ath9k_hw_configpcipowersave can trigger a data bus error.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2263,6 +2263,8 @@ static int ath9k_start(struct ieee80211_
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
 
+	ath9k_ps_wakeup(sc);
+
 	mutex_lock(&sc->mutex);
 
 	if (ath9k_wiphy_started(sc)) {
@@ -2372,6 +2374,8 @@ static int ath9k_start(struct ieee80211_
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
+	ath9k_ps_restore(sc);
+
 	return r;
 }
 


