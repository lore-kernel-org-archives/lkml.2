Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2JPENA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:13:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39310 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2JPEM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <87lif958lb.fsf@devron.myhome.or.jp>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
Date: Tue, 16 Oct 2012 13:12:56 +0900
Message-ID: <CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Implement preallocation via the fallocate syscall on VFAT partitions.
>> This patch is based on an earlier patch of the same name which had some
>> issues detailed below and did not get accepted. Refer
>> https://lkml.org/lkml/2007/12/22/130.
>>
>> a)The preallocated space was not persistent across remounts when the
>> FALLOC_FL_KEEP_SIZE flag was set. Also, writes to the file allocated new
>> clusters instead of using the preallocated area.
>>
>> Consider the scenario:
>> mount-->preallocate space for a file --> unmount.
>> In the old patch,the preallocated space was not reflected for that
>> file (verified using the 'du' command).
>>
>> This is now fixed with modifications to fat_fill_inode().
>
When we consider other filesystems like XFS and ext4,  the space which
is preallocated is reserved for the life-time of that file which is
persistent across(mount/umount).
So, we tried to make this as similar to the existent solution - as
that would keep the meaning of FALLOCATE - WITH_KEEP_SIZE as same
across all filesystems.

> What is real usage pattern of persistent across remounts on FAT?
Yes,  like a TORRENT FILE -> it reserves space in advance
even though the system can be rebooted/disk unmounted and remount
but the space still remains there - as long as the torrent exists
Or if Torrent case does not matches currently
Then, Consider a case for a TV series to be recorded
Since – we want all the parts to be recorded on the same file (i.e.,
APPEND write) – and in such cases there are chances of TV shutdown,
device unmount-mount again. So, we need to have the space to be remain
available in such cases.

> If once device was unmounted, we can't know the state of FS anymore, there are
> many implementations of FAT. And preallocation is not in the spec.
I agree, As you said before, we can make fat fallocate feature as
configurable – so this is entirely in the hands of USER.
>
> I worry to break something. And I guess the freeing preallocation on
> last close may fix the issue for usage.
Okay, we can avoid most of your concerns except suddenly unplugging usb device.
But fallocate behavior will be different with other filesystem.

How about to make fat fallocate with configuration to be used by users
is having needs?

Let me know your opinion :)

Thanks.
Thanks.> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
