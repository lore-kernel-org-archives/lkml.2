Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1FGJwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:52:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1FGJwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:52:10 -0400
Date: Tue, 7 Jun 2011 11:51:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110607095135.GD4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED239B.8177.13CDBA86@pageexec.freemail.hu>
 <20110606192544.GA28947@elte.hu>
 <4DED7222.28864.150079CE@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED7222.28864.150079CE@pageexec.freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 6 Jun 2011 at 21:25, Ingo Molnar wrote:
> 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > 
> > > [...] it goes like 'I am not willing to do A because it would 
> > > help script kiddies but I'd rather do B that would help script 
> > > kiddies'. with A = 'disclose security bugs' and B = 'keep the 
> > > last roadblock that prevents full ASLR'.
> > 
> > No, that's wrong, the logic goes like this:
> > 
> >   if i do A then it has X1 advantages and Y1 disadvantages.
> >   if i do B then it has X2 advantages and Y2 disadvantages.
> > 
> > The Y1 and Y2 set of disadvantages can both include "making it 
> > easier for script kiddies" but the sets of advantages and 
> > disadvantages can also include MANY OTHER considerations, making 
> > the decision unique in each case.
> 
> Sure, i was only reflecting on what Linus himself kept insisting on 
> in the past.

>From what i've seen his say in past discussions he clearly applied 
the common-sense logic i outlined above, not the twisted logic you 
provided.

You paraphrased Linus in such a way:

  " it goes like 'I am not willing to do A because it would 
    help script kiddies but I'd rather do B that would help script 
    kiddies'. with A = 'disclose security bugs' and B = 'keep the 
    last roadblock that prevents full ASLR'.
  "

IMO your are blatantly misrepresenting Linus's opinion.

> > To translate it to this specific case (extremely simplifed, so 
> > please don't nit-pick that my descriptions of advantages and 
> > disadvantages are not precise nor complete):
> 
> i don't even need to get there, you already failed right in the 
> very first sentence, very impressive. no. 'not precise' is an 
> understatement.
> 
> >  A) "i put a zero day exploit and a CVE code into a changelog"
> > 
> >      Advantages: - it describes the problem more fully
> > 
> >   Disadvantages: - it makes it easier for people (including script kiddies) do harm faster
> >                  - creates a false, misleading category for "security bugs"
> > 
> 
> you try to set things up to serve your argument but it's not the things
> we've ever talked about (IOW, this is a strawman).
> 
> in particular, i've never ever requested exploits in commit logs 
> (and i don't remember anyone else who has, do you?). why do you 
> keep thinking in only extremes? is it so impossible to simply state 
> a CVE and the generic bug class (CWE) that the commit fixes? what 
> Linus has insisted on is 'no greppable words', that's diametrically 
> opposite to 'full disclosure' that you guys say you're supposedly 
> doing.

You contradict yourself in that paragraph (see below).

I simply disagree with putting easily greppable words like 'CVE' into 
the changelogs of bugs, due to what i already said above:

     Disadvantages: - it makes it easier for people (including script kiddies) do harm faster
                    - creates a false, misleading category for "security bugs"

> so if you omit the exploits that noone really requested (and i 
> don't even know why they'd be useful in a commit) then suddenly the 
> script kiddies are no longer helped.
> 
> and you have yet to explain what is false and misleading about the 
> security bug category. you used these words yourself several times 
> today, how do you explain that? why does the CVE exist? why does 
> bugtraq exist? are all those people discussing 'false and 
> misleading' things? why does your employer release security errata? 
> etc, etc.

My arguments against putting easily greppable CVE numbers into 
changelogs are very simple:

Firstly:

  - in many cases it is equivalent to providing a zero-day exploit
    in the changelog, to any reasonably skilled exploit writer

And you yourself said that you don't want to put zero-day exploits 
into changelogs, so why are you even arguing?

Secondly:

  - it's misleading because IMO CVE tagged bugs do not cover all 
    bugs that matter, they are self-selected bugs often highlighted 
    by attention-seeking participants of the security circus.
    The primary driving force in that industry is attention seeking, 
    *not* the maximization of security - and often they act in direct 
    conflict to better security ...

Maximizing security is hard: whether a bug has security implications 
is highly usecase and bug dependent, and the true security impact of 
bugs is not discovered in the majority of cases. I estimate that in 
*ANY* OS there's probably at least 10 times more bugs with some 
potential security impact than ever get a CVE number...

So putting CVEs into the changelog is harmful, pointless, misleading 
and would just create a fake "scare users" and "gain attention" 
industry (coupled with a "delay bug fixes for a long time" aspect, if 
paid well enough) that operates based on issuing CVEs and 'solving' 
them - which disincentivises the *real* bugfixes and the 
non-self-selected bug fixers.

I'd like to strengthen the natural 'bug fixing' industry, not the 
security circus industry.

[ But this is a higher level meta argument based on opinion so it's 
  probably rather pointless to argue it with you as such arguments
  need a certain level of mutual trust to discuss efficiently. ]

> > > but it's very simple logic Ingo.
> > 
> > Please drop the condescending tone, i think it should be clear to 
> > you by now that i have a good basis to disagree with you.
> 
> i'm a firm believer of instant karma, it seems to work on people 
> like yourself or Linus really well. in somewhat profane but simple 
> english: if you behave as an asshole i will treat you as one, if 
> you believe i treated you as an asshole it's because i think you 
> acted as one, and if you don't understand why then you're welcome 
> to 1. look into yourself and figure it out yourself, 2. ask me. 
> what is not going to get you anywhere is if you talk to me and 
> others from the high horse, you must be a lot better than your 
> current self for anyone to tolerate it.

I simply disagreed with you and argued with you without insulting you 
in such a tone.

Does disagreeing with you make me an 'asshole'?

But the thing is, i probably shouldnt bother arguing with you since i 
have trouble convincing you about very obvious things like the simple 
fact that putting more instructions into the page fault path ... 
slows it down, why should i bother arguing with you here?

You are not willing to listen and amazingly, in all these recent 
discussions you've never *ever* conceded a single point - even in 
cases where you were proven wrong beyond recognition!

Thanks,

	Ingo
