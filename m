Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab1JYNiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:38:18 -0400
Received: from brick.kernel.dk ([87.104.106.3]:49982 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab1JYNiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:38:17 -0400
Message-ID: <4EA6BBC2.2060406@kernel.dk>
Date: Tue, 25 Oct 2011 15:38:10 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for Oct 25 (block ?)
References: <CA+icZUVe7DrbrbDB7wJWrT9FHUsV62UFdifWbe3MGL7ujkX5Vw@mail.gmail.com> <CA+icZUUO3rxx4OFBNbHm4J3BFH66HBDY2LXC6-r2WY8ioo+8Dg@mail.gmail.com>
In-Reply-To: <CA+icZUUO3rxx4OFBNbHm4J3BFH66HBDY2LXC6-r2WY8ioo+8Dg@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-25 15:10, Sedat Dilek wrote:
> On Tue, Oct 25, 2011 at 3:04 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Tue, Oct 25, 2011 at 11:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> *Note well*
>>>
>>> This tree has nate had any build testing at all.  As such, it probably
>>> doesn't build :-) This tree is really just a roll up of the current state
>>> of the trees when the v3.2 merge window opened.  It will not be put into
>>> the build system referred to below.
>>>
>>
>> I have generated a single linux-next (next-20111025) patch on top of
>> v3.1, it's approx. 100M!
>>
>> $ du -h patch-v3.1-next-20111025.patch
>> 96M     patch-v3.1-next-20111025.patch
>>
>> I noticed this build-failure:
>>
>>  CC      block/blk-throttle.o
>>  CC [M]  fs/fuse/dir.o
>> /mnt/sdb3/linux-kernel/linux-3.1/debian/build/source_i386_none/block/blk-throttle.c:
>> In function 'blk_throtl_drain':
>> /mnt/sdb3/linux-kernel/linux-3.1/debian/build/source_i386_none/block/blk-throttle.c:1221:2:
>> error: implicit declaration of function 'lockdep_is_held'
>> [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[5]: *** [block/blk-throttle.o] Error 1
>> make[4]: *** [block] Error 2
>>
>> This happens with Debian's gcc-4.6 (4.6.1-16) and default
>> KBUILD_ENABLE_EXTRA_GCC_CHECKS value.
>>
>> - Sedat -
>>
> 
> Looks like "#include <linux/lockdep.h>" is missing in block/blk-throttle.c?

Hmm, I wonder why it isn't triggering for cfq-iosched.o or elevator.o as
well. Is blk-throttle modular? What is your .config?

-- 
Jens Axboe

