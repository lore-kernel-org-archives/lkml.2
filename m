Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab0COOrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:47:00 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:42270 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab0COOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:46:59 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 10:46:59 EDT
Message-ID: <4B9E4863.80905@sandeen.net>
Date: Mon, 15 Mar 2010 09:46:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
 assfail+0x1b/0x20 SS:ESP 0068:f687bf14
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan> <4B9E46F9.8090209@sandeen.net> <alpine.DEB.2.00.1003151042390.9496@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003151042390.9496@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Mon, 15 Mar 2010, Eric Sandeen wrote:
> 
>> Justin Piszcz wrote:
>>> Specifications:
>>>
>>> 2.6.33
>>> 32bit
>>> Debian Testing
>>>
>>> On Mar 14th, my server hung up:
>>>
>>> Mar 14 00:00:22 server1 kernel: [488470.189675] ------------[ cut here
>>> ]------------
>>> Mar 14 00:00:22 server1 kernel: [488470.189679] invalid opcode: 0000
>>> [#1] SMP
>>> Mar 14 00:00:22 server1 kernel: [488470.189681] last sysfs file:
>>> /sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/uevent
>>>
>>>
>>> Mar 14 00:00:22 server1 kernel: [488470.189704] Process xfssyncd (pid:
>>> 584, ti=f687a000 task=f70fa400 task.ti=f687a000)
>>> Mar 14 00:00:22 server1 kernel: [488470.189705] Stack:
>>> Mar 14 00:00:22 server1 kernel: [488470.189721] Call Trace:
>>> Mar 14 00:00:22 server1 kernel: [488470.189739] Code: 00 e8 ea e5 01 00
>>> 83 c4 14 c3 8d b6 00 00 00 00 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24
>>> 04 c7 04 24 30 ab 42 c1 e8 7c 11 1c 00 <0f> 0b eb fe 90 55 57 89 cf 56
>>> 89 c6 b8 80 b0 52 c1 83 e6 07 53
>>> Mar 14 00:00:22 server1 kernel: [488470.189739] EIP: [<c11a018b>]
>>> assfail+0x1b/0x20 SS:ESP 0068:f687bf14
>>>
>>> Is this a bug related to AMD (CPU) or XFS?
>>
>> Hard to know without seeing the rest of the stack trace, is this all
>> you got?
> Yes, that was the only entry in the log file, I could not wake up the
> monitor to get any more information.
> 
>>
>> You hit an assertion failure in xfs.
>>
>> Are you running with CONFIG_XFS_DEBUG?
> Nope.
> 
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_DEBUG is not set

Ok, then you hit an ASSERT_ALWAYS

There are only a few:

0 xfs/linux-2.6/xfs_super.c xfs_fs_destroy_inode  953 ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
1 xfs/linux-2.6/xfs_super.c xfs_fs_destroy_inode  954 ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
2 xfs/linux-2.6/xfs_sync.c  xfs_reclaim_inode     727 ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
3 fs/xfs/xfs_log.c          xfs_log_notify        376 ASSERT_ALWAYS((iclog->ic_state == XLOG_STATE_ACTIVE) ||
4 fs/xfs/xfs_log.c          xlog_commit_record   1273 ASSERT_ALWAYS(iclog);

but I'm not sure which one you hit since there is no backtrace provided.

-Eric
