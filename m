Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0JQFkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:40:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0JQFkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:40:41 -0400
Date: Sun, 17 Oct 2010 07:40:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017054008.GA16383@elte.hu>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004945.GE1614@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Oct 16, 2010 at 02:10:29PM -0700, H. Peter Anvin wrote:
>
> > "Christoph Hellwig" <hch@infradead.org> wrote:
> >
> > > Besides the algorithmic problems with ima, why is kernel.org using 
> > > IMA to start with?  Except for IBM looking for a reason to jusity 
> > > why TPM isn't a completely waster of ressources it's pointless.  
> > > And it was only merged under the premise that it would not affect 
> > > innocent normal users.
> >
> > I'm confused ... what makes you think we are?  This might have been 
> > an unintentional misconfiguration...
> 
> I didn't mean to imply you enabled it intentionally.  In fact it looks 
> like the inode tracking in IMA is always on once it's compiled in, 
> which totally defeats the purpose of doing it's on iternal inode 
> tracking instead of bloating the inode what they originally proposed.  
> IMA really needs a kernel parameter to only enabled this crap when 
> people actually use it.

That is true.

> And whoever turned it on in Fedora needs some serious wahcking.

And that is false.

This security feature was merged upstream last year, it's not in 
drivers/staging/ and the Kconfig help text does not contain any warning 
that this is 'crap', so how were the Fedora people supposed to know?

If you are suggesting that distribution kernel maintainers should not 
trust upstream kernel feature decisions and are expected to do a line by 
line review of the ~40,000 commits that go upstream every year, to make 
sure there's no hidden 'crap' in them (and failing that be labeled 
incompetent idiots), then you are out of your mind.

It's just not possible to do that nor is it reasonable or efficient: 
crap should be caught via hierarchical filtering: when the developer 
posts the first patches to lkml, or when it merged into a maintainer 
tree, or when it goes upstream or when it is upstream and then, as the 
very last (and most expensive) line of defense, it will be caught when 
it gets exposure in distributions. Which seems to be precisely what 
happened here.

Fact is that Kyle did Linux a _favor_ by enabling the feature in Fedora, 
as it allowed the bug/inefficiency/crap to be found by Dave. Linux got 
richer as a result as we learned about a bug that affects many people. 
Your gratuitous insults against him are highly misguided.

Thanks,

	Ingo
