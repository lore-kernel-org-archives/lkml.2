Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0GAPbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:31:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39801 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171Ab0GAPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:31:13 -0400
Date: Thu, 1 Jul 2010 16:31:12 +0100
From: MattFleming <matt@console-pimps.org>
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
Message-ID: <20100701153112.GA13511@console-pimps.org>
References: <20100624142804.431553874@chello.nl> <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com> <1277464589.32034.276.camel@twins> <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com> <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop> <1277996555.1917.205.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277996555.1917.205.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:02:35PM +0200, Peter Zijlstra wrote:
> 
> Matt, you said it broke SH completely, but did you try perf stat? perf
> record is not supposed to work on SH due to the hardware not having an
> overflow interrupt.

perf record does work to some degree. It definitely worked before
applying your changes but not after. I admit I haven't really read the
perf event code, but Paul will know.

> Which made me think, what on SH guarantees we update the counter often
> enough not to suffer from counter wrap? Would it make sense to make the
> SH code hook into their arch tick handler and update the counters from
> there?

This was the way that the oprofile code used to work. Paul and I were
talking about using a hrtimer to sample performance counters as
opposed to piggy-backing on the tick handler.
