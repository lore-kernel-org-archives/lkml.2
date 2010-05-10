Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab0EJXpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:45:03 -0400
Received: from kroah.org ([198.145.64.141]:32865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab0EJWvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:43 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:18 2010
Message-Id: <20100510223318.189961904@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [011/117] mac80211: remove bogus TX agg state assignment
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit b4bb5c3fd9333024044362df67e23e96158489ed upstream.

When the addba timer expires but has no work to do,
it should not affect the state machine. If it does,
TX will not see the successfully established and we
can also crash trying to re-establish the session.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -183,7 +183,6 @@ static void sta_addba_resp_timer_expired
 		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=
 						HT_ADDBA_REQUESTED_MSK) {
 		spin_unlock_bh(&sta->lock);
-		*state = HT_AGG_STATE_IDLE;
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"(or no longer) expecting addBA response there",


