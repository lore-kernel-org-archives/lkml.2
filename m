Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2KFV52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:57:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2KFVzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4/8] sched: warnings in kernel/sched/fair.c
Date: Tue,  6 Nov 2012 22:55:29 +0100
Message-Id: <1352238933-4886-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Rr2cxAkJH9E2WKVd8YTNA5XAftBI2AySYJO6M4MoX0p
 MHTZUUFNPJ3nyIfkRVlHsa54eYw4vSXfwUpXPHGeDfsK+U9W/f
 tkF6JtTQO3kM7602Fro6WDRyh1quGb83g/rS+WkD3Zddd14TZR
 TlaxzWd8IHbZ8HvOwKBlDXYjb5+AUHPQdfwxv/j9Xk9NlxcVd2
 6cvaOg6KZZF8eDePT/nc0FrhOqioja2WNebzuJFBbFfPAws0kB
 Tp3AZG77hSaPzX5kAtuvTw/zThK/hZF/xB/RIbTkCMYQsYMNc3
 Vvzsfwp/dmVHLXEsY7eBjlr8/96kV+8G86j5u45NFUijcQOdi7
 m+Pa4bfzsePNVHwNLf5J1tthVyzqmGAzrdz7Ffv/kp5wQhOeEo
 NxYFr4sGyjQBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a4c96ae319 "sched: Unthrottle rt runqueues in __disable_runtime()"
turned the unthrottle_offline_cfs_rqs function into a static symbol,
which now triggers a warning about it being potentially unused:

kernel/sched/fair.c:2055:13: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]

Marking it __maybe_unused shuts up the gcc warning and lets the
compiler safely drop the function body when it's not being used.

To reproduce, build the ARM bcm2835_defconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..9f52728 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2052,7 +2052,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
-- 
1.7.10

