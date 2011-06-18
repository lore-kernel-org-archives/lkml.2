Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1FRXHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 19:07:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:57776 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1FRXHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 19:07:48 -0400
Subject: Re: 3.0-rc3: WARNING: at fs/fs-writeback.c:356
 writeback_single_inode+0x3e/0x18f()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20110618173355.GB4652@localhost>
References: <alpine.SOC.1.00.1106141213570.11764@math.ut.ee>
	 <1308112976.2635.27.camel@pasglop>  <20110618173355.GB4652@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 09:07:18 +1000
Message-ID: <1308438438.32158.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-19 at 01:33 +0800, Wu Fengguang wrote:
> Hi Benjamin,
> 
> On Wed, Jun 15, 2011 at 02:42:56PM +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2011-06-14 at 12:15 +0300, Meelis Roos wrote:
> > > Tested 3.0-rc3 on my PC (2 PATA disks, single duron CPU). Got several of 
> > > these in dmesg:
> > 
> > Same here on a powerpc64 machine while doing a fresh debian install
> > (while the installer's installing the packages), -rc3 as well.
> 
> Do you have some clue that this bug show up in between 3.0-rc1 and
> 3.0-rc3, or between 2.6.39 and 3.0-rc3?

No idea. I just noticed that as I was re-installing debian on a machine
(to track down another problem actually).

Maybe Meelis has more data.

Cheers,
Ben.
 
> Thanks,
> Fengguang
> 
> > > [  842.680141] ------------[ cut here ]------------
> > > [  842.680172] WARNING: at fs/fs-writeback.c:356 writeback_single_inode+0x3e/0x18f()
> > > [  842.680178] Hardware name:         
> > > [  842.680182] Modules linked in: mga ppdev lp ipv6 fuse loop snd_ens1371 gameport snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq sg sr_mod snd_timer snd_seq_device pcspkr evdev cdrom snd uhci_hcd ehci_hcd parport_pc rtc_cmos parport soundcore usbcore via686a snd_page_alloc ac97_bus hwmon i2c_viapro processor button
> > > [  842.680248] Pid: 1341, comm: flush-8:0 Not tainted 3.0.0-rc3 #67
> > > [  842.680254] Call Trace:
> > > [  842.680269]  [<c1254ada>] ? printk+0x18/0x1a
> > > [  842.680281]  [<c101fb6b>] warn_slowpath_common+0x77/0x8c
> > > [  842.680288]  [<c1092f8e>] ? writeback_single_inode+0x3e/0x18f
> > > [  842.680294]  [<c1092f8e>] ? writeback_single_inode+0x3e/0x18f
> > > [  842.680300]  [<c101fb9d>] warn_slowpath_null+0x1d/0x1f
> > > [  842.680306]  [<c1092f8e>] writeback_single_inode+0x3e/0x18f
> > > [  842.680313]  [<c1093519>] writeback_sb_inodes+0xcb/0x153
> > > [  842.680320]  [<c1093aba>] writeback_inodes_wb+0xb0/0xf1
> > > [  842.680326]  [<c1093c1d>] wb_writeback+0x122/0x1b0
> > > [  842.680334]  [<c1093d15>] wb_check_old_data_flush+0x6a/0x76
> > > [  842.680340]  [<c1093dc1>] wb_do_writeback+0xa0/0xf3
> > > [  842.680347]  [<c1093e53>] bdi_writeback_thread+0x3f/0xd7
> > > [  842.680354]  [<c1093e14>] ? wb_do_writeback+0xf3/0xf3
> > > [  842.680366]  [<c10328cc>] kthread+0x61/0x66
> > > [  842.680373]  [<c103286b>] ? kthread_worker_fn+0xf7/0xf7
> > > [  842.680383]  [<c125ce7e>] kernel_thread_helper+0x6/0xd
> > > [  842.680388] ---[ end trace c75e8a0e74c129b7 ]---
> > > 
> > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


