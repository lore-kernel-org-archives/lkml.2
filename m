Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713Ab2EQLsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:48:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2EQLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:48:48 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4e99ZUtEKCT8sPAI1DYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337255326.6724.92.camel@gandalf.stny.rr.com>
Subject: Re: Perf record format portability
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Date: Thu, 17 May 2012 07:48:46 -0400
In-Reply-To: <4FB4885F.4000002@linaro.org>
References: <4FB275EB.5050904@linaro.org>
	  <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>
	  <20120516145927.GC7864@infradead.org>
	 <1337187503.6724.50.camel@gandalf.stny.rr.com>
	 <4FB4885F.4000002@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 09:10 +0400, Dmitry Antipov wrote:
> On 05/16/2012 08:58 PM, Steven Rostedt wrote:
> 
> > On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:
> >
> >> Steve,
> >>
> >> 	Was the kernel trace events infrastructure designed with that in
> >> mind? I.e. cross analysis? I must be missing something here, still
> >> ENOCOFFEE :-\
> >
> > Yes, the libparsevents library was design for this from day one. That's
> > why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
> > whatever. I did all my development testing against 32bit, 64bit and big
> > and little endian. This was the case from the beginning.
> 
> I didn't face with big/little conversion issues, most probably both x86 and
> my ARM board are of the same (little) endian :-).
> 
> But the original question was about event IDs. For example,
> /sys/kernel/debug/tracing/events/sched/sched_switch/id is 55 on my ARM board
> and 279 on my PC host, so 'perf report' displays "unknown:unknown" instead
> of expected "sched:sched_switch" when attempting to do some cross-analysis.
> I suppose that original event IDs should be preserved, either within perf.data
> or by providing the copy of original /sys/kernel/debug/tracing/*, much like
> it's done with --kallsyms to resolve kernel symbols.

trace-cmd copies the entire /sys/kernel/debug/tracing/events directory
into the data file (well it copies only the events you specify). I
thought perf did the same. It should be using what's in the perf.dat
file and not what's on the host.

Again, perf report is not what uses the events from trace-cmd. It's perf
script that does. If perf script works, then perf report needs to be
fixed. But after it gets updated to use the latest libparse-events,
which I have no idea when that will ever happen.

-- Steve

