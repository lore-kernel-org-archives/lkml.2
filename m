Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2A0Jk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:40:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59585 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2A0Jk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:40:56 -0500
Message-ID: <1327657245.2446.153.camel@twins>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jan 2012 10:40:45 +0100
In-Reply-To: <20120127092205.GC8897@dirshya.in.ibm.com>
References: <20120116161740.29759.4679.stgit@localhost>
	 <20120116162241.29759.13220.stgit@localhost>
	 <1327504213.2614.78.camel@laptop>
	 <20120127092205.GC8897@dirshya.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 14:52 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-25 16:10:13]:
> 
> > On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> > > @@ -6150,10 +6150,8 @@ SD_INIT_FUNC(CPU)
> > >   SD_INIT_FUNC(ALLNODES)
> > >   SD_INIT_FUNC(NODE)
> > >  #endif
> > > -#ifdef CONFIG_SCHED_SMT
> > > +#ifdef CONFIG_SCHED_POWERSAVE
> > >   SD_INIT_FUNC(SIBLING)
> > > -#endif
> > > -#ifdef CONFIG_SCHED_MC
> > >   SD_INIT_FUNC(MC)
> > >  #endif
> > >  #ifdef CONFIG_SCHED_BOOK
> > > @@ -6250,7 +6248,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
> > >                 *per_cpu_ptr(sdd->sgp, cpu) = NULL;
> > >  }
> > >  
> > > -#ifdef CONFIG_SCHED_SMT
> > > +#ifdef CONFIG_SCHED_POWERSAVE
> > >  static const struct cpumask *cpu_smt_mask(int cpu)
> > >  {
> > >         return topology_thread_cpumask(cpu);
> > > @@ -6261,10 +6259,8 @@ static const struct cpumask *cpu_smt_mask(int cpu)
> > >   * Topology list, bottom-up.
> > >   */
> > >  static struct sched_domain_topology_level default_topology[] = {
> > > -#ifdef CONFIG_SCHED_SMT
> > > +#ifdef CONFIG_SCHED_POWERSAVE
> > >         { sd_init_SIBLING, cpu_smt_mask, },
> > > -#endif
> > > -#ifdef CONFIG_SCHED_MC
> > >         { sd_init_MC, cpu_coregroup_mask, },
> > >  #endif
> > >  #ifdef CONFIG_SCHED_BOOK 
> > 
> > I don't like this either, SCHED_{MC,SMT} here have nothing to do with
> > powersavings, its topology support.
>  
> Yes, but we don't need these domains for any other purpose other than
> powersave balance.  The code overheads are not high,  I will remove
> the config option and check.

Yes we do, SMT perf skips siblings and only loads them when there's only
siblings left idle. Similarly for MC, we prefer to run tasks on separate
sockets when possible.
