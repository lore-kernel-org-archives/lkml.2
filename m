Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2GYOVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:21:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:32792 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2GYOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120716103948.456416747@linutronix.de>
References: <20120716103749.122800930@linutronix.de>
	<20120716103948.456416747@linutronix.de>
Date: Wed, 25 Jul 2012 23:21:15 +0900
Message-ID: <CAAmzW4OhKu=Xwt1S1ABs-fZvLRq=DauXPXjWZqCJb1n1Q7dWXA@mail.gmail.com>
Subject: Re: [Patch 4/7] softirq: Use hotplug thread infrastructure
From: JoonSoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/16 Thomas Gleixner <tglx@linutronix.de>:
> -               static const struct sched_param param = {
> -                       .sched_priority = MAX_RT_PRIO-1
> -               };
> -
> -               p = per_cpu(ksoftirqd, hotcpu);
> -               per_cpu(ksoftirqd, hotcpu) = NULL;
> -               sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> -               kthread_stop(p);
> +               int hotcpu = (unsigned long)hcpu;
> +
>                 takeover_tasklets(hotcpu);
>                 break;

Currently, "int hotcpu = (unsigned long)hcpu;" is somewhat strange.
"takeover_tasklets((unsigned long)hcpu)" is sufficient for me.
