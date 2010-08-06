Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633Ab0HFRwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:52:21 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45159 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0HFRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:52:19 -0400
Date: Fri, 6 Aug 2010 19:52:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>,
        "Justin P. Mattock" <justinmattock@gmail.com>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix make oldconfig
Message-ID: <20100806175217.GA8944@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> <4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> <20100806051354.GA24343@merkur.ravnborg.org> <4C5BE229.1090801@suse.cz> <AANLkTimWHnxbYzkJ1KhuS3DgTuSRz-gMnzEJvbsY835g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWHnxbYzkJ1KhuS3DgTuSRz-gMnzEJvbsY835g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 09:19:23AM -0700, Linus Torvalds wrote:
> On Fri, Aug 6, 2010 at 3:21 AM, Michal Marek <mmarek@suse.cz> wrote:
> >
> > Linus, will you apply this directly or should I apply it to the kbuild
> > tree and send you a pull request?
> 
> I took it directly, since I spend a lot of time doing "make oldconfig
> ; make -j16" which is why I found this (after pulling, I tend verify
> that at least nothing broke my _own_ configuration)

Hmm, I wonder why you call oldconfig explicitly?

A plain "make -j16" executes "silentoldconfig" if there
is any changes in a Kconfig* file or in .config.
Just double checked and it works as I expected.

So you are asked if there is any new options anyway even
if you skip your "oldconfig" step.

The difference between oldconfig and silentoldconfig these days
are just that silentoldconfig updates include/config/*
which oldconfig does not.

It could be as simple as old habits.
Just curious to know if there is something I have missed.

	Sam
