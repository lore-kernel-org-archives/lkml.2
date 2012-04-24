Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2DXWfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:13 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2DXWfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:08 -0400
Message-Id: <20120424223244.035314155@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 24/62] mac80211: fix logic error in ibss channel type check
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 6741e7f048dacc92e37c5d724ff5c64e45f6c2c9 upstream.

The broken check leads to rate control attempting to use HT40 while
the driver is configured for HT20. This leads to interesting hardware
issues.

HT40 can only be used if the channel type is either HT40- or HT40+
and if the channel type of the cell matches the local type.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ibss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -435,8 +435,8 @@ static void ieee80211_rx_bss_info(struct
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if ((channel_type == NL80211_CHAN_HT40MINUS ||
-			     channel_type == NL80211_CHAN_HT40PLUS) &&
+			if (!(channel_type == NL80211_CHAN_HT40MINUS ||
+			      channel_type == NL80211_CHAN_HT40PLUS) ||
 			    channel_type != sdata->u.ibss.channel_type)
 				sta_ht_cap_new.cap &=
 					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;


