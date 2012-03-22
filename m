Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2CVL3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:29:03 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59125 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2CVL3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:29:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/4] mn10300/CPU hotplug: Add missing call to
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
Date: Thu, 22 Mar 2012 16:58:47 +0530
Message-ID: <20120322112830.17063.88766.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032211-2000-0000-0000-000006E042F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/mn10300/kernel/smp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 9242e9f..25ca7fe 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -875,10 +875,14 @@ static void __init smp_online(void)
 
 	cpu = smp_processor_id();
 
-	local_irq_enable();
+	notify_cpu_starting(cpu);
 
+	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	smp_wmb();
+	ipi_call_unlock();
+
+	local_irq_enable();
+
 }
 
 /**

