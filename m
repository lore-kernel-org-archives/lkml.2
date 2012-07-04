Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab2GDIHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:07:22 -0400
Received: from ozlabs.org ([203.10.76.45]:49607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab2GDIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:07:16 -0400
Message-ID: <1341389237.22063.7.camel@concordia>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 04 Jul 2012 18:07:17 +1000
In-Reply-To: <1341306905.23484.53.camel@twins>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1341300987.11663.15.camel@concordia> <1341306905.23484.53.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 11:15 +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-03 at 17:36 +1000, Michael Ellerman wrote:
> > On Fri, 2012-06-29 at 00:00 +0800, Feng Tang wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Add support for reporting PEBS records in a raw format that can
> > > be then parsed by perf script.
> > > 
> > > This is roughly similar to the existing AMD IBS support.
> > > 
> > > This is mainly for advanced users and to experiment with
> > > new usages. Widespread PEBS usages are expected to get higher
> > > level interfaces over time, like the existing "precise ip" support.
> > 
> > Hi folks,
> > 
> > Pardon if I slightly hijack this thread, but we'd like to do something
> > similar to this on powerpc.
> 
> Do expand. What does exact information does it provide?

Basically we have three registers which provide various information about
the instruction which caused an event to overflow.

The first reports the address of the instruction, the second the data
address associated with the instruction, and the third reports "other
stuff".

We use the first for SAMPLE_IP, and the second for SAMPLE_ADDR, but
currently we have no way of spitting out the third register.

There's a whole bunch of info in there. I think the most interesting are
stuff like whether and where in the pipeline the instruction stalled, or
where a load was serviced from. I'm not sure to be honest, so I've asked
the HW guys what they're most interested in.

So I can imagine us coming up with a generic sample type for "sample
other info at event overflow", but I'm struggling to see how we'd make
the content of the sample non architecture specific, or even processor
version specific.

> > I've been telling people not to use PERF_SAMPLE_RAW because it provides
> > no way for the consumer to know what data they're getting, and it's not
> > extensible in any way.
> > 
> > So is shovelling things out using PERF_SAMPLE_RAW generally acceptable
> > for "advanced usage" scenarios?
> 
> No.

OK good, at least I was right about that :)

cheers





