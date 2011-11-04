Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1KDO7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:59:22 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:44307 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1KDO7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:59:20 -0400
Date: Fri, 4 Nov 2011 10:59:08 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <gitster@pobox.com>, Shawn Pearce <spearce@spearce.org>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111104145908.GA3903@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Junio C Hamano <gitster@pobox.com>,
	Shawn Pearce <spearce@spearce.org>, git@vger.kernel.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org>
 <7vvcr1f38j.fsf@alter.siamese.dyndns.org>
 <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 12:09:55PM -0700, Linus Torvalds wrote:
> I personally dislike it, and don't really think it's a wonderful thing
> at all. I really does have real downsides:
> 
>  - internal signatures really *are* a disaster for maintenance. You
> can never fix them if they need fixing (and "need fixing" may well be
> "you want to re-sign things after a repository format change")

Note that a repository format change will break a bunch of other
things as well, including references in commit descriptions ("This
fixes a regression introduced in commit 42DEADBEEF") So if SHA-1 is in
danger of failing in way that would threaten git's use of it (highly
unlikely), we'd probably be well advised to find a way to add a new
crypto checksum (i.e., SHA-256) in parallel, but keep the original
SHA-1 checksum for UI purposes.

>  - they are ugly as heck, and you really don't want to see them in
> 99.999% of all cases.

So we can make them be hidden from "git log" and "gik" by default.
That bit is a bit gross, I agree, but 3rd party verification really is
a good thing, which I'm hoping can be added in a relatively clean
fashion.

						- Ted
