Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0JCPSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 11:18:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0JCPSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 11:18:07 -0400
Message-ID: <4CA89E63.4080907@kernel.org>
Date: Sun, 03 Oct 2010 17:16:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera> <sQALkqF1FWE.A.15D.bo6nMB@chimera> <20101002165433.GL21129@thunk.org> <201010022358.35972.rjw@sisk.pl> <20101003022707.GN21129@thunk.org>
In-Reply-To: <20101003022707.GN21129@thunk.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 03 Oct 2010 15:17:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'in Jan and quoting the whole body for him)

Jan, any chance this is caused by the recent bdi change?

On 10/03/2010 04:27 AM, Ted Ts'o wrote:
> On Sat, Oct 02, 2010 at 11:58:35PM +0200, Rafael J. Wysocki wrote:
>> On Saturday, October 02, 2010, Ted Ts'o wrote:
>>> On Sun, Sep 26, 2010 at 10:04:15PM +0200, Rafael J. Wysocki wrote:
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.35.  Please verify if it still should be listed and let the tracking team
>>>> know (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
>>>> Subject		: Dirtiable inode bdi default != sb bdi btrfs
>>>> Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
>>>> Date		: 2010-09-23 0:54 (4 days old)
>>>> Message-ID	: <4C9AA546.6050201@cesarb.net>
>>>> References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2
>>>
>>> Note: I'm seeing this warning (Dirtiable inode bdi default != sb bdi)
>>> when I moved from 2.6.36-rc3 to 2.6.36-rc6, using ext4 as a root
>>> partition, and running mke2fs and e2fsck on ext2, ext3, and ext4 file
>>> systems.  So I'm seeing this as a known regression from rc3 to rc6.
>>> Maybe it's different bug with ext4, but in any case, it's highly
>>> annoying.
>>
>> Thanks for the info.  I wonder who should see this report.
> 
> Oops, correction, the correct warning that I'm seeing is:
> 
> Dirtiable inode bdi block != sb bdi block
>                     ^^^^^           ^^^^^
> 
> ------------[ cut here ]------------
> WARNING: at /usr/projects/linux/ext4/fs/fs-writeback.c:87 inode_to_bdi+0x4e/0x5c()
> Hardware name: 
> Dirtiable inode bdi block != sb bdi block
> Modules linked in:
> Pid: 21649, comm: mkfs.ext4 Tainted: G        W   2.6.36-rc6-00016-gcc25699 #735
> Call Trace:
>  [<c015a2e2>] warn_slowpath_common+0x6a/0x7f
>  [<c020a762>] ? inode_to_bdi+0x4e/0x5c
>  [<c015a36a>] warn_slowpath_fmt+0x2b/0x2f
>  [<c020a762>] inode_to_bdi+0x4e/0x5c
>  [<c020b6c3>] __mark_inode_dirty+0xaf/0x162
>  [<c0202305>] file_update_time+0xcc/0xe9
>  [<c01c68dd>] __generic_file_aio_write+0x136/0x28f
>  [<c02145a4>] blkdev_aio_write+0x33/0x72
>  [<c01f20da>] do_sync_write+0x8f/0xca
>  [<c0647678>] ? mutex_unlock+0xd/0xf
>  [<c030d528>] ? security_file_permission+0x27/0x2b
>  [<c01f227c>] ? rw_verify_area+0x9d/0xc0
>  [<c01f204b>] ? do_sync_write+0x0/0xca
>  [<c01f2629>] vfs_write+0x85/0xe3
>  [<c01f2725>] sys_write+0x40/0x62
>  [<c064915d>] syscall_call+0x7/0xb
> ---[ end trace 1f39401760ab3a42 ]---

-- 
tejun
