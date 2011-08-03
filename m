Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1HCXns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:43:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab1HCX0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221247.499947121@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [035/102] mac80211: Restart STA timers only on associated state
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2200,6 +2200,9 @@ void ieee80211_sta_restart(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))


