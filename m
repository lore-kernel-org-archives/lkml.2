Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1CWVWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1CWVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:22:30 -0400
Date: Wed, 23 Mar 2011 17:22:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110323212202.GB29184@redhat.com>
References: <20110321182235.GA14562@sgi.com>
 <20110321193740.GN1239@redhat.com>
 <20110322171118.GA6294@sgi.com>
 <20110322184450.GU1239@redhat.com>
 <20110322212519.GA12076@sgi.com>
 <20110322220505.GB13453@redhat.com>
 <20110323163255.GA17178@sgi.com>
 <20110323175320.GB9413@redhat.com>
 <20110323200008.GZ1239@redhat.com>
 <4D8A5BE0.30802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8A5BE0.30802@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:45:20PM +0300, Cyrill Gorcunov wrote:
> On 03/23/2011 11:00 PM, Don Zickus wrote:
> > On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
> >> Let me know if the patch fixes that problem.  Then it will be one less
> >> thing to worry about. :-)
> > 
> > Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> > against 2.6.38.  Sorry about that.
> > 
> > Cheers,
> > Don
> > 
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 87eab4a..62ec8e9 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -1375,7 +1375,7 @@ perf_event_nmi_handler(struct notifier_block *self,
> >  	if ((handled > 1) ||
> >  		/* the next nmi could be a back-to-back nmi */
> >  	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
> > -	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
> > +	     (__this_cpu_read(pmu_nmi.handled) > 0) && handled && this_nmi)) {
> 
> Don, why do you need to check for this_nmi here? it's zero for first nmi in a
> system (right?), so I fail to get the reason for such check. What I miss?

It was a stupid optimization, otherwise it _always_ traverses on the
first nmi.  I wasn't sure that is what I wanted.  Mainly I was trying to
wrap my head around the problem.  You can remove it to see if the problem
is still fixed.

I'm not a fan of this fix as it is getting a little ugly, but for now...

Cheers,
Don
