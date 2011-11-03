Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1KCDQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:16:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40210 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1KCDQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:16:52 -0400
Date: Thu, 3 Nov 2011 03:16:49 +0000
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Jeff King <peff@peff.net>, Git Mailing List <git@vger.kernel.org>
Cc: Shawn Pearce <spearce@spearce.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Junio C Hamano <gitster@pobox.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <robbat2-20111103T030225-511273733Z@orbis-terrarum.net>
References: <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <20111103025532.GB9492@sigill.intra.peff.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103025532.GB9492@sigill.intra.peff.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 10:55:32PM -0400,  Jeff King wrote:
> But big projects that are interested in signatures probably want to say
> more. They want to say "this developer really wrote this commit". They
> want to say "QA passed this commit". They want to say "the history up to
> here looks good". And so on.
On the Gentoo side, we've also pondered the question of:
author != committer != pusher
And how to preserve many signatures from sources.

We're on a central repo model, with some ~250 committers.

I was originally primarily after the push certificates/signed-push, and
recording that data in the notes, but that still has the problems of
third-party verification as mentioned in the thread.

If we require that the tip of every push is a signed commit via a hook,
we get knowledge of the pushers. Either your real commit itself is
signed, or you have a signed merge commit on top, or you have a signed
empty commit. In all of the cases, I can verify your signature at the
recv hook. Having signed push in this case has a benefit that you could
ship the data as a bundle, or async from the signing.

The QA value of multiple signatures per commit is also valuable, to
assert SOB WITHOUT altering the commit. I see spearce's rant and the
retort, and really think there needs to be a middle ground - some of
commits that are coming from pulls, and not getting additional SOB,
could really benefit from them being recorded (I see them on mailing
lists, but not introduced since that would break 'stable' IDs).

> But they can't say those things without binding some data to the commit
> (i.e., making a certificate saying "this commit passed QA").  Data which
> might only make sense to assert much later than the commit is written.
> 
> So you're going to need to support detached commit signatures in some
> form anyway to make everybody happy. Which isn't to say in-commit
> signatures are wrong, but they are just one tool in a toolbox.
I was proposing that Git supports _all_ of these models:
- signed commits
- signed pushes (via certs)
- whatever signed lightweight tag idea happens
- existing annotated tags

Choices. Each with their own costs and advantages.

-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Trustee & Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85
