Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1HFALW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:11:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1HFALR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:14 2011
Message-Id: <20110806000414.012653734@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [24/50] mac80211: Restart STA timers only on associated state
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 676b58c27475a9defccc025fea1cbd2b141ee539 upstream.

A panic was observed when the device is failed to resume properly,
and there are no running interfaces. ieee80211_reconfig tries
to restart STA timers on unassociated state.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2318,6 +2318,9 @@ void ieee80211_sta_restart(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))


