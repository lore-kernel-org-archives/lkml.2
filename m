Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0HYVVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:21:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab0HYVVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:21:02 -0400
Date: Wed, 25 Aug 2010 17:20:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100825212037.GI4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
 <20100825110006.GB27891@elte.hu>
 <20100825201106.GH4879@redhat.com>
 <20100825202458.GE14874@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825202458.GE14874@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 12:24:58AM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 25, 2010 at 04:11:06PM -0400, Don Zickus wrote:
> ...
> > >  Uhhuh. NMI received for unknown reason 00 on CPU 15.
> > >  Do you have a strange power saving mode enabled?
> > >  Dazed and confused, but trying to continue
> > 
> > So I found a Nehalem box that can reliably reproduce Ingo's problem using
> > something as simple 'perf top'.  But like above, I am noticing the
> > samething, an extra NMI(PMI??) that comes out of nowhere.
> > 
> > Looking at the data above the delta between nmis is very small compared to
> > the other nmis.  It almost suggests that this is an extra PMI.
> > Considering there is already two cpu errata discussing extra PMIs under
> > certain configurations, I wouldn't be surprised if this was a third.
> > 
> > Cheers,
> > Don
> > 
> 
> Oh. I'm not sure if it would be a good idea at all but maybe we could
> use kind of Robert's idea about "pmu nmi relaxing time" ie some time
> slice in which we treat nmi's as being from pmu, but not arbitrary number
> but equal to the number of PMI turned off. Say we handle NMI and found
> that 4 events are overflowed, we clear them, arm timer and wait for
> 3 unknow nmis to happen, if they are not happening during some time
> period we clear this waitqueue, if they happen or partially happen
> - we destroy the timer. Ie almost the same as Robert's idea but
> without tsc? Just a thought.

The only problem is only one counter is overflowing in these cases, so we
would have to do it all the time, which may not be hard.  But I was
thinking of something similar.

For now, I am trying to force counter0 off, seeing that most of the perf
errata on nehalem have been on counter0.  Or maybe I can get 'perf top' to
use something other than counter0 by running 'perf record' first?

Cheers,
Don

> 
> 	-- Cyrill
