Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1HAR6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1HAR60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:58:26 -0400
Date: Mon, 1 Aug 2011 12:38:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110801163823.GZ2581@redhat.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
 <1311958726.5890.411.camel@twins>
 <20110801053201.GY4590@erda.amd.com>
 <1312212103.2617.495.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312212103.2617.495.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 05:21:43PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-01 at 07:32 +0200, Robert Richter wrote:
> > > So IBS cannot trigger the whole unknown NMI business? Wouldn't ibs_op
> > > triggering while ibs_fetch just started latch the NMI line, the
> > > in-progress NMI would handle both, and we then end up with a spare NMI?
> > 
> > Ok, I will run some excessive testing of this. If this turns out to be
> > a problem I will change the code. Could this be on top of this patch
> > set then? 
> 
> Sure, if you somehow end up duplicating some logic I think you know
> about this common.c file you proposed ;-)
> 
> I kinda lost the current state of affairs wrt spurious NMIs, I think
> there's still a few reports out there. I recently read through some
> Intel errata and found the Intel PMU can send double PMIs under some
> circumstances (just to keep life interesting).

I tried looking into but everytime I applied workarounds for Intel errata
I wound up with more unknown NMIs and proving that a couple of them worked
(with trace_printks) seemed elusive.  I got frustrated and left it alone.

But yeah, Intel's perf has so many errata that I think if you kick the
box while running perf you can generate an unknown NMI.

> 
> I also haven't checked up on what the perf_event_nmi_handler() magic
> looks today, so I can't say if its a problem or not, but I thought I'd
> just mention it.

It hasn't changed much since Robert added his magic which handles the
majority of use cases for now.

Cheers,
Don
