Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1GFN7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:59:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:53494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1GFN67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:58:59 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
In-Reply-To: <20110705230217.GA9584@bloggs.ozlabs.ibm.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309768420.3282.8.camel@twins> <1309769066.3282.14.camel@twins>
	 <1309867418.3282.73.camel@twins>
	 <20110705230217.GA9584@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Jul 2011 15:58:38 +0200
Message-ID: <1309960718.3282.289.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 09:02 +1000, Paul Mackerras wrote:
> On Tue, Jul 05, 2011 at 02:03:38PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-07-04 at 10:44 +0200, Peter Zijlstra wrote:
> > > Anton, Paulus, IIRC PowerPC had some sort of Data-Source indication,
> > > would you have some docs available on the PowerPC PMU?
> > 
> > Going through
> > http://www.power.org/resources/downloads/PowerISA_V2.06B_V2_PUBLIC.pdf
> > 
> > Book III-S, Appendix B
> > 
> > I can only find the SDAR thing (which I assume is what PERF_SAMPLE_DATA
> > uses) but no mention of extra bits describing where the data was sourced
> > from. For some reason I had the impression PPC64 had the capability to
> > tell if a load/store was from/to L1/2/3/DRAM etc.
> > 
> > Now since the above document is in fact not an exhaustive spec of a
> > particular chip but more an outline of what a regular ppc64 chip should
> > have, with lots of room for implementation specific extensions it
> > doesn't say much at all.
> > 
> > So do you know of such a feature for PPC64 and if so, where's the
> > docs? :-)
> 
> Unfortunately the P7 PMU documentation is not available publicly yet. :(

Are the P6/P6+ PMU docs? That at least would give me something to look
at.

> There are events that can be used to count how many times data or
> instructions get loaded from different places in the memory
> subsystem.  There are 15 separate DATA_FROM_xxx events, for instance,
> that count things like "number of times data was loaded from L2 or L3
> cache on another chip and the cache line was in shared state".
> They're great if you want fine detail on memory traffic but perhaps
> not so good if you want a broad overview (there are separate events
> for L1 and L2 accesses and misses though).
> 
> I've attached a table of P7 PMU events.  Look for the PM_DATA_FROM_xxx
> and PM_INST_FROM_xxx events.

Ok, so those are regular events and perf covers that capability.

The thing we're talking about is Intel PEBS Load Latency/Precise Store
and AMD IBS where together with a mem op retired event (mem loads
retired for Load-Latency, mem stores retired for Precise Store) provides
an additional field describing where the load/store was sourced from.

Such additional data would require the addition of a PERF_SAMPLE_SOURCE
field or similar, for some reason or other I was under the impression
some of the PPC chips had something similar. But if not, it saves us
having to worry about that.
