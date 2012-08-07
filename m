Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2HGQoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:44:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62526 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HGQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <5020AA5B.4080407@zankel.net>
References: <50205592.1030205@gmail.com>
	<5020AA5B.4080407@zankel.net>
Date: Tue, 7 Aug 2012 20:43:58 +0400
Message-ID: <CAMo8BfLLxBeUC-vg6sAxWLjqPt=fwsQEQgjsqqbjurT3vzo-Pw@mail.gmail.com>
Subject: Re: xtensa port maintenance
From: Max Filippov <jcmvbkbc@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Marc Gauthier <marc@tensilica.com>,
        Kirill Krinkin <kirill.krinkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 9:40 AM, Chris Zankel <chris@zankel.net> wrote:
> Hi Max,
>
> On 08/06/2012 04:38 PM, Max Filippov wrote:
>>
>> AFAIK xtensa linux port is currently in bad shape: it doesn't work in the
>> mainline, it fails to build in the linux-next. The latest working kernels
>> for
>> xtensa are 2.6.29...31 trees hosted at the git.linux-xtensa.org.
>
> I wouldn't say it's in bad shape, I just built an vmlinux image from the
> latest tree (3.6.0-rc1), but it might not be very stable. One of the major
> issues is not really the kernel but  there's actually no way to build a
> fairly recent version of the toolchain. I have been using a somewhat more
> recent buildroot version than what is on xtensa-linux.org, but even that
> version of buildroot is rather old now and needed a few patches.

I've been using userspace built from the buildroot image hosted on
linux-xtensa.org with gcc-4.4.5 + binutils-2.20.1. I use gcc-4.6.3
(without libc) + binutils-2.22 to build the kernel. I had an impression that
mentioned buildroot was able to produce userspace where LTP could
run successfully for days. So, my initial plan is to use that userspace
with mainline kernel.

[...]

>> forward-port patches accumulated in linux-xtensa.org git trees and make
>> the
>> resulting kernels rock-solid. I'd like to restore xtensa participation in
>> the
>> linux-next. Further (currently undetailed) plans are to bring modern Linux
>> features to the xtensa port, e.g. device trees.
>
> That would be great. Might I also add that we'd need to have a working
> toolchain and bootable image. For me, buildroot seems to be the quickest
> route here. That would also require possibly adding patches to the toolchain
> and uClibc that are currently missing. There's also the bootloader, etc.
>
>> I have a couple of questions regarding the path of xtensa-specific patches
>> upstream:
>>      - which git tree should they be targeted for? Should I set up a tree
>> for
>>        pull requests, or will patches be picked up into some existing
>> tree?
>>        (Looks like Linus' tree is the right target. AFAIK previously
>> xtensa
>>        patches went mostly through akpm tree).
>
> Yes, Andrew has been very helpful stepping in and adding those patches. Most
> if not all of those patches were fixes because of generic kernel changes and
> not major fixes or changes to the core of the Xtensa port.
>
> Ideally, it would be great if you could create a git tree (I saw you already
> have a version on github already?) that would allow us to look over those
> patches. The goal should be to have a system to build toolchain, bootable
> image, and kernel, so we can run some regression tests on either the
> simulator (qemu) or an actual board. Once we have a regression test system
> in place, we can then add more features and funnel those patches either
> through me or more directly..
>
> What do you think?

I have a subset thereof that builds toolchain (without libc) and the kernel.
Buildroot gave me an impression of not very reproducible environment, perhaps
I spent too little time on it. So I made an image and I hope that
pre-built image
may be used, at least in the beginning. I had to lightly patch U-boot hosted on
linux-xtensa.org to make it work on LX60/110/200 QEMU models. I guess we
can start with pre-built image of the bootloader too.

> If you already have such a system in place, it would be great if you could
> send me some instructions to recreate it locally. We can give you also
> access to the wiki to add any information there.

Ok, I'll consolidate my scripts to something that could be used as such
system and share them. I have an editor access to wiki.linux-xtensa.org.

>>      - which mailing lists should they go to?
>>        (I guess that besides linux-xtensa@linux-xtensa.org list they
>> should go
>>        to linux-kernel@vger.kernel.org for general review. Anything else?)
>
> For now, I would really appreciate if you could hold off sending any major
> patch to the linux-kernel mailing list until we had a chance to look over
> them unless it's some generic patch (fixing an issue because of an API
> change to the kernel, etc.)

Ok. I'd like to have even generic patches (my current queue is mostly
generic) reviewed. Do you prefer to read them on github or on the
linux-xtensa mailing list?

>> I'm also a developer and maintainer of the target-xtensa QEMU port [3].
> That's so great!! I didn't know there was a QEMU port for Xtensa.

It's there since qemu-1.0.

> Bottom line, I hope you agree with me that the kernel, although the most fun
> part, is only one piece of the puzzle, and we also need a running system. If
> you already have that in place, we can jump to the kernel fairly quickly.

Completely agree.

-- 
Thanks.
-- Max
