Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab2BJCwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:52:32 -0500
Received: from mail2.shareable.org ([80.68.89.115]:47047 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2BJCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:52:31 -0500
Date: Fri, 10 Feb 2012 02:52:17 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20120210025217.GA9258@jl-vm1.vm.bytemark.co.uk>
References: <20120201133642.GC3673@elf.ucw.cz>
 <Pine.LNX.4.44L0.1202011027150.1405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202011027150.1405-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 1 Feb 2012, Pavel Machek wrote:
> 
> > > particular, this should help to solve a long-standing issue that, in
> > > some cases, during resume from hibernation the boot loader causes the
> > > journal to be replied for the filesystem containing the kernel image
> > > and/or initrd causing it to become inconsistent with the information
> > > stored in the hibernation image.
> > 
> > Ungood. Why is bootloader/initrd doing that? If it mounts filesystem
> > read/write, what is the guarantee that it will not change data on the
> > filesystem, breaking stuff?
> > 
> > Bootloaders should just not replay journals.
> > 
> > > The user-space-driven hibernation (s2disk) is not covered by this
> > > change, because the freezing of filesystems prevents s2disk from
> > > accessing device special files it needs to do its job.
> > 
> > ...so bootloaders need to be fixed, anyway.
> 
> I don't know about bootloaders, but from what I've heard, Linux fs
> drivers (including those inside initrds) always replay the journal,
> even if the filesystem is mounted read-only.  This could be considered
> a bug in the filesystem code.

Theoretically a filesystem might need replay for the bootloader to see
a non-corrupt image, even for just the files it uses.

For example if the last state was in the middle of updating the root
directory, the /boot entry in the root directory might not be reliably
found without replaying the journal.

However replaying a journal when mounted read-only should probably
track journalled blocks in memory only, not commit back to the storage.

All the best,
-- Jamie
