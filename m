Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1CDHIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:08:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1CDHIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:08:17 -0500
Date: Fri, 4 Mar 2011 08:08:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
Message-ID: <20110304070802.GA27618@elte.hu>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
 <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
 <20110221083511.GC31267@htj.dyndns.org>
 <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
 <4D700B93.2080807@gmail.com>
 <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com>
 <4D701015.2040703@kernel.org>
 <alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Thu, 3 Mar 2011, Yinghai Lu wrote:
> 
> > he want
> > 
> > > +#ifdef CONFIG_ACPI_NUMA
> > >> > +		ret = numa_init(x86_acpi_numa_init);
> > >> > +		if (!ret)
> > >> > +			return;
> > >> > +#endif
> > >> > +#ifdef CONFIG_AMD_NUMA
> > >> > +		ret = numa_init(amd_numa_init);
> > >> > +		if (!ret)
> > >> > +			return;
> > >> > +#endif
> > 
> > to be replaced by:
> > 
> > > +#ifdef CONFIG_ACPI_NUMA
> > >> > +		if (!numa_init(x86_acpi_numa_init))
> > >> > +			return;
> > >> > +#endif
> > >> > +#ifdef CONFIG_AMD_NUMA
> > >> > +		if (!numa_init(amd_numa_init))
> > >> > +			return;
> > >> > +#endif
> 
> It's a matter of style and I think it's up to Ingo what he'd prefer to 
> see.

I think your variant is cleaner: hiding function call side-effects in conditionscan 
be a fragile thing to do. We want constant expressions with no side-effects - so if 
functions are called they should be constant functions as well.

Code compactness isn't everything - if it was we'd be using C to the max to create 
unreadable compound expressions all the time.

Thanks,

	Ingo
