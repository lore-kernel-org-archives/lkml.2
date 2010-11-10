Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0KJPaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:30:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:34694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0KJPaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:30:35 -0500
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289401781.12418.145.camel@gandalf.stny.rr.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 16:30:19 +0100
Message-ID: <1289403019.2084.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 10:09 -0500, Steven Rostedt wrote:
> 
> > sure the second way is the only way out, but you still need to come up
> > with a trace data format and a control ABI.
> 
> Great! Let's start with that then. Could you list some of the basic
> needs of perf? 

Needs for what? I've already got a full control ABI and I can already
redirect output to other buffers ;-)

I don't have enumeration of what all is redirected to what, I pretend
that people know wth they're doing.. so if you want session lists of
what tracepoints are active on which buffers and the like you'll have to
come up with something for that.

As for the buffer, I prefer a u64 aligned data stream, but the very
least I need is frame encapsulation. What I don't want _ever_ is stupid
sub-buffers. And no they're not needed, see the discussion about sync
markers a while back.

I also don't want to support the stupid concurrent read/write from tail.

What I do want is both mmap() and splice(), this means buffer size needs
to be specified at buffer creation.

I currently support overwrite (flight-recorder) and non-overwrite modes
depending on PROT_WRITE, I guess that can easily be pushed into the
buffer create call.

As to the mmap() part, it needs a control page to expose the head/tail
pointers and some data.

And as you know I need to write > PAGE_SIZE entries.
