Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0JBJgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 05:36:50 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:35685
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab0JBJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 05:36:48 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9NPB0-01-1M9-02
X-M-MSG: 
Date: Sat, 2 Oct 2010 11:35:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20101002093524.GJ13563@erda.amd.com>
References: <20100929154528.GD9440@lenovo>
 <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
 <20100929170924.GR13563@erda.amd.com>
 <20100929181207.GW26290@redhat.com>
 <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
 <20100930091246.GV13563@erda.amd.com>
 <20100930194451.GI26290@redhat.com>
 <20101001071750.GB13563@erda.amd.com>
 <AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
 <AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.10.10 07:53:37, Stephane Eranian wrote:

> That's another issue I have with this NMI callchain logic. It is hard to tell
> who's in front of who in each callchain. You may have two registered users
> at the same priority, the one which registers last gets priority.
> 
> We may not want perf_event to run at the lowest priority because it is
> performance sensitive, remember that the counters are running until
> you get to the handler. Unlike many of the other subsystems on the
> call chain perf_event is doing performance monitoring not debugging.
> The rate of calls on the chain is now very high.

Yes, actually the perf handler should run with the highest priority to
reduce overhead when executing the handler chain. As this will cause
implications to other handlers I think the most promising approach
will be Andi's suggestion to separate the nmi handlers from the die
chain by adding a new one. We should consider this when reworking the
die handler (cc'ing Huang).

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

