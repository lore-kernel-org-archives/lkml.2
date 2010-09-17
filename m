Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0IQIOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:14:45 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:25395
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751673Ab0IQIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:14:43 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L8VTJ9-02-BB3-02
X-M-MSG: 
Date: Fri, 17 Sep 2010 10:13:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100917081358.GJ13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <1284658950.2275.591.camel@laptop>
 <1284682396.32373.16.camel@yhuang-dev>
 <1284709936.3764.2241.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284709936.3764.2241.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.09.10 03:52:16, Peter Zijlstra wrote:
> On Fri, 2010-09-17 at 08:13 +0800, Huang Ying wrote:
> 
> > Please take a look at my recent patch that rewrites the NMI handler.
> 
> (Link would have been useful)
> 
> > Where NMI are divided into two types. CPU specific NMI are processed
> > firstly as DIE_NMI_IPI, and non-CPU specific NMI are processed as
> > DIE_NMI.
> 
> OK, and you can discriminate between these two by means of that reason
> port? Still I think NMI_IPI is a terrible name for that.

I think the current implementation that devides into NMI and NMI_IPI
is just to keep a certain order when calling the handlers - handling
local NMIs before non-CPU NMIs.

The patch I send is wrong, it should actually remove DIE_NMI_IPI. But
in the end the result is the same, not to call the perf handler twice.

I had this in my patch queue and posted it for debugging the 'unknown
nmi' warnings. Huang also did the same change in his patch set, but
his patch included too much changes and was not usable as a single
fix.

I am fine with dropping this patch in favor of Huang's patches, but
maybe we extract a single patch of this change for stable too.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

