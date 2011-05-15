Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab1EONuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:50:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38919 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1EONum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:50:42 -0400
Date: Sun, 15 May 2011 15:50:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc7
Message-ID: <20110515135037.GA26111@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 07:49:48PM -0700, Linus Torvalds wrote:
> But please do test, just to make sure that 39-final is good.

I'm hitting a warn_on in the gendisk events code; happens after plugging
an ipod through usb. Adding Tejun.

[49045.176773] usb 1-3.1: new high speed USB device number 5 using ehci_hcd
[49045.287681] usb 1-3.1: New USB device found, idVendor=05ac, idProduct=1263
[49045.287697] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[49045.287707] usb 1-3.1: Product: iPod
[49045.287715] usb 1-3.1: Manufacturer: Apple Inc.
[49045.294369] scsi5 : usb-storage 1-3.1:1.0
[49046.300561] scsi 5:0:0:0: Direct-Access     Apple    iPod             1.62 PQ: 0 ANSI: 0
[49046.350703] sd 5:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[49046.354059] sd 5:0:0:0: [sdc] Write Protect is off
[49046.354071] sd 5:0:0:0: [sdc] Mode Sense: 68 00 00 08
[49046.354078] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[49046.357265] sd 5:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[49046.358222] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[49046.359584]  sdc: sdc1
[49046.363303] sd 5:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[49046.364265] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[49046.364290] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[49739.003924] ------------[ cut here ]------------
[49739.003946] WARNING: at block/genhd.c:1556 disk_clear_events+0xca/0x101()
[49739.003954] Hardware name: System Product Name
[49739.003961] Modules linked in: nls_iso8859_15 nls_cp437 usblp tun powernow_k8 mperf cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats freq_table binfmt_misc kvm_amd kvm fuse ipv6 vfat fat 8250_pnp 8250 edac_core serial_core ohci_hcd k10temp
[49739.004043] Pid: 11237, comm: hald-addon-stor Not tainted 2.6.39-rc7 #1
[49739.004050] Call Trace:
[49739.004067]  [<ffffffff8144673e>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[49739.004082]  [<ffffffff810383ee>] warn_slowpath_common+0x85/0x9d
[49739.004094]  [<ffffffff81038420>] warn_slowpath_null+0x1a/0x1c
[49739.004104]  [<ffffffff81190b97>] disk_clear_events+0xca/0x101
[49739.004117]  [<ffffffff811159b9>] check_disk_change+0x27/0x5f
[49739.004129]  [<ffffffff813051e4>] sd_open+0x86/0x12d
[49739.004139]  [<ffffffff81191eae>] ? disk_get_part+0x22/0x128
[49739.004150]  [<ffffffff811168ce>] __blkdev_get+0xb0/0x34c
[49739.004161]  [<ffffffff81116d62>] blkdev_get+0x1f8/0x32a
[49739.004172]  [<ffffffff81030494>] ? sub_preempt_count+0xa3/0xb6
[49739.004182]  [<ffffffff814467a4>] ? _raw_spin_unlock+0x35/0x52
[49739.004194]  [<ffffffff81116f1d>] blkdev_open+0x89/0x8d
[49739.004205]  [<ffffffff810e6dc9>] __dentry_open+0x250/0x37b
[49739.004216]  [<ffffffff81116e94>] ? blkdev_get+0x32a/0x32a
[49739.004227]  [<ffffffff810e6fbf>] nameidata_to_filp+0x60/0x67
[49739.004238]  [<ffffffff810f4ff8>] do_last+0x5c4/0x6b8
[49739.004250]  [<ffffffff810f6167>] path_openat+0xca/0x363
[49739.004261]  [<ffffffff8105d941>] ? local_clock+0x2a/0x3b
[49739.004272]  [<ffffffff81101357>] ? alloc_fd+0x1bc/0x1ce
[49739.004284]  [<ffffffff810f64f9>] do_filp_open+0x3d/0x8c
[49739.004294]  [<ffffffff814467a4>] ? _raw_spin_unlock+0x35/0x52
[49739.004305]  [<ffffffff81101357>] ? alloc_fd+0x1bc/0x1ce
[49739.004316]  [<ffffffff810e697d>] do_sys_open+0x110/0x1a9
[49739.004327]  [<ffffffff810e6a49>] sys_open+0x20/0x22
[49739.004338]  [<ffffffff814472eb>] system_call_fastpath+0x16/0x1b
[49739.004347] ---[ end trace 0e6e57542dc517bf ]---

-- 
Regards/Gruss,
    Boris.
