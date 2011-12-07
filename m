Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab1LGQYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:24:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966Ab1LGQYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:24:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:21 2011
Message-Id: <20111207161221.868287595@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:28 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [086/104] mac80211: fill rate filter for internal scan requests
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>

commit c72e8d335e2c6a309b6281f2abcf491f37b8b92b upstream.

The rates bitmap for internal scan requests shoud be filled,
otherwise there will be probe requests with zero rates supported.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -742,6 +742,12 @@ int ieee80211_register_hw(struct ieee802
 	if (!local->int_scan_req)
 		return -ENOMEM;
 
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!local->hw.wiphy->bands[band])
+			continue;
+		local->int_scan_req->rates[band] = (u32) -1;
+	}
+
 	/* if low-level driver supports AP, we also support VLAN */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);


