Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab1GELgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:36:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab1GELgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:36:48 -0400
Date: Tue, 5 Jul 2011 13:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86/EFI: properly pre-initialize table pointers
Message-ID: <20110705113642.GB15654@elte.hu>
References: <4E12DC26020000780004C1C1@nat28.tlf.novell.com>
 <20110705093343.GB5725@elte.hu>
 <4E130EA0020000780004C24A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E130EA0020000780004C24A@nat28.tlf.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 05.07.11 at 11:33, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Jan Beulich <JBeulich@novell.com> wrote:
> > 
> >> Consumers of the table pointers in struct efi check for
> >> EFI_INVALID_TABLE_ADDR to determine validity, hence these pointers
> >> should all be pre-initialized to this value (rather than zero).
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> 
> >> ---
> >>  arch/x86/platform/efi/efi.c |   12 +++++++++++-
> >>  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > This changelog is missing some key information:
> > 
> >  - how did you find the bug (by chance via code review or did you see
> >    some actual badness?)
> 
> I can certainly add that information and re-send, but would 
> certainly have stated any really bad effect if I had observed such.

I have no way to know that and disambiguate it: it could be as you 
say, or you could have forgotten to include it.

And this is not a theoretical concern, for example here you claimed 
that a fix "possibly" fixed a boot crash:

   http://lkml.org/lkml/2011/1/6/262

and after repeated prodding you admitted that you have a specific 
system where it fixes not a possible but a real crash:

   http://lkml.org/lkml/2011/1/7/159

There's a world of a difference between a "possible" boot crash and a 
truly observed one.

> >  - what practical effect (if any) did you see from this patch?
> > 
> >  - what practical effect (if any) do you expect others to see from this 
> > patch?
> 
> Hmm, I can't really see why this kind of information (especially 
> the last) would belong into a changeset comment, the more a pretty 
> obvious one like this.

Such information is a standard part of bugfixes, exactly for the 
reasons demonstrated with the patch i quoted above. Please fix and 
resubmit.

> > This kind of information helps us prioritize bugfixes.
> 
> Bug fixes are bug fixes - unless they fix really critical issues 
> (and here that's unlikely to be the case, as the code had been 
> wrong for ages), I don't follow why you require more information to 
> be added than a description of what gets changed (the "why" should 
> really only matter if it's debatable whether the original code was 
> wrong).

No, that's not how we construct changelogs. What we do is the exact 
opposite: we try to err on the side of being overly verbose. A too 
verbose changelog is never a problem.

But should a commit turn out to cause problems (often months/years 
down the line) it's absolutely vital to have the motivation, 
observations and expectations of the patch submitter documented.

You already have that information, you only need to write it down - 
instead of forcing maintainers to guess and duplicate work ...

> Furthermore, this being not the first time you ask (from my pov) to 
> be overly verbose when it comes to describing changes and their 
> effects - is it unreasonable to expect you (not always you 
> personally, but you as being one of the three x86 maintainers; you 
> hopefully agree that from my position it doesn't really matter who 
> answers as long as someone assumes that responsibility) to be a 
> little less lax in responding to submitted patches? I would roughly 
> estimate that 50% of the patches I send get dropped on the floor 
> with no response whatsoever (there are even cases where you 
> welcomed patches, but never applied them or responded with a 
> revised opinion on a re- submission). I clearly realize that the 
> volume you need to deal with must be pretty high, yet I don't think 
> that ought to be an excuse for other than occasional cases of this 
> happening.
> 
> And yes, there are also other times when things get integrated 
> *very* quickly, and I definitely appreciate that.

You should realize that there's correlation between the proper 
verbosity of your changelogs and the likelyhood that they get 
applied.

Thanks,

	Ingo
