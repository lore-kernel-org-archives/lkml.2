Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab0HLNYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:24:34 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4137 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760107Ab0HLNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:24:32 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3cfcs329eqz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L71JWH-02-61W-02
X-M-MSG: 
Date: Thu, 12 Aug 2010 15:24:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100812132419.GX26154@erda.amd.com>
References: <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100809200245.GF6056@lenovo>
 <20100810074200.GE26154@erda.amd.com>
 <20100810161627.GB6893@lenovo>
 <20100810164124.GK26154@erda.amd.com>
 <20100810172451.GD6893@lenovo>
 <20100810190541.GN26154@erda.amd.com>
 <20100810192428.GE6893@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100810192428.GE6893@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.10 15:24:28, Cyrill Gorcunov wrote:
> On Tue, Aug 10, 2010 at 09:05:41PM +0200, Robert Richter wrote:
> > On 10.08.10 13:24:51, Cyrill Gorcunov wrote:
> > 
> > > It gets masked on NMI arrival, at least for some models (Core Duo, P4,
> > > P6 M and I suspect more theh that, that was the reason oprofile has
> > > it, also there is a note in SDM V3a page 643).
> > 
> > Yes, that's right, I never noticed that. Maybe it is better to
> > implement the apic write it in model specific code then.
> > 
> 
> Perhaps we can make it simplier I think, ie like it was before -- we just
> move it under your new DIE_NMIUNKNOWN, in separate patch of course. Though
> I'm fine with either way.

I do not understand why you want to put this in the 'unknown'
path. Isn't it necessary to unmask the vector with every call of the
nmi handler?

-Robert

> 
> (actually it's interesting to know wouldn't we leave lvt masked when
>  we hit 'second delayed nmi has arrived' situation, I guess we didn't
>  hit it before in real yet :-)
> 
> > -Robert
> > 
> > -- 
> > Advanced Micro Devices, Inc.
> > Operating System Research Center
> > 
> 	-- Cyrill
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

