Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab2KZRRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:17:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab2KZRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Huacai Chen <chenhc@lemote.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Charles Wang <muming.wq@taobao.com>, Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 270/270] Revert "sched: Add missing call to calc_load_exit_idle()"
Date: Mon, 26 Nov 2012 14:59:20 -0200
Message-Id: <1353949160-26803-271-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

This reverts commit 900404e5d201d0a6d2806f615b41e939713d55db on 3.5,
which is commit 749c8814f08f12baa4a9c2812a7c6ede7d69507d upstream.

The change was originally intended to fix a mismerge in 3.6. The 3.5
stable branch was unaffected by the issue, as reported by Huacai Chen on
stable mailing list (on the thread 'Seems like "sched: Add missing call
to calc_load_exit_idle()" should be reverted in 3.5 branch').

As concluded by Peter Zijlstra:
"(...) You are right, v3.5.5 has one calc_load_exit_idle() too many, the
one in tick_nohz_update_jiffies() needs to go. (...)"

Cc: Huacai Chen <chenhc@lemote.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Charles Wang <muming.wq@taobao.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/time/tick-sched.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a057ed4..4a08472 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -145,7 +145,6 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
 
-	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 }
 
-- 
1.7.9.5

