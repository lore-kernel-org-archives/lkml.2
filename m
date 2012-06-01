Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2FAGsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:48:23 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55960 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2FAGsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:48:22 -0400
Date: Fri, 1 Jun 2012 12:18:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] sched/x86: Calculate booted cores after construction of
 sibling_mask
Message-ID: <20120601064815.GJ7511@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20120531073738.GH7511@linux.vnet.ibm.com>
 <1338496257.28384.121.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338496257.28384.121.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060106-8878-0000-0000-000002BD5492
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-31 22:30:57]:

(snip)
> > 
> > sched/x86: Calculate booted cores after construction of sibling_mask
> 
> Why repeat this subject again?
> 
Will take care of it from next posting.

(snip)
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index fd019d7..a8d78f3 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -382,7 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
> >  		if ((i == cpu) || (has_mc && match_llc(c, o)))
> >  			link_mask(llc_shared, cpu, i);
> > 
> > -		if ((i == cpu) || (has_mc && match_mc(c, o))) {
> > +	}
> > +
> > +	for_each_cpu(i, cpu_sibling_setup_mask) {
> > +		o = &cpu_data(i);
> > +
> > +	if ((i == cpu) || (has_mc && match_mc(c, o))) {
> >  			link_mask(core, cpu, i);
> > 
> >  			/*
> 
> This patch actually horribly mangles the indenting. I did the below to
> it:

Sorry about the indentation. Thanks for fixing it.


