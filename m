Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2CFRMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:12:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42269 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab2CFRMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:12:20 -0500
Date: Tue, 6 Mar 2012 18:12:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] KVM: perf: kvm events analysis tool
Message-ID: <20120306171209.GB25648@elte.hu>
References: <4F55D110.2020609@linux.vnet.ibm.com>
 <20120306090730.GB27238@elte.hu>
 <4F55EA0D.4040408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F55EA0D.4040408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Thanks for your review, Ingo!
> 
> On 03/06/2012 05:07 PM, Ingo Molnar wrote:
> 
> 
> > So, your new tool has a similar workflow to:
> > 
> >   perf kvm record
> >   perf kvm report
> > 
> > but differs from it in terms of events used and in terms of 
> > reported output.
> > 
> > To me it appears that your tool is basically pretty similar to 
> > 'perf stat', adapted to KVM, right?
> > 
> > So, could your new tool's workflow be simplified like this:
> > 
> >   perf kvm stat ..
> > 
> > ?
> > 
> > To automatically stat all vcpus in the system, the well-known 
> > -a/--all-cpus system-wide method could be used:
> > 
> >   perf kvm stat -a ...
> > 
> > with stat output following immediately after it has finished.
> > 
> 
> 
> Actually, the stat information has already been included in the report.
> 
> 
> > It should also be possible to use those new events in a 
> > recording fashion - a new, rather logical command sub-space 
> > could be used for that:
> > 
> >  perf kvm stat record ...
> >  perf kvm stat report ...
> > 
> > [ This could be expanded to regular 'perf stat' as well: 'perf 
> >   stat record' and 'perf stat report' would be useful - but I 
> >   suspect that's outside the scope of your patches. ]
> > 
> 
> 
> I totally agree with you except i prefer 'perf kvm events' to 
> 'perf kvm stat' :) : it records some specified kvm events and 
> smartly analyze it. I think it matches its doing better.

Well, my problem is that *all* of the 'perf kvm' functionality 
deals with events :-) So the 'events' does not say much - you 
just add a variation to the theme without really distinguishing 
it.

Since 'perf stat' is not yet used and the output of your tool 
looks quite perf stat alike, why not use that name and 
standardize all these workflows?

Thanks,

	Ingo
