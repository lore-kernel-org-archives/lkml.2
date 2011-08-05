Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1HENsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1HENsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:48:05 -0400
Date: Fri, 5 Aug 2011 09:47:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110805134748.GK1972@redhat.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
 <1311958726.5890.411.camel@twins>
 <20110801053201.GY4590@erda.amd.com>
 <1312212103.2617.495.camel@laptop>
 <20110801163823.GZ2581@redhat.com>
 <20110805095519.GC2420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805095519.GC2420@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 11:55:19AM +0200, Ingo Molnar wrote:
> > I tried looking into but everytime I applied workarounds for Intel 
> > errata I wound up with more unknown NMIs and proving that a couple 
> > of them worked (with trace_printks) seemed elusive.  I got 
> > frustrated and left it alone.
> > 
> > But yeah, Intel's perf has so many errata that I think if you kick 
> > the box while running perf you can generate an unknown NMI.
> 
> Hence the only sane approach is to just tolerate spurious NMIs and 
> only annoy the user with them if there's *way* too many of them or 
> so.

That may work if we can determine if the user is running perf or not.  But
on older systems (like pre-Nehalem), sometimes the only way a system can
signal a platform error is through a single unknown NMI.  I would be
afraid we might lose one of those if we 'tolerate' unknown NMIs.

So far I have only noticed perf generating 'unknown NMIs' on high volume
usage (like multiple counters).  For the casual user it has been ok so
far.

Cheers,
Don
