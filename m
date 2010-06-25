Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0FYLRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:17:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:37123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0FYLRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:17:44 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 13:16:29 +0200
Message-ID: <1277464589.32034.276.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 12:11 +0100, Will Deacon wrote:
> Hi Peter,
> 
> On Thu, 2010-06-24 at 15:28 +0100, Peter Zijlstra wrote:
> > These patches prepare the perf code for multiple pmus (no user
> > interface yet, Lin Ming is working on that). These patches remove all
> > weak functions and rework the struct pmu interface.
> > 
> > The patches are boot tested on x86_64 and compile tested on: powerpc
> > (!fsl, what config is that?), sparc and arm (sorry no SH compiler)
> > 
> 
> I tried to test these for ARM, but I get compilation errors. Maybe you
> forgot to enable perf in the ARM .config? Anyway, the compiler log is:
> 
>   CC      arch/arm/kernel/perf_event.o
> arch/arm/kernel/perf_event.c: In function 'validate_event':
> arch/arm/kernel/perf_event.c:342: error: 'pmu' undeclared (first use in this function)
> arch/arm/kernel/perf_event.c:342: error: (Each undeclared identifier is reported only once
> arch/arm/kernel/perf_event.c:342: error: for each function it appears in.)
> arch/arm/kernel/perf_event.c: In function 'armpmu_event_init':
> arch/arm/kernel/perf_event.c:536: warning: return makes integer from pointer without a cast
> arch/arm/kernel/perf_event.c: In function 'init_hw_perf_events':
> arch/arm/kernel/perf_event.c:3037: error: expected ';' before 'return'
> arch/arm/kernel/perf_event.c:3038: warning: no return statement in function returning non-void
> make[1]: *** [arch/arm/kernel/perf_event.o] Error 1
> make: *** [arch/arm/kernel] Error 2
> 
> I think there's a missing semicolon, an ERR_PTR that should be a PTR_ERR
> and an ordering issue with the pmu struct.

I seem to have lost a refresh before sending the emails, please check:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu

I pushed out updated patches there.
