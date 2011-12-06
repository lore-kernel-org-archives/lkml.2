Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1LFVH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:07:28 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:20834
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab1LFVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:07:26 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPV:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 6 Dec 2011 16:07:21 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <eranian@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_event self-monitoring overhead regression
In-Reply-To: <CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112061604040.23414@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu> <1322654092.2921.256.camel@twins> <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com> <alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
 <CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, stephane eranian wrote:

> I take it your test is all about self-monitoring, single event, single thread.
> Did you try breaking down the cost using  TSC and rdtsc() to pinpoint where the
> regression is coming from in the 3 perf_event syscalls you're using?

I've started gathering results using rdtsc() and the results are even more 
puzzling.  

See:
   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/core2_raw_null_kernel_rdtsc.png
for example.

Those results are from a core2 machine, with the CPU scaling governor set 
to "performance", the test bound to CPU0, and the test run 1000 times.

Part of the issue is that a few of those kernels are Debian unstable 
distro kernels and not hand-compiled stock kernels.  I'll rebuild a full 
set of kernels myself and see if I can reproduce the results.

Vince

