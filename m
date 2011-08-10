Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1HJTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:01:32 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58521
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680Ab1HJTBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:01:31 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1418M1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPVD:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 10 Aug 2011 15:01:20 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sam wang <linux.swang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
In-Reply-To: <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu> <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011, Will Deacon wrote:

> > It turns out the branches event used (ARMV7_PERFCTR_PC_WRITE) only seems
> > to count taken branches.
>
> It also counts exceptions and instructions that write to the PC.

are those more common than not-taken branches?  I'd think branch predictor 
statistics will be a bit off if only taken instructions are measured.

> > ARMV7_PERFCTR_PC_IMM_BRANCH seems to do a better job of counting both 
> > taken and not-taken.  So I've attached a patch to change the definition
> > for Cotex A9.
>
> Well, it also only considers immediate branches so whilst it might 
> satisy your test, I think that overall it's a less meaningful number.

I guess there isn't more info available about which branches exactly are 
counted by all the events?  I've gone through the trouble of writing such 
tests to find out experimentally what various counters count for x86, it 
would be sad to have to do it again for ARM.

> (b) start replacing our generalised events with HW_OP_UNSUPPORTED and force
>     the user to use raw events. I agree this isn't very friendly, but it's
>     better than giving them crazy results [for example, we currently report
>     more cache misses than cache references on A9 iirc].
> 
> Personally, I'm favour of (b) and getting userspace to provide the user with
> a CPU-specific event listing and then translate this to raw events using
> something like libpfm.

I agree 100%, but it's an unpopular opinion on linux-kernel.  (Note that 
I'm the one who contributed ARM Cortex A8/A9 support to both libpfm4 and 
PAPI).

Since the generalized events are there and ABI though, people are going to 
use them.  That's why I've been writing tests that check them to see 
exactly what they are measuring.

It's still an important issue to know what "branches" measures, just it 
probably shouldn't be a kernel issue like it's become.

Vince
vweaver1@eecs.utk.edu

