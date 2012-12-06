Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2LFQZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:25:45 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53838 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2LFQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:25:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1212070024460.4693@tundra.namei.org>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
 <50B5508D.7050409@schaufler-ca.com> <20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
 <alpine.LRH.2.02.1212070024460.4693@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Dec 2012 08:25:21 -0800
X-Google-Sender-Auth: xC5dbGKlC7Bu6YbQFRNwIE1UzoQ
Message-ID: <CA+55aFwJDtofV36R_ot8qj31BCGwBgDsGOKRkMRhRLamf5M+mw@mail.gmail.com>
Subject: Re: linux-next: unusual update of the security tree
To: James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 5:25 AM, James Morris <jmorris@namei.org> wrote:
> Any suggestions on how to fix this?  That branch is public, and what
> people use to develop against, so I can't rebase it.

Quite frankly, I really am not going to pull that. It has random crazy
merges for no reason what-so-ever. This is *exactly* the kind of stuff
I used to speak out against years ago, and I thought we had long since
put behind us. Do

    git fetch git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
next
    gitk ..FETCH_HEAD

from mainline to see what I'm talking about. It has all those random
merges interspersed with random sporadic development. This is not how
we make history make sense.

It looks like Casey has for the last year+ just had his own tree, done
his own thing, and then pulled from the 'next' branch of security at
random points to intermix his occasional commits with everything
else.So now all his sporadic commits are randomly intermixed together
with *everything* else that happened over the last year. It's kind of
the epitome of not-a-feature-branch.

There are 26 "normal" commits spread out over the year, coupled with
22 merges that have been done bi-weekly or something, and have
altogether brought in 13 *thousand* commits that have very little to
do with the 26 commits that are new work. And with many of the merges
done despite that development tree having *no* development in it of
its own, so you have those repeated "let's merge upstream code" pulls
that only add upstream code with no development in between.

This is the kind of development that should be kept private, and maybe
using a "git pull --rebase" to maintain the private commits on top of
whatever upstream. NOT be used to say "ok, I now have more than a year
of messy development history of 22 changes randomly interspersed with
the thirteen thousand commits that went into mainline during that
year+ time".

Or it should just have been a development branch that only did its own
development and never pulled from upstream.

Have people pulled that thing into anything else? Because quite
frankly, I think it's unsalvageable except with a rebase.

                  Linus
