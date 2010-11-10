Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0KJXNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:13:39 -0500
Received: from www.tglx.de ([62.245.132.106]:55230 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0KJXNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:13:38 -0500
Date: Thu, 11 Nov 2010 00:12:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
In-Reply-To: <20101110225115.GB9299@Krystal>
Message-ID: <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6>
References: <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu>
 <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com> <20101110225115.GB9299@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:

> * Luck, Tony (tony.luck@intel.com) wrote:
> > >- Perf does not support flight recorder tracing (concurrent read/write)
> > >  - Sub-buffers are needed to support concurrent read/writes
> > 
> > When I hear somebody say "flight recorder" - I think of "black boxes"
> > in airplanes that log data while the flight is running, and are only
> > looked at offline later.  So I'm confused by the "concurrent read/write"
> > requirement.
> > 
> > Perhaps you could explain the use cases of your "flight recorder",
> > because it seems that the name doesn't fit exactly, and this is
> > causing me (and maybe others) some confusion.
> 
> As Steven pointed out, the flight recorder buffers are set to overwrite the
> oldest data when the buffer is filled. Therefore, the tracer can be used in
> close-circuit mode (without extracting the data out of the memory buffers) to
> keep a trace of the recent events. The trace can be extracted when an
> interesting condition (trigger) occurs.
> 
> A typical use-case is to let it run on an end-user machine to enhance
> application crash diagnosis with tracing information, albeit using a very small
> fraction of the system resources to do so.
> 
> The reason why "concurrent read/write" is required is for server-class machines
> which needs to continuously be able to gather trace data to report/find/locate
> problematic scenarios happening. This means we're not only interested in one
> single failure, but rather by a whole set of erroneous/warning conditions that
> need to be reported. Stopping tracing every time data is gathered is
> inappropriate, because it would hide errors/warnings that would be happening
> during data collection.

Aargh! Just because it can be done all in one with an insane amount of
complexity does not mean that it's an absolute requirement and a good
solution.

So if you want to have both the flight recorder crash documentation
and the ongoing monitoring then use two separate sessions with
separate modes and be done with it.

Cramming both into the same session is just insane.

The first rule is "Keep It Simple!".  Period.

Thanks,

	tglx
