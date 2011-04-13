Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1DMPza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:30 -0400
Received: from kroah.org ([198.145.64.141]:54320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab1DMPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:45 2011
Message-Id: <20110413155145.854879745@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [27/74] ath9k: fix a chip wakeup related crash in ath9k_start
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1918,6 +1918,8 @@ static int ath9k_start(struct ieee80211_
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
+	ath9k_ps_wakeup(sc);
+
 	mutex_lock(&sc->mutex);
 
 	if (ath9k_wiphy_started(sc)) {
@@ -2025,6 +2027,8 @@ static int ath9k_start(struct ieee80211_
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
+	ath9k_ps_restore(sc);
+
 	return r;
 }
 


