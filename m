Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1DZBxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:53:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33126 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1DZBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:53:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: (resend) [PATCH 1/4] blackfin: remove unused function
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Frysinger <vapier.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110426105045.F359.A69D9226@jp.fujitsu.com>
References: <BANLkTi=WJytLPuKmiMYEHsVq4o=ESSY8MQ@mail.gmail.com> <20110426105045.F359.A69D9226@jp.fujitsu.com>
Message-Id: <20110426105518.F35D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 10:53:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_send_ipi() has old call-by-value cpumask_t fashon and
it's unused.

Then, this patch removes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org

---
 arch/blackfin/mach-bf561/include/mach/smp.h |    2 --
 arch/blackfin/mach-bf561/smp.c              |   13 -------------
 2 files changed, 0 insertions(+), 15 deletions(-)

I sent this parch to wrong address (device-driver-devel@blackfin.uclinux.org).
thus now I'm resending it.


diff --git a/arch/blackfin/mach-bf561/include/mach/smp.h b/arch/blackfin/mach-bf561/include/mach/smp.h
index 346c605..36e2ac5 100644
--- a/arch/blackfin/mach-bf561/include/mach/smp.h
+++ b/arch/blackfin/mach-bf561/include/mach/smp.h
@@ -21,8 +21,6 @@ void platform_secondary_init(unsigned int cpu);
 
 void platform_request_ipi(int irq, /*irq_handler_t*/ void *handler);
 
-void platform_send_ipi(cpumask_t callmap, int irq);
-
 void platform_send_ipi_cpu(unsigned int cpu, int irq);
 
 void platform_clear_ipi(unsigned int cpu, int irq);
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index 7b07740..630e2c2 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -116,19 +116,6 @@ void __init platform_request_ipi(int irq, void *handler)
 		panic("Cannot request %s for IPI service", name);
 }
 
-void platform_send_ipi(cpumask_t callmap, int irq)
-{
-	unsigned int cpu;
-	int offset = (irq == IRQ_SUPPLE_0) ? 6 : 8;
-
-	for_each_cpu_mask(cpu, callmap) {
-		BUG_ON(cpu >= 2);
-		SSYNC();
-		bfin_write_SICB_SYSCR(bfin_read_SICB_SYSCR() | (1 << (offset + cpu)));
-		SSYNC();
-	}
-}
-
 void platform_send_ipi_cpu(unsigned int cpu, int irq)
 {
 	int offset = (irq == IRQ_SUPPLE_0) ? 6 : 8;
-- 
1.7.3.1





