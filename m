Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0ELIh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:37:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0ELIhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:37:55 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20100512055112.GA4691@linux-sh.org>
References: <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
	 <1273566031.30322.31.camel@minggr.sh.intel.com>
	 <1273567815.5605.3491.camel@twins>
	 <1273568620.30322.42.camel@minggr.sh.intel.com>
	 <1273569154.5605.3499.camel@twins>
	 <1273570845.30322.59.camel@minggr.sh.intel.com>
	 <1273571322.5605.3523.camel@twins>  <20100512055112.GA4691@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 May 2010 10:37:23 +0200
Message-ID: <1273653443.5605.3529.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 14:51 +0900, Paul Mundt wrote:
> On Tue, May 11, 2010 at 11:48:42AM +0200, Peter Zijlstra wrote:

> > No all the cpus would have the same event sources. I'm not sure if we
> > can make sysfs understand that though (added GregKH and Kay to CC).
> > 
> This is something I've been thinking about, too. On SH we have a
> large set of perf counter events that are entirely dependent on the
> configuration of the CPU they're on, with no requirement that these
> configurations are identical on all CPUs in an SMP configuration.
> 
> As an example, it's possible to halve the L1 dcache and use that part of
> it as a small and fast memory which has completely different events
> associated with it from the regular L1 dcache events. These events would
> be invalid on a CPU that was running with all cache ways enabled but
> might also be valid on other CPUs that bolt these events to an extra SRAM
> outside of the cache topology completely.
> 
> In any event, the events are at least consistent across all CPUs, it's
> only which ones are valid on a given CPU at a given time that can change.

So you're running with asymmetric SMP systems? I really hadn't
considered that. Will this change at runtime or is it a system boot time
thing?
