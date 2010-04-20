Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0DTGVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:21:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:56404 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753466Ab0DTGVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:21:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,240,1270450800"; 
   d="scan'208";a="614691723"
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <20100420060933.GC22277@elte.hu>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
	 <20100419181154.GA14631@elte.hu>
	 <1271729638.2078.624.camel@ymzhang.sh.intel.com>
	 <20100420060640.GB22277@elte.hu>  <20100420060933.GC22277@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 20 Apr 2010 14:21:18 +0800
Message-Id: <1271744478.2078.626.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 08:09 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > >  unsigned long perf_misc_flags(struct pt_regs *regs)
> > >  {
> > >  	int misc = 0;
> > > +
> > >  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> > > +		if (perf_guest_cbs->is_user_mode())
> > > +			misc |= PERF_RECORD_MISC_GUEST_USER;
> > > +		else
> > > +			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> > > +	} else if (user_mode(regs))
> > > +		misc |= PERF_RECORD_MISC_USER;
> > > +	else
> > > +		misc |= PERF_RECORD_MISC_KERNEL;
> > > +
> > 
> > We try to use balanced curly braces. I.e.:
> > 
> > 	if (x) {
> > 		boo();
> > 	} else {
> > 		if (y)
> > 			foo();
> > 		else	
> > 			bar();
> > 	}	
> > 
> > And avoid unbalanced ones:
> > 
> > 	if (x) {
> > 		boo();
> > 	} else
> > 		if (y)
> > 			foo();
> > 		else	
> > 			bar();
> 
> Note, i fixed this in the patch and applied it to perf/core. (the invalid-C 
> problem was causing build failures)
Thanks for your teaching. Originally, I used {} in the 2nd half, but deleted it.

Yanmin


