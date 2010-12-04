Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0LDDoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 22:44:38 -0500
Received: from plane.gmane.org ([80.91.229.3]:44022 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0LDDoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 22:44:37 -0500
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2010 22:44:37 EST
Message-ID: <4CF9B487.1010009@gmail.com>
Date: Fri, 03 Dec 2010 19:24:55 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@plane.gmane.org>
CC: Kent Overstreet 
	<public-kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        public-linux-bcache-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: Bcache version 9
References: <20101121140808.GA6429@moria> <20101122010914.GB7688@kroah.com> <4CEB7648.8030000@gmail.com> <20101201041610.GA5891@kroah.com>
In-Reply-To: <20101201041610.GA5891@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Sat, 04 Dec 2010 04:26:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 11/30/2010 08:16 PM, Greg KH wrote:
> True, but I thought configfs could handle "bare" config items, you might
> want to look a bit closer as to how people are using it.  But I could be
> totally wrong however.

The documentation is pretty specific and I haven't seen any 
counterexamples, but I'll see what I can find.

>> There do exist global interfaces in sysfs, not attached to any
>> device - besides /sys/kernel, there's /sys/fs which doesn't have any
>> rhyme or reason to it I can discern.
>
> /sys/fs is for different filesystem specific things.
>
>> ecryptfs has
>> /sys/ext4/ecryptfs/version, ext4 has per device stuff that you can't
>> find from the device's dir (you woludn't know /sys/fs/ext4/md0
>> exists from looking at /sys/block/md0). There's also /sys/fs/cgroup,
>> which is another unique thing as far as I can tell...
>
> No, sys/fs/cgroup/ is where the cgroup filesystem is mounted.

Yes, but as far as how the namespace is used it's exactly the same. By 
that logic, I could stick anything in /sys/fs if I made a filesystem for 
it to mount there. cgroupfs is just an interface, users wouldn't care if 
the same interface was written against sysfs (except for mounting 
multiple instances, but that's still not an argument for putting a 
mountpoint in /sys/fs).

>> Then there's /sys/module which has a bunch of ad hoc stuff, but as
>> far as I can tell that's all still module parameters and
>> register_cache and register_dev certainly aren't module parameters.
>
> It's not ad hoc, it's module specific things.

Exactly :p Bcache lives in a module, as does most code. There's no 
pattern to it besides that, is all I was saying.

> What is "bcache"?  Is it related to filesystems?

It uses SSDs to cache block devices; you'd cache say /dev/md0 with 
/dev/sdb, reads and writes get added to the cache and writes get 
buffered in the cache if writeback caching is on.

> If so, use
> /sys/fs/bcache and I have no issues with it.  But don't put it in
> /sys/kernel/ without at least asking.

You could say it's related to filesystems, but it's an awful stretch 
since it lives entirely at the block layer.

It's on the list of things that need fixing before merging, but that's a 
solid list. Priority #1 has been making it rock solid, which appears to 
be done... I've still got to finish handling all the potential memory 
allocation failures correctly and do something about the hooks in the 
block layer, which is a much bigger problem. I prefer my hacks to be 
obvious, ugly hacks :)


