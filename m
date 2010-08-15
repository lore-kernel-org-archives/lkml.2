Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0HORQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:16:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0HORQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:16:34 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=V_4aMAxed5IA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=meVymXHHAAAA:8 a=JfrnYn6hAAAA:8 a=0_xt3IXNWR6S5DRtEH8A:9 a=E8_XJUOEgenTK1hvFoUA:7 a=6xHOovfjvwgoYb1EPfLciWJUR8MA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [RFD] Mechanical synchronization algorithms proofs (was: Re:
 [patch 1/2] x86_64 page fault NMI-safe)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20100815141017.GB18175@Krystal>
References: <20100815141017.GB18175@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 15 Aug 2010 13:16:28 -0400
Message-ID: <1281892588.3058.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-15 at 10:10 -0400, Mathieu Desnoyers wrote:
> (I re-threaded this email because this is yet another topic that does not have
> much to do with NMIs)
> 
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Fri, 2010-08-06 at 10:13 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > 
> > > Less code = less instruction cache overhead. I've also shown that the LTTng code
> > > is at least twice faster. In terms of complexity, it is not much more complex; I
> > > also took the extra care of doing the formal proofs to make sure the
> > > corner-cases were dealt with, which I don't reckon neither Steven nor yourself
> > > have done.
> > 
> > Yes Mathieu, you did a formal proof. Good for you. But honestly, it is
> > starting to get very annoying to hear you constantly stating that,
> > because, to most kernel developers, it is meaningless.
> 
> So what you are stating is that having mechanically tested that all possible
> reordering done by the architecture on enough unrolled loops of the algorithm,
> testing all boundary cases (buffer full, NMI, etc) is 'meaningless' to kernel
> developers ?

No, but the constant "reminder" of your proof is meaningless, and
honestly, annoying. Because most bugs in the kernel are not design
related but implementation related. And a proof of an algorithm only
shows that the design is fine, not its implementation.

> 
> This tells me I have an important explanation job to do, because this can be
> tremendously useful to ensure rock-solidness of the current kernel
> synchronization primitives.

Sure, go ahead.

> 
> I vastly prefer this approach to synchronization primitives to the 'let's turn
> this knob and see what breaks and which reviewers will oppose' approach that
> some kernel developers currently have.

I'm not one of those. I never encourage a "lets try it until it works"
approach. That is blatantly flawed. But having a full understanding of
the design is different. Anytime something breaks I try to find out the
exact cause and see if it has to do with design or just a "oops in
implementation". In fact, I never accept a fix unless it has a full
understanding of the reason it fixes the problem and not a "if I do
this, it works".

> 
> 
> > Any slight
> > modification of your algorithm, renders the proof invalid.
> 
> We can add the model and test-cases somewhere in Documentation then, and require
> that the model should be updated and the test-suite ran when important
> synchronization changes are done.

What's the definition of "important .. changes"? To me, it must be run
_every_time_  something changes. That's just too much to ask for.

> 
> > 
> > You are not the only one that has done a proof to an algorithm in the
> > kernel,
> 
> I know Paul McKenney has done formal proofs about RCU too. I actually started
> from his work when I started looked into proving the LTTng sync. algos. I even
> worked with him on a formal model of Userspace RCU. It ended up being a more
> generic proof framework that I think can be useful beyond modeling of algorithm
> corner-cases. It lets us model whole synchronization algorithms; the framework
> per se takes care of modeling memory and instruction reordering.

Yes, Paul has done this too. But the difference between you and Paul, is
that Paul has never shoved it down our throats the fact that there's
been proofs. It was for his comfort, not everyone elses.

> 
> > but you are definitely the only one that constantly reminds
> > people that you have done so. Congrats on your PhD, and in academia,
> > proofs are important.
> 
> Even though you don't seem to see it or like it, this proof holds an important
> place in the robustness we can expect from this ring buffer, and I want people
> to go look and ask questions about the model if they care about it. Yes,
> modeling and doing formal proofs takes time. I understand that kernel developers
> don't have that much time on their hands. But don't look down on people who
> spent the time and effort to do it.

