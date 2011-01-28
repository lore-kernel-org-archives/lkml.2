Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1A1QBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:01:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1A1QBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:01:05 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: [PATCH 3/3] watchdog: Don't change watchdog state on read of sysctl
Date: Fri, 28 Jan 2011 11:00:33 -0500
Message-Id: <1296230433-6261-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
References: <1296230433-6261-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
[ add {}'s to fix a warning ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 38af39a..6b16cb1 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -493,10 +493,12 @@ int proc_dowatchdog_enabled(struct ctl_table *table, int write,
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 
-	if (watchdog_enabled)
-		watchdog_enable_all_cpus();
-	else
-		watchdog_disable_all_cpus();
+	if (write) {
+		if (watchdog_enabled)
+			watchdog_enable_all_cpus();
+		else
+			watchdog_disable_all_cpus();
+	}
 	return 0;
 }
 
-- 
1.7.3.4

