Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1CJUvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:51:35 -0500
Received: from kroah.org ([198.145.64.141]:35911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1CJUve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:51:34 -0500
Date: Thu, 10 Mar 2011 12:50:54 -0800
From: Greg KH <greg@kroah.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Dr Andrew John Hughes <ahughes@redhat.com>, mkl@pengutronix.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] NFS regression in 2.6.37.1 (current stable)
Message-ID: <20110310205054.GA1861@kroah.com>
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
 <1299785965.3075.30.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299785965.3075.30.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:39:25PM -0500, Trond Myklebust wrote:
> On Thu, 2011-03-10 at 18:53 +0000, Dr Andrew John Hughes wrote: 
> > [Please CC me on responses as I'm not subscribed]
> > 
> > Hi,
> > 
> > I seem to have uncovered a regression in the NFS code between 2.6.37 and 2.6.37.1
> > caused by this changeset:
> > 
> > commit 55ea499d60aefa3d03a77fc8590c26b5881faa92
> > Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date:   Sat Jan 8 17:45:38 2011 -0500
> > NFS: Don't use vm_map_ram() in readdir
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commit;h=6650239a4b01077e80d5a4468562756d77afaa59
> > 
> > With this change applied, copying of files between NFS and non-NFS
> > mounts seems to be broken.  The easiest way I've found to replicate
> > this myself is to use a VCS to do a clone of a tree on a NFS mount to
> > a directory on a non-NFS mount.  I used Mercurial, as I had Mercurial
> > trees to hand from work on IcedTea, but I assume doing it with a git
> > tree such as the linux tree would also work.  The idea is to do
> > something which involves copying over a bunch of directories and
> > checking the result is readable.
> > 
> > $ hg clone $HOME/projects/openjdk/icedtea6-hg
> > destination directory: icedtea6-hg
> > updating to branch default
> > abort:
> > data/contrib/templater/hotspot/src/cpu/CPU/vm/bytecodeInterpreter_CPU.inline.hpp.i@16d04ce16287:
> > no match found!
> > 
> > In the above, $HOME is an NFS mount and $PWD is a local reiserfs
> > partition.  I initially hit failures doing builds with source on $HOME
> > and the build directory on a local reiserfs partition.  In that
> > scenario, it would fail as not being able to find files that should
> > have been copied over.
> > 
> > Reverting the changeset fixes the issue.  2.6.37.2 still has the bug.
> > I haven't checked 2.6.37.3 yet but I didn't see any NFS changes in there.
> > --
> > Andrew :)
> > 
> > Free Java Software Engineer
> > Red Hat, Inc. (http://www.redhat.com)
> 
> It looks to me as if you are hitting the issue that was fixed in
> mainline by commit d1205f87bbb8040c1408bbd9e0a720310b2b0b9b (NFS: NFSv4
> readdir loses entries). That commit was labelled as "Cc:
> stable@kernel.org" but has still not made it into the 2.6.37 stable
> series.
> 
> I've attached it below...

That's because this patch does not apply to the 2.6.37-stable kernel
tree.  I should have sent out an email saying that this is why it was
not included.

Just to be sure, I just now resent the "this doesn't apply" email.
Please feel free to backport it and send it to stable@kernel.org and I
will be glad to queue it up.

thanks,

greg k-h
