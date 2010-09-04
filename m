Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0IDXXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:23:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:53224 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab0IDXXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:23:53 -0400
Date: Sat, 4 Sep 2010 19:23:52 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100904232351.GG4887@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de>
 <201009041839.09261.Martin@lichtvoll.de>
 <20100904184611.GC4887@thunk.org>
 <201009042111.41695.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009042111.41695.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 09:11:34PM +0200, Martin Steigerwald wrote:
> 
> Stop! I think we are misunderstanding.
> 
> Its a bug I stumpled across the bisecting process. Neither 2.6.33 or 
> 2.6.34 are affected, but some kernels in between. As such I didn't think 
> its worth reporting the bug.
> 
> I made a photo of part of the backtrace tough, so if you want I open a bug 
> report about it nonetheless. But I really think it has been fixed during 
> the 2.6.33 to 2.6.34 development cycle.

FYI, it's fair game to send a note to LKML with the backtrace, saying,
I'm getting this wierd stack trace while trying to do a bisect; it
looks like it's fixed in 2.6.34, does it look familiar?  If so,
someone might be able to point you at the commit that fixes the bug,
and then you can apply that patch by hand while doing the bisect at
each step (and then unapply it before doing the next bisect
iteration).

> For now I just skipped affected kernels in the bisection process in the 
> hope that none is the first last good or first bad one regarding the freeze 
> bug. Since for now it has all been kernels of a usb merge that showed this 
> issue, I don't think the freeze bug is in there.

Are you actually booting off of a USB device?  Even if you are, it
seems... strange... that a series of USB patches would cause an
ext4/readahead kernel OOPS.  Can you disable using USB devices, which
would hopefully prevent the problem from showing up?

Note by the way, that you don't have to try compiling at the points
chosen by "git bisect".  If you run into problems, you can try going
to the head of the USB patches, and if that works, report that
particular commit as "good" or "bad".

> So I just wanted to show that I am seriously working on tracking down that 
> likely radeon kms related freeze bug and that its time-consuming for me 
> due to having lots of unbootable kernels.

Have you reported this bug to the maintainer?  Is he helping you out?
Have you looked at the various Radeon-related commits between 2.6.34
and 2.6.33?  I imagine there probably aren't that many of them.  You
might try testing commits just before and after the Radeon-related
commits, which might speed up the git bisect significantly.

						- Ted
