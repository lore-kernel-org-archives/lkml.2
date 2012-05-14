Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2ENUEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:04:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49462 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932304Ab2ENUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:04:00 -0400
Date: Mon, 14 May 2012 16:03:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: get rid of some lockdep false positives
In-Reply-To: <20120514191853.GA4344@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1205141553290.1699-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Greg KH wrote:

> > ---
> > 
> >  drivers/usb/core/sysfs.c |    6 +++---
> >  fs/sysfs/dir.c           |   31 ++++++++++++++++++++++++++-----
> >  include/linux/device.h   |    3 +++
> >  include/linux/sysfs.h    |   12 ++++++++++++
> >  4 files changed, 44 insertions(+), 8 deletions(-)
> > 
> > Index: usb-3.4/include/linux/sysfs.h
> > ===================================================================
> > --- usb-3.4.orig/include/linux/sysfs.h
> > +++ usb-3.4/include/linux/sysfs.h
> 
> Just a note about this patch, from a meta-point of view (I have no
> objection to the patch at all, I'll go apply it in a bit.)
> 
> You do use git to generate these patches, right?  Or are you using
> something else?  The "Index:" lines seem odd, like cvs things.

No, I use quilt, with QUILT_REFRESH_ARGS set to "--diffstat 
--no-timestamps -p1" in my .quiltrc file.  There's an option to 
suppress the Index: lines but I never bothered to set it.

> Also, I just learned about the '--3way' option to 'git am', which, when
> I have merge problems with a patch (like, for example this one, which
> had rejects in the device.h portion), should be able to help me out, if
> you used git to generate the patch.
> 
> But, if you don't use git, no problems, I was just curious as to what
> was creating the "Index:" lines.

They are added explicitly by /usr/share/quilt/scripts/patchfns -- grep
for "Index:".  I don't know why quilt adds those lines, though.  
Trying to resemble cvs output, maybe?

Alan Stern

