Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab1I3LNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:13:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:55416 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab1I3LNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:13:05 -0400
From: Vasily Averin <vvs@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vvs@sw.ru>
Subject: [PATCH] watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL
Date: Fri, 30 Sep 2011 15:12:54 +0400
Message-ID: <1317381174-19596-1-git-send-email-vvs@parallels.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Averin <vvs@sw.ru>

fixed compilation warnings in case of disabled CONFIG_SYSCTL
kernel/watchdog.c:483:13: warning: ‘watchdog_enable_all_cpus’ defined but not used
kernel/watchdog.c:500:13: warning: ‘watchdog_disable_all_cpus’ defined but not used

these functions are are static and are used only in sysctl handler,
so move them inside #ifdef CONFIG_SYSCTL too

Signed-off-by: Vasily Averin <vvs@sw.ru>
---
 kernel/watchdog.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..13644ee 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -480,6 +480,8 @@ static void watchdog_disable(int cpu)
 	}
 }
 
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
@@ -508,9 +510,6 @@ static void watchdog_disable_all_cpus(void)
 	watchdog_enabled = 0;
 }
 
-
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
-- 
1.7.4.1

