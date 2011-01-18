Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1ARXzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:55:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab1ARXzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:55:16 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jan 2011 15:54:54 -0800
Message-ID: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
Subject: Linux 2.6.38-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been two weeks, and the merge window for 2.6.38 is thus closed.
And an interesting merge window it has been.

This merge window saw the introduction of two of my favorite new features:

 - the use of group scheduling to give nicer interactive behavior in
the presence of "traditional" UNIX loads (ie terminal windows with
heavy loads like a "make -j8" or similar) by giving tty sessions
separate groups (the SCHED_AUTOGROUP config variable)

 - Nick's new (well, "new" - it's been brewing for a long time)
RCU-based path name lookup.

So the autogroup thing is really more of a technical gimmick than
anything else, but it really works very well for the kinds of things
it is designed for. If you still do "real work" in a terminal window,
you're likely to appreciate it. Compile in parallel in one window,
watch a movie in another, and the movie is really smooth. It can be
very noticeable indeed. It's not a panacea, but it's nice for what it
is.

The RCU-based name lookup is at the other end of the spectrum - the
absolute anti-gimmick. It's some seriously good stuff, and gets rid of
the last main global lock that really tends to hurt some kernel loads.
The dentry lock is no longer a big serializing issue. What's really
nice about it is that it actually improves performance a lot even for
single-threaded loads (on an SMP kernel), because it gets rid of some
of the most expensive parts of path component lookup, which was the
d_lock on every component lookup. So I'm seeing improvements of 30-50%
on some seriously pathname-lookup intensive loads.

So last cycle, we got rid of most of the BKL - which was really nice,
but practically speaking it was not a very important lock any more.
This cycle was different: Nick's series (and thanks to everybody else
who helped) really help a very real scalability and performance issue.
And we used to be rather good at pathname lookup before - now we're
just a whole lot better.

Now, those two are my personal favorites, but that's not to say that
you may care. Not all loads are all that name-lookup heavy, and the
scheduler auto-grouping may not matter for you. So to round the thing
up, we have a metric ton of other features, with drivers as usual
accounting for about half of the changes. The most noticeable part
during the merge window was the DRI updates, which caused some pain.
The most obvious fallout of that should all have been fixed, and we
should now have support for the AMD Fusion stuff along with some Fermi
acceleration support. And several updates to the Intel driver too.

But never fear. If you don't care about pathname lookup, scheduling or
graphics cards, I'm sure you can find changes to be excited about,
whatever your area of interest is. SCSI target infrastructure? Or all
the architecture updates (notably ARM and blackfin platform
additions)? Or just the sound and media drivers? Go look at your
favorite area in the git tree, I suspect it has gotten some love.

And as usual, report any regressions to the lists and the appropriate
authorities.

                    Linus
