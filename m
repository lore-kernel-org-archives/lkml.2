Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2ILOiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:38:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:53633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985Ab2ILOiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:38:50 -0400
Message-ID: <1347460719.15764.42.camel@twins>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 12 Sep 2012 16:38:39 +0200
In-Reply-To: <CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-2-git-send-email-eranian@google.com>
	 <1347459984.15764.34.camel@twins>
	 <CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:33 +0200, Stephane Eranian wrote:

> 
> If I do:
>   for_each_possible_cpu(cpu) {
>        cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
>        hr = &cpuctx->hrtimer;
>        hrtimer_init(hr)
> }
> I don't understand why I would have to refer to per-cpu data
> (hrtimer_bases) from
> a CPU that is not equal to "cpu" here. Unless you're telling me it's
> read-only data.

No its not read only, but it is unused until you do *hrtimer_start*(),
which will test and fix.

> But still if it's per-cpu why not initialize with the correct CPU from
> the start?

To keep the interface simpler I guess. There's no great harm in your
proposal, but it is strictly speaking superfluous. I'm not sure the max
one time avoidance of a base swizzle is worth the extra interface, I'll
leave that up to Thomas.

Also, what Eric said ;-)
