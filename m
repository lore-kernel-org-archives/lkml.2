Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731Ab0CPJkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:40:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab0CPJku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:40:50 -0400
Date: Tue, 16 Mar 2010 10:40:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
Message-ID: <20100316094037.GF7961@elte.hu>
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
 <4B8FFE55.5070008@linux.vnet.ibm.com>
 <20100311124608.GG31354@elte.hu>
 <4B993AAF.9050507@linux.vnet.ibm.com>
 <20100311191441.GA7593@elte.hu>
 <4B99568D.30608@linux.vnet.ibm.com>
 <4B9EC50E.80702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9EC50E.80702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> On 3/11/2010 12:46 PM, Corey Ashford wrote:
> >
> >
> >On 3/11/2010 11:14 AM, Ingo Molnar wrote:
> >>
> >>* Corey Ashford<cjashfor@linux.vnet.ibm.com> wrote:
> >[snip]
> >>>I'm not sure how that would work. The issue I am trying to solve
> >>>here is that Power arch chips have a large number of very
> >>>hardware-specific events that are not generalizable. Many of these
> >>>events not only have names, but other user-configurable bits as well
> >>>that select or narrow the scope of which exact events are recorded.
> >>>This issue is dealt with nicely in libpfm4, as it has mechanisms for
> >>>parsing event names and attributes (aka modifiers or unit masks),
> >>>and then produces a usable config field for the perf_events_attr
> >>>struct.
> >>>
> >>>Should I take it from the above that you are completely against the
> >>>idea of using an external library for hardware-specific event and
> >>>attribute naming?
> >>
> >>Could you give a few relevant examples of events in question, and the
> >>kind of
> >>configurability/attributes they have on Power?
> >
> >Here are a few examples for the Power A2 processor. I've distorted the
> >names because PMU architecture isn't publicly released yet.
> >
> >PM_DE_PMC_9:hrd_mask=0xff:hrd=0x22:pma_mask=0x3fff:pma=0x1b2d:culling_mode=3
> >
> >PM_EX_0x03:lane=2:vlane=1
> >PM_OWE_ENG_MAC_FULL:usu=3
> 
> Just a follow-up note to this...
> 
> I learned that the much of the high-level architecture of the new
> chip that IBM is working on has been publicly released recently, so
> I have "undistorted" the event names below:
> 
> PM_DC_PMC_9:lpid_mask=0xff:lpid=0x22:pid_mask=0x3fff:pid=0x1b2d:marking_mode=3
> PM_REGX_0x03:lane=2:vlane=1
> PM_XML_ENG_MAC_FULL:sus=3
> 
> 
> DC = Decompression/Compression accelerator
> PMC_9 = Peformance monitoring event 9
> REGX = Regular eXpression accelerator
> XML = XML parsing accelerator
> pid = process id to match
> pid_mask = process id match mask
> lpid = logical partition id
> lpid_mask = logical partition id mask
> sus = source unit select
> lane, vlane = signal routing fields
> marking_mode = used to determine which accelerator work units to
> mark for performance monitoring

Are these special-purpose instructions for compression/regex/xml-parsing 
speedups?

I think it would be rather useful to merge the hw (and sw) perf events with 
the ftrace/tracepoints symbolic events space. That would be a one-stop-shop 
for both perf and other tools to figure out the events we offer, their 
characteristics, format, relationship to other events, etc.

	Ingo
