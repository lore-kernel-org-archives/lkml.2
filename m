Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0IOR2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:28:43 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:43237 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0IOR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:28:41 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8STUR-01-4EC-02
X-M-MSG: 
Date: Wed, 15 Sep 2010 19:28:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100915172805.GR13563@erda.amd.com>
References: <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <20100915164610.GA5959@lenovo>
 <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com>
 <20100915170222.GB5959@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915170222.GB5959@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.09.10 13:02:22, Cyrill Gorcunov wrote:
> > what's for sure, is that you can have an interrupt in flight by the time
> > you disable.
> > 
> 
> I fear you can x86_pmu_stop()
> 
> 	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
> 
> --->		active_mask will be cleared here for sure
> --->		but counter still ticks, say nmi happens active_mask
> --->		is cleared, but NMI can still happen and gets buffered
> --->		before you disable counter in real
> 
> 		x86_pmu.disable(event);
> 		cpuc->events[hwc->idx] = NULL;
> 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
> 		hwc->state |= PERF_HES_STOPPED;
> 	}
> 
> No?

I tried reordering this too, but it didn't fix it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

