Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1FGAFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:05:05 -0400
Received: from r00tworld.com ([212.85.137.150]:43090 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1FGAFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:05:03 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 07 Jun 2011 02:02:52 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
In-reply-to: <20110606191218.GB20123@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED16C1.24309.139B86C7@pageexec.freemail.hu>, <20110606191218.GB20123@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Tue, 07 Jun 2011 02:03:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 21:12, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > and whoever enables them, what do you think they're more likely to 
> > get in return? some random and rare old binaries that still run for 
> > a minuscule subset of users or every run-of-the-mill exploit 
> > working against *every* user, metasploit style (did you know that 
> > it has a specific target for the i386 compat vdso)?
> 
> That's what binary compatibility means, yes.

so fedora is not binary compatible. did just admit that in real life security
won out? we're on the right track! ;)

> > so once again, tell me whether the randomized placement of the vdso 
> > wasn't about security (in which case can we please have it back at 
> > a fixed mmap'd address, since it doesn't matter for security you 
> > have no reason to refuse ;).
> 
> It's a statistical security measure, and was such a measure from the 
> day it was committed:
> 
>  | commit e6e5494cb23d1933735ee47cc674ffe1c4afed6f
>  | Author: Ingo Molnar <mingo@elte.hu>
>  | Date:   Tue Jun 27 02:53:50 2006 -0700
>  |
>  |    [PATCH] vdso: randomize the i386 vDSO by moving it into a vma
>  |    
>  |    Move the i386 VDSO down into a vma and thus randomize it.
>  |    
>  |    Besides the security implications, this feature also helps debuggers, which
>  |    can COW a vma-backed VDSO just like a normal DSO and can thus do
>  |    single-stepping and other debugging features.
> 
> So what's your point?

you called this feature "borderline security FUD" but have yet to prove it.
on the contrary you did prove that it is a security feature and there's at
least one distro where it matters. of course you can call fedora's and even
mainline's vdso randomization FUD, but then please fix it and map it at a
constant address. you wouldn't want to live with "borderline security FUD"
features, would you? ;)

> > > It's only a security problem if there's a security hole 
> > > elsewhere.
> > 
> > it's not an 'if', there *is* a security hole 'elsewhere', else the 
> > CVE list had been abandoned long ago and noone would be doing 
> > proactive security measures such as intrusion prevention 
> > mechanisms.
> > 
> > so it *is* a security problem.
> 
> Two arguments.
> 
> Firstly, you generalize too much, it's only a security problem if you 
> actually have an attack surface:

a security problem without an attack surface is an animal that doesn't
exist. a potential problem becomes a security problem when there's a way
to attack/abuse it. your security vocabulary is seriously lacking and/or
you're very confused about very basic terminology but i'll try to do my
best to make sense out of what you're trying to say and also correct it
as needed.

>   Many Linux systems don't have any: non-networked appliances that 
>   are not physically connected to any hostile medium.

that only means that some problems are not security problems for those
systems. i find it somewhat ironic that you accuse me of too much
generalization yet you're the one who believes in black and white
terms, such as 'security bugs'. let me clear up your profound confusion:

pretty much every term in security is relative, of the 'it depends on this
or that condition' kind. e.g., when we call something an exploitable bug
it's because we know it can be exploited for sure under some conditions
(given OS, given userland app, given config options, etc, whatever applies
to the given situation) not because it cannot be exploited under some other
conditions, duh.

>   For such a system a gaping root hole bug is *not even a bug*, while 
>   a rare memory leak that you'd shrug off on a desktop might be a 
>   showstopper.

for such a system there's no 'gaping root hole' and we don't say that such
a system 'has an exploitable bug but not really'. such categories may exist
in your head only, but i can assure you that they don't exist among professionals.
what's more, there're things that some consider as a feature while others
consider a bug (or even security bug), then what ;). 

> Secondly, and more importantly, we try to maintain the kernel in a 
> way so that it can converge to a no bugs state in the long run.

no, you're not doing that. you don't even know that such a state is a
pipedream and cannot be achieved by any practical means we know of. i'm
somewhat saddened (if true) that this is a driving idea among kernel
developers.

