Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1FGKE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:04:56 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45490 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1FGKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:04:55 -0400
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove redundant check in select_task_rq_fair
In-Reply-To: <1307440414.2322.236.camel@twins>
References: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com> <1307440414.2322.236.camel@twins>
User-Agent: Notmuch/0.3.1-59-g676d251 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-redhat-linux-gnu)
Date: Tue, 07 Jun 2011 15:34:48 +0530
Message-ID: <m3hb82aren.fsf@IBM-009124035060.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jun 2011 11:53:34 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-07 at 15:18 +0530, Nikunj A. Dadhania wrote:
> > When balancing for wakeup affinity, a redundant check can removed.
> 
> Yes, tempting, but no, now you've got an extra call to wake_affine(),
> which is more expensive.
Ah, got that. How about this, it is more readable. Other options would
be to add a comment.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..354e26b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1753,7 +1753,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
