Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1BCOXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:23:14 -0500
Received: from [216.32.181.185] ([216.32.181.185]:20980 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932222Ab1BCOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:23:12 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 09:23:12 EST
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2cK936eK146fK1dbaL1432N98dNzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG1OJD-02-2H3-02
X-M-MSG: 
Date: Thu, 3 Feb 2011 15:06:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core
 counters
Message-ID: <20110203140650.GI5874@erda.amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
 <1296666198.26581.343.camel@laptop>
 <20110202172419.GB5874@erda.amd.com>
 <1296667777.26581.349.camel@laptop>
 <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
 <20110203090001.GG5874@erda.amd.com>
 <1296725883.26581.359.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1296725883.26581.359.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.02.11 04:38:03, Peter Zijlstra wrote:
> On Thu, 2011-02-03 at 10:00 +0100, Robert Richter wrote:
> > 
> > 
> > ok, nb events may be implemented independent from core events in a
> > separate struct pmu.
> > 
> > I still would prefer a lookup table for counter addresses. Adding a
> > shift parameter to struct x86_pmu to do a
> > 
> >       addr = base + (index << shift)
> > 
> > seems to me a quite special solution that may not be reused in other
> > implementations
> 
> What other implementations? I hope people will not re-arrange the MSR
> layout on every new model, that'd be quite annoying.

I mean counters referred by index that cannot be derived from the base
address like fixed counters, BTS, IBS, P4... Often this is implemented
in if/else if paths.

> >  while a lookup table is more generic. I also don't
> > see a performance or memory impact there.
> 
> Well it is an extra pointer chase and data cache hit just to get
> something you can trivially compute.

Indeed, cache pollution is an argument.

> > Anyway, a shift parameter would work too. What do you think? 
> 
> I think the alternatives thing is probably nicest, except for having to
> write the bits in asm.

Will send an updated version.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

