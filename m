Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2IYLUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:20:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IYLUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:20:37 -0400
Message-ID: <1348572025.3881.17.camel@twins>
Subject: Re: [BUG] perf/x86: Intel uncore_pmu_to_box() local variable typo
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Date: Tue, 25 Sep 2012 13:20:25 +0200
In-Reply-To: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
References: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 12:44 +0200, Stephane Eranian wrote:
> Hi,
> 
> I don't understand why the local variable box needs to
> be declared static here:
> 
> static struct intel_uncore_box *
> uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
> {
>         static struct intel_uncore_box *box;
> 
>         box = *per_cpu_ptr(pmu->box, cpu);
>         if (box)
>                 return box;
>         ....
> }

Uhmm.. me neither.. that looks like a bug indeed.
