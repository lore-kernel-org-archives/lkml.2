Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2FAAqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:46:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44294 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab2FAAp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:45:59 -0400
Date: Thu, 31 May 2012 21:45:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with breakpoints
Message-ID: <20120601004551.GA16429@infradead.org>
References: <1338462398.28384.52.camel@twins>
 <1338473302.13348.336.camel@gandalf.stny.rr.com>
 <1338486029.28384.93.camel@twins>
 <1338486820.13348.366.camel@gandalf.stny.rr.com>
 <1338487413.28384.103.camel@twins>
 <1338490218.13348.379.camel@gandalf.stny.rr.com>
 <1338491176.28384.114.camel@twins>
 <20120531195529.GA22976@Krystal>
 <1338495006.13348.418.camel@gandalf.stny.rr.com>
 <1338495969.28384.119.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338495969.28384.119.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 10:26:09PM +0200, Peter Zijlstra escreveu:
> > Hmm, this brings up another question. By default, perf does not allow
> > users to profile trace_events correct? IOW, perf does not let
> > unprivileged users call text_poke()? I just tried it and got the:
> > 
> > $ ~/bin/perf record -e sched:sched_switch sleep 1
> > Permission error - are you root?
> > Consider tweaking /proc/sys/kernel/perf_event_paranoid:
> >  -1 - Not paranoid at all
> >   0 - Disallow raw tracepoint access for unpriv
> >   1 - Disallow cpu events for unpriv
> >   2 - Disallow kernel profiling for unpriv
> 
> It would, except tools/perf does stupid, its unconditionally adding
> PERF_SAMPLE_RAW (even for non-sampling events), which is the bit that
> requires privs.

Looserland, bah, I'll check that, thanks.

- Arnaldo
