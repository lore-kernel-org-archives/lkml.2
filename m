Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab0EUXhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:37:09 -0400
Received: from kroah.org ([198.145.64.141]:33333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab0EUXhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:37:07 -0400
Date: Fri, 21 May 2010 16:36:55 -0700
From: Greg KH <greg@kroah.com>
To: Neil Brown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: linux-next: build failure after merge of the staging-next tree
Message-ID: <20100521233655.GD31430@kroah.com>
References: <20100430155205.a4171034.sfr@canb.auug.org.au>
 <20100430144340.GD1824@kroah.com>
 <20100518153020.06d5a602@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518153020.06d5a602@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:30:20PM +1000, Neil Brown wrote:
> On Fri, 30 Apr 2010 07:43:40 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Apr 30, 2010 at 03:52:05PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the staging-next tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > drivers/md/md.c: In function 'level_store':
> > > drivers/md/md.c:3029: error: too few arguments to function 'sysfs_get_dirent'
> > > 
> > > Caused by commit 262f8e4937e7b4a587923ca3c039a184668f49ec ("sysfs:
> > > Implement sysfs tagged directory support") from the driver-core tree
> > > interacting with commit fecc531e3cc0de60514d326c7d82f1075ed55888 ("md:
> > > manage redundancy group in sysfs when changing level") from the md.
> > > 
> > > I have applied this fixup patch for today and can carry it as necessary.
> > > 
> > > [This could have been avoided, of course, by creating a new API (maybe
> > > sysfs_get_dirent_tagged) and implementing the old API in terms of that].
> > 
> > Thanks for the fixup.
> 
> hi Greg,
>  I'm assuming that you will submit you patch queue to Linus first, then I
>  will create a merge which fixes this issue and ask Linus to pull that - so
>  everything is all still bisectable without me rebasing.
> 
>  If you are OK with that, please let me know when you have submitted your
>  queue..  I'll try to keep and eye open, but I might miss it...

The drivercore queue is now in Linus's tree.

Oh, you missed a kref_set() usage in the tree as well, you might want to
fix that up also.

thanks,

greg k-h
