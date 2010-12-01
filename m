Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0LAEPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:15:22 -0500
Received: from kroah.org ([198.145.64.141]:44379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0LAEPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:15:20 -0500
Date: Tue, 30 Nov 2010 20:16:10 -0800
From: Greg KH <greg@kroah.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Bcache version 9
Message-ID: <20101201041610.GA5891@kroah.com>
References: <20101121140808.GA6429@moria>
 <20101122010914.GB7688@kroah.com>
 <4CEB7648.8030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEB7648.8030000@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:07:36AM -0800, Kent Overstreet wrote:
> On 11/21/2010 05:09 PM, Greg KH wrote:
> >On Sun, Nov 21, 2010 at 06:09:34AM -0800, Kent Overstreet wrote:
> >>+++ b/Documentation/bcache.txt
> >
> >For new sysfs files, please create Documentation/ABI files.
> >
> >>+All configuration is done via sysfs. To use sde to cache md1, assuming the
> >>+SSD's erase block size is 128k:
> >>+
> >>+  make-bcache -b128k /dev/sde
> >>+  echo "/dev/sde">  /sys/kernel/bcache/register_cache
> >>+  echo "<UUID>  /dev/md1">  /sys/kernel/bcache/register_dev
> >
> >/sys/kernel/bcache/?  Really?
> 
> That was a completely arbitrary choice dating from when I first
> started hacking on it. No point in moving it when it might be moved
> again :p

Heh.

> >Come on, shouldn't this be somewhere else?  You only have 1 file here,
> >right?
> 
> Two files (really three, but the third is for gimpy latency tracing
> and will die eventually). register_dev is there so on bootup you
> don't have to wait for the cache to be discovered - when you add a
> cache device if there's a backing device waiting for a cache, and
> the cache has seen that UUID before it'll do what you want.
> 
> >Shouldn't it be a configfs file instead as that is what you are doing?
> 
> That was one of the possibilities I had in mind. My main issue with
> that though is I don't see any way to just have a bare config_item -
> per the documentation, the user must do a mkdir() first, which just
> doesn't make any sense for bcache. There's no point in having a
> persistent object besides the one associated with the block device.
> Maybe there would be in the future, with multiple cache devices, but
> I still think it's a lousy interface for that problem - what bcache
> wants is something more like a syscall; you wouldn't use configfs to
> replace mount(), for example.

True, but I thought configfs could handle "bare" config items, you might
want to look a bit closer as to how people are using it.  But I could be
totally wrong however.

> There do exist global interfaces in sysfs, not attached to any
> device - besides /sys/kernel, there's /sys/fs which doesn't have any
> rhyme or reason to it I can discern.

/sys/fs is for different filesystem specific things.

> ecryptfs has
> /sys/ext4/ecryptfs/version, ext4 has per device stuff that you can't
> find from the device's dir (you woludn't know /sys/fs/ext4/md0
> exists from looking at /sys/block/md0). There's also /sys/fs/cgroup,
> which is another unique thing as far as I can tell...

No, sys/fs/cgroup/ is where the cgroup filesystem is mounted.

> Then there's /sys/module which has a bunch of ad hoc stuff, but as
> far as I can tell that's all still module parameters and
> register_cache and register_dev certainly aren't module parameters.

It's not ad hoc, it's module specific things.

> So anyways, I absolutely agree that there are better solutions than
> /sys/kernel/bcache but I want to replace it with something correct,
> not something that sucks less. Ideas/flames are of course more than
> welcome :)

What is "bcache"?  Is it related to filesystems?  If so, use
/sys/fs/bcache and I have no issues with it.  But don't put it in
/sys/kernel/ without at least asking.

thanks,

greg k-h