consider that before eliminating old bugs you'd better not let new ones
in, in the first place. but you have no processes to ensure this, you don't
even know how to do it or if it's even possible to pull off such a feat.

> You can only do that by making sure that even in the very last 
> stages, when there are virtually no bugs left, the incentives and 
> mechanisms are still there to fix even those bugs.

more pipedreams. do you have *any* idea what you're talking about? seriously,
can you provide a program (think task list, not actual computer stuff)
that you think will get you anywhere near to this goal? i bet you cannot.
i bet you don't even know what the state of the art is in creating
such systems (on the linux scale, not thousand line long specialized
microkernels).

> If we add obstruction features that turn bugs into less severe 
> statistical bugs then that automatically reduces the speed of 
> convergence.

what? (you're still very confused about the bug vs. exploit thing btw,
ASLR doesn't affect bugs, it affects exploit techniques)

what's the connection again? you're just repeating what you said before
without anything to back it up. one more time: intrusion prevention is
orthogonal to bug finding & fixing. also for the latter group of people,
you only really care about those that actually disclose to you what they
find, and they are not influenced by exploit prevention techniques given
how they're not interested in writing said exploits (else they would not
disclose the bugs they're exploiting).

> We might still do it, but you have to see and acknowledge that it's a 
> *cost*.

i don't have to acknowledge non-existent things ;). you made up all this
'cost' thing and have yet to explain it.

> You seem to argue that it's a bona fide bug and that the fix 
> is deterministic that it "needs fixing" - and that is wrong on both 
> counts.

sorry i really lost you here. what bug are you talking about? and what's
with the 'fix is deterministic'? what else can a fix be? you either fix
a bug or you don't, as much as i hate black&white statements, i don't
know how you can make bugfixing non-deterministic ;). i hope you're not
mixing up ASLR (which works against exploit techniques) with bugfixing.

> You generally seem to assume that security is an absolute goal with 
> no costs attached.

quote me on that back please or admit you made this up. i'm very well
aware of every security feature and its cost in PaX for example, i have
written about them extensively and educated both users and non-users for
over a decade now. if you want to paint me something do yourself a favour
and at least read up on the project and person you're discussing. you
can start with the PaX documentation, its kernel config help, grsec
forum threads, etc.

> > > Yes, the upside is that they reduce the risks associated with 
> > > security holes - but only statistically so.
> > 
> > not sure what 'these measures' are here (if you mean ASLR related
> > ones, please say so), some are randomization based (so their impact 
> > on security is probabilistic), some aren't (their impact is 
> > deterministic).
> 
> Which of these changes are deterministic?

you tell me, you seemed to talk in generic terms without naming
anything in particular, so i was left guessing and made a similarly
generic statement ;). but to give you an idea here, my approach of
making the vsyscall page nx is a deterministic approach. there's no
randomness involved in that step. or Andy's approach of replacing
the syscall insns (which can be found and executed from anywhere)
with a specially chosen one is also a deterministic solution, there
is no randomness involved in whether an attacker can or cannot abuse
them. heck, you can consider having the vsyscall page at a fixed
address as a deterministic help library for exploit writers.

> Removing a syscall or a RET from a fixed address is *still* only a 
> probabilistic fix: the attacker can still do brute-force attacks 
> against the many executable pages in user-space, even if everything 
> is ASLR obfuscated.

no, it's not a fix, you're once again confusing bugs with exploit
techniques and bugfixes with exploit prevention techniques. other
that that yes, you stated a tautology, the point of which was?

> It helps if you read the bit i provided after the colon:
> 
>   > > if a bug is not exploitable then people like Spender wont spend 
>   > > time exploiting and making a big deal out of them, right?
> 
> If a bug is hidden via ASLR (and *all* of the changes in this thread 
> had only that effect) and can not be exploited using the simple fixed 
> address techniques disabled by these patches, then people like you or 
> Spender wont spend time exploiting them, right?

you're really really confused about this whole bug/exploit thing. ASLR
has nothing to do with bugs. it has everything to do with exploits and
more precisely, exploit techniques. do you understand the difference
between bugs and exploits? because if you do, you can't have made the
above question, so i'm guessing you don't understand the difference,
even if this is the most crucial point in understanding what all the
intrusion prevention approach is about.

