Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0LHA7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:23 -0500
Received: from kroah.org ([198.145.64.141]:48404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab0LHA7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.486892237@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [021/289] ath9k: fix regression which disabled ps on ath9k
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 008443def34db1dcc8016763587a288254ea5735 upstream.

The patch titled "ath9k: Add new file init.c" shuffled some code
around but in dong so for some reason also removed the revision
check for disablign power save. Add this revision check again
so we can get power save re-enabled again by default on cards
newer than AR5416 and AR5418.

$ git describe --contains 556242049cc3992d0ee625e9f15c4b00ea4baac8
v2.6.34-rc1~233^2~49^2~343

This patch has fixes for stable kernels [2.6.34+].

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -660,7 +660,8 @@ void ath9k_set_hw_capab(struct ath_softc
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (AR_SREV_5416(sc->sc_ah))
+		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->queues = 4;
 	hw->max_rates = 4;


