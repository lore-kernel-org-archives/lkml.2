Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0LITzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:55:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:39258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0LITzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:55:06 -0500
Date: Thu, 9 Dec 2010 11:54:01 -0800
From: Greg KH <gregkh@suse.de>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        hch@infradead.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
Message-ID: <20101209195401.GA27819@suse.de>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
 <20101209192050.GA26457@suse.de>
 <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:49:32PM -0700, Andreas Dilger wrote:
> On 2010-12-09, at 12:20, Greg KH wrote:
> > On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
> >> For a long time it has been pretty painful to retrieve informations from
> >> /sys/block/*/queue for particular block device. Not only it is painful
> >> to retrieve informations within C tool, parsing strings, etc, but one
> >> have to run into problem even finding the proper path in sysfs.
> > 
> > What's wrong with using libudev?  That should give you all of this
> > information easily using a .c program without any need to change the
> > kernel at all.
> > 
> > Ick, no, please just use the sysfs files, don't create a new ioctl, they
> > are horrid.
> 
> Can you please show a real example of how using libudev is less horrid
> than just calling "ioctl(fd, BLKGETQUEUEINFO, &val)"?

It doesn't need permissions to open that fd in the first place, and in
maintaining the ioctl from within the kernel code, it's a _world_ easier
to handle over time.

I'm not saying that your .c code is somehow "easier" than just using an
ioctl, I'm saying that it is "future proof and saner" to use libudev
than to try to parse sysfs files yourself.

> How is trying to map a block device name from /etc/mtab (via
> getmntent()) into a possibly wildly different block device name in
> /sys (e.g. /dev/vgroot/lvhome vs. /dev/dm-0 vs.
> /dev/mapper/vgroot-lvhome => /sys/block/dm-0), then parsing text
> output considered a "good API"?

Again, use libudev, it handles that mapping for you and you don't have
to parse text output.

good luck,

greg k-h
