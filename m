Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2I1J2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:28:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:57274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2I1J2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:28:31 -0400
Message-ID: <1348824500.3292.66.camel@twins>
Subject: Re: [PATCH 01/31] perf, x86: Add PEBSv2 record support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 11:28:20 +0200
In-Reply-To: <CABPqkBS1Crg7yHbzrvF7S2YUjrPZNSYRpE7tuax+OcEu4xrHMA@mail.gmail.com>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-2-git-send-email-andi@firstfloor.org>
	 <1348821784.3292.50.camel@twins>
	 <CABPqkBS1Crg7yHbzrvF7S2YUjrPZNSYRpE7tuax+OcEu4xrHMA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 10:54 +0200, Stephane Eranian wrote:
> On Fri, Sep 28, 2012 at 10:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> >> +               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
> >
> > Shouldn't that be: && x86_pmu.intel_cap.pebs_trap, like most other sites
> > instead? Or didn't they flip the trap capability on Haswell?
> 
> On Haswell, you get the event_ip which points to the sampled
> instruction, i.e., the off-by-one
> error can be avoided by using that value instead of pebs.rip. The nice
> side effect is that you
> free the LBR and minimize the overhead (no fixups). Therfore the LBR
> filter can have any
> setting when combined with PEBS, thus we do not need to check for
> compatibility nor force
> any setting for the LBR filter.

Yes I got that, but what good is that trap capability flag if they don't
use it? Them adding a second u64 to the format to report it seems to
suggest their trap capability is pointless, but nowhere has this been
explained.
