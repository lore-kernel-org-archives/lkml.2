Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab2FWAvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:51:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:1198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab2FWAvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:51:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183913974"
Message-ID: <4FE51325.8090408@linux.intel.com>
Date: Fri, 22 Jun 2012 17:51:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Hagen Paul Pfeifer <hagen@jauu.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [GIT PULL] perf fixes
References: <20120622133650.GA24136@gmail.com>  <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>  <20120622183827.GA8014@virgo.local>  <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>  <20120622190632.GB8014@virgo.local>  <1340394896.27036.258.camel@gandalf.stny.rr.com>  <86448d73-2e19-416f-8104-ce72aa5d76eb@email.android.com> <1340407123.27036.265.camel@gandalf.stny.rr.com>
In-Reply-To: <1340407123.27036.265.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2012 4:18 PM, Steven Rostedt wrote:
> How so? It's not a C function call (like the -finstrument-functions
> produces). It's an assembly function call. The only differences between
> having ftrace enabled and ftrace disabled with -mfentry is that you get
> a 5 byte nop at the start of each traceable function. Sure, it might put
> a little pressure on the icache, but from the benchmarks I've run, the
> impact has all been within the noise.
> 
> I've been told that it doesn't even hurt the pipeline. But I've Cc'd hpa
> and Arjan for their comments. How much impact does a 5 byte nop at the
> start of each function really have on the normal operations of the
> kernel?
> 

if it's truely an official nop, it will take decoder bandwidth obviously
(which can decode 3 to 4 instructions per cycle, depending on the
brand/model of CPU and the total size in bytes of these instructions).
likewise, at the end of the out of order pipeline, NOPs may take a
retirement slot (again 3 to 4 instructions per cycle)

icache is there as well, and if the NOP actually changes cpu flags (some
of the less fortunate ones do) that can create a false data dependency.


I would also worry about the compiler being able to inline a function
containing one of these, but that's a compiler thing, not a CPU type of
thing.

