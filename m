Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0KJQwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:52:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab0KJQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:52:43 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LB5X0C42w9VlHoZdSTUA:9 a=Een5wimXyOlyu_SpWZ4A:7 a=zk9gp7Sj_NaUwD9FafRytQiHsnMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289403019.2084.17.camel@laptop>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 11:52:40 -0500
Message-ID: <1289407960.12418.169.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 16:30 +0100, Peter Zijlstra wrote:

> As for the buffer, I prefer a u64 aligned data stream, but the very
> least I need is frame encapsulation. What I don't want _ever_ is stupid
> sub-buffers. And no they're not needed, see the discussion about sync
> markers a while back.

BTW, the sub buffers is just an implementation detail. I suspect that
we'll have to end up with something that splits the buffer up. Whether
we have 'markers' or something else. They all break down the buffer into
a "sub-buffer".

> 
> I also don't want to support the stupid concurrent read/write from tail.

I was thinking about this more. I guess it can work if the reader always
goes the opposite direction of the writer. It's just any user that uses
this will need to cope with it. I would personally like both methods
implemented. One as the "broken design" (as you put it) which removes
the burden of sorting from the user. But the "fast design" which
requires the end result having to be able to sort the buffer.

> 
> What I do want is both mmap() and splice(), this means buffer size needs
> to be specified at buffer creation.

Sure.

> 
> I currently support overwrite (flight-recorder) and non-overwrite modes
> depending on PROT_WRITE, I guess that can easily be pushed into the
> buffer create call.

yep.

> 
> As to the mmap() part, it needs a control page to expose the head/tail
> pointers and some data.

But lets make this somehow generic, where it can be used by all sorts.


> And as you know I need to write > PAGE_SIZE entries.

Sure.

Also, lets not focus now on implementation. Let's try to concentrate on
what we want the tools to be able to do.

For example, I would like:

Very small entries, and pick and chose what I want in my entries.

A way to read it fast to a file or over the network (splice).

The read backwards seems like a cool idea, but I would not want to throw
away the read forwards part either.

How we implement this, we can work together on.

-- Steve


