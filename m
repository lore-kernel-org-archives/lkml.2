Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0GAQE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:04:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49077 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab0GAQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:04:57 -0400
Date: Thu, 1 Jul 2010 17:04:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, paulus <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
Message-ID: <20100701160456.GB13511@console-pimps.org>
References: <20100624142804.431553874@chello.nl> <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com> <1277464589.32034.276.camel@twins> <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com> <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop> <1277996555.1917.205.camel@laptop> <20100701153112.GA13511@console-pimps.org> <1277998793.1917.212.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277998793.1917.212.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:39:53PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-01 at 16:31 +0100, MattFleming wrote:
> > On Thu, Jul 01, 2010 at 05:02:35PM +0200, Peter Zijlstra wrote:
> > >
> > > Which made me think, what on SH guarantees we update the counter often
> > > enough not to suffer from counter wrap? Would it make sense to make the
> > > SH code hook into their arch tick handler and update the counters from
> > > there?
> > 
> > This was the way that the oprofile code used to work. Paul and I were
> > talking about using a hrtimer to sample performance counters as
> > opposed to piggy-backing on the tick handler.
> 
> Ah, for sampling for sure, simply group a software perf event and a
> hardware perf event together and use PERF_SAMPLE_READ.
> 
> But suppose its a non sampling counter, how do you avoid overflows of
> the hardware register?

Hmm.. good question! I'm not entirely sure we do. As you were saying,
without using the arch tick handler, I don't think we can guarantee
avoiding counter overflows. Currently the counters are chained such
that the counters are at least 48 bits. I guess all my tests were
short enough to not cause the counters to wrap ;-)

At some point we will want to not require chaining, giving us 32
bits. So yeah, this is issue is gonna crop up then. Interestingly, the
counters on SH don't wrap when they reach they're maximum value, they
just stop incrementing.
