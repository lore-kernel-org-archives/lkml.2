Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0KRGN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:13:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:35876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab0KRGN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:13:56 -0500
Date: Wed, 17 Nov 2010 22:14:15 -0800
From: Greg KH <gregkh@suse.de>
To: Shan Wei <shanwei@cn.fujitsu.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING in tty_io.c
Message-ID: <20101118061415.GA14712@suse.de>
References: <4CDA5291.4010802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDA5291.4010802@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:06:41PM +0800, Shan Wei wrote:
> 
> Modify start-ttys.conf to add ttyS0 device on my Fedora13 with 2.6.37-rc1+ kernel.
> After rebooting system, got the following WARNING.
> 
> 
> ------------[ cut here ]------------
> WARNING: at drivers/char/tty_io.c:1331 tty_open+0x20e/0x3b2()
> Hardware name: Aspire SA80
> Modules linked in: ipv6 uinput snd_intel8x0 snd_ac97_codec ac97_bus r8169 ppdev parport_pc snd_seq snd_seq_device snd_pcm sis900 mii snd_timer snd soundcore parport snd_page_alloc pcspkr ata_generic pata_acpi sata_sis pata_sis [last unloaded: scsi_wait_scan]
> Pid: 117, comm: plymouthd Not tainted 2.6.37-rc1+ #4

Does this still happen in .37-rc2?

Alan, any ideas?

> Call Trace:
>  [<c044045c>] warn_slowpath_common+0x6a/0x7f
>  [<c062aff0>] ? tty_open+0x20e/0x3b2
>  [<c0440485>] warn_slowpath_null+0x14/0x18
>  [<c062aff0>] tty_open+0x20e/0x3b2
>  [<c04dc6c7>] chrdev_open+0xf3/0x110
>  [<c04d8688>] __dentry_open+0x141/0x237
>  [<c04d8833>] nameidata_to_filp+0x43/0x51
>  [<c04dc5d4>] ? chrdev_open+0x0/0x110
>  [<c04e25b8>] do_last+0x372/0x47f
>  [<c04e3b8d>] do_filp_open+0x19c/0x406
>  [<c04e5085>] ? do_vfs_ioctl+0x55e/0x5b4
>  [<c05b6232>] ? might_fault+0x1e/0x20
>  [<c04d8457>] do_sys_open+0x4d/0xcf
>  [<c0581f47>] ? selinux_file_ioctl+0x43/0x46
>  [<c04d8525>] sys_open+0x23/0x2b
>  [<c04097df>] sysenter_do_call+0x12/0x28
>  [<c07a0000>] ? init_intel_cacheinfo+0x6d/0x39e
> ---[ end trace eeb22dd7bedfb0b1 ]---
>  
