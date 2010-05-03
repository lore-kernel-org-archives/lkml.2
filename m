Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0ECVdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:33:44 -0400
Received: from kroah.org ([198.145.64.141]:36394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0ECVdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:33:43 -0400
Date: Mon, 3 May 2010 14:17:51 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Greg KH <gregkh@suse.de>, "ss@aao.gov.au" <ss@aao.gov.au>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100503211751.GB21402@kroah.com>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
 <20100430215645.GA12409@kroah.com>
 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
 <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 03:15:42PM -0500, H Hartley Sweeten wrote:
> On Monday, May 03, 2010 12:00 PM, Greg KH wrote:
> > On Sun, May 02, 2010 at 01:00:41PM -0500, H Hartley Sweeten wrote:
> >> The macros ReadMReg and WriteMReg are really just private versions of
> >> the kernel's readl and writel functions.  Use the kernel's functions
> >> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> >> change all the uses of dt3155_lbase to reflect this.
> >> 
> >> While here, make dt3155_lbase static since it is only used in the
> >> dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
> >> since it is not used anywhere in the code.
> >> 
> >> Where is makes sense, create a local 'mmio' variable instead of using
> >> dt3155_lbase[minor] to make the code more readable.
> >> 
> >> This change also affects the {Read|Write}I2C functions so they are
> >> also modified as needed.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Scott Smedley <ss@aao.gov.au>
> >
> > Odd, but no, this still does not apply.  I get the following errors:
> > patching file drivers/staging/dt3155/dt3155_drv.c
> > Hunk #1 succeeded at 75 (offset 11 lines).
> > Hunk #2 FAILED at 115.
> > Hunk #3 succeeded at 150 (offset 8 lines).
> > Hunk #4 succeeded at 184 (offset 8 lines).
> > Hunk #5 succeeded at 201 (offset 8 lines).
> > Hunk #6 succeeded at 216 (offset 8 lines).
> > Hunk #7 succeeded at 227 with fuzz 2 (offset 8 lines).
> > Hunk #8 succeeded at 247 with fuzz 2 (offset 8 lines).
> > Hunk #9 FAILED at 257.
> > Hunk #10 succeeded at 273 with fuzz 2 (offset 8 lines).
> > Hunk #11 succeeded at 290 (offset 8 lines).
> > Hunk #12 succeeded at 326 with fuzz 2 (offset 8 lines).
> > Hunk #13 FAILED at 395.
> > Hunk #14 succeeded at 418 with fuzz 2 (offset 8 lines).
> > Hunk #15 succeeded at 435 (offset 8 lines).
> > Hunk #16 FAILED at 438.
> > Hunk #17 FAILED at 456.
> > Hunk #18 FAILED at 471.
> > Hunk #19 succeeded at 501 (offset 8 lines).
> > Hunk #20 succeeded at 510 (offset 8 lines).
> > Hunk #21 succeeded at 699 (offset 8 lines).
> > Hunk #22 succeeded at 727 (offset 8 lines).
> > Hunk #23 succeeded at 929 with fuzz 1 (offset 8 lines).
> > Hunk #24 succeeded at 1054 with fuzz 2 (offset 8 lines).
> > 6 out of 24 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_drv.c.rej
> > patching file drivers/staging/dt3155/dt3155_drv.h
> > patching file drivers/staging/dt3155/dt3155_io.c
> > Hunk #2 FAILED at 77.
> > Hunk #3 FAILED at 103.
> > Hunk #4 FAILED at 119.
> > Hunk #5 FAILED at 134.
> > Hunk #6 FAILED at 151.
> > 5 out of 6 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_io.c.rej
> > patching file drivers/staging/dt3155/dt3155_io.h
> > Reversed (or previously applied) patch detected!  Assume -R? [n] 
> > Apply anyway? [n] 
> > Skipping patch.
> > 2 out of 2 hunks ignored -- saving rejects to file drivers/staging/dt3155/dt3155_io.h.rej
> > 
> > 
> > Did you rebase this on the latest linux-next tree?
> 
> I did.  And I just re-did is again against next-20100503 and it generated the same patch.

Wierd.

> But, I just noticed this:
> 
> $ git log drivers/staging/dt3155
> commit 3c59b4691587b8977cc77ecf07985758a2ba0d97
> Merge: 7f1e428 bed46a8
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon May 3 14:17:49 2010 +1000
> 
>     Merge remote branch 'staging-next/staging-next'
>     
>     Conflicts:
>         drivers/staging/arlan/arlan-main.c
>         drivers/staging/comedi/drivers/cb_das16_cs.c
>         drivers/staging/cx25821/cx25821-alsa.c
>         drivers/staging/dt3155/dt3155_drv.c
>         drivers/staging/netwave/netwave_cs.c
> 
> Could the next tree be out of sync with your tree?

Hm, some other tree might be doing something in those files.  But the
fact that the drivers/staging/dt3155/dt3155_io.h was so wrong it thought
it was a revert, makes me suspect that you did it against something
else.

If you make this against my staging-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
using the staging-next branch, does that make the patch different?

Let me know if you need help doing that.

thanks,

greg k-h
