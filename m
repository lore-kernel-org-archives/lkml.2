Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab0JFONy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:13:54 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60379 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab0JFONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:13:52 -0400
Date: Wed, 6 Oct 2010 23:13:47 +0900
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
Message-ID: <20101006141347.GA32376@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org> <20101006122736.GL13563@erda.amd.com> <20101006123950.GA29118@linux-sh.org> <20101006131825.GO13563@erda.amd.com> <20101006133041.GA29273@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006133041.GA29273@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 10:30:41PM +0900, Paul Mundt wrote:
> On Wed, Oct 06, 2010 at 03:18:25PM +0200, Robert Richter wrote:
> > I am not against adding the pmu name to the perf API. But the oprofile
> > cpu_type strings are oprofile centric esp. for the userland. So these
> > strings will remain part of oprofile. Also I don't think we want to
> > polute the perf pmu names with it.
> > 
> And those architectures that have opted to use different strings for perf
> events are free to mangle them however they want for the oprofile case.
> It doesn't change the fact that strings are still being managed by all of
> the architectures. The perf PMU names aren't presently locked in to an
> ABI, whereas the oprofile strings are, so it seems fairly straightforward
> to develop standard mangling rules for preventing an oprofile-facing
> string, or to simply reuse the strings verbatim.
> 
So to add a bit of context here, I was just looking at the oprofile
tools. The naming format here is one of:

	<arch>/<pmu>

if there were a generic perf to oprofile pmu name mangler that did this
it would cover almost all of the ARM cases already, the SH strings I'm
happy to convert to work this way, and a good chunk of the PowerPC PMUs
would work fine, too. PowerPC already has an oprofile CPU string in its
CPU spec, so this would be even more trivial to wire up there if such a
generic interface were to exist.

This would just leave x86 as the odd one out, but I suppose if x86 were
to move to the oprofile perf wrapper in the future then a bit of id to
name mangling as an override wouldn't be too much work.
