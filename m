Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2CZXXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:23:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab2CZXXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:23:37 -0400
Date: Mon, 26 Mar 2012 16:23:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net, pgf@laptop.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-Id: <20120326162335.f45bf001.akpm@linux-foundation.org>
In-Reply-To: <20120326231408.GA7495@gmail.com>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
	<20120326231408.GA7495@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 01:14:08 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Signed-off-by: Daniel Drake <dsd@laptop.org>
> > > Originally-from: Paul Fox <pgf@laptop.org>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Andres Salomon <dilinger@queued.net>
> > > 
> > > ...
> > >
> > > v4: really fix sign-off tags
> > 
> > s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> > is based upon an earlier version from Paul then Signed-off-by: is
> > correct.
> 
> No, the original ordering was *not* correct:
> 
>   From: Daniel Drake <dsd@laptop.org>
> 
>   [...]
> 
>   Signed-off-by: Daniel Drake <dsd@laptop.org>
>   Signed-off-by: Paul Fox <pgf@laptop.org>
> 
> In the previous discussion we had I explained what the rules for 
> signoffs are. Let me quote Linus as well:
> 
>   " The sign-off chain should be very simple: the first person 
>     to sign off should be the author, and the last person to 
>     sign off should be the committer. "
> 
>   https://lkml.org/lkml/2012/3/22/489
>   
> This is not true for this patch, because the first signoff does 
> not match the 'From:' line (author).
> 
> Nor is the last signoff the committer - i.e. the person sending 
> me this patch to apply. Every maintainer along the route adds a 
> signoff to the tail if it's propagated via email, or does a 
> merge commit if it's a pull.
> 
> If Daniel sends me a patch he should be the last signoff. If he 
> authored the patch then he should also be the first (and, by 
> implication, only) signoff. Signed-off-by does not recognize 
> multiple authorship - that has to be written into the changelog, 
> added via another type of tag - either approach is fine to me. 

That's a bunch of stuff which you and Linus apparently cooked up and
didn't tell anyone about and didn't document anywhere.  I'd never heard
about it before and I doubt if many other people knew about it.  And if
anyone should have known about it, I should have!

So we have an unknown but probably large number of patches in the tree
now which do not follow this rule.  So nobody can depend on
Signed-off-by: ordering in the tree as it stands.

So if we want to implement this (new!) rule then let's write the damn
thing down (in Documentation/SubmittingPatches) and tell people about
it!  And, if poss, add a checkpatch rule to detect possible violations.

