Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2IYL5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:57:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47862 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2IYL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:57:16 -0400
Date: Tue, 25 Sep 2012 13:57:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf/x86: Intel uncore_pmu_to_box() local variable typo
Message-ID: <20120925115711.GB25264@gmail.com>
References: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
 <1348572025.3881.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348572025.3881.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2012-09-25 at 12:44 +0200, Stephane Eranian wrote:
> > Hi,
> > 
> > I don't understand why the local variable box needs to
> > be declared static here:
> > 
> > static struct intel_uncore_box *
> > uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
> > {
> >         static struct intel_uncore_box *box;
> > 
> >         box = *per_cpu_ptr(pmu->box, cpu);
> >         if (box)
> >                 return box;
> >         ....
> > }
> 
> Uhmm.. me neither.. that looks like a bug indeed.

the compiler (or Sparse) should refuse function local statics 
really.

Thanks,

	Ingo
