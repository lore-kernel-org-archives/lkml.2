Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0IGOdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:50 -0400
Received: from www.tglx.de ([62.245.132.106]:43816 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0IGOd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:29 -0400
Message-Id: <20100907125055.849873983@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: [patch 12/30] ibmphp-hpc: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-pci-hotplug-ibmphp-hpc-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org

---
 drivers/pci/hotplug/ibmphp_hpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/ibmphp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/ibmphp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/ibmphp_hpc.c
@@ -133,8 +133,8 @@ void __init ibmphp_hpc_initvars (void)
 	debug ("%s - Entry\n", __func__);
 
 	mutex_init(&sem_hpcaccess);
-	init_MUTEX (&semOperations);
-	init_MUTEX_LOCKED (&sem_exit);
+	sema_init(&semOperations, 1);
+	sema_init(&sem_exit, 0);
 	to_debug = 0;
 
 	debug ("%s - Exit\n", __func__);


