Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2A0H1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:27:22 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49131 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab2A0H0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 7/7] x86, irq: kill create_irq()
Date: Thu, 26 Jan 2012 23:25:53 -0800
Message-Id: <1327649153-16477-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F225198.0084,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

it only causes confusing.

And now we don't have user for create_irq().

So remove create_irq() for x86.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index cb8c43d..4bda08d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3090,21 +3090,6 @@ unsigned int create_irq_nr(unsigned int from, int node)
 	return ret;
 }
 
-int create_irq(void)
-{
-	int node = cpu_to_node(0);
-	unsigned int irq_want;
-	int irq;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
-
-	if (irq == 0)
-		irq = -1;
-
-	return irq;
-}
-
 void destroy_irq(unsigned int irq)
 {
 	struct irq_cfg *cfg = irq_get_chip_data(irq);
-- 
1.7.7

