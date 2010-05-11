Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab0EKGsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:48:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:52106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0EKGsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:48:03 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
In-Reply-To: <4BE8931C.9070106@linux.vnet.ibm.com>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 08:46:59 +0200
Message-ID: <1273560419.5605.3426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 16:13 -0700, Corey Ashford wrote:

> Having extra fields for each event would allow us to describe hardware-specific event attributes.  For example:
> /sys/devices/system/node/nodeN/node_events
>                                node_events/event_source_id
>                                node_events/local_misses/event_id
>                                           /local_hits/event_id
>                                           /crypto_datamover  <- specific node PMU
>                                               /marked_crb_rcv_des
>                                                   /event_id
>                                                   /attrib
>                                                          /lpid <- attribute name
>                                                          /lpid/type <- type of attribute (boolean, integer, etc.)
>                                                          /lpid/min  <- min value of int attribute
>                                                          /lpid/max  <- max value of int attribute
>                                                          /lpid/bit_offset <- amount to shift attribute value before OR'ing into the raw event code
>                                                          /marking_mode <- attribute name
>                                                          /marking_mode/type
>                                                          /...
> 
> Of course, these nodes would need to be replicated for each event that needs them or other attributes.

I would suggest having a 1:n pmu:event_source ratio, not the other way
around. So in your example above the crypto_datamover PMU thingy would
get its own event_source(s), which get placed at whatever place in the
machine topology they live. If that happens to be at the node level,
place them there.

> >> Sure, sounds like a sensible suggestion.
> >>
> >> One thing I'd also like to clarify is that !raw events should not be 
> >> exhaustive hardware event lists, those are best left for userspace, but 
> >> instead are generally useful events that can be expected to be implemented 
> >> by any hardware of that particular class.
> 
> Why exactly is this?  I got the impression this was something you and
> Ingo wanted earlier.  As big of an impact as it will be, it would be
> nice to unify the two event spaces (generic and raw) into one space
> that can be explored by a user space tool (or even crudely
> by /bin/ls).

No we want generic event spaces that have events that are generally
applicable to a whole class of PMUs, so say to all CPU PMUs, or all GPU
PMUs or all PCI-bridge PMUs.

What we do not want are exhaustive event lists for specific PMU
implementations, those are best left for userspace.

I'll let Ingo answer your other question.