ASLR prevents exploit techniques that rely on knowing addresses in the
attacked process, regardless of the the underlying bug. from another
angle, a bug may very well be exploitable by one exploit technique even
under ASLR but not exploitable by another technique (obviously an exploit
writer's job is to find out what the case is and choose wisely by
considering all the factors).

so what you wanted to say above but didn't know how to put it correctly
is that given an exploit technique prevented (in a probabilistic sense)
by ASLR, what would an exploit writer do (neither of us is, btw but your
continued insistence on painting us as such shows how far detached you
are from the world of computer security, i bet you can't even name a
single company that actually trades in exploits and employs such people).

and the answer to that is that 'it depends', as so many things do in security.

it depends on, among others:
- whether there's another bug that can leak back useful addresses
- whether there's another exploit technique that doesn't need fixed
  addresses (think partial pointer overwrites for example)
- whether the given target can sustain brute force or not
- anything else that a real exploit writer (unlike us) would consider

so your question has no black&white answer even if you'd like to get
one, that's just the way things often are in security.

> But it can still be exploited brute-force: just cycle through the 
> possible addresses until you find the right instruction that elevates 
> privileges.

that's not true, at least not in systems that do ASLR properly and have
a brute force prevention mechanism. there the probability can be bounded
below 1 (did you even read the ASLR doc i wrote some 8 years ago? it's
all explained there).

> > it's a nice theory, it has never worked anywhere (just look at 
> > OpenBSD ;). show me a single class of bugs that you think you'd 
> > fixed in linux. [...]
> 
> For example after this meta-fix:
> 
>   c41d68a: compat: Make compat_alloc_user_space() incorporate the access_ok()
> 
> We certainly have eliminated the class of bugs where we'd return 
> out-of-bounds pointers allocated via compat_alloc_user_space() and 
> exploited via large or negative 'len' values.

it wasn't a class but a single instance of a bug. a class of bugs needs
more instances. have you got any more of this kind? alternatively you
can try and find your supposed class in the CWE, i'm all ears ;).

> > > Can you guarantee that security bugs will be found and fixed with 
> > > the same kind of intensity even if we make their exploitation 
> > > (much) harder? I don't think you can make such a guarantee.
> > 
> > why would *i* have to guarantee anything? [...]
> 
> It was an generic/indefinite 'you'.
> 
> To understand my point you need to look at the context i replied to:
> 
>  > > > the fixed address of the vsyscall page *is* a very real 
>  > > > security problem, it should have never been accepted as such 
>  > > > and it's high time it went away finally in 2011AD.
> 
> You claimed that it is a very real security problem. I pointed out 
> that this is not a real primary fix for some security bug

ASLR was never about bugs, but exploit techniques, not sure where you
read anything to the contrary from me. so 'citation needed'. or are
you once again confusing bugfixes with intrusion prevention techniques?

> but a statistical method that makes exploits of other bugs harder (but
> not impossible),

that's not true as explained above.

> and as such it has the cost of making *real* fixes slower to arrive. 

yes, you keep saying that but you never presented any evidence why that
would be the case. and you probably meant 'finding bugs' not 'fixing
bugs' as it'd be a real shame if the kernel bug fixing process would
depend on the presence of intrusion prevention mechanisms. as i pointed
it out earlier, customers/userd don't take DoS that much more kindly
either ;).

> I don't think this was a terribly complicated argument, yet you do 
> not even seem to acknowledge that it exists.

that's because your 'argument' is bogus. you imagine things and believe
them to be true, without having even taken a look at real life out there.

host-based intrusion prevention techniques are what, like little over a
decade old? what do you think happened in all that timeframe with bugs?
did they die out? or did more and more people jump on the bug finding
bandwagon and eventually make the bug counts explode? what happened to
the exploits over the same time frame? did they die out? or did their
numbers explode? what happened to malware? etc, etc.

you're so uninformed yet insist on playing the knowledgable one that
one begins to wonder whether you have some psycholocigal issue with trying
to be the smart person in every field of life. it should now be becoming
clear to you that security won't be that field if you keep ignoring reality.

