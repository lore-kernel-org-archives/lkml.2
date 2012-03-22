Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2CVM7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:59:46 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42257 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2CVM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:59:42 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] xen/smp: Remove unnecessary call to smp_processor_id()
To: konrad.wilk@oracle.com, jeremy@goop.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 18:29:24 +0530
Message-ID: <20120322125923.19782.82924.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032202-5140-0000-0000-000000EF1998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an extra and unnecessary call to smp_processor_id()
in cpu_bringup(). Remove it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/xen/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 501d4e0..acfe7a3 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -59,7 +59,7 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 
 static void __cpuinit cpu_bringup(void)
 {
-	int cpu = smp_processor_id();
+	int cpu;
 
 	cpu_init();
 	touch_softlockup_watchdog();

