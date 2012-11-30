Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2K3Wzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:55:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62181 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2K3Wzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:55:50 -0500
Date: Fri, 30 Nov 2012 14:55:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
Message-ID: <20121130225545.GC6021@htj.dyndns.org>
References: <50A78AA9.5040904@iskon.hr>
 <20121130225200.GB6021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130225200.GB6021@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Can you please try this patch?  Thanks!

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..26368ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1477,7 +1477,10 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	} while (unlikely(ret == -EAGAIN));
 
 	if (likely(ret >= 0)) {
-		__queue_delayed_work(cpu, wq, dwork, delay);
+		if (!delay)
+			__queue_work(cpu, wq, &dwork->work);
+		else
+			__queue_delayed_work(cpu, wq, dwork, delay);
 		local_irq_restore(flags);
 	}
 
