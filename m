Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0GAPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:40:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab0GAPkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:40:04 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Will Deacon <will.deacon@arm.com>, paulus <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100701153112.GA13511@console-pimps.org>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop>
	 <1277996555.1917.205.camel@laptop>
	 <20100701153112.GA13511@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 17:39:53 +0200
Message-ID: <1277998793.1917.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:31 +0100, MattFleming wrote:
> On Thu, Jul 01, 2010 at 05:02:35PM +0200, Peter Zijlstra wrote:
> > 
> > Matt, you said it broke SH completely, but did you try perf stat? perf
> > record is not supposed to work on SH due to the hardware not having an
> > overflow interrupt.
> 
> perf record does work to some degree. It definitely worked before
> applying your changes but not after. I admit I haven't really read the
> perf event code, but Paul will know.

Ok, let me look at that again.

> > Which made me think, what on SH guarantees we update the counter often
> > enough not to suffer from counter wrap? Would it make sense to make the
> > SH code hook into their arch tick handler and update the counters from
> > there?
> 
> This was the way that the oprofile code used to work. Paul and I were
> talking about using a hrtimer to sample performance counters as
> opposed to piggy-backing on the tick handler.

Ah, for sampling for sure, simply group a software perf event and a
hardware perf event together and use PERF_SAMPLE_READ.

But suppose its a non sampling counter, how do you avoid overflows of
the hardware register?
