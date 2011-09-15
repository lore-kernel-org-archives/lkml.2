Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990Ab1IOVPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:15:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56465 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1IOVPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110912014407.GA5171@moria>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
Date: Thu, 15 Sep 2011 14:15:19 -0700
Message-ID: <CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Dan Williams <dan.j.williams@gmail.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
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

On Sun, Sep 11, 2011 at 6:44 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
>> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.com> wrote:
>> > I don't think that makes any more sense, as module paramaters AFAIK are
>> > even more explicitly just a value you can stick in and pull out.
>> > /sys/fs/bcache/register is really more analagous to mount().

... and you looked at module_param_call()?

>> > You're not the first person to complain about that, I moved it to
>> > configfs for awhile at Greg K-H's behest... but when I added cache sets
>> > I had to move it back to sysfs.
>> >
>> >> Alternately you could device a new 'bus' type for bcache and do some sort of
>> >> device-model magic to attach something as a new device of that type.
>> >
>> > I like that, I think that could make a lot of sense.
>> >
>> > I'm not sure what to do about register though, I do prefer to have it a
>> > file you can echo to but it doesn't really fit anywhere.
>>
>> Rather than using /proc or /sys to configure bcache, why not integrate it with device mapper, and use dmsetup to configure it?  That avoids adding yet another block device abstraction into the kernel, and yet one more obscure way of configuring things.
>>
>> A bcache device could be considered almost like an LV snapshot, where writes go to the SSD device instead of a disk, and they can have writeback or writethrough cache.
>
> I looked into that many months ago, spent quite a bit of time fighting
> with the dm code trying to get it to do what I wanted and... no. Never
> again

Did you do a similar analysis of md?  I had a pet caching project that
had it's own sysfs interface registration system, and came to the
conclusion that it would have been better to have started with an MD
personality.  Especially when one of the legs of the cache is a
md-raid array it helps to keep all that assembly logic using the same
interface.  And md supports assembling devices via sysfs without
requiring mdadm which is a nice feature.

Also has the benefit of reusing the distro installation / boot
enabling for md devices which turned out to be a bit of work when
enabling external-metadata in md.

--
Dan
