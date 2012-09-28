Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab2I1S6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965120Ab2I1S6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Charles Wang <muming.wq@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 100/262] sched: Add missing call to calc_load_exit_idle()
Date: Fri, 28 Sep 2012 11:50:29 -0700
Message-Id: <20120928183009.878573430@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
 


