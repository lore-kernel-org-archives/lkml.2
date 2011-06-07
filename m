Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab1FGX0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:26:24 -0400
Received: from r00tworld.com ([212.85.137.150]:50302 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759113Ab1FGX0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:26:21 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 01:24:11 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEEB31B.24457.19E64984@pageexec.freemail.hu>
In-reply-to: <20110607095135.GD4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED7222.28864.150079CE@pageexec.freemail.hu>, <20110607095135.GD4133@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 01:24:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 11:51, Ingo Molnar wrote:

> > Sure, i was only reflecting on what Linus himself kept insisting on 
> > in the past.
> 
> From what i've seen his say in past discussions he clearly applied 
> the common-sense logic i outlined above, not the twisted logic you 
> provided.

you must have been reading a different discussion over the years than
what i have. he's never once provided anything remotely related to
'common sense'. every time i pointed out the holes in his logic, he
just shut up. not exactly the way to have a meaningful conversation
but let's see if you fare any better ;).

> You paraphrased Linus in such a way:
> 
>   " it goes like 'I am not willing to do A because it would 
>     help script kiddies but I'd rather do B that would help script 
>     kiddies'. with A = 'disclose security bugs' and B = 'keep the 
>     last roadblock that prevents full ASLR'.
>   "
> 
> IMO your are blatantly misrepresenting Linus's opinion.

i think the man can defend himself if he really feels that way, but let
me show you the origin of this idiotic script kiddie defense of his:
http://lkml.org/lkml/2008/7/15/293 notice how he didn't even know the
difference between publishing exploits (something script kiddies could
try) vs. describing the security aspects of the fix. but as we can see
below, you're not that much better either, so let's continue there.

> > in particular, i've never ever requested exploits in commit logs 
> > (and i don't remember anyone else who has, do you?). why do you 
> > keep thinking in only extremes? is it so impossible to simply state 
> > a CVE and the generic bug class (CWE) that the commit fixes? what 
> > Linus has insisted on is 'no greppable words', that's diametrically 
> > opposite to 'full disclosure' that you guys say you're supposedly 
> > doing.
> 
> You contradict yourself in that paragraph (see below).

you wish i did ;).

> I simply disagree with putting easily greppable words like 'CVE' into 
> the changelogs of bugs, due to what i already said above:

i note that most of the world does this already, so you'd better come up with
an excuse that applies only to you but not the other projects/companies/etc.
i also note that you provided no explanation for your employer's behaviour
(http://www.redhat.com/security/data/cve/). do you disagree with them?

>      Disadvantages: - it makes it easier for people (including script kiddies) do harm faster

what evidence do you have that people are doing harm faster when you put
CVEs/etc into commits? and what do scipt kiddies have to do with this again?
do you know what that term even means?

>                     - creates a false, misleading category for "security bugs"

let's see this one below.

> My arguments against putting easily greppable CVE numbers into 
> changelogs are very simple:
> 
> Firstly:
> 
>   - in many cases it is equivalent to providing a zero-day exploit
>     in the changelog, to any reasonably skilled exploit writer

bullshit again. you don't even know what the term '0-day exploit' means.
(do you understand that if knowing the CVE leads people to exploits then
they can just track the CVEs instead and forget about kernel commits?).

but that aside, you're assuming the existence of a person who can read
the code in a commit and create an exploit out of it (when the CVE/etc
are included) but at the same time when he reads the same commit, he's
suddenly unable to create an exploit out of it (when the CVE/etc are not
included). are you for real Ingo? do you know this thing called 'logic'?
do you understand that your 'argument' rests on an impossible situation,
the existence of a person with mutually exclusive attributes?

btw, what do you know about exploit writers? and then what is a reasonably
skilled exploiter writer according to you? how would you even be able to
determine that?

let me tell you now a real distadvantage of your coverup: you're hurting
the good guys (the defenders) a lot more than you're hurting the bad guys
(the attackers). why? because of the usual asymmetry of the situation we
often face in security. an attacker needs to find only a single commit
silently fixing a security bug (never mind finding the earlier commit
that introduced it) whereas the defenders would have to find all of them.

thanks to your policy you can guess which side has a distinct advantage
from the start and how well the other side fares.

> And you yourself said that you don't want to put zero-day exploits 
> into changelogs, so why are you even arguing?

it's not even arguing Ingo, that would assume sides with equal knowledge
but you have only delusions about the real world out there. i always
wondered where you guys cook up these ideas about script kiddies, exploits,
0day, etc. do you read about them in the news? do you follow conferences
and read papers? do you actively research vulnerabilities? seriously,
what's the source of all this nonsense i see?

> Secondly:
> 
>   - it's misleading because IMO CVE tagged bugs do not cover all 
>     bugs that matter,

sure but that's not your problem. as a kernel developer your task is
to keep your users informed about what you yourselves know. covering
it up does not serve users, it serves attackers.

>     they are self-selected bugs
               ^^^^^^^^^^^^^
what does this mean?

>     often highlighted by attention-seeking participants of the security circus.

what do external actors have to do with what you tell your users?
nothing? also, what is this 'security circus'? the security industry
is very big, it has many many actors in it (playing on a wide spectrum
of attack and defense), which ones are you referring to in particular?

>     The primary driving force in that industry is attention seeking, 

as always, it's not a black&white world, so yes, some actors can be
described as above but then others cannot. whatever their interest
however, i don't see what it matters to you. your job is not to force
people to behave one way or another (considering all the negative
response you've got so far, you've failed at it) but to keep your
users secure. covering up security fixes doesn't do that, informing
them does.

>     *not* the maximization of security - and often they act in direct 
>     conflict to better security ...

i don't understand who you're referring to here. i believe the context
is people who provide you with security bugs, get a CVE and then go
public with it with more or less fanfare? is that what you're referring
to here? in any case, what does 'maximization of security' mean to you?
and how do these actors (whoever they are, define them please) act against
better security?

> Maximizing security is hard: whether a bug has security implications 
> is highly usecase and bug dependent, and the true security impact of 
> bugs is not discovered in the majority of cases. I estimate that in 
> *ANY* OS there's probably at least 10 times more bugs with some 
> potential security impact than ever get a CVE number...

sure but what does that imply for the bugs that you do know are security
related? i don't see how the coverup follows from it.

> So putting CVEs into the changelog is harmful,

it's not harmful, or at least not more harmful than withholding it. remember
the asymmetric situation. also by extension anyone else who publishes CVEs
is actively harming their users, is that what you're saying? if not then
explain why the rule applies to kernel development only but not the rest
of the world.

> pointless,

why? not knowing about security fixes harms exactly those who you claim
to protect, your users, the good guys.

> misleading

why? who's being misled and about what? a security bug is a security bug,
there's nothing misleading about it.
 
> and would just create a fake "scare users"

who's being scared by attaching a CVE to a commit? i've never seen such a
person in my life, have you? and what percentage of the userbase do you
think are 'scared' whenever a security bug's fixed? and why should the existence
of such users affect how the rest is informed? do you think that the weatherman
should retire as well because someone might be scared when told about the coming
storm ahead of time?

> and "gain attention" industry

that part of the industry is there, has been for a long while and is not
going away. why does all that matter to you guys though? in particular, how
do you think covering up security fixes will change anything in that part
of the industry? hint: it won't, in fact it will allow them grow even bigger
and louder since you continually provide munition to them.

> (coupled with a "delay bug fixes for a long time" aspect, if 
> paid well enough)

uh, are you still talking about kernel security bugs? what are you referring
to here in particular? what's the connection between the above and covering
up security fixes? i think i'm getting lost here a bit, sorry ;).

> that operates based on issuing CVEs and 'solving' 
> them - which disincentivises the *real* bugfixes and the 
> non-self-selected bug fixers.

self-selected again, what's that mean here? and how does 'whatever you are
talking about above' discourage the 'real' bugfixes? what are these 'real
bugfixes'?

> I'd like to strengthen the natural 'bug fixing' industry, not the 
> security circus industry.

what is this 'natural bug fixing industry' exactly? who are you thinking
of in particular? and how do you think covering up security fixes strengthens
this 'industry'? what does it even mean to strengthen them?

> I simply disagreed with you and argued with you without insulting you 
> in such a tone.

yeah we all saw your tone now and in the past too. that's why you get
what you deserve ;). but then you're an adult person and can take the
heat, can't you? judging by the average Linus and other flames on lkml,
i think i was being pretty mild so far in fact ;).

