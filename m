Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0LHB6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:58:54 -0500
Received: from kroah.org ([198.145.64.141]:48453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab0LHA7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.193023169@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [028/289] ath9k: Fix incorrect access of rate flags in RC
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

commit 4fc4fbd1d9a05fa4f348b499aca3a6f8d3c9bbe6 upstream.

The index variable to access the rate flags should be obtained from the
inner loop counter which corresponds to the rate table structure.This
fixes the invalid rate selection i.e when the supported basic rate is
invalid on a particular band and also the following warning message.
Thanks to Raj for finding this out.

Call Trace:

 [<ffffffff8104ee4a>] warn_slowpath_common+0x7a/0xb0

 [<ffffffff8104ee95>] warn_slowpath_null+0x15/0x20

 [<ffffffffa0583c45>] ath_get_rate+0x595/0x5b0 [ath9k]

 [<ffffffff811a0636>] ? cpumask_next_and+0x36/0x50

 [<ffffffffa0405186>] rate_control_get_rate+0x86/0x160 [mac80211]

 [<ffffffffa040dfac>] invoke_tx_handlers+0x81c/0x12d0 [mac80211]

 [<ffffffffa040eae9>] ieee80211_tx+0x89/0x2b0 [mac80211]

 [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0

 [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]

 [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]

 [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]

 [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150
[mac80211]

 [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0

 [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]

 [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]

 [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]

 [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150
[mac80211]

 [<ffffffffa03f8896>] ieee80211_scan_work+0x146/0x600 [mac80211]

 [<ffffffff8133a375>] ? schedule+0x2f5/0x8e0

 [<ffffffffa03f8750>] ? ieee80211_scan_work+0x0/0x600 [mac80211]

 [<ffffffff81064fcf>] process_one_work+0x10f/0x380

 [<ffffffff81066bc2>] worker_thread+0x162/0x340

 [<ffffffff81066a60>] ? worker_thread+0x0/0x340

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -538,7 +538,7 @@ static u8 ath_rc_setvalid_rates(struct a
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
-			u16 rate_flags = rate_table->info[i].rate_flags;
+			u16 rate_flags = rate_table->info[j].rate_flags;
 			u8 rate = rateset->rs_rates[i];
 			u8 dot11rate = rate_table->info[j].dot11rate;
 


