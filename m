Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0FYLL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:11:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55636 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501Ab0FYLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:11:55 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624142804.431553874@chello.nl>
References: <20100624142804.431553874@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 12:11:28 +0100
Message-ID: <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2010 11:11:32.0044 (UTC) FILETIME=[2AA640C0:01CB1457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, 2010-06-24 at 15:28 +0100, Peter Zijlstra wrote:
> These patches prepare the perf code for multiple pmus (no user
> interface yet, Lin Ming is working on that). These patches remove all
> weak functions and rework the struct pmu interface.
> 
> The patches are boot tested on x86_64 and compile tested on: powerpc
> (!fsl, what config is that?), sparc and arm (sorry no SH compiler)
> 

I tried to test these for ARM, but I get compilation errors. Maybe you
forgot to enable perf in the ARM .config? Anyway, the compiler log is:

  CC      arch/arm/kernel/perf_event.o
arch/arm/kernel/perf_event.c: In function 'validate_event':
arch/arm/kernel/perf_event.c:342: error: 'pmu' undeclared (first use in this function)
arch/arm/kernel/perf_event.c:342: error: (Each undeclared identifier is reported only once
arch/arm/kernel/perf_event.c:342: error: for each function it appears in.)
arch/arm/kernel/perf_event.c: In function 'armpmu_event_init':
arch/arm/kernel/perf_event.c:536: warning: return makes integer from pointer without a cast
arch/arm/kernel/perf_event.c: In function 'init_hw_perf_events':
arch/arm/kernel/perf_event.c:3037: error: expected ';' before 'return'
arch/arm/kernel/perf_event.c:3038: warning: no return statement in function returning non-void
make[1]: *** [arch/arm/kernel/perf_event.o] Error 1
make: *** [arch/arm/kernel] Error 2

I think there's a missing semicolon, an ERR_PTR that should be a PTR_ERR
and an ordering issue with the pmu struct.

Cheers,

Will

