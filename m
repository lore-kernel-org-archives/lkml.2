Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1HYQi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab1HYQiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:38:24 -0400
Date: Thu, 25 Aug 2011 18:35:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] add EXPORT_SYMBOL(set_current_blocked)
Message-ID: <20110825163521.GA7883@redhat.com>
References: <20110825141212.4f82835beaad506553e291e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825141212.4f82835beaad506553e291e8@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export set_current_blocked() for modules. We have the code which
wrongly plays with ->blocked, and sigprocmask() should be avoided.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

--- 3.1/kernel/signal.c~export_set_current_blocked	2011-08-25 18:23:42.000000000 +0200
+++ 3.1/kernel/signal.c	2011-08-25 18:24:02.000000000 +0200
@@ -2463,6 +2463,7 @@ void set_current_blocked(const sigset_t 
 	__set_task_blocked(tsk, newset);
 	spin_unlock_irq(&tsk->sighand->siglock);
 }
+EXPORT_SYMBOL(set_current_blocked);
 
 /*
  * This is also useful for kernel threads that want to temporarily

