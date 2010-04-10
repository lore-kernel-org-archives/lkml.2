Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0DJQYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:24:51 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45561 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0DJQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=waepOQ6T9gUHHKP8hiHJyUwzRQ+rk4GkBTmEuG6d98R4e/CFuAAo+UeMJj+Xy6Yeaq
         LeF4Yixv8vB6MQTcTc/FBIKCxtrCrX6No76JSKo1Bs4J7Rw7f5qyzSsyW7AmdeDE3aGd
         lAuCXiJYm6ypY+BwHqJde3fbSUow36MHg53LI=
Date: Sat, 10 Apr 2010 18:24:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100410162439.GH5204@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312221.23953.arnd@arndb.de> <20100331214058.GE5163@nowhere> <201004011442.38536.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011442.38536.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 02:42:38PM +0200, Arnd Bergmann wrote:
> On Wednesday 31 March 2010, Frederic Weisbecker wrote:
> > On Wed, Mar 31, 2010 at 10:21:23PM +0200, Arnd Bergmann wrote:
> > 
> > > In the meantime, we can move the declaration of the .locked_ioctl callback
> > > into an #ifdef CONFIG_BKL, to make sure nobody builds a driver with an
> > > ioctl function that does not get called.
> > 
> > 
> > Ok, now how to get this all merged? A single monolithic patch is probably
> > not appropriate.
> > 
> > The simplest is to have a single branch with the default_ioctl implemented,
> > and then attributed to drivers in a set cut by subsystems/drivers. And
> > push the whole for the next -rc1.
> > 
> > The other solution is to push default_ioctl for this release and get
> > the driver changes to each concerned tree. That said, I suspect a good
> > part of them are unmaintained, hence the other solution looks better
> > to me.
> 
> I don't care much about the unmaintained parts, we can always have a
> tree collecting all the patches for those drivers and merge it in -rc1.
> 
> I'd say the nicest way would be to get Linus to merge the patch
> below now, so we can start queuing stuff in maintainer trees on top
> of it, and check against linux-next what is still missing and push
> all of them from our branch.
> 
> 	Arnd
> 
> ---
> Subject: [PATCH] introduce CONFIG_BKL and default_ioctl
> 
> This is a preparation for the removal of the big kernel lock that
> introduces new interfaces for device drivers still using it.
> 
> We can start marking those device drivers as 'depends on CONFIG_BKL'
> now, and make that symbol optional later, when the point has come
> at which we are able to build a kernel without the BKL.
> 
> Similarly, device drivers that currently make use of the implicit
> BKL locking around the ioctl function can now get annotated by
> changing
> 
> 	.ioctl = foo_ioctl,
> 
> to
> 
> 	.locked_ioctl = foo_ioctl,
> 	.unlocked_ioctl = default_ioctl,
> 
> As soon as no driver remains using the old ioctl callback, it can
> get removed.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Al, we would like to make this for 2.6.34, so that we can start
converting the drivers that use bkl'ed ioctl to this new scheme
in the relevant maintainers trees.

Can we get your ack?

Thanks.

