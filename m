Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0DUUhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:37:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:46873 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0DUUhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:37:24 -0400
Date: Wed, 21 Apr 2010 14:37:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Bruno =?ISO-8859-1?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>
Subject: Re: [RFC] Initial OLPC Viafb merge
Message-ID: <20100421143721.36f62d4d@bike.lwn.net>
In-Reply-To: <4BC3DF05.9060400@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<4BBEBE87.4000809@gmx.de>
	<20100409124626.0b150104@bike.lwn.net>
	<4BBFB914.1020600@gmx.de>
	<20100409182722.3080bb2d@bike.lwn.net>
	<4BBFCE24.2070207@gmx.de>
	<20100410105241.5df22845@neptune.home>
	<4BC3DF05.9060400@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trying to get caught up again ... ]

On Tue, 13 Apr 2010 05:03:33 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> Good news! After some hours of hacking, damaging a filesystem and nearly 
> smashing my SD card I've found a promising way to implement suspend and 
> resume in viafb based on the first patch of this series. I think this is 
> something that can be done for the next merge window. 

This all sounds good.

> I'll start a clean 
> implementation after Jon sent an updated patch series (including the 
> initial s&r implementation)

I'd missed that on my previous reading.  Do you want me to post a new
S/R version over the latest patch set?

> However:
> - suspending is very slow, looks like it takes double the time compared 
> to before s&r support was added to viafb (this is also with only the 
> original patch)

You mean, double the time without actually dealing with the frame
buffer?  I'm a little confused there.

> - does not restore some values in the mmio but reinitializes it instead. 
> Do you need any special values restored, Jon?

Code using MMIO (the camera in particular) definitely needs stuff
done; the OLPC code can currently suspend and resume with the camera
streaming and it all works.

What I'd done was to move core S/R into via-core.c (which you've not
yet seen, but which I hope to get posted tomorrow) and give subdevices
a hook so they can be called for S/R events.  That lets each subdev
ensure that its own needs are met.

Now, I'd been expecting to strip that out on the assumption that the
current S/R code wasn't going to make it upstream.  I could change
plans, though, if that's helpful.

> > When I get time to, I will give these patches a try. A central GIT tree
> > where all viafb patches get collected would definitely be nice (even with
> > multiple semi-throw-away "topic" branches).
> 
> Yes, I guess that would be a good idea at least now where 2 people are 
> actively working on viafb. I have also a few minor patches ready I'll 
> send in a few days (after having repaired my development environment).

As a starting point, I've set up:

	git://git.lwn.net/linux-2.6.git viafb-next

That's for patches aimed at linux-next.  It contains the last series I
sent out, plus one embarrassing compilation fix.  Once I have other
stuff ready for review (soon!), I'll stick it into a different branch.

Incidentally, the "olpc-2.6.31-cam" branch there has the full set of
code as used by OLPC now.  That branch reflects a lot history of
figuring out how this hardware actually works (sometimes it looks
vaguely like what's in the datasheet, but I think that's coincidental);
some real cleanup needs to happen on the way to the mainline.

Thanks,

jon
