Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab0J1RRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:17:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933943Ab0J1RRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:17:15 -0400
Date: Thu, 28 Oct 2010 19:17:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Message-ID: <20101028171701.GA18368@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
 <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
 <20101028163854.GA15450@elte.hu>
 <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 28, 2010 at 9:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Point taken in any case, i'll read your edited changelog and will change the
> > template accordingly.
> >
> > Would this:
> >
> >  Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() to
> >  ext4_{exit,init}_*()"), breaks the build on all[yes/mod]config with
> >  CONFIG_EXT4_FS_XATTR disabled:
> >
> >  ...
> >
> > have been better?
> 
> Yes. Except for the kernel the default git commit abbreviation is borderline too 
> short. Seven hex-chars can easily alias with a few more pulls from me: git will 
> not give aliases at the time it gives a shorthand, but a month or two later the 
> abbreviated commit may no longer be unique.
> 
> So I suggest using --abbrev=12 or similar.

ok. A helper script i use does this:

   git log --pretty=format:"%h: %s" $@

I have added --abbrev=12. Might make sense to lengthen the %h default in upstream 
Git as well?

> What I ended up writing your commit as was this:
> 
>     ext4: fix compile with CONFIG_EXT4_FS_XATTR disabled
> 
>     Commit 5dabfc78dced ("ext4: rename {exit,init}_ext4_*() to
>     ext4_{exit,init}_*()") causes
> 
>       fs/ext4/super.c:4776: error: implicit declaration of function ‘ext4_init_xattr’
> 
>     when CONFIG_EXT4_FS_XATTR is disabled.
> 
>     It renamed init_ext4_xattr to ext4_init_xattr but forgot to update the
>     dummy definition in fs/ext4/xattr.h.
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Acked-by: "Theodore Ts'o" <tytso@mit.edu>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> but that's just me.

Ok, this indeed is much nicer to read.

Thanks,

	Ingo
