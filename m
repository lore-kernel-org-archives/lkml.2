Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1G0J5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:57:09 -0400
Received: from narfation.org ([79.140.41.39]:43165 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1G0Jzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:49 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Subject: [PATCHv4 10/11] drop_monitor: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:49 +0200
Message-Id: <1311760070-21532-10-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org
---
 net/core/drop_monitor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7f36b38..ef4a05d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -137,7 +137,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	struct per_cpu_dm_data *data = &__get_cpu_var(dm_cpu_data);
 
 
-	if (!atomic_add_unless(&data->dm_hit_count, -1, 0)) {
+	if (!atomic_dec_not_zero(&data->dm_hit_count)) {
 		/*
 		 * we're already at zero, discard this hit
 		 */
-- 
1.7.5.4

