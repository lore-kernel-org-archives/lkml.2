Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2LNImb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 03:42:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6938 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2LNIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 03:42:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Dec 2012 00:40:36 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <ccross@android.com>, <santosh.shilimkar@ti.com>, <khilman@ti.com>,
        <rjw@sisk.pl>, <daniel.lezcano@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/1] cpuidle: coupled: fix ready counter decrement
Date: Fri, 14 Dec 2012 10:42:08 +0200
Message-ID: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ready_waiting_counts atomic variable is compared against the wrong
online cpu count. The latter is computed incorrectly using logical-OR
instead of bit-OR. This patch fixes that.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 drivers/cpuidle/coupled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 3265844..2a297f8 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -209,7 +209,7 @@ inline int cpuidle_coupled_set_not_ready(struct cpuidle_coupled *coupled)
 	int all;
 	int ret;
 
-	all = coupled->online_count || (coupled->online_count << WAITING_BITS);
+	all = coupled->online_count | (coupled->online_count << WAITING_BITS);
 	ret = atomic_add_unless(&coupled->ready_waiting_counts,
 		-MAX_WAITING_CPUS, all);
 
-- 
1.7.9.5

