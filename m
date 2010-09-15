Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0IOW1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:27:47 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:32729 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0IOW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:27:46 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8T7PD-01-CL7-02
X-M-MSG: 
Date: Thu, 16 Sep 2010 00:27:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100915222712.GU13563@erda.amd.com>
References: <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com>
 <20100915203948.GB28455@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915203948.GB28455@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 15, 2010 at 10:21:10PM +0200, Stephane Eranian wrote:
> > When you do perf record foo, it's equivalent to
> > perf record -e cycles:uk -F 1000 foo

Yes, thanks.

I am asking because I have observed up to 4 back-to-back nmis from the
same counter when enabling an event. The period is not yet adjusted.
We should avoid those short sampling periods in the beginning and
better start with too long periods. Didn't look at the implementation
so far. I know this is not easy to handle because this very much
depends on the event we measure.

Maybe we start the counter with a delay and then calculate period =
duration - delay, later decreasing the delay until the frequency is
adjusted but keeping the total sampling rate more or less constant.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