I never looked down on you for doing it. I look down on you constantly
reminding us that you have and that you are "superior" because of it. It
really is like you are saying "I have a proof, all others are garbage
until they too have a proof" and that part I find extremely annoying.

> 
> With a more collaborative mindset, we could try to automate the C to
> out-of-order memory/instruction framework with a simple compiler, so we could
> create those proofs with much less effort than what is currently required.

I'm not against proofs. If you want to add this, then go ahead. If you
prove that something is flawed (or works), I say GREAT!  That would be
extremely useful, without a doubt.

> 
> > 
> > But this is a ring buffer, not a critical part of the workings of the
> > kernel. There are much more critical and fragile parts of the kernel
> > that work fine without a formal proof.
> 
> I've come to find this out all by myself: regarding the LTTng tree, I receive
> more bug reports about problems coming from the kernel than tracer-related
> problems.

The kernel is much more massive than the tracing infrastructure, and
designed by many more developers. It's one of the largest projects in
the world. Of course there will be more bugs.

> 
> We seem to have slightly different definitions of "working fine".
> 
> > 
> > Paul McKenney did a proof for RCU not for us, but just to help give him
> > a warm fuzzy about it. RCU is much more complex than the ftrace ring
> > buffer,
> 
> Not that much I'm afraid. Well, the now deprecated "preempt rcu" was a
> complexity mess, but I think Paul did a good job at simplifying the TREE_RCU
> preempt implementation to bring the complexity level doing to something we can
> model and understand in its entirety.
> 
> > and it also is much more critical. If Paul gets it wrong, a
> > machine will crash. He's right to worry.
> 
> What if we start using the ring buffer as a core kernel synchronization
> primitive in audio drivers, video drivers, etc ? These are all implementing
> their own ring buffer flavor at the moment, which duplicates code with similar
> functionality and multiply reviewer's job. Then the ring buffer suddenly become
> more critical than you initially thought.

Oh, I have no doubt about that. But the ring buffer code is still less
complex than RCU. I've worked on both, I know. OK, others may say my
ring buffer is complex, but I personally find it quite trivial compared
to other things that I have worked on.

> 
> > And even Paul told me that no
> > formal proof makes up for large scale testing. Which BTW, the ftrace
> > ring buffer has gone through.
> 
> LTTng has gone through large-scale testing in terms of user-base and machine
> configurations too. I've also ran it on the largest-scale machines in terms of
> CPU I could find (only 8 so far, but I'd love to see results on larger
> machines).

I've ran my ring buffer on 1024 CPU machines. So far, no issues there.


> 
> I can say for sure that Ftrace performance has not been tested on large-scale
> SMP machines, simply because your Ftrace benchmark only use one writer/one
> reader thread.

I can try it out on those large scale boxes too. I just need to update
the code to do so. Obviously, having a reader read a page that a writer
just written to will take a huge cache hit on those boxes. But the only
good way to fix that is to have a per cpu reader, and I don't want that
(not yet).

> 
> > 
> > Someday I may go ahead and do that proof,
> 
> Please do.

When I get the time, which unfortunately, I don't have at the moment.

> 
> > but I did do a very intensive
> > state diagram, and I'm quite confident that it works.
> 
> Convincing others is the hard part.
> 
> > It's been deployed
> > for quite a bit, and the design has yet to be a factor in any bug report
> > of the ring buffer.
> 
> Yeah, synchronization bugs are really hard to reproduce, I'm not that surprised.

Well, I have yet to see any symptoms of synchronization bugs.

Don't get me wrong. I have nothing against you doing the proof, and if
you have time to prove other aspects of the kernel please do. Report
something if it is faulty or say that it works. This would be a huge
benefit to the kernel. I would encourage you on such an endeavor.

What I'm complaining about is the "elite" aspect that you constantly
bring to the conversation. Having a proof does not make your algorithm
any better than any other algorithm. I may need to do this proof on mine
just to make you shut up. But I would never use it as an argument
against another algorithm. Having a faster, or easier to use algorithm
is what really matters. If you do the proof against mine and prove that
mine is flawed, then that would count. But for now there's a yes mine
works, but yours which has yet to show a failure may not.

-- Steve


