Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1LVWlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:41:07 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55649 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1LVWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:41:04 -0500
X-Sasl-enc: /VOsrNwKFcrZLWV2egChXGSGwwbTy5ISlPEbs8Z2x/5o 1324593663
Date: Thu, 22 Dec 2011 14:40:59 -0800
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging
 foundation
Message-ID: <20111222224059.GA16558@kroah.com>
References: <20111222155050.GA21405@ca-server1.us.oracle.com>
 <20111222173129.GB28856@kroah.com>
 <1f76c37d-15d4-4c62-8c64-8293d3382b4a@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f76c37d-15d4-4c62-8c64-8293d3382b4a@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:06:26PM -0800, Dan Magenheimer wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> 
> Thanks for the quick response!
> 
> > Sent: Thursday, December 22, 2011 10:31 AM
> > To: Dan Magenheimer
> > Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org;
> > Konrad Wilk; Kurt Hackel; sjenning@linux.vnet.ibm.com; Chris Mason
> > Subject: Re: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging foundation
> > 
> > On Thu, Dec 22, 2011 at 07:50:50AM -0800, Dan Magenheimer wrote:
> > > >From 93c00028709a5d423de77a2fc24d32ec10eca443 Mon Sep 17 00:00:00 2001
> > > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > > Date: Wed, 21 Dec 2011 14:01:54 -0700
> > > Subject: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging foundation
> > 
> > Why duplicate this in the email body?  That forces me to edit the
> > patches and remove them, please use git send-email...
> 
> OK, sorry, will do.  Still learning the git tools and my mutt
> scripts use that line to create the subject line.  I'll try
> git-send-email next time.
>  
> > > Copy cluster subdirectory from ocfs2.  These files implement
> > > the basic cluster discovery, mapping, heartbeat / keepalive, and
> > > messaging ("o2net") that ramster requires for internode communication.
> > > Note: there are NO ramster-specific changes yet; this commit
> > > does NOT pass checkpatch since the copied source files do not.
> > 
> > Why are you copying the files, and not just exporting the symbols you
> > need/want to use here?  Are you going to be able to properly track
> > keeping this code in sync?
> 
> This particular part of ocfs2 has never been broken out for non-ocfs2
> use before, some changes to the ocfs2 core cluster code is necessary
> for ramster to use that code (see patch 3), and ramster is currently
> incompatible with real ocfs2 anyway (requires !CONFIG_OCFS2_FS).  I will
> definitely work with Joel Becker to see if these code interdependencies
> can be merged before ramster could possibly be promoted out of staging but,
> for now for staging, this seemed to be an expedient way to make
> use of the ocfs2 core cluster code but still incorporate some required
> ramster changes.  This way, also, I think it is not necessary to keep the
> code in sync every release, but still allow for easy merging later.
> 
> > Same goes for your other patch in this series that copies code, why do
> > that?
> 
> The other code copies are from drivers/staging/zcache.  The tmem.c/h
> changes can definitely be shared between zcache and ramster (and
> I've said before that the eventual destination tmem.c/h is the linux
> lib directory).  The zcache.c changes are most likely mergeable but
> I know that Seth Jennings and Nitin Gupta are working on some
> other significant changes (including a new allocator which would
> replace the lengthy zbud code and breaking zcache.c into many smaller
> files), so thought it best to branch temporarily and merge later.
> 
> > Are there goals to eventually not have duplicated code?  If so,
> > what are they, and why not mention them?
> 
> Sorry, you're right, I should have included the above paragraphs
> in the commit comments.

Ok, that makes sense.

Can you ensure that the TODO file in this driver's directory says that
you will remove the duplicated code from it before it can be merged into
the main part of the kernel tree?

That, and fix up the other things mentioned and resend it and I'll be
glad to queue it up.

thanks,

greg k-h
