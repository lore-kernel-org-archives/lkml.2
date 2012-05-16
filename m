Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab2EPSgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2EPSgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:36:37 -0400
Date: Wed, 16 May 2012 19:48:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Perf record format portability
Message-ID: <20120516174825.GA11516@m.brq.redhat.com>
References: <4FB275EB.5050904@linaro.org>
 <20120515155146.GB7864@infradead.org>
 <4FB38677.8070601@linaro.org>
 <20120516145927.GC7864@infradead.org>
 <1337187503.6724.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337187503.6724.50.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:58:23PM -0400, Steven Rostedt wrote:
> On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:
> 
> > Steve,
> > 
> > 	Was the kernel trace events infrastructure designed with that in
> > mind? I.e. cross analysis? I must be missing something here, still
> > ENOCOFFEE :-\
> 
> Yes, the libparsevents library was design for this from day one. That's
> why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
> whatever. I did all my development testing against 32bit, 64bit and big
> and little endian. This was the case from the beginning.

for ppc64(record) vs x86_64(report) I got following report on latest tip:

[jolsa@dhcp-26-214 test]$ ../perf report > report.target
Endianness of raw data not corrected!
Warning:
718 samples with id not present in the header
Warning:
The perf.data file has no samples!

for following record:
perf record -a -e sched:sched_switch -e sched:sched_process_exit -e sched:sched_process_fork -e sched:sched_wakeup -- sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.178 MB perf.data (~7781 samples) ]

I haven't tried trace-cmd, but I guess let's wait for libparsevents
perf integration then.. ;)

jirka
