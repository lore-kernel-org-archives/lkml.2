Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0HPIj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:39:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:14453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0HPIj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:39:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,375,1278313200"; 
   d="scan'208";a="545685386"
Subject: Re: perf, how to support multiple x86 hw pmus?
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <1281947113.1926.1004.camel@laptop>
References: <1281946154.6555.46.camel@minggr.sh.intel.com>
	 <1281947113.1926.1004.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 16:39:19 +0800
Message-ID: <1281947959.6555.56.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 16:25 +0800, Peter Zijlstra wrote:
> On Mon, 2010-08-16 at 16:09 +0800, Lin Ming wrote:
> > Hi, all
> > 
> > Here multiple x86 hw pmus means, for example, Intel "core" and "uncore"
> > pmu. "core" pmu is to collect per cpu data, cpu-cycles, branch-misses,
> > etc. "uncore" pmu is to collect per package data, L3 cache, Intel QPI,
> > integrated memory controller, etc.
> > 
> > I am going to add Intel uncore pmu support to perf. To reduce code
> > duplicate, "uncore" pmu should reuse most of the "core" pmu code. But
> > currently, the x86 core pmu code(arch/x86/kernel/cpu/perf_event.c) only
> > supports one pmu, with a definition as below.
> > 
> > static struct x86_pmu x86_pmu __read_mostly;
> > 
> > Many functions use above global definition "x86_pmu". It seems to me
> > that we need to re-structure x86 pmu code to support multiple hw pmus.
> > 
> > Any idea?
> 
> Yes, see my patch series http://lkml.org/lkml/2010/7/9/96 reworking the
> pmu interface.

Yes, I know that series.

> 
> After that and some patches adding per pmu contexts adding multiple
> hardware pmus should be simple.

I didn't see the per pmu contexts patches, are you still working on
them?

> 
> uncore should not share any code with the regular pmu, since they're
> mostly unrelated.

But should they share code like collect_events, schedule_events,
x86_perf_event_set_period(with some modification) etc...?


