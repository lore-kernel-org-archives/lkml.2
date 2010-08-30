Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0H3B6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:58:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52881 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0H3B6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:58:53 -0400
Date: Mon, 30 Aug 2010 11:58:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20100830115850.81829b70.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
net/mac80211/main.c between commit
95fed448c6d7dac3fb36847cda7094f3524a6cb7 ("mac80211: delete work timer")
from the wireless-current tree and commit
258086a48b766d12a500f98834654ffa927ca475 ("mac80211: cancel restart_work
in ieee80211_unregister_hw") from the wireless tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/main.c
index ea433b6,93194f6..0000000
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@@ -807,12 -844,7 +844,13 @@@ void ieee80211_unregister_hw(struct iee
  
  	rtnl_unlock();
  
 +	/*
 +	 * Now all work items will be gone, but the
 +	 * timer might still be armed, so delete it
 +	 */
 +	del_timer_sync(&local->work_timer);
 +
+ 	cancel_work_sync(&local->restart_work);
  	cancel_work_sync(&local->reconfig_filter);
  
  	ieee80211_clear_tx_pending(local);
