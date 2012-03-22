Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab2CVMKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:10:48 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42042 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2CVMKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:10:46 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 4/4] tile/CPU hotplug: Add missing call to
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
Date: Thu, 22 Mar 2012 16:59:11 +0530
Message-ID: <20120322112905.17063.88829.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032211-8878-0000-0000-000001CD74CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/tile/kernel/smpboot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index b949edc..172aef7 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -196,6 +196,8 @@ void __cpuinit online_secondary(void)
 	/* This must be done before setting cpu_online_mask */
 	wmb();
 
+	notify_cpu_starting(smp_processor_id());
+
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of

