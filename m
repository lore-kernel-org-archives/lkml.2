Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2BVPcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:32:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49631 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2BVPcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:32:46 -0500
Message-ID: <1329924752.24994.25.camel@twins>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, rth <rth@redhat.com>
Date: Wed, 22 Feb 2012 16:32:32 +0100
In-Reply-To: <1329923583.24994.21.camel@twins>
References: <cover.1329851692.git.jbaron@redhat.com>
	 <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu>
	 <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu>
	 <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
	 <1329916920.25686.79.camel@gandalf.stny.rr.com>
	 <20120222133404.GA14085@elte.hu>
	 <1329918881.25686.92.camel@gandalf.stny.rr.com>
	 <1329923583.24994.21.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 16:13 +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-22 at 08:54 -0500, Steven Rostedt wrote:
> > But we could push a "unlikely(static_branch())" for
> > such a case (or keep it as very_unlikely()). 
> 
> If only that would work.. GCC assumes a bunch of things when you use
> 'asm goto'. An unbiased 'asm goto' that would take likely() and
> unlikely() hints would be ideal, but alas that's not how the thing got
> implemented.
> 
> Now arguable we could maybe just stick with the static_branch() thing
> and decide that GCC is broken for adding bias and not respecting
> likely() and unlikely(), but the GCC folks might have an opinion there.
> 
> Anyway, if we have to stick with the current implementation then an
> unbiased version is impossible to implement.
> 
> If we get GCC folks on board to change stuff, who knows.

So I clicked the link Jason provided in his 10/10 Documentation patch
and stumbled upon:

  http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01558.html

Where rth suggests that __attribute__((hot,cold)) might work on the
destination labels. Trying this my compiler (4.6.1+crap) pukes all over
me suggesting this isn't (yet) implemented.

Richard, is something like that still on the table?
