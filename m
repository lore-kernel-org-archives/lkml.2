Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2BVSEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:04:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2BVSEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:04:06 -0500
Date: Wed, 22 Feb 2012 18:57:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] powerpc/eeh: remove eeh_event_handler()->daemonize()
Message-ID: <20120222175703.GA10935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

daemonize() is only needed when a user-space task does kernel_thread().

eeh_event_handler() thread is created by the worker kthread, and thus
it doesn't need the soon-to-be-deprecated daemonize().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Linas Vepstas <linasvepstas@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Matt Fleming <matt.fleming@intel.com>
---

 arch/powerpc/platforms/pseries/eeh_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.1/arch/powerpc/platforms/pseries/eeh_event.c~3_daemonize_eeh	2011-04-06 21:33:42.000000000 +0200
+++ 3.1/arch/powerpc/platforms/pseries/eeh_event.c	2011-08-16 21:03:56.000000000 +0200
@@ -60,7 +60,7 @@ static int eeh_event_handler(void * dumm
 	struct eeh_event	*event;
 	struct pci_dn *pdn;
 
-	daemonize ("eehd");
+	set_task_comm(current, "eehd");
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	spin_lock_irqsave(&eeh_eventlist_lock, flags);

