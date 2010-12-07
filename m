Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0LGOvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:51:55 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:29311 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754223Ab0LGOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:51:54 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jcPigeAVM1m8XSQZrgkMPrkmiXXTx01pe62SoKc.39rbFAD
 iU8syFF50pAQm4EMiczg_ZXGXlx__ab0ejT8GkkoBF4L6iww0L2YE3PigyOZ
 V9XpGLT6eU3pksk16BuOAq2bU6qocFXxKIdia8nQIur22Bd879pyXcnEqF1b
 lFT8VJAUAefRONppFXIm1nNffVM9t5uavJbuWe6T3TXCg8DNRqAgBEHckrrg
 mt9cpEikEds_Q5qXqmD5Koye5ft818y3kYM7GlEcCLMIqlwoUZYGY3H45H62
 28Y_5Kmhqr92OlepR4MmkVMFu
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 08:51:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 05/11] core: Replace __get_cpu_var with
 __this_cpu_read if not used for an address.
In-Reply-To: <4CFE44E2.9050408@kernel.org>
Message-ID: <alpine.DEB.2.00.1012070850060.25976@router.home>
References: <20101206171618.302060721@linux.com> <20101206171639.183187260@linux.com> <4CFE44E2.9050408@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Tejun Heo wrote:

> >  	if (&per_cpu(tasklet_hi_vec, cpu).head != per_cpu(tasklet_hi_vec, cpu).tail) {
> > -		*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
> > -		__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
> > +		*__this_cpuo_read(tasklet_hi_vec.tail) = per_cpu(tasklet_hi_vec, cpu).head;
> > +		__this_cpu_write(tasklet_hi_vec.tail, per_cpu(tasklet_hi_vec, cpu).tail;
>
> I don't think __this_cpuo_read() would build.

A CONFIG_HOTPLUG_CPU section.

Fix up CONFIG_HOTPLUG_CPU compilation

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c	2010-12-07 08:49:51.000000000 -0600
+++ linux-2.6/kernel/softirq.c	2010-12-07 08:49:32.000000000 -0600
@@ -810,10 +810,10 @@ static void takeover_tasklets(unsigned i
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);

 	if (&per_cpu(tasklet_hi_vec, cpu).head != per_cpu(tasklet_hi_vec, cpu).tail) {
-		*__this_cpuo_read(tasklet_hi_vec.tail) = per_cpu(tasklet_hi_vec, cpu).head;
-		__this_cpu_write(tasklet_hi_vec.tail, per_cpu(tasklet_hi_vec, cpu).tail;
+		*__this_cpu_read(tasklet_hi_vec.tail) = per_cpu(tasklet_hi_vec, cpu).head;
+		__this_cpu_write(tasklet_hi_vec.tail, per_cpu(tasklet_hi_vec, cpu).tail);
 		per_cpu(tasklet_hi_vec, cpu).head = NULL;
-		per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head);
+		per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head;
 	}
 	raise_softirq_irqoff(HI_SOFTIRQ);



