Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0FSXaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 19:30:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1193 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0FSXaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 19:30:19 -0400
From: Joe Perches <joe@perches.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/net/wireless/b43: Use local ratelimit_state
Date: Sat, 19 Jun 2010 16:30:09 -0700
Message-Id: <4b06544d432227e8587f17330f73edcaa734de86.1276988387.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1276988387.git.joe@perches.com>
References: <cover.1276988387.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid limiting the logging output of other networking devices

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/b43/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 7965b70..8031f24 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -311,13 +311,15 @@ static int b43_wireless_core_start(struct b43_wldev *dev);
 
 static int b43_ratelimit(struct b43_wl *wl)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
+
 	if (!wl || !wl->current_dev)
 		return 1;
 	if (b43_status(wl->current_dev) < B43_STAT_STARTED)
 		return 1;
 	/* We are up and running.
 	 * Ratelimit the messages to avoid DoS over the net. */
-	return net_ratelimit();
+	return __ratelimit(&ratelimit);
 }
 
 void b43info(struct b43_wl *wl, const char *fmt, ...)
-- 
1.7.1.337.g6068.dirty

