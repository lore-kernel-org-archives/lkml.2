Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab0HELbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:31:21 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:42502 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758838Ab0HELbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:31:18 -0400
X-Greylist: delayed 1157 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 07:31:18 EDT
Subject: [PATCH] stop_machine: struct cpu_stopper, remove alignment padding
 on 64 bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:11:57 +0100
Message-ID: <1281006717.2000.12.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder elements in structure cpu_stopper to remove alignment padding on
64 bit builds, this shrinks its size from 40 to 32 bytes saving 8 bytes
per cpu.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.35
compiled & tested on x86_64

regards
Richard


diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 70f8d90..4372ccb 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -35,9 +35,9 @@ struct cpu_stop_done {
 /* the actual stopper, one per every possible cpu, enabled on online cpus */
 struct cpu_stopper {
 	spinlock_t		lock;
+	bool			enabled;	/* is this stopper enabled? */
 	struct list_head	works;		/* list of pending works */
 	struct task_struct	*thread;	/* stopper thread */
-	bool			enabled;	/* is this stopper enabled? */
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);


