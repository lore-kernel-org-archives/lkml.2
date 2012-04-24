Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2DXXLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:11:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61440 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab2DXXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:11:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/2] res_counter: Account max_usage when calling res_counter_charge_nofail()
Date: Wed, 25 Apr 2012 01:11:36 +0200
Message-Id: <1335309096-12886-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating max_usage is something one would expect when we reach
a new maximum usage value even when we do this by forcing through
the limit with res_counter_charge_nofail().

(Whether we want to account failcnt when we force through the limit
is another debate).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
---
 kernel/res_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 07a2992..bebe2b1 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -35,7 +35,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val,
 	}
 
 	counter->usage += val;
-	if (!force && counter->usage > counter->max_usage)
+	if (counter->usage > counter->max_usage)
 		counter->max_usage = counter->usage;
 	return ret;
 }
-- 
1.7.5.4

