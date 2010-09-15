Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0IOT5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:57:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59558 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab0IOT5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:57:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: [RFC][PATCH] PM / Runtime: Use alloc_workqueue() for creating PM workqueue
Date: Wed, 15 Sep 2010 21:56:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009152156.30749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Use alloc_workqueue() for creating PM workqueue

Although we need the PM workqueue to be freezable, we don't need it
to be singlethread.  Also, the number of concurrent work items
running on a single CPU need not be constrained.  For these reasons
use alloc_workqueue() directly, with suitable arguments, instead of
create_freezeable_workqueue(), to create the runtime PM workqueue.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Tejun,

I'm not sure about that WQ_RESCUER thing.  Can you please tell me what
exactly it is for?

Thanks,
Rafael

---
 kernel/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL_GPL(pm_wq);
 
 static int __init pm_start_workqueue(void)
 {
-	pm_wq = create_freezeable_workqueue("pm");
+	pm_wq = alloc_workqueue("pm", WQ_FREEZEABLE | WQ_RESCUER, 0);
 
 	return pm_wq ? 0 : -ENOMEM;
 }
