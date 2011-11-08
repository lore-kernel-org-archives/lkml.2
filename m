Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1KHM5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:57:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab1KHM5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:57:04 -0500
Date: Tue, 8 Nov 2011 13:55:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vince@deater.net>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111108125509.GB1022@elte.hu>
References: <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@MIT.EDU> wrote:

> 
> On Nov 8, 2011, at 4:32 AM, Ingo Molnar wrote:
> > 
> > No ifs and when about it, these are the plain facts:
> > 
> > - Better features, better ABIs: perf maintainers can enforce clean, 
> >   functional and usable tooling support *before* committing to an 
> >   ABI on the kernel side.
> 
> "We don't have to be careful about breaking interface compatibility 
> while we are developing new features".

See my other mail titled:

	[F.A.Q.] perf ABI backwards and forwards compatibility

the compatibility process works surprisingly well, given the 
complexity and the flux of changes.

>From the experience i have with other ABI and feature extension 
efforts, perf ABI compatibility works comparably better, because the 
changes always go together so people can review and notice any ABI 
problems a lot easier than with an artificially fragmented 
tooling/kernel maintenance setup.

I guess you can do well with a split project as well - my main claim 
is that good compatibility comes *naturally* with integration.

Btw., this might explain why iOS and Android is surprisingly 
compatible as well, despite the huge complexity and the huge flux of 
changes on both platforms - versus modular approaches like Windows or 
Linux distros.

> The flip side of this is that it's not obvious when an interface is 
> stable, and when it is still subject to change. [...]

... actual results seem to belie that expectation, right?

> [...]  It makes life much harder for any userspace code that 
> doesn't live in the kernel. [...]

So *that* is the real argument? As long as compatibility is good, i 
don't think why that should be the case.

Did you consider it a possibility that out of tree projects that have 
deep ties to the kernel technically seem to be at a relative 
disadvantage to in-kernel projects because separation is technically 
costly with the costs of separation being larger than the advantages 
of separation?

> [...] And I think we do agree that moving all of userspace into a 
> single git tree makes no sense, right?

I'm inclined to agree that applications that have no connection and 
affinity to the kernel (technically or socially) should not live in 
the kernel repo. (In fact i argue that they should be sandboxed but 
that's another topic .)

But note that there are several OS projects that succeeded doing the 
equivalent of a 'whole world' single Git repo, so i don't think we 
have the basis to claim that it *cannot* work.

> > - We have a shared Git tree with unified, visible version control. I
> >   can see kernel feature commits followed by tooling support, in a
> >   single flow of related commits:
> > 
> >      perf probe: Update perf-probe document
> >      perf probe: Support --del option
> >      trace-kprobe: Support delete probe syntax
> > 
> >   With two separate Git repositories this kind of connection between
> >   the tool and the kernel is inevitably weakened or lost.
> 
> "We don't have to clearly document new interfaces between kernel 
> and userspace, and instead rely on git commit order for people to 
> figure out what's going on with some new interface"

It does not prevent the creation of documentation at all - but i 
argue that the actual *working commits* are more valuable information 
than the documentation.

That inevitably leads to the conclusion that you cannot destroy the 
more valuable information just to artificially promote the creation 
of the less valuable piece of information, right?

> > - Easier development, easier testing: if you work on a kernel 
> >   feature and on matching tooling support then it's *much* easier to
> >   work in a single tree than working in two or more trees in 
> >   parallel. I have worked on multi-tree features before, and except
> >   special exceptions they are generally a big pain to develop.
> 
> I've developed in the split tree systems, and it's really not that 
> hard.  It does mean you have to be explicit about designing 
> interfaces up front, and then you have to have a good, robust way 
> of negotiating what features are in the kernel, and what features 
> are supposed by the userspace --- but if you don't do that then 
> having good backwards and forwards compatibility between different 
> versions of the tool simply doesn't exist.

I actually think that ext4 is a good example at ABI design - and we 
borrowed heavily from that positive experience in the perf.data 
handling code.

But i also worked in other projects where the split design worked a 
lot less smoothly, and arguably ext4 would be *dead* if it had a 
messy interface design: a persistent filesystem cannot under any 
circumstance be messy to survive in the long run.

Other ABIs, not so much, and we are hurting from that.

> So at the end of the day it question is whether you want to be able 
> to (for example) update e2fsck to get better ability to fix more 
> file system corruptions, without needing to upgrade the kernel.  If 
> you want to be able to use a newer, better e2fsck with an older, 
> enterprise kernel, then you have use certain programming 
> disciplines.  That's where the work is, not in whether you have to 
> maintain two git trees or a single git tree.

I demonstrated how this actually works with perf (albeit the 
compatibility requirements are a lot less severe on perf than with a 
persistent, on-disk filesystem), do you accept that example as proof?


> > - We are using and enforcing established quality control and 
> >   coding principles of the kernel project. If we mess up then 
> >   Linus pushes back on us at the last line of defense - and has 
> >   pushed back on us in the past. I think many of the currently 
> >   external kernel utilities could benefit from the resulting rise 
> >   in quality. I've seen separate tool projects degrade into 
> >   barely usable tinkerware - that i think cannot happen to perf, 
> >   regardless of who maintains it in the future.
>
> That's basically saying that if you don't have someone competent 
> managing the git tree and providing quality assurance, life gets 
> hard. [...]

No, it says that we want to *guarantee* that someone competent is 
maintaining it. If me, Peter and Arnaldo gets hit by the same bus or 
crashes with the same airplane then i'm pretty confident that life 
will go on just fine and capable people will pick it up.

With an external project i wouldn't be nearly as sure about that - it 
could be abandonware or could degrade into tinkerware.

Working in groups and structuring that way and relying on the 
infrastructure of a large project is an *advantage* of Linux, why 
should this surprise *you* of all people, hm? :-)


