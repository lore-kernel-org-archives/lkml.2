Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2FTM35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:29:57 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:29139
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab2FTM3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:29:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5X1DN-02-5QI-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 14:29:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
Message-ID: <20120620122941.GH5046@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
 <20120620092932.GH1478@erda.amd.com>
 <1340185084.21745.81.camel@twins>
 <20120620100031.GI1478@erda.amd.com>
 <1340187373.21745.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340187373.21745.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.12 12:16:13, Peter Zijlstra wrote:
> Sure it can be done, just not pretty. Combine that with all the other
> special casing like patches 3 and 10 and one really starts to wonder if
> its all worth it.

I actually started writing the code by implementing a different pmu.
It turned out to be the wrong direction. The pmus would be almost
identical, just some different config values and a bit nb related
special code. But you can't really reuse the functions on a 2nd
running pmu, there are hard wired functions in the x86 pmu code and
x86_pmu ops do not fit for such a split. It would mean a complete
rework of x86 perf code. Really, I tried that already. And all this
effort just to implement nb counters? If someone is willing to help
here this would be ok, but I guess I would have to do all this on my
own. And to be fair, this effort was also not make for fixed counters,
pebs, bts, etc. Maybe the uncore implementation is different here, but
today is the first day the uncore patches are in tip.

I also do not see the advantage of a separate pmu. Just to have a
different msr base to avoid the use of counter masks and some
optimized pmu ops? Masks are wide spread used in the kernel and on x86
the bsf instruction takes not more than an increment. And switches in
the code paths to special nb code are not more expensive than other
switches for other special code.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

