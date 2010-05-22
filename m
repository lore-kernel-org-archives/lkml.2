Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0EVAVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:21:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0EVAVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:21:04 -0400
Date: Sat, 22 May 2010 10:20:48 +1000
From: Neil Brown <neilb@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>, Sage Weil <sage@newdream.net>
Subject: Re: linux-next: build failure after merge of the staging-next tree
Message-ID: <20100522102048.3923b197@notabene.brown>
In-Reply-To: <20100521233655.GD31430@kroah.com>
References: <20100430155205.a4171034.sfr@canb.auug.org.au>
	<20100430144340.GD1824@kroah.com>
	<20100518153020.06d5a602@notabene.brown>
	<20100521233655.GD31430@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 16:36:55 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, May 18, 2010 at 03:30:20PM +1000, Neil Brown wrote:
> > On Fri, 30 Apr 2010 07:43:40 -0700
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Fri, Apr 30, 2010 at 03:52:05PM +1000, Stephen Rothwell wrote:
> > > > Hi Greg,
> > > > 
> > > > After merging the staging-next tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > > 
> > > > drivers/md/md.c: In function 'level_store':
> > > > drivers/md/md.c:3029: error: too few arguments to function 'sysfs_get_dirent'
> > > > 
> > > > Caused by commit 262f8e4937e7b4a587923ca3c039a184668f49ec ("sysfs:
> > > > Implement sysfs tagged directory support") from the driver-core tree
> > > > interacting with commit fecc531e3cc0de60514d326c7d82f1075ed55888 ("md:
> > > > manage redundancy group in sysfs when changing level") from the md.
> > > > 
> > > > I have applied this fixup patch for today and can carry it as necessary.
> > > > 
> > > > [This could have been avoided, of course, by creating a new API (maybe
> > > > sysfs_get_dirent_tagged) and implementing the old API in terms of that].
> > > 
> > > Thanks for the fixup.
> > 
> > hi Greg,
> >  I'm assuming that you will submit you patch queue to Linus first, then I
> >  will create a merge which fixes this issue and ask Linus to pull that - so
> >  everything is all still bisectable without me rebasing.
> > 
> >  If you are OK with that, please let me know when you have submitted your
> >  queue..  I'll try to keep and eye open, but I might miss it...
> 
> The drivercore queue is now in Linus's tree.

Thanks Greg.
I've created a merge which resolves the sysfs_get_dirent issue and sent Linus
a pull request.

> 
> Oh, you missed a kref_set() usage in the tree as well, you might want to
> fix that up also.

That would be the one in fs/ceph ??
Sage knows about that and presumably has a fix queued.
  http://lkml.org/lkml/2010/3/17/224

Thanks,
NeilBrown



> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

