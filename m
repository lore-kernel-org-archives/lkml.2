Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0HTIuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:50:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0HTIuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:50:35 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100819215803.GZ4879@redhat.com>
References: <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com>
	 <1282214753.1926.4669.camel@laptop> <20100819141240.GO4879@redhat.com>
	 <1282228033.2605.204.camel@laptop>  <20100819215803.GZ4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 10:50:16 +0200
Message-ID: <1282294216.2605.664.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 17:58 -0400, Don Zickus wrote:
> On Thu, Aug 19, 2010 at 04:27:13PM +0200, Peter Zijlstra wrote:
> >  		x86_pmu.drain_pebs(regs);
> > +	}
> >  
> >  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
> >  		struct perf_event *event = cpuc->events[bit];
> >  
> > +		handled++;
> > +
> >  		if (!test_bit(bit, cpuc->active_mask))
> >  			continue;
> 
> Sorry I didn't notice this earlier, but I think you want that handled++
> after the if(..) continue pieces.  Otherwise you will always have a number
> >1. :-)

Only if there's any remaining set bits in the overflow status reg,
right?

But if we want to be paranoid, we should also check if the event that
generated the overflow actually had the INT flag enabled, I guess ;-)
