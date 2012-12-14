Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2LNJex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:34:53 -0500
Received: from canardo.mork.no ([148.122.252.1]:42748 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab2LNJew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:34:52 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Revert "watchdog: Fix CPU hotplug regression"
Date: Fri, 14 Dec 2012 10:34:35 +0100
Message-Id: <1355477675-10552-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <87y5h1c70y.fsf@nemi.mork.no>
References: <87y5h1c70y.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 8d4516904b39507458bee8115793528e12b1d8dd.

commit 8d451690 ("watchdog: Fix CPU hotplug regression") cause
a hard lockup when I connect AC power on my laptop.  The indirect
reason is that laptop-mode-tools is configured to do

  echo 0 > /proc/sys/kernel/nmi_watchdog

when AC power is disconnected and

  echo 1 > /proc/sys/kernel/nmi_watchdog

when AC power is connected.  This is the default configuration of
the Debian laptop-mode-tools package.

Cc: <stable@vger.kernel.org> # v3.7
Cc: Norbert Warmuth <nwarmuth@t-online.de>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 kernel/watchdog.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c8c21be..dd4b80a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -368,9 +368,6 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	if (!watchdog_enabled)
-		return;
-
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
-- 
1.7.2.5

