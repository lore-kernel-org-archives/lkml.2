Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2LaRww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:52:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2LaRwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:47 -0500
Date: Mon, 31 Dec 2012 18:52:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uprobes: Kill the bogus IS_ERR_VALUE(xol_vaddr) check
Message-ID: <20121231175232.GA32118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

utask->xol_vaddr is either zero or valid, remove the bogus
IS_ERR_VALUE() check in xol_free_insn_slot().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad1245d..ed4fcbe 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1223,8 +1223,7 @@ static void xol_free_insn_slot(struct task_struct *tsk)
 		return;
 
 	slot_addr = tsk->utask->xol_vaddr;
-
-	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
+	if (unlikely(!slot_addr))
 		return;
 
 	area = tsk->mm->uprobes_state.xol_area;
-- 
1.5.5.1

