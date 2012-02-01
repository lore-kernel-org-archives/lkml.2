Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2BAP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:29:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49139 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756503Ab2BAP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:29:40 -0500
Date: Wed, 1 Feb 2012 10:29:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
In-Reply-To: <20120201133642.GC3673@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1202011027150.1405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Pavel Machek wrote:

> > particular, this should help to solve a long-standing issue that, in
> > some cases, during resume from hibernation the boot loader causes the
> > journal to be replied for the filesystem containing the kernel image
> > and/or initrd causing it to become inconsistent with the information
> > stored in the hibernation image.
> 
> Ungood. Why is bootloader/initrd doing that? If it mounts filesystem
> read/write, what is the guarantee that it will not change data on the
> filesystem, breaking stuff?
> 
> Bootloaders should just not replay journals.
> 
> > The user-space-driven hibernation (s2disk) is not covered by this
> > change, because the freezing of filesystems prevents s2disk from
> > accessing device special files it needs to do its job.
> 
> ...so bootloaders need to be fixed, anyway.

I don't know about bootloaders, but from what I've heard, Linux fs
drivers (including those inside initrds) always replay the journal,
even if the filesystem is mounted read-only.  This could be considered
a bug in the filesystem code.

Alan Stern

