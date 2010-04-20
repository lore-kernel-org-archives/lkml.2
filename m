Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0DTGJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:09:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57814 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0DTGJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:09:41 -0400
Date: Tue, 20 Apr 2010 08:09:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
Message-ID: <20100420060933.GC22277@elte.hu>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
 <20100419181154.GA14631@elte.hu>
 <1271729638.2078.624.camel@ymzhang.sh.intel.com>
 <20100420060640.GB22277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420060640.GB22277@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> >  unsigned long perf_misc_flags(struct pt_regs *regs)
> >  {
> >  	int misc = 0;
> > +
> >  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> > +		if (perf_guest_cbs->is_user_mode())
> > +			misc |= PERF_RECORD_MISC_GUEST_USER;
> > +		else
> > +			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> > +	} else if (user_mode(regs))
> > +		misc |= PERF_RECORD_MISC_USER;
> > +	else
> > +		misc |= PERF_RECORD_MISC_KERNEL;
> > +
> 
> We try to use balanced curly braces. I.e.:
> 
> 	if (x) {
> 		boo();
> 	} else {
> 		if (y)
> 			foo();
> 		else	
> 			bar();
> 	}	
> 
> And avoid unbalanced ones:
> 
> 	if (x) {
> 		boo();
> 	} else
> 		if (y)
> 			foo();
> 		else	
> 			bar();

Note, i fixed this in the patch and applied it to perf/core. (the invalid-C 
problem was causing build failures)

Thanks,

	Ingo
