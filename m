Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1I1XQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:16:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab1I1Wnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220137.964000204@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [120/244] mac80211: fix missing sta_lock in __sta_info_destroy
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4bae7d976976fa52d345805ba686934cd548343e upstream.

Since my commit 34e895075e21be3e21e71d6317440d1ee7969ad0
("mac80211: allow station add/remove to sleep") there is
a race in mac80211 when it clears the TIM bit because a
sleeping station disconnected, the spinlock isn't held
around the relevant code any more. Use the right API to
acquire the spinlock correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -669,7 +669,7 @@ static int __must_check __sta_info_destr
 		BUG_ON(!sdata->bss);
 
 		atomic_dec(&sdata->bss->num_sta_ps);
-		__sta_info_clear_tim_bit(sdata->bss, sta);
+		sta_info_clear_tim_bit(sta);
 	}
 
 	local->num_sta--;


