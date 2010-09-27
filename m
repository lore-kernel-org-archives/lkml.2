Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab0I0WfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:35:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:36006 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab0I0WfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:35:20 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9FG2K-01-ECB-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 00:35:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
Message-ID: <20100927223507.GW13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-4-git-send-email-ying.huang@intel.com>
 <20100927094136.GB32222@erda.amd.com>
 <AANLkTimTg1uqXdAJ+GyZ3_B6n2xKWdqFL96jvv18JBM+@mail.gmail.com>
 <20100927132537.GO13563@erda.amd.com>
 <20100927152916.GZ26290@redhat.com>
 <20100927174057.GU13563@erda.amd.com>
 <20100927191433.GG26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100927191433.GG26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 15:14:33, Don Zickus wrote:
> Actually, looking through the handlers, by introducing priorities means
> that people have to register multiple handlers to deal with the different
> priorities.
> 
> For example, perf would need two handlers, one for DIE_NMI and one for
> DIE_NMIUNKOWN.  I am not sure that is the way to go.

Ok, this could be a problem for handlers dealing with both DIE_NMI and
DIE_NMI_UNKNOW. But without priorities as it is implemented now, the
handlers are called in registration order or even without any order.
So I don't think we need this fine grained priorities for different
cases. If we have priorities, the order would be always the same for
all chains, which should be fine for most cases.

> I would be inclined to leave the patch as is until we can come up with a
> better way to handle the priorities.
> 
> Though I agree that DIE_NMI_IPI isn't a great name (doesn't it all go
> through the local apic?), it isn't being introduced with this patch.
> 
> Thoughts?

At least we should give the above a try. If it turns out it is not as
easy as I think, the still can fall back. But if we could finally get
rid of DIE_NMI_IPI, this would eas much.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

