Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1GTJgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:36:21 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:44357 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1GTJgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <4E26A03E.10707@suse.cz>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
	<20110717144746.78063c97.rdunlap@xenotime.net>
	<CAGTPOqdP6OwZ2dF+1J3rxL0aBag5ir+_-ge1n_4UWWUMc1949Q@mail.gmail.com>
	<4E26A03E.10707@suse.cz>
Date: Wed, 20 Jul 2011 12:36:19 +0300
Message-ID: <CAGTPOqeMgXXtVnGZ8R1rQT2nMyiOdt3vTOi0nF4o7h2ETkxRxw@mail.gmail.com>
Subject: Re: `make headers_check' bustage
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:30 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 20.7.2011 11:26, Vitaliy Ivanov wrote:
>>
>> On Mon, Jul 18, 2011 at 12:47 AM, Randy Dunlap<rdunlap@xenotime.net>
>>  wrote:
>>>
>>> On Thu, 7 Jul 2011 17:16:27 -0700 Andrew Morton wrote:
>>>
>>>> It is just me, or is headers_check busted in current -linus?
>>>>
>>>> z:/usr/src/25>  make mrproper; make allmodconfig; make headers_check
>>>> ...
>>>> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference
>>>> function or variable defined in the kernel
>>>> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference
>>>> function or variable defined in the kernel
>>>> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference
>>>> function or variable defined in the kernel
>>>> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot
>>>> reference function or variable defined in the kernel
>>>
>>> What does it take to reproduce this?
>>> Does it fail on either type of X86 or is this from some other $ARCH?
>>> I can't make it fail on X86 (3.0-rc7).
>>
>> Config is attached. I can see it on today's linus' tree.
>>
>> Wed Jul 20 12:15:14
>> [vitaliy.ivanov@vivanov linux-2.6]$ make
>> O=/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6
>> headers_check
>
>> [...]
>
> And it exits with non-zero? Please run make headers_check; echo $?


[...]
  CHECK   include/linux (366 files)
/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/kernel.h:65:
userspace cannot reference function or variable defined in the kernel
/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/quota.h:175:
userspace cannot reference function or variable defined in the kernel
/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/soundcard.h:1054:
userspace cannot reference function or variable defined in the kernel
  CHECK   include/mtd (5 files)
  CHECK   include/rdma (6 files)
  CHECK   include/scsi/fc (4 files)
  CHECK   include/scsi (3 files)
/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/scsi/scsi_netlink.h:108:
found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/sound (8 files)
  CHECK   include/video (3 files)
  CHECK   include/xen (2 files)
  CHECK   include (0 files)
  CHECK   include/asm (56 files)
Wed Jul 20 12:33:50
[vitaliy.ivanov@vivanov linux-2.6]$ echo $?
0


- Vitaliy
