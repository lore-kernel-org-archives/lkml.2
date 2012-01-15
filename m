Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2AOSh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:37:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2AOSh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:37:27 -0500
Date: Sun, 15 Jan 2012 19:37:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Ted Ts'o" <tytso@mit.edu>, Vincent Pelletier <plr.vincent@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ext4 bug ? "Intel 320 SSD write performance ??? contd."
Message-ID: <20120115183726.GA20506@atrey.karlin.mff.cuni.cz>
References: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com>
 <20111031210951.GK16825@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031210951.GK16825@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Reading this blog post[1], I thought the "2nd iteration" results could be
> > considered a bug in mkfs.ext4 (and possibly any mkfs implementation):
> > shouldn't mkfs run [FI]TRIM on its target before creating filesystem
> > structure ?
> 
> It's not enabled by default, because there are crappy SSD's out there
> where use of the TRIM command will turn them into bricks.  (No, it's
> not the Intel X-25 drives that I'm worried about.)
> 
> So I (and the distributions) don't want to make it the default, since
> if you buy crap drives and then mke2fs turns them into bricks, who are
> you likely to blame?  The crap SSD manufacturer?  Yourself for trying
> to buy SSD's on the cheap?  Or the program that issued the TRIM
> command?

Kernel for allowing userspace damage the hardware?

If there are known-bad drives, we should blacklist them, and kernel
should -EPERM on attempts to trim.

If it is too widespread, we  should probably create a whitelist...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
