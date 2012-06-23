Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2FWSZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:25:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:36818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab2FWSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="157470058"
Message-ID: <4FE60A26.30109@linux.intel.com>
Date: Sat, 23 Jun 2012 11:25:42 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
References: <20120622133650.GA24136@gmail.com>  <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>  <20120622183827.GA8014@virgo.local>  <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>  <20120622190632.GB8014@virgo.local>  <1340394896.27036.258.camel@gandalf.stny.rr.com>  <86448d73-2e19-416f-8104-ce72aa5d76eb@email.android.com> <1340407123.27036.265.camel@gandalf.stny.rr.com> <4FE51325.8090408@linux.intel.com>
In-Reply-To: <4FE51325.8090408@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 05:51 PM, Arjan van de Ven wrote:
> 
> if it's truely an official nop, it will take decoder bandwidth obviously
> (which can decode 3 to 4 instructions per cycle, depending on the
> brand/model of CPU and the total size in bytes of these instructions).
> likewise, at the end of the out of order pipeline, NOPs may take a
> retirement slot (again 3 to 4 instructions per cycle)
> 
> icache is there as well, and if the NOP actually changes cpu flags (some
> of the less fortunate ones do) that can create a false data dependency.
> 

If it changes CPU flags it's most definitely not a NOP.

Either way, the 0F 1F ops are official, and listed in the SDM.

	-hpa

