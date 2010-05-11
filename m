Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab0EKGuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:50:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:34575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0EKGup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:50:45 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE89CA8.3020801@linux.vnet.ibm.com>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins>  <4BE89CA8.3020801@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 08:50:16 +0200
Message-ID: <1273560616.5605.3429.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 16:54 -0700, Corey Ashford wrote:
> 
> Just to give a concrete example, the IBM Wire-Speed Processor has four
> AT-"nodes" per chip, each containing four PowerPC cores.
> 
> Those four nodes together share a number of nest PMU accelerators, I/O
> devices, buses etc. which each have their own PMUs.  Further adding to
> the structure is that some of the nodes are replicated.  For example,
> we have two memory controllers, each with a pair of PMUs.
> 
> /sys/devices/system/node/node0/mem_ctlr0/
>                                         event_source_id
>                                         events/
>                                               partial_cacheline_read_retried/
>                                               partial_cacheline_write_retried/
>                                               ...
>                                mem_ctlr1/
>                                         event_source_id
>                                         events/
>                                               partial_cacheline_read_retried/
>                                               ...
> 
> So it's a bit ugly to replicate the event information across identical
> pmus, but that can be done via links, without too much memory cost, I
> assume.
> 
> Does this seem workable? 

If you really have two memory controllers per node, I guess so. Sounds
strange to me though, typically a memory controller is the node
boundary.

But like I said in the other email, use a 1:n pmu:event_source ratio and
simply stick then in the machine/device topology wherever they belong,
if that ends up with multiple PMUs at one particular level, so be it.


