Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1AaMwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:52:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:39046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab1AaMwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:52:42 -0500
Date: Mon, 31 Jan 2011 12:52:16 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1296230433-6261-3-git-send-email-dzickus@redhat.com>
References: <1296230433-6261-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Don't change watchdog state on read of sysctl
Message-ID: <tip-9ffdc6c37df131f89d52001e0ef03091b158826f@git.kernel.org>
Git-Commit-ID: 9ffdc6c37df131f89d52001e0ef03091b158826f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:52:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ffdc6c37df131f89d52001e0ef03091b158826f
Gitweb:     http://git.kernel.org/tip/9ffdc6c37df131f89d52001e0ef03091b158826f
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Fri, 28 Jan 2011 11:00:33 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Jan 2011 13:22:43 +0100

watchdog: Don't change watchdog state on read of sysctl

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
[ add {}'s to fix a warning ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <1296230433-6261-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c7e0049..f37f974 100644
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
 
