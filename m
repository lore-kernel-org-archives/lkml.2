Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1I1Wnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab1I1Wnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.863700795@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        George <george0505@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [119/244] rtlwifi: Fix problem when switching connections
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: George <george0505@realtek.com>

commit bac2555c6d86387132930af4d14cb47c4dd3f4f7 upstream.

The driver fails to clear encryption keys making it impossible
to switch connections.

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -610,6 +610,11 @@ static void rtl_op_bss_info_changed(stru
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
+
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+
+			rtl_cam_reset_all_entry(hw);
 			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
@@ -1063,6 +1068,9 @@ static int rtl_op_set_key(struct ieee802
 		 *or clear all entry here.
 		 */
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
+
+		rtl_cam_reset_sec_info(hw);
+
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,


