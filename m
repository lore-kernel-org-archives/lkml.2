Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1KRQdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:33:00 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56808 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1KRQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:32:59 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dK4015Lzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUV7AQ-02-84L-02
X-M-MSG: 
Date: Fri, 18 Nov 2011 17:32:47 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] perf, x86: handle overlapping counters
Message-ID: <20111118163247.GY15738@erda.amd.com>
References: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
 <1321629017.2197.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321629017.2197.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.11.11 16:10:17, Peter Zijlstra wrote:
> OK, I've queued these and tested them using something like:

> +	EVENT_CONSTRAINT_OVERLAP(0x003c, 0x1|0x2, INTEL_ARCH_EVENT_MASK),
> +	EVENT_CONSTRAINT_OVERLAP(0x00c0, 0x2|0x4, INTEL_ARCH_EVENT_MASK),
> +	EVENT_CONSTRAINT_OVERLAP(0x4f2e, 0x4|0x8, INTEL_ARCH_EVENT_MASK),
> +	EVENT_CONSTRAINT_OVERLAP(0x412e, 0x8|0x1, INTEL_ARCH_EVENT_MASK),
> +
>  	EVENT_CONSTRAINT_END
>  };
>  
> To stress the thing, you can quite easily manage to hit that
> WARN_ON_ONCE() in there, but I haven't seen things explode yet.

Yes, the above would require a stack depth of 4 in the worst case
ending up in 2^4 max loops for the above. It would become more with
higher weights.

> > Robert Richter (2):
> >   configs: updating misc-x86_64-erda to v3.0.8
> >   config: updating misc-x86_64-erda.config for ASUS M4A89GTD PRO
> > 
> >  configs/misc-x86_64-erda.config |  517 ++++++++++++++++++++++++++++-----------
> >  1 files changed, 379 insertions(+), 138 deletions(-)
> 
> You sure about that? :-)

Yeah, wrong terminal... Luckily the patches are correct. ;)

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

