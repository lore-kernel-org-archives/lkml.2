Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0LNONU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:13:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33521 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0LNONT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:13:19 -0500
Date: Tue, 14 Dec 2010 15:13:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@linux.ibm.com>
Subject: Re: [RFC PATCH 3/3 v3] perf: Update perf tool to monitor uncore
 events
Message-ID: <20101214141314.GC21257@basil.fritz.box>
References: <1291267238.2405.315.camel@minggr.sh.intel.com>
 <4D06C846.4030804@linux.vnet.ibm.com>
 <1292292908.10384.137.camel@minggr.sh.intel.com>
 <1292330007.6803.1629.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292330007.6803.1629.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:33:27PM +0100, Peter Zijlstra wrote:
> > > First of all, "uncore" is an x86-specific term and so it's not clear to 
> > > me if you meant for all arches to utilize this encoding for all "not 
> > > core but on the same die" events (IBM Power arch refers to this as 
> > > "nest" logic).
> 
> I don't think the x86 uncore matches the "not on core but on the same
> die" definition. The x86-uncore thing is more like a memory controller
> PMU (and since the memory controller is on die it is of course on die,

memory controller + interconnect + cache + power management + various other things.

Older x86 CPUs also had special PMUs on die for parts of that, but
without memory controller.

> but its not just any random on-die thing).
> 
> The wire-speed thing has tons of special purpose 'cores' on die, each of
> them having a PMU.

Modern x86 CPUs also have other PMUs, at least in package (e.g. in the 
GPU) 

> Using the sysfs stuff you could actually expose each individually.

I expect this will be also needed on x86. Also there are x86 SOCs
where other parts of the SOC will have their own counters too.
So in general a flexible scheme to describe that is useful.

-Andi
