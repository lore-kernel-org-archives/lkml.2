Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab2BJQIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab2BJQIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:08:46 -0500
Date: Fri, 10 Feb 2012 17:07:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
Message-ID: <20120210160756.GB6145@m.redhat.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
 <1328880444.8273.3.camel@gandalf.stny.rr.com>
 <1328885120.8273.7.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328885120.8273.7.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:45:20AM -0500, Steven Rostedt wrote:
> On Fri, 2012-02-10 at 08:27 -0500, Steven Rostedt wrote:
> > On Tue, 2012-02-07 at 20:44 +0100, Jiri Olsa wrote:
> > > hi,
> > > here's another version of perf support for function trace
> > > with filter. 
> > 
> > OK, I've applied all of these and I'm now going to run them through my
> > test suite before sending them to Ingo. I'll let you know if anything
> > goes wrong.
> 
> OK, I build booted and installed a kernel with your patches. I also
> installed the latest perf code from linus/master. Then I ran the
> following:
> 
> # perf record -e ftrace:function ls
> 
> and then ran
> 
> # perf report
> 
> It went into an infinite loop of "Processing time ordered events".
> 
> Is this expected?
> 
> Although perf script works fine.

yep, I was using perf script for testing
I get the same error for perf report, also if you run it like:

[root@dhcp-26-214 perf]# ./perf report --stdio
Warning:
Processed 82392 events and lost 1 chunks!

Check IO/CPU overload!

# ========
# captured on: Fri Feb 10 19:15:37 2012
# hostname : dhcp-26-214.brq.redhat.com
# os release : 3.3.0-rc3+
# perf version : 3.3.rc3.1274.g135d69
# arch : x86_64
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
# cpuid : GenuineIntel,6,23,10
# total memory : 1969896 kB
# cmdline : /home/jolsa/tip/tools/perf/perf record -e ftrace:function ls 
# event : name = ftrace:function, type = 2, config = 0x1, config1 = 0x0,
# config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 3, 4 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# ========
#
Warning: Timestamp below last timeslice flush
# Events: 78K ftrace:function
#
# Overhead  Command      Shared Object                   Symbol
# ........  .......  .................  .......................
#
   100.00%       ls  [kernel.kallsyms]  [k] ftrace_ops_control_func

#
# (For a higher level overview, try: perf report --sort comm,dso)



I'll check whats going on, thanks
jirka
