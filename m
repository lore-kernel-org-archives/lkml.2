Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158Ab0EDUje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:39:34 -0400
Received: from kroah.org ([198.145.64.141]:49765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab0EDUj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:39:29 -0400
Date: Tue, 4 May 2010 13:12:08 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100504201207.GA7096@kroah.com>
References: <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
 <20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
 <20100503234123.GC13519@suse.de>
 <1272931198.30040.218.camel@Joe-Laptop.home>
 <20100504025430.GA26421@suse.de>
 <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 03:02:35PM -0500, H Hartley Sweeten wrote:
> On Tuesday, May 04, 2010 12:07 PM, Joe Perches wrote:
> > On Mon, 2010-05-03 at 19:54 -0700, Greg KH wrote: 
> >>> git push?
> >> I have, and they look to be there to me:
> >>   http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-next-2.6.git;a=commit;h=4f923d004396ef272600d381a365cac9d832486d
> >> So something must be odd on your side.
> >
> > Yup, sorry, my mistake.
> >
> > staging-next is the name of your repository as well as
> > a branch within your repository and git after git clone
> > doesn't by default show all remote branches.
> >
> > $ git clone --reference=linux-2.6 \
> >	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> >
> > $ git branch -r
> >   origin/HEAD -> origin/master
> >   origin/master
> >   origin/staging-next
> >
> > I needed to add a git checkout origin/staging-next
> 
> That tree is still missing a couple commits that are in Linus' tree:
> 
> commit 6536560cabab170ed2969b005bf69a496e9c45bf
>     Staging: dt3155: fix 50Hz configuration
> 
> commit 74a920139a0f1119c5a604cef0ce5d6f591dc782
>     staging: fix dt3155 build

Yes, if you look, the staging-next branch starts on Linus's tree as of
April 8 (just after 2.6.34-rc3).  I don't merge back to Linus's tree a
bunch, because that is not how it should be done.  When I am going to
push these to Linus, then I will merge and handle any fixups if needed.

> Which would probably explain the conflict that occurs in linux-next for
> dt3155_drv.c.

Yes.  And how easy it is to fix up :)

> commit 9e1bd9a6f8c6ad8b461294a365c49b19212178d9
> Merge: 5382319 e595eea
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Tue May 4 15:42:20 2010 +1000
> 
>     Merge remote branch 'staging-next/staging-next'
>     
>     Conflicts:
>         drivers/staging/arlan/arlan-main.c
>         drivers/staging/comedi/drivers/cb_das16_cs.c
>         drivers/staging/cx25821/cx25821-alsa.c
>         drivers/staging/dt3155/dt3155_drv.c
>         drivers/staging/netwave/netwave_cs.c

That doesn't explain how you aren't seeing the correct stuff to base
your patches off of though.

Are you _sure_ you have the 'staging-next' branch of the tree checked
out?

thanks,

greg k-h
