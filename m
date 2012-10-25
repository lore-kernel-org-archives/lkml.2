Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab2JYO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:59:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53830 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2JYO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:59:24 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] irq: tsk->comm is an array
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 16:01:01 +0100
Message-ID: <20121025150056.17719.94347.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

More relevantly what about termination and locks ?

Anyway the array check is useless so remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..ea39714 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -792,8 +792,9 @@ static void irq_thread_dtor(struct callback_head *unused)
 
 	action = kthread_data(tsk);
 
+	/* FIXME: locking */
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+	       tsk->comm, tsk->pid, action->irq);
 
 
 	desc = irq_to_desc(action->irq);

