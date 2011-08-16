Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1HPVTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:19:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1HPVTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:19:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Subject: Re: 3.0-rc2 failed s2ram: Freezing of tasks failed after 20.00 seconds
Date: Tue, 16 Aug 2011 23:20:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110816094245.GA2042@Pilar.site> <201108162013.55341.rjw@sisk.pl> <20110816211358.GA2251@Pilar.site>
In-Reply-To: <20110816211358.GA2251@Pilar.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108162320.28297.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 16, 2011, Carlos R. Mafra wrote:
> On Tue, 16 Aug 2011 at 20:13:55 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, August 16, 2011, Carlos R. Mafra wrote:
> > > I started testing 3.0-rc2 yesterday and after a few successful suspend to ram
> > > it did not suspend anymore and I got this:
> > > 
> > >  PM: Syncing filesystems ... done.
> > >  PM: Preparing system for mem sleep
> > >  Freezing user space processes ... 
> > >  Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
> > >  udisks-daemon   D ffff8800a641e5d0     0  5848   5845 0x00800004
> > >   ffff8800a6741928 0000000000000082 ffff880000000000 00000000000105c0
> > >   ffff8800a641e200 00000000000105c0 ffff8800a6741fd8 00000000000105c0
> > >   00000000000105c0 ffff8800a6740000 ffff8800a6741fd8 00000000000105c0
> > >  Call Trace:
> > >   [<ffffffff814cf355>] schedule_timeout+0x1c5/0x230
> > >   [<ffffffff814ce8c9>] ? schedule+0x399/0x8a0
> > >   [<ffffffff814ce3e0>] wait_for_common+0xc0/0x160
> > >   [<ffffffff8103ec60>] ? try_to_wake_up+0x290/0x290
> > >   [<ffffffff814d10ba>] ? _raw_spin_unlock_irq+0x2a/0x40
> > >   [<ffffffff814ce528>] wait_for_completion+0x18/0x20
> > >   [<ffffffff81059afb>] flush_work+0x2b/0x40
> > >   [<ffffffff81058fd0>] ? do_work_for_cpu+0x30/0x30
> > >   [<ffffffff8105a076>] flush_delayed_work+0x46/0x50
> > >   [<ffffffff8121e6b6>] disk_clear_events+0x76/0x110
> > >   [<ffffffff81106052>] check_disk_change+0x32/0x80
> > >   [<ffffffff812ee649>] sd_open+0xb9/0x190
> > >   [<ffffffff81106f81>] __blkdev_get+0x91/0x3d0
> > >   [<ffffffff81107600>] ? blkdev_get+0x340/0x340
> > >   [<ffffffff8110730e>] blkdev_get+0x4e/0x340
> > >   [<ffffffff810e1b17>] ? do_lookup+0xb7/0x380
> > >   [<ffffffff81107600>] ? blkdev_get+0x340/0x340
> > >   [<ffffffff8110765d>] blkdev_open+0x5d/0x80
> > >   [<ffffffff810d3d80>] __dentry_open+0x130/0x320
> > >   [<ffffffff810d5021>] nameidata_to_filp+0x71/0x80
> > >   [<ffffffff810e2ab1>] do_last+0xb1/0x800
> > >   [<ffffffff810e4603>] path_openat+0xd3/0x3f0
> > >   [<ffffffff81229077>] ? kobject_put+0x27/0x60
> > >   [<ffffffff812ced62>] ? put_device+0x12/0x20
> > >   [<ffffffff810e4984>] do_filp_open+0x44/0xa0
> > >   [<ffffffff810f0a44>] ? alloc_fd+0xf4/0x150
> > >   [<ffffffff810d512c>] do_sys_open+0xfc/0x1e0
> > >   [<ffffffff810d3a86>] ? filp_close+0x56/0x80
> > >   [<ffffffff810d522b>] sys_open+0x1b/0x20
> > >   [<ffffffff814d1c3b>] system_call_fastpath+0x16/0x1b
> > >  
> > >  Restarting tasks ... done.
> > >  video LNXVIDEO:01: Restoring backlight state
> > >  acpid: 1 client rule loaded
> > >  EXT4-fs (sda2): re-mounted. Opts: discard,commit=600
> > >  INFO: task udisks-daemon:5848 blocked for more than 120 seconds.
> > >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >  udisks-daemon   D ffff8800a641e5d0     0  5848   5845 0x00000004
> > >   ffff8800a6741928 0000000000000082 ffff880000000000 00000000000105c0
> > >   ffff8800a641e200 00000000000105c0 ffff8800a6741fd8 00000000000105c0
> > >   00000000000105c0 ffff8800a6740000 ffff8800a6741fd8 00000000000105c0
> > >  Call Trace:
> > >   [<ffffffff814cf355>] schedule_timeout+0x1c5/0x230
> > >   [<ffffffff814ce8c9>] ? schedule+0x399/0x8a0
> > >   [<ffffffff814ce3e0>] wait_for_common+0xc0/0x160
> > >   [<ffffffff8103ec60>] ? try_to_wake_up+0x290/0x290
> > >   [<ffffffff814d10ba>] ? _raw_spin_unlock_irq+0x2a/0x40
> > >   [<ffffffff814ce528>] wait_for_completion+0x18/0x20
> > >   [<ffffffff81059afb>] flush_work+0x2b/0x40
> > >   [<ffffffff81058fd0>] ? do_work_for_cpu+0x30/0x30
> > >   [<ffffffff8105a076>] flush_delayed_work+0x46/0x50
> > >   [<ffffffff8121e6b6>] disk_clear_events+0x76/0x110
> > >   [<ffffffff81106052>] check_disk_change+0x32/0x80
> > >   [<ffffffff812ee649>] sd_open+0xb9/0x190
> > >   [<ffffffff81106f81>] __blkdev_get+0x91/0x3d0
> > >   [<ffffffff81107600>] ? blkdev_get+0x340/0x340
> > >   [<ffffffff8110730e>] blkdev_get+0x4e/0x340
> > >   [<ffffffff810e1b17>] ? do_lookup+0xb7/0x380
> > >   [<ffffffff81107600>] ? blkdev_get+0x340/0x340
> > >   [<ffffffff8110765d>] blkdev_open+0x5d/0x80
> > >   [<ffffffff810d3d80>] __dentry_open+0x130/0x320
> > >   [<ffffffff810d5021>] nameidata_to_filp+0x71/0x80
> > >   [<ffffffff810e2ab1>] do_last+0xb1/0x800
> > >   [<ffffffff810e4603>] path_openat+0xd3/0x3f0
> > >   [<ffffffff81229077>] ? kobject_put+0x27/0x60
> > >   [<ffffffff812ced62>] ? put_device+0x12/0x20
> > >   [<ffffffff810e4984>] do_filp_open+0x44/0xa0
> > >   [<ffffffff810f0a44>] ? alloc_fd+0xf4/0x150
> > >   [<ffffffff810d512c>] do_sys_open+0xfc/0x1e0
> > >   [<ffffffff810d3a86>] ? filp_close+0x56/0x80
> > >   [<ffffffff810d522b>] sys_open+0x1b/0x20
> > >   [<ffffffff814d1c3b>] system_call_fastpath+0x16/0x1b
> > >   
> > > 
> > > and there are some more of these traces in the logs, but they all look the 
> > > same.
> > 
> > It looks like udisks-daemon is waiting for a completion that's
> > never completed.
> > 
> > Do you use any removable storage devices?
> 
> Yes, external harddisks connected via USB. But none were mounted
> when I closed the lid to suspend.

Were they connected to the USB ports?

> PS: I made a mistake in the Subject:, the kernel is 3.1-rc2 and
> not 3.0-rc2.

Did 3.0 work correctly?

Rafael
