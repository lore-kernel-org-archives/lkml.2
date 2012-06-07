Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab2FGPn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:43:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2FGPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:43:15 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=1R9QqmykjiYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=A6epgubW1mPyAzyLiQAA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120607154313.745979097@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Jun 2012 11:42:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 3/4] mips-remove-smp-reserve-lock.patch
References: <20120607154222.443210802@goodmis.org>
Content-Disposition: inline; filename=0003-mips-remove-smp-reserve-lock.patch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Instead of making the lock raw, remove it as it protects nothing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/cavium-octeon/smp.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index efcfff4..86fce15 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -257,8 +257,6 @@ DEFINE_PER_CPU(int, cpu_state);
 
 extern void fixup_irqs(void);
 
-static DEFINE_SPINLOCK(smp_reserve_lock);
-
 static int octeon_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -266,8 +264,6 @@ static int octeon_cpu_disable(void)
 	if (cpu == 0)
 		return -EBUSY;
 
-	spin_lock(&smp_reserve_lock);
-
 	cpu_clear(cpu, cpu_online_map);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
@@ -277,8 +273,6 @@ static int octeon_cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	spin_unlock(&smp_reserve_lock);
-
 	return 0;
 }
 
-- 
1.7.10


