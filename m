Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2A0JKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:10:32 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58443 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2A0JK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:10:28 -0500
Date: Fri, 27 Jan 2012 14:40:12 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/2] sched: fix group_capacity for thread level
 consolidation
Message-ID: <20120127091012.GA8897@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120116161740.29759.4679.stgit@localhost>
 <20120116162255.29759.6264.stgit@localhost>
 <1327505886.2614.82.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1327505886.2614.82.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012623-7014-0000-0000-0000007BD7B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-25 16:38:06]:

> On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> > +               /*
> > +                * If power savings balance is set at this domain, then
> > +                * make capacity equal to number of hardware threads to
> > +                * accommodate more tasks until capacity is reached.
> > +                */
> > +               else if (sd->flags & SD_POWERSAVINGS_BALANCE)
> > +                       sgs.group_capacity =
> > +                               cpumask_weight(sched_group_cpus(sg)); 
> 
> sg->group_weight perhaps?

Yes, I will correct this.  sg->group_weight is updated to the correct
value on sched_domain rebuild in init_sched_groups_power().

--Vaidy

