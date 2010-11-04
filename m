Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0KDWgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:36:00 -0400
Received: from kroah.org ([198.145.64.141]:47314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab0KDWf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:35:59 -0400
Date: Thu, 4 Nov 2010 15:36:41 -0700
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Message-ID: <20101104223641.GA3596@kroah.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <20101103174607.GA6777@kroah.com> <201011050958.39020.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011050958.39020.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 09:58:38AM +1300, Charles Manning wrote:
> On Thursday 04 November 2010 06:46:07 Greg KH wrote:
> > On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
> > > From: Charles Manning <cdhmanning@gmail.com>
> > >
> > > Adding yaffs2 file system.
> > >
> > > Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> > > ---
> > >  fs/yaffs2/Kconfig  |  190
> > > ++++++++++++++++++++++++++++++++++++++++++++++++++++ fs/yaffs2/Makefile |
> > >   17 +++++
> >
> > Don't do this as your first patch, make it your last one.  Otherwise the
> > build will break when you apply this one to the tree.
> > Remember, we need to be able to have a correct build at every patch in
> > the whole development series, otherwise tools like 'git bisect' will not
> > work properly.
> 
> I left the actual hook in to the tree building to the last patch which changes 
> fs/Kconfig and fs/Makefile.  Thus building the whole of Linux would not 
> break.
> 
> I suppose the best is to put all the Kconfigs and Makefile changes in the last 
> patch.

Either way, you are correct, this works as-is, it was my mistake in
reviewing it, sorry for the noise.

> > Also, is your goal to get this cleaned up good enough to get it into .38
> > in the "real" place in the kernel, or do you want to see it go through
> > staging and take a bit longer to get everything cleaned up properly
> > before moving to the "real" location?
> 
> My goal it to get this into mainline, .38 preferred.
> 
> I am a complete newbie when it comes to this process. What's the best
> path to getting there? 

I don't know, both will work.

> My preference is to keep cleaning up code in yaffs.net and patching
> from there as this will keep the trees closer together and minimise
> clerical issues.

Sure, but remember, once the code goes into mainline, having an external
tree is a huge liability, not a benifit at all, so consider dropping it.

Until then, if you want to go for .38 in the "real" part of the tree,
take the review comments people made, and then respin the patches and
resend them asking for comments.  I think Andrew Morton usually merges
new filesystems, so after everyone on linux-fs is "happy" with the
patches, ask him to take them for merging into .38.

Good luck,

greg k-h
