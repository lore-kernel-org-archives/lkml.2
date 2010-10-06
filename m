Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab0JFP5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:57:12 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40061 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245Ab0JFP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:57:10 -0400
Date: Thu, 7 Oct 2010 00:57:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
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
Message-ID: <20101006155704.GB10220@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org> <20101006122736.GL13563@erda.amd.com> <20101006123950.GA29118@linux-sh.org> <20101006131825.GO13563@erda.amd.com> <20101006133041.GA29273@linux-sh.org> <20101006155026.GT13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006155026.GT13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 05:50:26PM +0200, Robert Richter wrote:
> On 06.10.10 09:30:41, Paul Mundt wrote:
> > On Wed, Oct 06, 2010 at 03:18:25PM +0200, Robert Richter wrote:
> > > So, I am also fine with implementing a generic perf_pmu_name() for sh
> > > and then derive the oprofile cpu_type string from it in the oprofile
> > > code.
> > > 
> > Again, this is unacceptable.
> 
> Paul,
> 
> maybe I misunderstood you, but isn't this you preferred solution? We
> make perf_pmu_name() part of the generic i/f and then derive the
> oprofile name from the pmu name provided by perf.
> 
Perhaps we've misunderstood each other. I thought what you meant is that
we would carry a special API deviation in the architecture code or expose
the sh_pmu structure to generic code, both of which I have no interest
in. My preferred solution is that we provide a perf_pmu_name() in the
generic perf code as a __weak and then override it in the sh code, where
we have sh_pmu visibility. This way we aren't providing any special APIs
and sh_pmu remains constrained to the sh perf events code.
