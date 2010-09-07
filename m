Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0IGOeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:34:23 -0400
Received: from www.tglx.de ([62.245.132.106]:43918 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab0IGOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:51 -0400
Message-Id: <20100907125056.892309973@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <rolandd@cisco.com>
Subject: [patch 23/30] infiniband: Make user_mad semaphore a real one
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline;
	filename=driver-infiniband-core-user-mad-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland Dreier <rolandd@cisco.com>

---
 drivers/infiniband/core/user_mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/infiniband/core/user_mad.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/core/user_mad.c
+++ linux-2.6/drivers/infiniband/core/user_mad.c
@@ -1022,7 +1022,7 @@ static int ib_umad_init_port(struct ib_d
 
 	port->ib_dev   = device;
 	port->port_num = port_num;
-	init_MUTEX(&port->sm_sem);
+	sema_init(&port->sm_sem, 1);
 	mutex_init(&port->file_mutex);
 	INIT_LIST_HEAD(&port->file_list);
 


