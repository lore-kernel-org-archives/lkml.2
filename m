Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1JYNK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:10:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45736 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab1JYNK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:10:56 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVe7DrbrbDB7wJWrT9FHUsV62UFdifWbe3MGL7ujkX5Vw@mail.gmail.com>
References: <CA+icZUVe7DrbrbDB7wJWrT9FHUsV62UFdifWbe3MGL7ujkX5Vw@mail.gmail.com>
Date: Tue, 25 Oct 2011 15:10:55 +0200
Message-ID: <CA+icZUUO3rxx4OFBNbHm4J3BFH66HBDY2LXC6-r2WY8ioo+8Dg@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 25 (block ?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 3:04 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Tue, Oct 25, 2011 at 11:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> *Note well*
>>
>> This tree has nate had any build testing at all.  As such, it probably
>> doesn't build :-) This tree is really just a roll up of the current state
>> of the trees when the v3.2 merge window opened.  It will not be put into
>> the build system referred to below.
>>
>
> I have generated a single linux-next (next-20111025) patch on top of
> v3.1, it's approx. 100M!
>
> $ du -h patch-v3.1-next-20111025.patch
> 96M     patch-v3.1-next-20111025.patch
>
> I noticed this build-failure:
>
>  CC      block/blk-throttle.o
>  CC [M]  fs/fuse/dir.o
> /mnt/sdb3/linux-kernel/linux-3.1/debian/build/source_i386_none/block/blk-throttle.c:
> In function 'blk_throtl_drain':
> /mnt/sdb3/linux-kernel/linux-3.1/debian/build/source_i386_none/block/blk-throttle.c:1221:2:
> error: implicit declaration of function 'lockdep_is_held'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
>
> make[5]: *** [block/blk-throttle.o] Error 1
> make[4]: *** [block] Error 2
>
> This happens with Debian's gcc-4.6 (4.6.1-16) and default
> KBUILD_ENABLE_EXTRA_GCC_CHECKS value.
>
> - Sedat -
>

Looks like "#include <linux/lockdep.h>" is missing in block/blk-throttle.c?

- Sedat -