> Does disagreeing with you make me an 'asshole'?

disagreements require (at least) two equally real and relevant choices
over which one can reasonably disagree. you have yet to present your
side of that relevant choice, until then i won't treat you as an equal
peer, sorry (you can start by answering the above questions, although
considering how many issues you skipped over so far i don't have high
hopes). so no, it's not about disagreements, it's about trying to
teach you some basics of security and in general, logical thinking.

> But the thing is, i probably shouldnt bother arguing with you since i 
> have trouble convincing you about very obvious things like the simple 
> fact that putting more instructions into the page fault path ... 
> slows it down, why should i bother arguing with you here?

as i said in another mail, the devil is in the details, here, whether
that slowdown matters or not. man, every time you bring this up i have
to stop typing as i'm still smiling over your pride about that absolutely
bogus and irrelevant single cycle 'speedup' ;).

> You are not willing to listen and amazingly, in all these recent 
> discussions you've never *ever* conceded a single point - even in 
> cases where you were proven wrong beyond recognition!

show me a single point then ;). so far i only saw ex cathedra statements
without numbers (single cycle improvement, remember? haha, sorry couldn't
help it ;). anything else i missed? also a discussion is not a trade of
'now i'll agree with you on this point if you agree with me on that other
point'. i'll agree with what i think is correct and i'll point out bullshit
when i see it, simple as that.

