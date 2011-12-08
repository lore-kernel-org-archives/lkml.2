Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1LHJ3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:29:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:52199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LHJ3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:29:52 -0500
Message-ID: <1323336544.17673.3.camel@twins>
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Thu, 08 Dec 2011 10:29:04 +0100
In-Reply-To: <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
	 <1322796864.4755.5.camel@marge.simson.net>
	 <1323275027.32012.114.camel@twins>
	 <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 11:20 -0800, Suresh Siddha wrote:

> > +DEFINE_PER_CPU(int, sd_top_spr_id);
> 
> pkg_srid (shared resource id)?

How about sd_llc{,_id} ?

> > +
> > +static void update_top_cache_domain(int cpu)
> > +{
> > +	struct sched_domain *sd;
> > +	int id = -1;
> > +
> > +	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> > +	if (sd)
> > +		id = cpumask_first(sched_domain_span(sd));
> 
> if there is no sd with shared pkg resources, then id has to be set to
> 'cpu'.

Ah, right. I hadn't considered the case where the LLC isn't shared at
all.

> > +	rcu_assign_pointer(per_cpu(sd_top_spr, cpu), sd);
> > +	per_cpu(sd_top_spr_id, cpu) = id;
> 
> Otherwise it looks good.

Thanks!
