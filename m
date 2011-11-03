Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1KCCzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:55:38 -0400
Received: from 99-108-226-0.lightspeed.iplsin.sbcglobal.net ([99.108.226.0]:60631
	"EHLO peff.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab1KCCzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:55:36 -0400
Date: Wed, 2 Nov 2011 22:55:32 -0400
From: Jeff King <peff@peff.net>
To: Shawn Pearce <spearce@spearce.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111103025532.GB9492@sigill.intra.peff.net>
References: <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 06:02:37PM -0700, Shawn O. Pearce wrote:

> > So I really think that signing the top commit itself is fundamentally wrong.
> 
> I really disagree. I like the signed commit approach. It allows for a
> lot more workflows than just providing a way for you to validate a
> pull from a trusted lieutenant. Debian/Gentoo folks want a way to sign
> every commit in their workflow. Just because you don't want that and
> think its crazy doesn't mean its not a valid workflow for that
> community and is something Git shouldn't support. I never use `git
> stash`. I hate the damn command. Yet its still there. I just choose
> not to use it. Junio's gpgsig header on each commit is also optional,
> and communities/contributors can choose to use (or ignore) the feature
> as they need to.

Stop for a minute and think about what it _means_ to sign a commit. Is
it saying "I wrote this commit?" Or "I think this commit is good?" Or "I
think all of the history leading to this is good?" It's obviously going
to be a per-project thing, but it's very constricting.  Leaving aside
all of the workflow issues Linus brought up (but which I do agree with),
think about what it would mean for Linus to fetch a commit from a
lieutenant and then sign it. Whatever it means, it can really only be
_one_ thing.

But big projects that are interested in signatures probably want to say
more. They want to say "this developer really wrote this commit". They
want to say "QA passed this commit". They want to say "the history up to
here looks good". And so on.

But they can't say those things without binding some data to the commit
(i.e., making a certificate saying "this commit passed QA").  Data which
might only make sense to assert much later than the commit is written.

So you're going to need to support detached commit signatures in some
form anyway to make everybody happy. Which isn't to say in-commit
signatures are wrong, but they are just one tool in a toolbox.

Personally, I think the only thing that makes sense to assert inside a
commit itself is that you are the author, and the author line of the key
should match the email UID of the signing key. And then anything you
want to say about _other_ people's commits (or even your own commits,
but later) should come in the form of detached signatures with some
content.

That's how signed tags work. It's not just Linus signing a commit. It's
Linus signing a binding between a commit and the statement "this is
v2.6.28". The only thing wrong with the signed tag model for more
general use is that you need some way of naming and organizing large
numbers of tags (e.g., several per commit if you have things like QA
signatures).

-Peff
