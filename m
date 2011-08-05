Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1HEJ4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:56:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1HEJ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:56:17 -0400
Date: Fri, 5 Aug 2011 11:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110805095519.GC2420@elte.hu>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
 <1311958726.5890.411.camel@twins>
 <20110801053201.GY4590@erda.amd.com>
 <1312212103.2617.495.camel@laptop>
 <20110801163823.GZ2581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801163823.GZ2581@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Mon, Aug 01, 2011 at 05:21:43PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-01 at 07:32 +0200, Robert Richter wrote:
> > > > So IBS cannot trigger the whole unknown NMI business? Wouldn't ibs_op
> > > > triggering while ibs_fetch just started latch the NMI line, the
> > > > in-progress NMI would handle both, and we then end up with a spare NMI?
> > > 
> > > Ok, I will run some excessive testing of this. If this turns out to be
> > > a problem I will change the code. Could this be on top of this patch
> > > set then? 
> > 
> > Sure, if you somehow end up duplicating some logic I think you 
> > know about this common.c file you proposed ;-)
> > 
> > I kinda lost the current state of affairs wrt spurious NMIs, I 
> > think there's still a few reports out there. I recently read 
> > through some Intel errata and found the Intel PMU can send double 
> > PMIs under some circumstances (just to keep life interesting).
> 
> I tried looking into but everytime I applied workarounds for Intel 
> errata I wound up with more unknown NMIs and proving that a couple 
> of them worked (with trace_printks) seemed elusive.  I got 
> frustrated and left it alone.
> 
> But yeah, Intel's perf has so many errata that I think if you kick 
> the box while running perf you can generate an unknown NMI.

Hence the only sane approach is to just tolerate spurious NMIs and 
only annoy the user with them if there's *way* too many of them or 
so.

Thanks,

	Ingo
