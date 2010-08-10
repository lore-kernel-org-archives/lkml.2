Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0HJOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:25:27 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59862 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0HJOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:25:22 -0400
Date: Tue, 10 Aug 2010 16:25:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
Message-ID: <20100810142520.GA15073@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com> <20100807040101.GA30520@merkur.ravnborg.org> <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com> <20100808155712.GA4804@merkur.ravnborg.org> <4C615C84.6060300@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C615C84.6060300@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The reason why your patch cured it was that we then no
> > longer triggered the bug (at least I guess so I did not look to close).
> > 
> > I will look into this as time permits. I assume the fix is simple
> > when I find the reason.
> 
> I'm looking into it now, but understanding the kconfig internals is not
> easy...
Nope...

What I have understood so far...

If we have a choice then the choice is represented by a symbol.
symbol->def[S_DEF_USER] is set to the selected symbol.
If we read all the choice values then we set:
symbol->flags |= SYMBOL_DEF_USER

If we have a choice where we do not have all choice_values
which is the case with the minimal defconfig then the
missing choice_value results in that SYMBOL_DEF_USER
is not set.
[See confdata:conf_read after the sym_ok label]

Later in symbol.c:sym_calc_value the visibility
is set to mod if we do not have all values.

And therefore the coice value is set to m not y.

I will look a bit more at it tonight.

	Sam
