Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1BCJAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:00:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54610 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755149Ab1BCJAI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:00:08 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2cK936eK146fK1dbaL1432N98dN9371Pzz1202hzz8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG1AC1-02-LZW-02
X-M-MSG: 
Date: Thu, 3 Feb 2011 10:00:01 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core
 counters
Message-ID: <20110203090001.GG5874@erda.amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
 <1296666198.26581.343.camel@laptop>
 <20110202172419.GB5874@erda.amd.com>
 <1296667777.26581.349.camel@laptop>
 <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.02.11 17:44:22, Stephane Eranian wrote:
> On Wed, Feb 2, 2011 at 6:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-02-02 at 18:24 +0100, Robert Richter wrote:
> >> On 02.02.11 12:03:18, Peter Zijlstra wrote:
> >> > Why this and not something like x86_pmu.perfctr + (index << 1)?
> >> > You could even use alternatives.
> >>
> >> I was thinking about this. The main reason is the implementation of
> >> northbridge counters, the range is in MSRC001_02[47:40]. This would
> >> add more complexity then. Using a table would be something like
> >>
> >> unsigned int eventsel_f15h[] = {
> >>       MSR_F15H_PERF_CTL,
> >>       MSR_F15H_PERF_CTL + 2,
> >>       MSR_F15H_PERF_CTL + 4,
> >>       MSR_F15H_PERF_CTL + 6,
> >>       MSR_F15H_PERF_CTL + 8,
> >>       MSR_F15H_PERF_CTL + 10,
> >>       MSR_F15H_NB_PERF_CTL,
> >>       MSR_F15H_NB_PERF_CTL + 2,
> >>       MSR_F15H_NB_PERF_CTL + 6,
> >>       MSR_F15H_NB_PERF_CTL + 8,
> >> };
> >>
> >> We don't need to change the address generation for this. Otherwise we
> >> need to introduce more logic for the calculation.
> >>
> >> Also, were could be potential easier implementations for fixed
> >> counters, BTS, P4, IBS, etc. But didn't look that close at it.
> >>
> >> (Btw, I am not yet sure if NB counters shouldn't better start at index
> >> 16 or so to reserve space for perf counter expansion.)
> >
> > Now that the NB PMU is completely separate from the core PMU, wouldn't
> > it make more sense to implement that as a separate entity just like the
> > intel uncore bits?
> 
> I agree on this.

Peter,

ok, nb events may be implemented independent from core events in a
separate struct pmu.

I still would prefer a lookup table for counter addresses. Adding a
shift parameter to struct x86_pmu to do a

      addr = base + (index << shift)

seems to me a quite special solution that may not be reused in other
implementations, while a lookup table is more generic. I also don't
see a performance or memory impact there.

Anyway, a shift parameter would work too. What do you think?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

