Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1G1HKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 03:10:30 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:55754 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1G1HKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:10:23 -0400
Date: Thu, 28 Jul 2011 15:10:15 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: On migrate_disable() and latencies
Message-ID: <20110728071015.GA2077@windriver.com>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1311329992.27400.23.camel@twins>
 <20110723003934.GP2382@linux.vnet.ibm.com>
 <1311582653.2617.49.camel@laptop>
 <20110725211706.GT2327@linux.vnet.ibm.com>
 <1311765198.24752.437.camel@twins>
 <20110727183008.GA2407@linux.vnet.ibm.com>
 <20110728055043.GA570@windriver.com>
 <alpine.LFD.2.02.1107280855220.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107280855220.2660@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 09:01:23AM +0200, Thomas Gleixner wrote:
> We do. Just RT is the only sched class which has a set_cpus_allowed()
> callback implemented and want's an update to its rt.nr_cpus_allowed
> field.
> 
>        if (!p->migrate_disable) {
>                 if (p->sched_class && p->sched_class->set_cpus_allowed)
>                         p->sched_class->set_cpus_allowed(p, new_mask);
>                 p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
>         }
> 
> The general part is here:
> 
>        cpumask_copy(&p->cpus_allowed, new_mask);
> 
> And tsk_cpus_allowed() does:
> {
>         if (p->migrate_disable)
>                 return cpumask_of(task_cpu(p));
> 
>         return &p->cpus_allowed;
> }

Hmmm, sched-use-task-allowed-accessor.patch is the preparation :)

Clear now, thanks Thomas.

-Yong

-- 
Only stand for myself
