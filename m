Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab2CVMEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:04:00 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49380 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab2CVMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:03:58 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/4] parisc/CPU hotplug: Add missing call to
 notify_cpu_starting()
To: rkuo@codeaurora.org, tglx@linutronix.de, linas@codeaurora.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, dhowells@redhat.com,
        yasutake.koichi@jp.panasonic.com, akpm@linux-foundation.org,
        benh@kernel.crashing.org, jesper.nilsson@axis.com, cmetcalf@tilera.com,
        linux@arm.linux.org.uk, jejb@parisc-linux.org, deller@gmx.de,
        vapier@gentoo.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org
Date: Thu, 22 Mar 2012 16:58:59 +0530
Message-ID: <20120322112852.17063.4629.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032211-4790-0000-0000-000001E77824
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/parisc/kernel/smp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 32d5884..50a4581 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -297,8 +297,13 @@ smp_cpu_init(int cpunum)
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
 		machine_halt();
-	}  
+	}
+
+	notify_cpu_starting(cpunum);
+
+	ipi_call_lock();
 	set_cpu_online(cpunum, true);
+	ipi_call_unlock();
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);

