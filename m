Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2CZXtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:49:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53686 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CZXtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:49:53 -0400
Date: Tue, 27 Mar 2012 01:49:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net, pgf@laptop.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-ID: <20120326234947.GA4811@gmail.com>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
 <20120326142908.c5248aec.akpm@linux-foundation.org>
 <20120326231408.GA7495@gmail.com>
 <20120326162335.f45bf001.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326162335.f45bf001.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 27 Mar 2012 01:14:08 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > Signed-off-by: Daniel Drake <dsd@laptop.org>
> > > > Originally-from: Paul Fox <pgf@laptop.org>
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > Cc: Andres Salomon <dilinger@queued.net>
> > > > 
> > > > ...
> > > >
> > > > v4: really fix sign-off tags
> > > 
> > > s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> > > is based upon an earlier version from Paul then Signed-off-by: is
> > > correct.
> > 
> > No, the original ordering was *not* correct:
> > 
> >   From: Daniel Drake <dsd@laptop.org>
> > 
> >   [...]
> > 
> >   Signed-off-by: Daniel Drake <dsd@laptop.org>
> >   Signed-off-by: Paul Fox <pgf@laptop.org>
> > 
> > In the previous discussion we had I explained what the rules for 
> > signoffs are. Let me quote Linus as well:
> > 
> >   " The sign-off chain should be very simple: the first person 
> >     to sign off should be the author, and the last person to 
> >     sign off should be the committer. "
> > 
> >   https://lkml.org/lkml/2012/3/22/489
> >   
> > This is not true for this patch, because the first signoff does 
> > not match the 'From:' line (author).
> > 
> > Nor is the last signoff the committer - i.e. the person sending 
> > me this patch to apply. Every maintainer along the route adds a 
> > signoff to the tail if it's propagated via email, or does a 
> > merge commit if it's a pull.
> > 
> > If Daniel sends me a patch he should be the last signoff. If he 
> > authored the patch then he should also be the first (and, by 
> > implication, only) signoff. Signed-off-by does not recognize 
> > multiple authorship - that has to be written into the changelog, 
> > added via another type of tag - either approach is fine to me. 
> 
> That's a bunch of stuff which you and Linus apparently cooked 
> up and didn't tell anyone about and didn't document anywhere. 
> [...]

I certainly didn't cook it up with Linus, and I think it's 
pretty clearly written down in SubmittingPatches:

        Signed-off-by: Random J Developer <random@developer.example.org>
        [lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
        Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>

It even describes how maintainers append themselves to after the 
existing Signed-off-by chain - and describes how the author of 
the patch adds the first Signed-off-by.

So I think it's pretty clearly defined.

> [...]  I'd never heard about it before and I doubt if many 
> other people knew about it.  And if anyone should have known 
> about it, I should have!
>
> So we have an unknown but probably large number of patches in 
> the tree now which do not follow this rule. [...]

I think all the major Git trees are doing it the way described 
in SubmittingPatches: first signoff is author and maintainers 
append a Signed-off-by to the end.

In practice there's a large number of noise in the tree through, 
as with any information created by humans, to be read by humans 
and not checked by computers. But this does not justify the 
intentional creation of noise I think.

Thanks,

	Ingo
