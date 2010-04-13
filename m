Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0DMVpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:45:36 -0400
Received: from mail-yx0-f153.google.com ([209.85.210.153]:57611 "EHLO
	mail-yx0-f153.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0DMVpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:45:34 -0400
X-Greylist: delayed 2230 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 17:45:34 EDT
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 14:08:23 -0700 (PDT)
In-Reply-To: <eaCvo-2Z3-11@gated-at.bofh.it>
X-IP: 72.254.93.3
References: <e9Rwu-8fL-17@gated-at.bofh.it> <eaj9o-81o-5@gated-at.bofh.it> 
	<eak5s-WM-13@gated-at.bofh.it> <earTj-47e-5@gated-at.bofh.it> 
	<eaxcm-3zV-17@gated-at.bofh.it> <eaxcm-3zV-15@gated-at.bofh.it> 
	<eaxvI-3WN-5@gated-at.bofh.it> <eayL9-5L5-17@gated-at.bofh.it> 
	<eaB6i-10t-9@gated-at.bofh.it> <eaCvo-2Z3-11@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.3a4pre) 
	Gecko/20100407 Ubuntu/10.04 (lucid) Minefield/3.7a4pre,gzip(gfe)
Message-ID: <6575892d-9f8d-4fc3-a9a3-74575015b724@z3g2000yqz.googlegroups.com>
Subject: Re: MMC: fix hang if card was removed during suspend and unsafe 
	resume was enabled
From: Eric Miao <eric.y.miao@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 4:00 am, Maxim Levitsky <maximlevit...@gmail.com> wrote:
> On Fri, 2010-02-05 at 10:26 -0800, Andrew Morton wrote:
> > On Fri, 05 Feb 2010 17:52:00 +0200
> > Maxim Levitsky <maximlevit...@gmail.com> wrote:
>
> > > > > <4>[15241.042047]  [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
> > > > > <4>[15241.042159]  [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
> > > > > <4>[15241.042271]  [<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
> > > > > <4>[15241.042386]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > > <4>[15241.042496]  [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
> > > > > <4>[15241.042606]  [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
> > > > > <4>[15241.042714]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > > <4>[15241.042824]  [<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
> > > > > <4>[15241.042935]  [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
> > > > > <4>[15241.043045]  [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
> > > > > <4>[15241.043155]  [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
> > > > > <4>[15241.043265]  [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
> > > > > <4>[15241.043375]  [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
> > > > > <4>[15241.043485]  [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
> > > > > <4>[15241.043594]  [<ffffffff811391de>] fsync_bdev+0x2e/0x60
> > > > > <4>[15241.043704]  [<ffffffff812226be>] invalidate_partition+0x2e/0x50
> > > > > <4>[15241.043816]  [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
> > > > > <4>[15241.043926]  [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
> > > > > <4>[15241.044043]  [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
> > > > > <4>[15241.044152]  [<ffffffff812ce746>] __device_release_driver+0x66/0xc0
> > > > > <4>[15241.044264]  [<ffffffff812ce89d>] device_release_driver+0x2d/0x40
> > > > > <4>[15241.044375]  [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
> > > > > <4>[15241.044486]  [<ffffffff812cb46f>] device_del+0x12f/0x1a0
> > > > > <4>[15241.044593]  [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
> > > > > <4>[15241.044702]  [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
> > > > > <4>[15241.044811]  [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
> > > > > <4>[15241.044929]  [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
> > > > > <4>[15241.045044]  [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]
>
> > > > So what's the hang?  del_gendisk is doing IO?  I'd assumed that it was
> > > > because it was calling kobject_uevent, but userspace is frozen.
>
> > > This is a backtrace of a hang.
>
> > But why did it hang?  Because the BDI worker threads are trying to
> > perform IO through a suspended device?
>
> Something like that I guess.
> Also this is 100% reproducible, and I can reproduce this with my own
> driver too (by making the card detection workqueue be non freezable)
>

It looks to me bdi is waiting for writeback task to finish, yet the
processes
are frozen, so this never happens, and hang.

And I can confirm this always happens. Without MMC_UNSAFE_RESUME,
this happens when suspending where the mmc core tries to remove the
card.
With MMC_UNSAFE_RESUME, this happens when resume if the card removed
during suspend.

Though the root cause looks to me lies in the del_gendisk() not safe
to be
called within suspend context, and a clean fix might be somewhere in
the
generic disk layer. Skip removing card during suspend, IMHO, might not
be
a clean enough fix to this problem.

I might be able to avoid this issue by removing the card within user
space
pm scripts, but that's a shame if this cannot be cleanly fixed within
kernel.
