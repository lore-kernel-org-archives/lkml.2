Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2JJN3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:29:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40794 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2JJN3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:29:08 -0400
Date: Wed, 10 Oct 2012 14:29:02 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [RFC PATCH 07/10] ARM: sched: Setup SCHED_HMP domains
Message-ID: <20121010132902.GF3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
 <1348252345-5642-8-git-send-email-morten.rasmussen@arm.com>
 <CAKohpokqC9Okav5HfNuN-Jd=58qoMvNO9SxVxDJWA7rqmsrkWA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKohpokqC9Okav5HfNuN-Jd=58qoMvNO9SxVxDJWA7rqmsrkWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Oct 2012 13:29:01.0570 (UTC) FILETIME=[35EA8620:01CDA6EB]
X-MC-Unique: 112101014290502701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:58:45AM +0100, Viresh Kumar wrote:
> On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
> > diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> 
> > +void __init arch_get_hmp_domains(struct list_head *hmp_domains_list)
> > +{
> > +       struct cpumask hmp_fast_cpu_mask;
> > +       struct cpumask hmp_slow_cpu_mask;
> 
> can be merged to single line.
> 
> > +       struct hmp_domain *domain;
> > +
> > +       arch_get_fast_and_slow_cpus(&hmp_fast_cpu_mask, &hmp_slow_cpu_mask);
> > +
> > +       /*
> > +        * Initialize hmp_domains
> > +        * Must be ordered with respect to compute capacity.
> > +        * Fastest domain at head of list.
> > +        */
> > +       domain = (struct hmp_domain *)
> > +               kmalloc(sizeof(struct hmp_domain), GFP_KERNEL);
> 
> should be:
> 
> domain = kmalloc(sizeof(*domain), GFP_KERNEL);
> 
> > +       cpumask_copy(&domain->cpus, &hmp_slow_cpu_mask);
> 
> what if kmalloc failed?
> 
> > +       list_add(&domain->hmp_domains, hmp_domains_list);
> > +       domain = (struct hmp_domain *)
> > +               kmalloc(sizeof(struct hmp_domain), GFP_KERNEL);
> 
> would be better to kmalloc only once with size 2* sizeof(*domain)
> 
> > +       cpumask_copy(&domain->cpus, &hmp_fast_cpu_mask);
> > +       list_add(&domain->hmp_domains, hmp_domains_list);
> 
> Also would be better to create a macro for above two lines to remove
> code redundancy.
> 

Agree on all of the above.

Thanks,
Morten

