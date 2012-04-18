Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2DRCxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:53:40 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:54066 "EHLO
	smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2DRCxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:53:36 -0400
Date: Wed, 18 Apr 2012 12:53:32 +1000
From: Chris Dunlop <chris@onthe.net.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.3.1: hung task in __lock_page
Message-ID: <20120418025332.GA6387@onthe.net.au>
References: <20120418022420.GA5949@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418022420.GA5949@onthe.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugger, just got another, almost identical...

FYI, the big 'rm -r' is still running on the other aoe export.

On Wed, Apr 18, 2012 at 12:24:20PM +1000, Chris Dunlop wrote:
> G'day,
> 
> Linux-3.3.1, x64, md/lvm, deadline scheduler. 3 LVs exported via
> aoe, 1 LV exported via iscsi. The machine had been running with this
> configuration for 19 hours with light to moderate load on the various
> exports. 20 min before the hung task message a large 'rm -r' was started
> on a different aoe export to the hung vblade task and was still
> running at the time of the hang. The hung vblade task caused the
> associated aoe export to have a conniption, but otherwise
> everything seems to be humming along fine.
> 
> [69137.699722] INFO: task vblade:6826 blocked for more than 120 seconds.
> [69137.699759] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [69137.699810] vblade          D 0000000000000002     0  6826   3881 0x00000000
> [69137.699852]  ffff880be9c1ba78 0000000000000046 ffff880c00a6c3c0 00000000001d38c0
> [69137.699909]  ffff880be9c1bfd8 ffff880be9c1a010 00000000001d38c0 00000000001d38c0
> [69137.699965]  ffff880be9c1bfd8 00000000001d38c0 ffff880c085a43c0 ffff880c00a6c3c0
> [69137.700021] Call Trace:
> [69137.700048]  [<ffffffff810f5400>] ? __lock_page+0x70/0x70
> [69137.700080]  [<ffffffff813ecadf>] schedule+0x3f/0x60
> [69137.700108]  [<ffffffff813ecb8c>] io_schedule+0x8c/0xd0
> [69137.700136]  [<ffffffff810f540e>] sleep_on_page+0xe/0x20
> [69137.700165]  [<ffffffff813ea65f>] __wait_on_bit+0x5f/0x90
> [69137.700195]  [<ffffffff810f5653>] wait_on_page_bit+0x73/0x80
> [69137.700226]  [<ffffffff81070190>] ? autoremove_wake_function+0x40/0x40
> [69137.700259]  [<ffffffff8108214d>] ? sched_clock_cpu+0xcd/0x110
> [69137.700289]  [<ffffffff810f61c1>] grab_cache_page_write_begin+0xa1/0xd0
> [69137.700323]  [<ffffffff81184360>] ? I_BDEV+0x10/0x10
> [69137.700351]  [<ffffffff81181768>] block_write_begin+0x38/0x90
> [69137.700383]  [<ffffffff812115ee>] ? do_raw_spin_unlock+0x5e/0xb0
> [69137.700413]  [<ffffffff81185193>] blkdev_write_begin+0x23/0x30
> [69137.700443]  [<ffffffff810f4b1b>] generic_file_buffered_write+0x11b/0x2a0
> [69137.700477]  [<ffffffff8104f567>] ? current_fs_time+0x27/0x30
> [69137.700507]  [<ffffffff810f791b>] __generic_file_aio_write+0x23b/0x470
> [69137.700539]  [<ffffffff81184826>] blkdev_aio_write+0x36/0x90
> [69137.700570]  [<ffffffff8114e1c2>] do_sync_write+0xe2/0x120
> [69137.700599]  [<ffffffff8118c663>] ? fsnotify+0x1f3/0x360
> [69137.700630]  [<ffffffff812f4cf1>] ? T.1251+0x51/0x60
> [69137.700658]  [<ffffffff8114e720>] vfs_write+0xd0/0x1a0
> [69137.700687]  [<ffffffff8114e88a>] sys_pwrite64+0x9a/0xb0
> [69137.700717]  [<ffffffff813f6469>] system_call_fastpath+0x16/0x1b
> [69137.700747] no locks held by vblade/6826.

[76207.016288] INFO: task vblade:6826 blocked for more than 120 seconds.
[76207.016328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[76207.016375] vblade          D 0000000000000002     0  6826   3881 0x00000000
[76207.016412]  ffff880be9c1ba78 0000000000000046 ffff880c00a6c3c0 00000000001d38c0
[76207.016472]  ffff880be9c1bfd8 ffff880be9c1a010 00000000001d38c0 00000000001d38c0
[76207.016528]  ffff880be9c1bfd8 00000000001d38c0 ffffffff8160d020 ffff880c00a6c3c0
[76207.016584] Call Trace:
[76207.016612]  [<ffffffff810f5400>] ? __lock_page+0x70/0x70
[76207.016643]  [<ffffffff813ecadf>] schedule+0x3f/0x60
[76207.016672]  [<ffffffff813ecb8c>] io_schedule+0x8c/0xd0
[76207.016700]  [<ffffffff810f540e>] sleep_on_page+0xe/0x20
[76207.016729]  [<ffffffff813ea65f>] __wait_on_bit+0x5f/0x90
[76207.016759]  [<ffffffff810f5653>] wait_on_page_bit+0x73/0x80
[76207.016790]  [<ffffffff81070190>] ? autoremove_wake_function+0x40/0x40
[76207.016823]  [<ffffffff8108214d>] ? sched_clock_cpu+0xcd/0x110
[76207.016853]  [<ffffffff810f61c1>] grab_cache_page_write_begin+0xa1/0xd0
[76207.016887]  [<ffffffff81184360>] ? I_BDEV+0x10/0x10
[76207.016915]  [<ffffffff81181768>] block_write_begin+0x38/0x90
[76207.016947]  [<ffffffff812115ee>] ? do_raw_spin_unlock+0x5e/0xb0
[76207.016980]  [<ffffffff81185193>] blkdev_write_begin+0x23/0x30
[76207.017014]  [<ffffffff810f4b1b>] generic_file_buffered_write+0x11b/0x2a0
[76207.017052]  [<ffffffff8104f567>] ? current_fs_time+0x27/0x30
[76207.017086]  [<ffffffff810f791b>] __generic_file_aio_write+0x23b/0x470
[76207.017122]  [<ffffffff81184826>] blkdev_aio_write+0x36/0x90
[76207.017157]  [<ffffffff8114e1c2>] do_sync_write+0xe2/0x120
[76207.017189]  [<ffffffff8118c663>] ? fsnotify+0x1f3/0x360
[76207.017222]  [<ffffffff8114e720>] vfs_write+0xd0/0x1a0
[76207.017254]  [<ffffffff8114e88a>] sys_pwrite64+0x9a/0xb0
[76207.017288]  [<ffffffff813f6469>] system_call_fastpath+0x16/0x1b
[76207.017321] no locks held by vblade/6826.

Cheers,

Chris.
