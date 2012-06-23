Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2FWDHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:07:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2FWDGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:06:43 -0400
X-Authority-Analysis: v=2.0 cv=bpjO9Tmi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=cqTQULt0mokA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7Lw8vzfhK7FhE-nfBW8A:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120623030639.113614886@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 22 Jun 2012 23:05:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        leroy christophe <christophe.leroy@c-s.fr>
Subject: [PATCH RT 2/3] Oops during Init IRQ
References: <20120623030548.500374594@goodmis.org>
Content-Disposition: inline; filename=0002-Oops-during-Init-IRQ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

On Mon, 18 Jun 2012, leroy christophe wrote:

> Hello,
>
> I'm trying to use the rt10 patch on a 3.4.2 kernel on a powerpc (MPC8xx)
> system, and I'm having the following Oops during Irq initialisation. This
> happens with CONFIG_PREEMPT_RT_FULL.
> It doesn't happen with CONFIG_PREEMPT__LL
>
> May someone help ?

Does the following uncompiled and untested patch fix it for you ?

Thanks,

	tglx

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: leroy christophe <christophe.leroy@c-s.fr>
---
 arch/powerpc/platforms/8xx/m8xx_setup.c |    1 +
 arch/powerpc/sysdev/cpm1.c              |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1e12108..806cbbd 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -43,6 +43,7 @@ static irqreturn_t timebase_interrupt(int irq, void *dev)
 
 static struct irqaction tbint_irqaction = {
 	.handler = timebase_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "tbint",
 };
 
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index d4fa03f..5e6ff38 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -120,6 +120,7 @@ static irqreturn_t cpm_error_interrupt(int irq, void *dev)
 
 static struct irqaction cpm_error_irqaction = {
 	.handler = cpm_error_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "error",
 };
 
-- 
1.7.10