> [...] Sure.  But at the same time, does it scale to move all of 
> userspace under one git tree and depending on Linus to push back?

We don't depend on Linus for every single commit, that would be silly 
and it would not scale.

We depend on Linus depending on someone who depends on someone else 
who depends on someone else. 3 people along that chain would have to 
make the same bad mistake for crap to get to Linus and while it 
happens, we try to keep it as rare as humanly possible.

> I mean, it would have been nice to move all of GNOME 3 under the 
> Linux kernel, so Linus could have pushed back on behalf of all of 
> us power users, [...]

You are starting to make sense ;-)

> [...] but as much as many of us would have appreciated someone 
> being able to push back against the insanity which is the GNOME 
> design process, is that really a good enough excuse to move all of 
> GNOME 3 into the kernel source tree?  :-)

Why not? </joking>

Seriously, if someone gave me a tools/term/ tool that has rudimentary 
xterm functionality with tabbing support, written in pure libdri and 
starting off a basic fbcon console and taking over the full screen, 
i'd switch to it within about 0.5 nanoseconds and would do most of my 
daily coding there and would help out with extending it to more apps 
(starting with a sane mail client perhaps).

I'd not expect the Gnome people to move there against their own good 
judgement - i have no right to do that. (Nor do i think would it be 
possible technically and socially: the culture friction between those 
projects is way too large IMO so it's clearly one of the clear
'HELL NO!' cases for integration.)

But why do you have to think in absolutes and extremes all the time? 
Why not excercise some good case by case judgement about the merits 
of integration versus separation?

> > - Better debuggability: sometimes a combination of a perf
> >   change in combination with a kernel change causes a breakage. I
> >   have bisected the shared tree a couple of times already, instead
> >   of having to bisect a (100,000 commits x 10,000 commits) combined
> >   space which much harder to debug …
> 
> What you are describing happens when someone hasn't been careful 
> about their kernel/userspace interfaces.

What i'm describing is what happens when there are complex bugs that 
interact in unforeseen ways.

> If you have been rigorous with your interfaces, this isn't really 
> an issue.  When's the last time we've had to do a NxM exhaustive 
> testing to find a broken sys call ABI between (for example) the 
> kernel and MySQL?

MySQL relies on very little on complex kernel facilities.

perf on the other hand uses a very complex interface to the kernel 
and extracts way more structured information from the kernel than 
MySQL does.

That's where the whole "is a tool deeply related to the kernel or 
not" judgement call starts mattering.

Also, i think we have a very clear example of split projects *NOT* 
working very well when it comes to NxMxO testing matrix: the whole 
graphics stack ...

You *really* need to acknowledge those very real complications and 
uglies as well when you argue in favor of separation ...

> > - Code reuse: we can and do share source code between the kernel 
> >   and the tool where it makes sense. Both the tooling and the 
> >   kernel side code improves from this. (Often explicit 
> >   librarization makes little sense due to the additional 
> >   maintenance overhead of a split library project and the 
> >   impossibly long latency of how the kernel can rely on the ready 
> >   existence of such a newly created library project.)
> 
> How much significant code really can get shared? [...]

It's relatively minor right now, but there's possibilities:

> [...] Memory allocation is different between kernel and userspace 
> code, how you do I/O is different, error reporting conventions are 
> generally different, etc.  You might have some serialization and 
> deserialization code which is in common, but (surprise!) that's 
> generally part of your interface, which is hopefully relatively 
> stable especially once the tool and the interface has matured.

The KVM tool would like to utilize lockdep for example, to cover 
user-space locks as well. It already uses the semantics of the kernel 
locking primitives:

disk/qcow.c:    mutex_lock(&q->mutex);
disk/qcow.c:            mutex_unlock(&q->mutex);
disk/qcow.c:            mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_lock(&q->mutex);
disk/qcow.c:            mutex_unlock(&q->mutex);
disk/qcow.c:            mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_unlock(&q->mutex);
disk/qcow.c:    mutex_lock(&q->mutex);

... and lockdep would certainly make sense for such type of 
"user-space that emulates hardware" while i don't think we'd ever 
want to go to the overhead of outright librarizing lockdep in an 
external way.

Thanks,

	Ingo
