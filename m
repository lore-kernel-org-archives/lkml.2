Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0HSOkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:40:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57974 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753698Ab0HSOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:39:57 -0400
Date: Thu, 19 Aug 2010 10:39:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        Linux USB <linux-usb@vger.kernel.org>,
        Adrian Drzewiecki <adriand@vmware.com>
Subject: Re: RIP: 0010:[<ffffffff81495d87>] [<ffffffff81495d87>]
 _raw_spin_lock_irq+0x1b/0x2b
In-Reply-To: <AANLkTi=m8GPqj2g9GXK+Kmh2dpeCba7vfyGaax3AWZjz@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1008191038100.1680-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Jeff Chua wrote:

> Not sure if this is a vmware bug or kernel, so I'm posting it here.
> Tried to upgrade my iPhone4 iOS to 4.0.2 running a VMware guest with
> Linux-2.6.35+ and Linux-2.6.36-rc1, and both has the same problem.
> "Sync" has no issue but I guess upgrading the firmware with a 600MB
> file is a difference story. Could this be cable problem or a real bug?
> 
> Thanks,
> Jeff.
> 
> 
> # on 2.6.35+
> 
> 2010-08-19T02:03:22.069981+08:00 boston kernel: Pid: 10376, comm:
> vmware-vmx Not tainted 2.6.35+ #2 5413FGA/5413FGA
...
> 2010-08-19T02:03:22.070017+08:00 boston kernel: Call Trace:
> 2010-08-19T02:03:22.070019+08:00 boston kernel: [<ffffffff813acdaf>] ?
> hid_pre_reset+0x25/0x4f
> 2010-08-19T02:03:22.070021+08:00 boston kernel: [<ffffffff8133db68>] ?
> usb_reset_device+0x6a/0x11b
> 2010-08-19T02:03:22.070023+08:00 boston kernel: [<ffffffff8134a040>] ?
> usbdev_do_ioctl+0x2c8/0xd88
> 2010-08-19T02:03:22.070026+08:00 boston kernel: [<ffffffff81027f74>] ?
> __wake_up_common+0x41/0x78
> 2010-08-19T02:03:22.070028+08:00 boston kernel: [<ffffffff8134ab18>] ?
> usbdev_ioctl+0x9/0xd
> 2010-08-19T02:03:22.070030+08:00 boston kernel: [<ffffffff810acd7e>] ?
> vfs_ioctl+0x23/0x93
> 2010-08-19T02:03:22.070032+08:00 boston kernel: [<ffffffff810ad265>] ?
> do_vfs_ioctl+0x405/0x43c
> 2010-08-19T02:03:22.070034+08:00 boston kernel: [<ffffffff810ad2d8>] ?
> sys_ioctl+0x3c/0x5c
> 2010-08-19T02:03:22.070037+08:00 boston kernel: [<ffffffff81001f42>] ?
> system_call_fastpath+0x16/0x1b

Try using the most recent git source, or else apply commit
9c9e54a8df0be48aa359744f412377cc55c3b7d2 (HID: hiddev: fix memory
corruption due to invalid intfdata).

Alan Stern

