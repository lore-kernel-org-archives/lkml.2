Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032382Ab2I1UZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:25:53 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48962 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032337Ab2I1UZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Charles Wang <muming.wq@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 079/218] sched: Add missing call to calc_load_exit_idle()
Date: Fri, 28 Sep 2012 13:14:56 -0700
Message-Id: <20120928201510.641643019@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Wang <muming.wq@taobao.com>

commit 749c8814f08f12baa4a9c2812a7c6ede7d69507d upstream.

Azat Khuzhin reported high loadavg in Linux v3.6

After checking the upstream scheduler code, I found Peter's commit:

  5167e8d5417b sched/nohz: Rewrite and fix load-avg computation -- again

not fully applied, missing the call to calc_load_exit_idle().

After that idle exit in sampling window will always be calculated
to non-idle, and the load will be higher than normal.

This patch adds the missing call to calc_load_exit_idle().

Signed-off-by: Charles Wang <muming.wq@taobao.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345449754-27130-1-git-send-email-muming.wq@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -145,6 +145,7 @@ static void tick_nohz_update_jiffies(kti
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
 
+	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 }
 


