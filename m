Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2A0JWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:22:20 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53308 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2A0JWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:22:17 -0500
Date: Fri, 27 Jan 2012 14:52:05 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
Message-ID: <20120127092205.GC8897@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120116161740.29759.4679.stgit@localhost>
 <20120116162241.29759.13220.stgit@localhost>
 <1327504213.2614.78.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1327504213.2614.78.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012709-2000-0000-0000-00000636949F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-25 16:10:13]:

> On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> > @@ -6150,10 +6150,8 @@ SD_INIT_FUNC(CPU)
> >   SD_INIT_FUNC(ALLNODES)
> >   SD_INIT_FUNC(NODE)
> >  #endif
> > -#ifdef CONFIG_SCHED_SMT
> > +#ifdef CONFIG_SCHED_POWERSAVE
> >   SD_INIT_FUNC(SIBLING)
> > -#endif
> > -#ifdef CONFIG_SCHED_MC
> >   SD_INIT_FUNC(MC)
> >  #endif
> >  #ifdef CONFIG_SCHED_BOOK
> > @@ -6250,7 +6248,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
> >                 *per_cpu_ptr(sdd->sgp, cpu) = NULL;
> >  }
> >  
> > -#ifdef CONFIG_SCHED_SMT
> > +#ifdef CONFIG_SCHED_POWERSAVE
> >  static const struct cpumask *cpu_smt_mask(int cpu)
> >  {
> >         return topology_thread_cpumask(cpu);
> > @@ -6261,10 +6259,8 @@ static const struct cpumask *cpu_smt_mask(int cpu)
> >   * Topology list, bottom-up.
> >   */
> >  static struct sched_domain_topology_level default_topology[] = {
> > -#ifdef CONFIG_SCHED_SMT
> > +#ifdef CONFIG_SCHED_POWERSAVE
> >         { sd_init_SIBLING, cpu_smt_mask, },
> > -#endif
> > -#ifdef CONFIG_SCHED_MC
> >         { sd_init_MC, cpu_coregroup_mask, },
> >  #endif
> >  #ifdef CONFIG_SCHED_BOOK 
> 
> I don't like this either, SCHED_{MC,SMT} here have nothing to do with
> powersavings, its topology support.
 
Yes, but we don't need these domains for any other purpose other than
powersave balance.  The code overheads are not high,  I will remove
the config option and check.

--Vaidy

