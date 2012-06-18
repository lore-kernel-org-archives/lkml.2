Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2FRIu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:50:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:47951 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2FRIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:50:55 -0400
Date: Mon, 18 Jun 2012 10:50:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120618084713.GC1946@moon>
Message-ID: <alpine.LFD.2.02.1206181050270.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de> <20120618084713.GC1946@moon>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Cyrill Gorcunov wrote:
> On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> > +
> > +static int
> > +__smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> > +{
> > +	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> > +	struct smpboot_thread_data *td;
> > +
> > +	if (tsk)
> > +		return 0;
> > +
> > +	td = kzalloc_node(sizeof(*td), GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!td)
> > +		return -ENOMEM;
> > +	td->cpu = cpu;
> > +	td->ht = ht;
> > +
> > +	tsk = kthread_create_on_cpu(ht->thread_fn, td, cpu, ht->thread_comm);
> > +	if (IS_ERR(tsk))
> > +		return PTR_ERR(tsk);
> > +
> 
> Hi Thomas, I might be missing something obvious but will not we leak td
> allocated here if kthread_create_on_cpu failed?

Yes. Good catch!

Thanks,

	tglx
