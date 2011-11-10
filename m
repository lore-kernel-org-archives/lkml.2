Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655Ab1KJNwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:52:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:48674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab1KJNwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:52:14 -0500
Message-ID: <1320933118.17392.23.camel@i7.infradead.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jochen Striepe <jochen@tolot.escape.de>,
        Shawn Pearce <spearce@spearce.org>, Junio C Hamano <gitster@pobox.com>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 10 Nov 2011 13:51:58 +0000
In-Reply-To: <CA+55aFyG4VuiRN3kcyDVF4sw7b89m-2bOBeQLOGWTcd9o3akzQ@mail.gmail.com>
References: <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
	 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
	 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
	 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
	 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
	 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
	 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
	 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
	 <CAJo=hJsXvSyB65KBp8sfciT=h5uZSqSUdxkpWtZJRtr4hXAh5A@mail.gmail.com>
	 <CA+55aFyXg32mko8TOGCfGHpr3jHBEgcKiK7HdVwq0Wez0fAs9A@mail.gmail.com>
	 <20111103032205.GA25888@pompeji.miese-zwerge.org>
	 <CA+55aFyG4VuiRN3kcyDVF4sw7b89m-2bOBeQLOGWTcd9o3akzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 21:13 -0700, Linus Torvalds wrote:
> No, my main objection to saving the data is that it's ugly and it's
> redundant. Sure, in practice you can check the signatures later fine
> (with the rare exceptions you mention), but even when you can do it,
> what's the big upside? 

Another objection (although it may not be insurmountable) is that it's
not necessarily *entirely* clear what's being signed.

In the simple case where I clone your tree, make a few commits with my
Signed-off-by:, sign a tag and then ask you to pull, that's easy enough.
I'm vouching for what I committed, and not for everything that was in
your tree beforehand.

But what if I'm working on top of someone else's published git tree?
Does a signed tag at the top of *my* work imply that I'm vouching for
all of theirs too?

In the case where the signature is ephemeral and only used for you to
trust my pull request, the answer is simple: If that other work wasn't
in your tree yet at the time I send my pull request, I'd damn well
better be vouching for it when I ask you to pull it. Nothing new there.

But if we're keeping signatures around for auditing purposes, we'd
better have a coherent answer to that question. One that isn't "a
signature cover everything since the last commit with torvalds@ as the
committer", if we want it to be useful for the general case.

-- 
dwmw2

