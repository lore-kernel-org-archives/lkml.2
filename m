Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0DZAc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 20:32:26 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:40212 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753332Ab0DZAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 20:32:25 -0400
Date: Mon, 26 Apr 2010 10:32:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com, opensuse-kernel@opensuse.org,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100426003213.GA11437@dastard>
References: <201004050049.17952.hpj@urpla.net>
 <20100413091823.GD7544@dastard>
 <201004131142.33518.hpj@urpla.net>
 <201004241844.23482.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004241844.23482.hpj@urpla.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> On Tuesday 13 April 2010, 11:42:33 Hans-Peter Jansen wrote:
> > On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> > > On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> > > > Dave, may I ask you kindly for briefly elaborating on the worst
> > > > consequences of just reverting this hunk, as I've done before?
> > >
> > > Well, given that is the new shrinker code generating the warnings,
> > > reverting/removing that hunk will render the patch useless :0
> >
> > Excuse me, I didn't express myself well. I'm after the consequences of
> > applying the revert, that I posted a few messages above.
> >
> > > I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> > > now....
> >
> > Cool, thanks.
> 
> Obviously and not totally unexpected, really fixing this is going to take 
> more time.

The problem is that the fix I did has been rejected by the upstream
VM guys, and the stable rules are that fixes have to be in mainline
before they can be put in a stable release.  So, until we get a fix
in mainline, it can't be fixed in the -stable kernels.

> FYI, 2.6.33.2 is still affected from this issue. 
> 
> Greg, you might search for a server using xfs filesystems and and a i586 
> kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well), log in as an 
> ordinary user, do a "du" on /usr, and wait for the other users screaming...

Yet there's only been one report of the problem. While that doesn't
make it any less serious, I don't think the problem you're reporting
is as widespread as you are making it out to be. We'll get the fix
done and upstream, and then it will go back to the stable kernel.

You could always apply the *tested* patches I posted that fix
the problem, as....

> BTW, all affected kernels, available from 
> http://download.opensuse.org/repositories/home:/frispete: have the 
> offending patch reverted (see subject), do run fine for me (on this 
> aspect).

... you seem to be capable of doing so.

> Will you guys pass by another round of stable fixes without doing anything 
> on this issue?

If the process of getting the fix upstream takes longer than another
stable release cycle, then yes. I'm sorry, but I can't control the
process, and if someone takes a week to NACK a fix, then you're just
going to have to wait longer. Feel free to run the fix in the
meantime - testing it, even if it was NACKed will still help us
because if it fixes your problem we know that we are fixing the
_right problem_.

If you can't live with this, then you shouldn't be running the
latest and greatest kernels in your production environment....

> Dave, this is why I'm kindly asking you: what might be the worst 
> consequences, if we just do the revert for now (at least for 2.6.33), until 
> you and Nick came to a final decision on how to solve this issue in the 
> future.

I've already told you - you could be reintroducing all the really
hard to reproduce inode reclaim problems (oops, hangs, panics,
potentially even fs corruption) that the patch in question was part
of the fix for.  You're running code that changes reclaim in very
subtle ways and has not been tested upstream in any way - if it
breaks you get to keep all the broken pieces to yourself...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
