Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab0JFSiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:38:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38505 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759683Ab0JFSiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:38:08 -0400
Date: Thu, 7 Oct 2010 03:38:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/7] perf: New helper function for pmu name
Message-ID: <20101006183801.GA13879@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org> <20101006181548.GU13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006181548.GU13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 08:15:48PM +0200, Robert Richter wrote:
> On 04.10.10 16:44:20, Matt Fleming wrote:
> > Introduce perf_pmu_name() helper function that returns the name of the
> > pmu. This gives us a generic way to get the name of a pmu regardless of
> > how an architecture identifies it internally, e.g. ARM uses an id
> > whereas SH currently uses a string.
> > 
> 
> Matt,
> 
> as an outcome of the discussion we have had in this thread I think we
> agree on the following:
> 
> We extend the generic perf interface with perf_pmu_name() implenting a
> default with the __weak attribute.  On sh we override this function
> and will use it for perf/oprofile string translation. This will be
> implemented in the oprofile function op_name_from_perf_name().
> 
> Later we implement a generic oprofile function that derives the
> cpu_type from perf_pmu_name() in a generic way and add other
> architectures. Thus, we will drop the ARM changes with this patch set.
> 
> Paul,
> 
> please correct me if I am wrong with the above.
> 
That all sounds fine to me, thanks for summarizing!
