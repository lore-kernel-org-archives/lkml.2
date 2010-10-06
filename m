Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0JFNSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:18:52 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28994
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756553Ab0JFNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:18:50 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9VEAO-02-DDL-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 15:18:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Paul Mundt <lethal@linux-sh.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/7] perf: New helper function for pmu name
Message-ID: <20101006131825.GO13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
 <20101006122736.GL13563@erda.amd.com>
 <20101006123950.GA29118@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101006123950.GA29118@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Peter)

On 06.10.10 08:39:50, Paul Mundt wrote:
> On Wed, Oct 06, 2010 at 02:27:36PM +0200, Robert Richter wrote:
> > On 04.10.10 16:44:20, Matt Fleming wrote:
> > > Introduce perf_pmu_name() helper function that returns the name of the
> > > pmu. This gives us a generic way to get the name of a pmu regardless of
> > > how an architecture identifies it internally, e.g. ARM uses an id
> > > whereas SH currently uses a string.
> > 
> > I rather want use here the solution we discussed earlier, simply
> > including <asm/perf_event.h> and then access sh_pmu->name directly
> > from oprofile.
> > 
> No. Exposing sh_pmu generically is unacceptable. This is already

I don't want to be the perf_pmu_name() discussion a show stopper for
this patch set. We don't have a generic perf interface available now
that allows us to detect the pmu type for sh cpus. I also don't see a
name string as a final solution for pmu detection. So it will be more
than just adding perf_pmu_name().

Until then, as we currently would only need the name for SH, I don't
see something wrong here to include architectural interfaces from
<asm/perf_event.h> directly by architectural code until a general
solution is available.  If you run a 'git grep include..asm/perf' this
is common for other architectures.

> centrally managed through perf, and if oprofile needs any additional
> information then it needs to get that through the perf layer. We already
> have the situation that effectively every architecture with perf support
> implements a name string already, so making this part of the perf API
> hardly seems like that big of a stretch. If the perf people are violently
> opposed to this, then of course we can look at alternatives.

I am not against adding the pmu name to the perf API. But the oprofile
cpu_type strings are oprofile centric esp. for the userland. So these
strings will remain part of oprofile. Also I don't think we want to
polute the perf pmu names with it.

> sh_pmu is created for use solely by the perf events code, we are not
> going to have oprofile poking around in data structures it has no place
> knowing anything about when 99% of everything else it is doing is already
> abstracted cleanly through the perf events interfaces. Likewise for
> special oprofile-specific APIs.

So, I am also fine with implementing a generic perf_pmu_name() for sh
and then derive the oprofile cpu_type string from it in the oprofile
code.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

