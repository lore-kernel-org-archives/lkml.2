Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2HTID3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:03:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2HTIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:03:25 -0400
From: Charles Wang <muming.wq@gmail.com>
To: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dsmythies@telus.net
Cc: Charles Wang <muming.wq@gmail.com>, Charles Wang <muming.wq@taobao.com>
Subject: [PATCH] sched: add missing call for calc_load_exit_idle
Date: Mon, 20 Aug 2012 16:02:33 +0800
Message-Id: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Charles Wang <muming.wq@taobao.com>

Azat Khuzhin reported "high loadavg in linux-3.6"

After checking for upstream's code, I found Peter's patch
(Commit id:5167e8d5417bf5c322a703d2927daec727ea40dd) not be
fully applied, missing the call for calc_load_exit_idle.
After that idle exit in sampling window will always be calculated
 to non-idle, and the load will be higher than normal.

This patch add the missing call for calc_load_exit_idle.

Signed-off-by: Charles Wang <muming.wq@taobao.com>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 024540f..3a9e5d5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -573,6 +573,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
+	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
-- 
1.7.9.5

