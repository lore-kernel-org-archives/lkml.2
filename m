Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0H0PvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:51:22 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38253 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0H0PvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:51:20 -0400
X-SpamScore: 0
X-BigFish: VPS0(z3cfcs329eqzbb2cK1432N98dN179dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7TILH-02-2H7-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 17:48:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827154855.GQ22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
 <20100827081038.GF22783@erda.amd.com>
 <20100827134429.GS4879@redhat.com>
 <20100827140523.GM22783@erda.amd.com>
 <20100827150523.GT4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100827150523.GT4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.10 11:05:23, Don Zickus wrote:
> The status masks seem to be identical, 0x1 (and when I forced pmc0
> unusable, everything was 0x2).

So this should also happen if only one counter is running?
Back-to-back nmis actually only occur then 2 different counters
trigger simultaneously.

> > > Now I wonder how the event was
> > > ever reloaded, unless it was by accident because of how the scheduler
> > > deals with perf counters (perf_start/stop all the time).
> > 
> > The nmi might be queued be the cpu regardless of of the overflow
> > state.
> > 
> > I am wondering why this happens at all, because events are disabled by
> > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0). Hmm, maybe this is exactly the
> 
> Heh.  Not sure why it isn't working then.  Then again you shouldn't need
> the loop if it was working I would think.
> 
> > reason because the nmi could fire again after reenabling the counters.
> > 
> > Is there a reason for disabling all counters?
> 
> It would be a nice to have that way we wouldn't have to 'eat' all these
> extra nmis.  But I guess it isn't working correctly.

What about the erratum mentioned in this thread before? We might
identify affected cpus and return handled=2 for them. This solution
will be still better than before. And, all other cpu models have the
nmi detection fixed. In a next step we could try to use a timer for
detection.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

