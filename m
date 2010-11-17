Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab0KQVRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:17:23 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50707 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933693Ab0KQVRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:17:21 -0500
Date: Wed, 17 Nov 2010 22:19:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Message-ID: <20101117211917.GA394@elf.ucw.cz>
References: <20101114052138.GB2189@elf.ucw.cz>
 <201011152326.44357.rjw@sisk.pl>
 <20101116052634.GA30449@elf.ucw.cz>
 <201011162327.27454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011162327.27454.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > ...but there's enough -- or at least it was enough to fit previous
> > > > versions. 32-bit machine, so it has highmem.
> > > > 
> > > > System is in console mode, very lightly loaded.
> > > > 
> > > > Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
> > > > Swap:   779148k total,     2360k used,   776788k free,   546388k cached
> > > 
> > > Well, the swap is rather in short supply.  Below the 50% of RAM recommendation.
> > 
> > Well, but the biggest image we can write is not 50% of RAM, but 50% of
> > lowmem... 
> 
> No, it is not.  It's been 50% of RAM for a couple of years now. :-)




> > > > PM: thaw of devices complete after 539.577 msecs
> > > > PM: writing image.
> > > > PM: Free swap pages: 194166
> > > > PM: Not enough free swap
> > > > Restarting tasks ...
> > > > 
> > > > Aha, and it is the new default /sys/power/image_size .. setting it to
> > > > 0 lets machine hibernate. I guess the new default is very wrong for
> > > > highmem machine...
> > > 
> > > The old default did the wrong thing for everyone with sufficient swap (it made
> > > the OOM code trigger every time while preparing to create an image), so I think
> > > the new one it's better overall.
> > 
> > OOM? No... image_size of 0 should have written "as small image as
> > possible"; slow, but should not OOM.
> 
> This is not how it works now.  We preallocate memory to create memory pressure,
> so if image_size is 0, we need to preallocate until we run out of pages that
> can be freed, which means OOM.

That's bad, right? Instead of killing 

Anyway, it does not work at all.

root@amd:~# echo 300000000 > /sys/power/image_size
root@amd:~# echo disk > /sys/power/state 
-su: echo: write error: No space left on device

(And dmesg full of failed allocations).

I can write 400M there, and it fails, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
