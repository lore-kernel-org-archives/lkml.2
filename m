Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281Ab2EQIv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab2EQIvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:51:21 -0400
Date: Thu, 17 May 2012 10:51:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Perf record format portability
Message-ID: <20120517085106.GA1801@m.brq.redhat.com>
References: <4FB275EB.5050904@linaro.org>
 <20120515155146.GB7864@infradead.org>
 <4FB38677.8070601@linaro.org>
 <20120516145927.GC7864@infradead.org>
 <1337187503.6724.50.camel@gandalf.stny.rr.com>
 <20120516174825.GA11516@m.brq.redhat.com>
 <1337196743.6724.66.camel@gandalf.stny.rr.com>
 <1337197154.6724.68.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337197154.6724.68.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 03:39:14PM -0400, Steven Rostedt wrote:
> On Wed, 2012-05-16 at 15:32 -0400, Steven Rostedt wrote:
> > On Wed, 2012-05-16 at 19:48 +0200, Jiri Olsa wrote:
> > 
> > > for ppc64(record) vs x86_64(report) I got following report on latest tip:
> > > 
> > > [jolsa@dhcp-26-214 test]$ ../perf report > report.target
> > > Endianness of raw data not corrected!
> > > Warning:
> > > 718 samples with id not present in the header
> > > Warning:
> > > The perf.data file has no samples!
> > > 
> 
> What does perf script give you. It looks like Frederic took my code for
> this when he ported the original parse-events over to perf. I see the
> setup of these variables in tools/perf/util/trace-event-read.c
> 
> If you run 'perf script' on x86 from a ppc perf.dat file, do you still
> get the same errors?

yes

---
[jolsa@dhcp-26-214 test]$ ../perf script
Endianness of raw data not corrected!
Warning:
718 samples with id not present in the header
# ========
# captured on: Wed May 16 19:53:13 2012
# hostname : ibm-js22-vios-02-lp1.rhts.eng.bos.redhat.com
# os release : 2.6.32-270.el6.ppc64
# perf version : 2.6.32-270.el6.ppc64.debug
# arch : ppc64
# nrcpus online : 8
# nrcpus avail : 8
# cpudesc : POWER6 (architected), altivec supported
# cpuid : 62,769
# total memory : 6236992 kB
# cmdline : /usr/bin/perf record -a -e sched:sched_switch -e
# sched:sched_process_exit -e sched:sched_process_fork -e
# sched:sched_wakeup -- sleep 10 
# event : name = sched:sched_switch, type = 2, config = 0x22, config1 =
# 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 97, 98, 99,
# 100, 101, 102, 103, 104 }
# event : name = sched:sched_process_exit, type = 2, config = 0x1b,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 105,
# 106, 107, 108, 109, 110, 111, 112 }
# event : name = sched:sched_process_fork, type = 2, config = 0x1d,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 113,
# 114, 115, 116, 117, 118, 119, 120 }
# event : name = sched:sched_wakeup, type = 2, config = 0x17, config1 =
# 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 121, 122, 123,
# 124, 125, 126, 127, 128 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
#
---

jirka
