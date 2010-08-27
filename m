Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0H0PFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab0H0PFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:05:52 -0400
Date: Fri, 27 Aug 2010 11:05:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827150523.GT4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
 <20100827081038.GF22783@erda.amd.com>
 <20100827134429.GS4879@redhat.com>
 <20100827140523.GM22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827140523.GM22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 04:05:23PM +0200, Robert Richter wrote:
> > What is funny is that this problem was masked by the
> > perf_event_nmi_handler swallowing all the nmis.  I wonder if we were
> > losing events as a result of this bug too because if you think about it,
> > we processed the first event, a second event came in and we accidentally
> > ack'd it, thus dropping it on the floor.
> 
> Yes, this could be the case, but only for handled counters. So it
> would be interesting to see for this case the status mask of the
> current and previous get_status call.

The status masks seem to be identical, 0x1 (and when I forced pmc0
unusable, everything was 0x2).

> 
> > Now I wonder how the event was
> > ever reloaded, unless it was by accident because of how the scheduler
> > deals with perf counters (perf_start/stop all the time).
> 
> The nmi might be queued be the cpu regardless of of the overflow
> state.
> 
> I am wondering why this happens at all, because events are disabled by
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0). Hmm, maybe this is exactly the

Heh.  Not sure why it isn't working then.  Then again you shouldn't need
the loop if it was working I would think.

> reason because the nmi could fire again after reenabling the counters.
> 
> Is there a reason for disabling all counters?

It would be a nice to have that way we wouldn't have to 'eat' all these
extra nmis.  But I guess it isn't working correctly.

Cheers,
Don
