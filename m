Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1FITjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:39:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab1FITjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:39:03 -0400
Date: Thu, 9 Jun 2011 12:38:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: NeilBrown <neilb@suse.de>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-Id: <20110609123843.77153b27.akpm@linux-foundation.org>
In-Reply-To: <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 14:47:49 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Thu, 9 Jun 2011 11:59:34 +1000 NeilBrown <neilb@suse.de> wrote:
> >
> >> On Wed, 8 Jun 2011 15:32:08 -0700 Andrew Morton <akpm@linux-foundation.org>
> >> wrote:
> >> > I've never really understood the need for fs overlaying.  Who wants it?
> >> > What are the use-cases?
> >> 
> >> https://lwn.net/Articles/324291/
> >> 
> >> I think the strongest use case is that LIVE-DVD's want it to have a
> >> write-able root filesystem which is stored on the DVD.
> >
> > Well, these things have been around for over 20 years.  What motivated
> > the developers of other OS's to develop these things and how are their
> > users using them?
> 
> That's a good question, Erez might be able to answer that better.
> 
> We have customers who need this for the "common base + writable
> configuration" case in a virtualized environment.
> 
> Since overlayfs's announcement several projects have tried it and have
> been very good testers and bug reporters.  These include OpenWRT, Ubuntu
> and other Debian based live systems.

I assume that the live CD was your motivator for developing overlayfs?

> >> > This sort of thing could be implemented in userspace and wired up via
> >> > fuse, I assume.  Has that been attempted and why is it inadequate?
> 
> Yes, unionfs-fuse and deltafs (written by me) are two examples.
> 
> One issue that a customer had with deltafs was lack of XIP support.  The
> other one (from the same customer) was the general yuck factor of
> userspace filesystems.
> 
> There are also performance and resource use issues associated with
> userspace filesystems.  These may or may not be problem depending on the
> actual use.  But it's a fact that out-of-kernel filesystems will never
> be as efficient as in-kernel ones.

Yes, userspace filesystems have a good yuck factor.  In a way it's a
sad commentary on the concept of FUSE, but I guess one could look at it
another way: FUSE is good for prototypes and oddball small-volume stuff
but once a FUSE-based setup has proven useful and people are getting
benefit from it, it's time to look at an in-kernel implementation.

> > Another issue: there have been numerous attempts at Linux overlay
> > filesystems from numerous parties.  Does (or will) this implementation
> > satisfy all their requirements?
> 
> Overlayfs aims to be the simplest possible but not simpler.
> 
> I think the reason why "aufs" never had a real chance at getting merged
> is because of feature creep.
> 
> Of course I expect new features to be added to overlayfs after the
> merge, but I beleive some of the features in those other solutions are
> simply unnecessary.

This is my main worry.  If overlayfs doesn't appreciably decrease the
motivation to merge other unioned filesystems then we might end up with
two similar-looking things.  And, I assume, the later and more
fully-blown implementation might make overlayfs obsolete but by that
time it will be hard to remove.

So it would be interesting to hear the thoughts of the people who have
been working on the other implementations.
