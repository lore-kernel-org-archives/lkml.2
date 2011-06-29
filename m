Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab1F2UWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:22:44 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18337 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1F2UWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:22:42 -0400
Date: Wed, 29 Jun 2011 22:13:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-wireless@vger.kernel.org
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] net, wireless: Don't return uninitialized in
 __cfg80211_stop_sched_scan()
Message-ID: <alpine.LNX.2.00.1106292212110.3747@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the 'driver_initiated' function argument to
__cfg80211_stop_sched_scan() is not 0 then we'll return an
uninitialized 'ret' from the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 net/wireless/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7a6c676..7940fa5 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -132,7 +132,7 @@ EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
-	int err;
+	int err = 0;
 	struct net_device *dev;
 
 	ASSERT_RDEV_LOCK(rdev);
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

