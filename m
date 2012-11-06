Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2KFOXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:23:20 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2KFOXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:23:19 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] irq: tsk->comm is an array
To: linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 14:28:56 +0000
Message-ID: <20121106142849.21834.20965.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The array check is useless so remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..ba3853a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -793,7 +793,7 @@ static void irq_thread_dtor(struct callback_head *unused)
 	action = kthread_data(tsk);
 
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+	       tsk->comm, tsk->pid, action->irq);
 
 
 	desc = irq_to_desc(action->irq);

