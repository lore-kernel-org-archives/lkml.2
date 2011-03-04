Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab1CDAMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:12:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:56161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1CDAMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:12:22 -0500
Date: Thu, 3 Mar 2011 16:05:50 -0800
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: mmotm 2011-03-02 - ACPI/sysfs WARNING with NVidia graphics card
Message-ID: <20110304000550.GA2073@suse.de>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
 <33350.1299196241@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33350.1299196241@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 06:50:41PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 02 Mar 2011 16:52:55 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Dell Latitude E6500, with an NVidia G98M (Quadro NVS 160M) graphics card.
> 
> Seen in my dmesg - it's had the 'Firmware Bug' message for roughly forever, but
> apparently somewhere recently a warning crawled in. 2.6.38-rc5-next-20110222
> did not throw the warning, jsut the firmware bug msg.
> 
> Hope somebody recognizes it, I won't be able to bisect this one for a bit (I
> have 2 or 3 other things I have a bigger need to track down).
> 
> [    0.784712] ACPI: Sleep Button [SBTN]
> [    0.816626] ------------[ cut here ]------------
> [    0.816633] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x88/0x9c()
> [    0.816635] Hardware name: Latitude E6500                  
> [    0.816637] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/device'
> [    0.816640] Modules linked in:
> [    0.816645] Pid: 1, comm: swapper Not tainted 2.6.38-rc7-mmotm0302 #2
> [    0.816647] Call Trace:
> [    0.816652]  [<ffffffff8103899e>] ? warn_slowpath_common+0x7e/0x96
> [    0.816657]  [<ffffffff81038a4a>] ? warn_slowpath_fmt+0x41/0x43
> [    0.816661]  [<ffffffff8114d876>] ? sysfs_add_one+0x88/0x9c
> [    0.816665]  [<ffffffff8114e06e>] ? sysfs_do_create_link+0x145/0x1d5
> [    0.816669]  [<ffffffff8114e10c>] ? sysfs_create_link+0xe/0x10
> [    0.816674]  [<ffffffff8126cef1>] ? acpi_video_device_find_cap+0x1f5/0x2de
> [    0.816678]  [<ffffffff8126d196>] ? acpi_video_bus_get_one_device+0x1bc/0x250
> [    0.816682]  [<ffffffff8126d3f8>] ? acpi_video_bus_add+0x1ce/0x36e
> [    0.816687]  [<ffffffff8124983d>] ? acpi_device_probe+0x49/0x117
> [    0.816692]  [<ffffffff812bd56b>] ? really_probe+0xc0/0x14d
> [    0.816696]  [<ffffffff812bd6fe>] ? driver_probe_device+0x37/0x52
> [    0.816700]  [<ffffffff812bd773>] ? __driver_attach+0x5a/0x7d
> [    0.816704]  [<ffffffff812bd719>] ? __driver_attach+0x0/0x7d
> [    0.816708]  [<ffffffff812bc85d>] ? bus_for_each_dev+0x54/0x88
> [    0.816712]  [<ffffffff812bd319>] ? driver_attach+0x19/0x1b
> [    0.816715]  [<ffffffff812bcf6d>] ? bus_add_driver+0xab/0x201
> [    0.816719]  [<ffffffff812bd976>] ? driver_register+0xb2/0x11f
> [    0.816724]  [<ffffffff81b3cf29>] ? acpi_video_init+0x0/0x17
> [    0.816729]  [<ffffffff8124a29e>] ? acpi_bus_register_driver+0x3e/0x40
> [    0.816732]  [<ffffffff8126c8c5>] ? acpi_video_register+0x1b/0x34
> [    0.816736]  [<ffffffff81b3cf3e>] ? acpi_video_init+0x15/0x17
> [    0.816741]  [<ffffffff8100020a>] ? do_one_initcall+0x7a/0x130
> [    0.816746]  [<ffffffff81b1bc0e>] ? kernel_init+0xe1/0x15b
> [    0.816750]  [<ffffffff81002f94>] ? kernel_thread_helper+0x4/0x10
> [    0.816754]  [<ffffffff8102a634>] ? finish_task_switch+0x3f/0xe3
> [    0.816759]  [<ffffffff8155ab44>] ? restore_args+0x0/0x30
> [    0.816763]  [<ffffffff81b1bb2d>] ? kernel_init+0x0/0x15b
> [    0.816766]  [<ffffffff81002f90>] ? kernel_thread_helper+0x0/0x10
> [    0.816804] ---[ end trace 6d450e935ee1897c ]---
> [    0.816808] ACPI: Create sysfs link
> [    0.817274] acpi device:38: registered as cooling_device0
> [    0.818068] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:36/LNXVIDEO:00/input/input3
> [    0.818077] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    0.818236] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.

Have you tried this option?

There's nothing sysfs can do here, sorry, it really looks like you have
a BIOS/firmware problem.

good luck,

greg k-h
