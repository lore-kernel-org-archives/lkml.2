Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0KJWvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:51:20 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45013 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757302Ab0KJWvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:51:19 -0500
Date: Wed, 10 Nov 2010 17:51:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101110225115.GB9299@Krystal>
References: <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:43:31 up 49 days,  2:45,  1 user,  load average: 0.21, 0.20,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony (tony.luck@intel.com) wrote:
> >- Perf does not support flight recorder tracing (concurrent read/write)
> >  - Sub-buffers are needed to support concurrent read/writes
> 
> When I hear somebody say "flight recorder" - I think of "black boxes"
> in airplanes that log data while the flight is running, and are only
> looked at offline later.  So I'm confused by the "concurrent read/write"
> requirement.
> 
> Perhaps you could explain the use cases of your "flight recorder",
> because it seems that the name doesn't fit exactly, and this is
> causing me (and maybe others) some confusion.

As Steven pointed out, the flight recorder buffers are set to overwrite the
oldest data when the buffer is filled. Therefore, the tracer can be used in
close-circuit mode (without extracting the data out of the memory buffers) to
keep a trace of the recent events. The trace can be extracted when an
interesting condition (trigger) occurs.

A typical use-case is to let it run on an end-user machine to enhance
application crash diagnosis with tracing information, albeit using a very small
fraction of the system resources to do so.

The reason why "concurrent read/write" is required is for server-class machines
which needs to continuously be able to gather trace data to report/find/locate
problematic scenarios happening. This means we're not only interested in one
single failure, but rather by a whole set of erroneous/warning conditions that
need to be reported. Stopping tracing every time data is gathered is
inappropriate, because it would hide errors/warnings that would be happening
during data collection.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
