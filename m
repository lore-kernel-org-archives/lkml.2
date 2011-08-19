Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1HSNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:25:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36059 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HSNY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:24:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110819130615.GA6307@kernel.org>
References: <1312315404-sup-6084@shiny>
	<20110819130615.GA6307@kernel.org>
Date: Fri, 19 Aug 2011 09:24:57 -0400
Message-ID: <CA+5PVA5QMZ3i7Pr1jsis+r4CeZZCWEt59oZXNhtf4Ea-yeAgGA@mail.gmail.com>
Subject: Re: [build breakage] Re: [GIT PULL] Btrfs pull round two
From: Josh Boyer <jwboyer@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 9:06 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Chris Mason <chris.mason@oracle.com> wrote:
>
>> Hi everyone,
>>
>> This has the rest of the btrfs cleanups for 3.1.  The bulk of this is
>> error handing fixes from SUSE and cleanups from Fujitsu.
>
> I havent seen a lkml mail of this pull request:
>
>  5c80c71b9a0e: Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
>
> so i'm following up on this earlier pull request.
>
> the aptly named btrfs-unstable branch indeed does not even build on
> x86 defconfig (32-bit):
>
>   LD      .tmp_vmlinux1
>  fs/built-in.o: In function `btrfs_can_relocate':
>  (.text+0x1d6605): undefined reference to `__udivdi3'
>  make: *** [.tmp_vmlinux1] Error 1
>
> and given that most of the commits:
>
> 81d86e1b7096: Merge branch 'btrfs-3.0' into for-linus
> f1e490a7ebe4: Btrfs: set i_size properly when fallocating and we already
> 9a4327ca1f45: btrfs: unlock on error in btrfs_file_llseek()
> cb6db4e57632: btrfs: btrfs_permission's RO check shouldn't apply to device nodes
> f81c9cdc567c: Btrfs: truncate pages from clone ioctl target range
> 0e588859618b: Btrfs: fix uninitialized sync_pending
> bb3ac5a4dfc8: Btrfs: fix wrong free space information
> f4ac904c411b: btrfs: memory leak in btrfs_add_inode_defrag()
> c97c2916e25c: Btrfs: use plain page_address() in header fields setget functions
> cb1b69f4508a: Btrfs: forced readonly when btrfs_drop_snapshot() fails
> cdcb725c05fe: Btrfs: check if there is enough space for balancing smarter
> 38c01b960592: Btrfs: fix a bug of balance on full multi-disk partitions
> 34f3e4f23ca3: Btrfs: fix an oops of log replay
> d5e2003c2bcd: Btrfs: detect wether a device supports discard
> 93ee7a9340d6: Linux 3.1-rc2
>
> were committed after -rc2 and were at most a couple of hours old
> before you sent them off to Linus, did you really expect any other
> outcome than breaking upstream in trivial ways? :-)

FYI, this was noticed and a patch was posted to linux-btrfs:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/12673

Josef bugged them to send it upstream.

josh
