Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2DPDh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:37:58 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44527 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2DPDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:37:57 -0400
Message-ID: <4F8B940B.40608@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:37:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [RFC PATCH 1/4] linsched: remove "process_all_softirqs" in main loop
 for accuracy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-8878-0000-0000-0000020ADED4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

"process_all_softirqs" will simulate an extra interrupt which will
cause cpu do extra load balance work.

This will make some cpu more active then others, the unfair will
cause inaccuracy.

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

-			process_all_softirqs();
 			linsched_rcu_invoke();

 			BUG_ON(irqs_disabled());
-- 
1.7.1

