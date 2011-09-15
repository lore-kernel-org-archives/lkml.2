Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122Ab1IOVjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:39:21 -0400
Received: from mail-ew0-f43.google.com ([209.85.215.43]:60578 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935035Ab1IOVjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:39:20 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 17:39:20 EDT
MIME-Version: 1.0
In-Reply-To: <CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
	<CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
Date: Thu, 15 Sep 2011 14:33:36 -0700
Message-ID: <CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 2:15 PM, Dan Williams <dan.j.williams@gmail.com> wrote:
> On Sun, Sep 11, 2011 at 6:44 PM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
>> On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
>>> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.com> wrote:
>>> > I don't think that makes any more sense, as module paramaters AFAIK are
>>> > even more explicitly just a value you can stick in and pull out.
>>> > /sys/fs/bcache/register is really more analagous to mount().
>
> ... and you looked at module_param_call()?

Damn, nope. I still think a module parameter is even uglier than a
sysfs file, though.

As far as I can tell, the linux kernel is really lacking any sort of
coherent vision for how to make arbitrary interfaces available from
the filesystem.

We all seem to agree that it's a worthwhile thing to do - nobody likes
ioctls, /proc/sys has been around for ages; something visible and
discoverable beats an ioctl or a weird special purpose system call any
day.

But until people can agree on - hell, even come up with a decent plan
- for the right way to put interfaces in the filesystem, I'm not going
to lose much sleep over it.

>> I looked into that many months ago, spent quite a bit of time fighting
>> with the dm code trying to get it to do what I wanted and... no. Never
>> again
>
> Did you do a similar analysis of md?  I had a pet caching project that
> had it's own sysfs interface registration system, and came to the
> conclusion that it would have been better to have started with an MD
> personality.  Especially when one of the legs of the cache is a
> md-raid array it helps to keep all that assembly logic using the same
> interface.

I did spend some time looking at md, I don't really remember if I gave
it a fair chance or if I found a critical flaw.

I agree that an md personality ought to be a good fit but I don't
think the current md code is ideal for what bcache wants to do. Much
saner than dm, but I think it still suffers from the assumption that
there's some easy mapping from superblocks to block devices, with
bcache they really can't be tied together.

> And md supports assembling devices via sysfs without
> requiring mdadm which is a nice feature.

Didn't know that, I'll have to look at that. If nothing else
consistency is good...

> Also has the benefit of reusing the distro installation / boot
> enabling for md devices which turned out to be a bit of work when
> enabling external-metadata in md.

Dunno what you mean about external metadata, but it would be nice to
not have to do anything to userspace to boot from a bcache device. As
is though it's only a couple lines of bash you have to drop in your
initramfs.
