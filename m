Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1D1PRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:17:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53419 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab1D1PRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:17:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] cris: convert old cpumask API into new one
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
In-Reply-To: <BANLkTikq2vorpoNzSCZ1B7z=gvtCNv0L=A@mail.gmail.com>
References: <20110429000619.3D63.A69D9226@jp.fujitsu.com> <BANLkTikq2vorpoNzSCZ1B7z=gvtCNv0L=A@mail.gmail.com>
Message-Id: <20110429001840.3D70.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:17:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -277,10 +279,10 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
> >        int ret = 0;
> >
> >        /* Calculate CPUs to send to. */
> > -       cpus_and(cpu_mask, cpu_mask, cpu_online_map);
> > +       cpumask_and(&cpu_mask, &cpu_mask, cpu_online_mask);
> >
> >        /* Send the IPI. */
> > -       for_each_cpu_mask(i, cpu_mask)
> > +       for_each_cpu(i,&cpu_mask)
> 
> please, could you add a space between i,&cpu_mask?

Sure.
Incrementa patch is here.


>From c338d6f323efc7ed92a19bbf312f7830b352fbda Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 29 Apr 2011 00:15:34 +0900
Subject: [PATCH] cris: fix style issue

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/cris/arch-v32/kernel/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 54467ec..f96ddfd 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -282,7 +282,7 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
 	cpumask_and(&cpu_mask, &cpu_mask, cpu_online_mask);
 
 	/* Send the IPI. */
-	for_each_cpu(i,&cpu_mask)
+	for_each_cpu(i, &cpu_mask)
 	{
 		ipi.vector |= vector;
 		REG_WR(intr_vect, irq_regs[i], rw_ipi, ipi);
@@ -290,7 +290,7 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
 
 	/* Wait for IPI to finish on other CPUS */
 	if (wait) {
-		for_each_cpu(i,&cpu_mask) {
+		for_each_cpu(i, &cpu_mask) {
                         int j;
                         for (j = 0 ; j < 1000; j++) {
 				ipi = REG_RD(intr_vect, irq_regs[i], rw_ipi);
-- 
1.7.3.1





