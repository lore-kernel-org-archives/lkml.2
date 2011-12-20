Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1LTPsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:48:52 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27192
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752863Ab1LTPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:48:31 -0500
X-SpamScore: 3
X-BigFish: VS3(zz98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9n61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPV:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 20 Dec 2011 10:48:26 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
In-Reply-To: <20111220091511.GB3091@elte.hu>
Message-ID: <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu>
References: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Ingo Molnar wrote:
> Granted, LWP was mis-designed to quite a degree, those AMD chip 
> engineers should have talked to people who understand how modern 
> PMU abstractions are added to the OS kernel properly. 

You do realize that LWP was probably in design 5+ years ago, at a time 
when most Linux kernel developers wanted nothing to do with perf counters, 
and thus anyone they did contact for help would have been from the 
since-rejected perfctr or perfmon2 camp.

Also, I'm sure Linux isn't the only Operating System that they had in mind 
when designing this functionality.


Running LWP through the kernel is a foolish idea.  Does anyone have any 
numbers on what that would do to overhead?

perf_events creates huge overhead when doing self monitoring.  For simple 
self-monintoring counter reads it is an *order of magnitude* worse than
doing the same thing with perfctr.
  (see numbers here if you don't believe me:
    http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/ )

Vince

