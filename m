Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab2IFRqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:46:12 -0400
Received: from [65.55.88.15] ([65.55.88.15]:54475 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759377Ab2IFRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:46:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI936eI1432I4015Izz1202hzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9XVYU-02-E2R-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 19:44:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120906174452.GC8285@erda.amd.com>
References: <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
 <20120724161507.GG3732@erda.amd.com>
 <500EDB50.3070704@gmail.com>
 <20120724180312.GJ6717@infradead.org>
 <5010D2B1.3000206@gmail.com>
 <1343290109.26034.82.camel@twins>
 <20120803135117.GC3732@erda.amd.com>
 <50477332.1000902@gmail.com>
 <1346882872.2600.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346882872.2600.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 06.09.12 00:07:52, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 09:43 -0600, David Ahern wrote:
> > We need to require exclude_guest when using precise attribute with perf 
> > else all running VMs on Intel-based servers will crash. I do not have an 
> > AMD based server to even attempt the preferred solution.

do you have a perf tool patch ready that enables exclude_guest per
default for precise events? I have ibs kernel code that returns EINVAL
in this case.  Current perf tool should then fall back by sending
another syscall with the exclude_guest modifier disabled. This should
work for ibs. Testing your patch wouln't be an effort for me.

To prevent Intel-based servers from crashing, pebs should be only
enabled if the exclude_guest modifier is enabled. I guess there is
already kernel code to prevent this, but didn't look at the sources.

To prevent probing the kernel with syscalls to detect pmu features, I
suggested some time ago to introduce

 /sys/bus/event_source/devices/*/flags

or so similar to /proc/cpuinfo:flags. Any opinions on that?

There is also the option to emulate exclude_guest for ibs in
software. So far I didn't have the time to look at this. We could
still add this in the future. Since we need to fix current mainline
anyway where such a patch wouldn't go in for v3.6, I will send my
current ibs kernel fixes I mentioned above next days. It would be
great to test this also with your patch.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

