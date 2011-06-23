Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab1FWJdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:33:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:33199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759176Ab1FWJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:33:36 -0400
Date: Thu, 23 Jun 2011 11:33:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
        trenn@novell.com, prarit@redhat.com, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        youquan.song@intel.com, stable@kernel.org
Subject: Re: [patch 1/4] x86, mtrr: lock stop machine during MTRR rendezvous
 sequence
In-Reply-To: <1308819905.1022.70.camel@twins>
Message-ID: <alpine.LFD.2.02.1106231131300.11814@ionos>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>  <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com> <1308819905.1022.70.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Peter Zijlstra wrote:

> On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> > +#ifdef CONFIG_SMP
> > +       /*
> > +        * If we are not yet online, then there can be no stop_machine() in
> > +        * parallel. Stop machine ensures this by using get_online_cpus().
> > +        *
> > +        * If we are online, then we need to prevent a stop_machine() happening
> > +        * in parallel by taking the stop cpus mutex.
> > +        */
> > +       if (cpu_online(raw_smp_processor_id()))
> > +               mutex_lock(&stop_cpus_mutex);
> > +#endif 
> 
> This reads like an optimization, is it really worth-while to not take
> the mutex in the rare offline case?
 
You cannot block on a mutex when you are not online, in fact you
cannot block on it when not active, so the check is wrong anyway.

Thanks,

	tglx


