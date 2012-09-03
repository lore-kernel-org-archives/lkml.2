Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2ICD6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:58:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34348 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICD6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:58:11 -0400
Message-ID: <50442ACA.3000509@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 11:58:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 1/4] linsched: remove process_all_softirqs() in main loop
 for accuracy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090303-7014-0000-0000-000001D43103
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

process_all_softirqs() will handle softirq for all the cpu even
it's not the right timing for them, this will cause inaccuracy.

This patch stop invoke process_all_softirqs(), so softirq will
only be handled after timer interrupt arrived.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/hrtimer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/linsched/hrtimer.c b/tools/linsched/hrtimer.c
index 26be1d8..de88b25 100644
--- a/tools/linsched/hrtimer.c
+++ b/tools/linsched/hrtimer.c
@@ -206,7 +206,6 @@ void linsched_run_sim(int sim_ticks)
                        /* a handler should never leave this state changed */
                        BUG_ON(smp_processor_id() != active_cpu);

-                       process_all_softirqs();
                        linsched_rcu_invoke();

                        BUG_ON(irqs_disabled());

