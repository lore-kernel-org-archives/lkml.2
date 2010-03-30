Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0C3XJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:08 -0400
Received: from kroah.org ([198.145.64.141]:48469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0C3XJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:01 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:51 2010
Message-Id: <20100330224950.266515228@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [17/45] sched: fine-tune SD_MC_INIT
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit 14800984706bf6936bbec5187f736e928be5c218 upstream.

Tune SD_MC_INIT the same way as SD_CPU_INIT:
unset SD_BALANCE_NEWIDLE, and set SD_WAKE_BALANCE.

This improves vmark by 5%:

vmark         132102 125968 125497 messages/sec    avg 127855.66    .984
vmark         139404 131719 131272 messages/sec    avg 134131.66   1.033

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -120,10 +120,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\


