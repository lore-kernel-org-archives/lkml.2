Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0EJLt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:49:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0EJLt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:49:56 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>
In-Reply-To: <20100510114311.GA6449@elte.hu>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins>  <20100510114311.GA6449@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 13:49:24 +0200
Message-ID: <1273492164.5605.3397.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 13:43 +0200, Ingo Molnar wrote:
> 
> Yeah, we really want a mechanism like this in place instead of continuing with 
> the somewhat ad-hoc extensions to the event enumeration space.
> 
> One detail: i think we want one more level. Instead of:
> 
>  /sys/devices/system/node/nodeN/node_events
>                                 node_events/event_source_id
>                                 node_events/local_misses
>                                            /local_hits
>                                            /remote_misses
>                                            /remote_hits
>                                            /...
> 
> We want the individual events to be a directory, containing the event_id:
> 
>  /sys/devices/system/node/nodeN/node_events
>                                 node_events/event_source_id
>                                 node_events/local_misses/event_id
>                                            /local_hits/event_id
>                                            /remote_misses/event_id
>                                            /remote_hits/event_id
>                                            /...
> 
> The reason is that we want to keep our options open to add more attributes to 
> individual events. (In fact extended attributes already exist for certain 
> event classes - such as the 'format' info for tracepoints.) 

Sure, sounds like a sensible suggestion.

One thing I'd also like to clarify is that !raw events should not be
exhaustive hardware event lists, those are best left for userspace, but
instead are generally useful events that can be expected to be
implemented by any hardware of that particular class.

So a GPU might have things like 'vsync' and 'cmd_pipeline_stall' or
whatever is a generic GPU feature, but not very implementation specific
things that the next generation of hardware won't ever have.


