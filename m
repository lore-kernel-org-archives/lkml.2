Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0D3Som (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:44:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:40834 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932557Ab0D3SoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:44:10 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19Y1kBnN1ZYwqxyWGI9mPYQpJhs4y+bEgKsxjHkvG
	j7tW7Rd9ZaIRcq
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Fri, 30 Apr 2010 04:44:03 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5-sidux-686; KDE/4.4.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Kujau" <lists@nerdbynature.de>, linux-media@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
In-Reply-To: <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004300444.05842.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 30 April 2010, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
> Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2010-03-13 23:53 (38 days old)
> Message-ID	: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
> References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2

This also continues to be a problem with b2c2-flexcop and 2.6.34-rc5-git10:

[   10.119807] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[   10.129183] flexcop-pci: will use the HW PID filter.
[   10.129187] flexcop-pci: card revision 2
[   10.129195] b2c2_flexcop_pci 0000:06:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.129239] ------------[ cut here ]------------
[   10.129244] WARNING: at /tmp/buildd/linux-sidux-2.6-2.6.34~rc5/debian/build/source_amd64_none/fs/proc/generic.c:317 __xlate_proc_name+0xb5/0xd0()
[   10.129246] Hardware name: EP45-DS3
[   10.129247] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
[   10.129248] Modules linked in: b2c2_flexcop_pci(+) ath9k_common b2c2_flexcop v4l1_compat snd_timer radeon(+) dvb_core ar9170usb(+) ath9k_hw snd_seq_device ir_common tveeprom ttm v4l2_compat_ioctl32 snd drm_kms_helper ir_core ath mac80211 soundcore videobuf_dma_sg cx24123 drm i2c_i801 i2c_algo_bit snd_page_alloc videobuf_core cx24113 s5h1420 cfg80211 rfkill evdev i2c_core tpm_tis btcx_risc tpm led_class pcspkr tpm_bios rtc_cmos button rtc_core intel_agp rtc_lib processor ext4 mbcache jbd2 crc16 dm_mod sg sr_mod cdrom sd_mod usbhid hid uhci_hcd firewire_ohci firewire_core ahci r8169 ehci_hcd mii libata crc_itu_t scsi_mod thermal usbcore nls_base [last unloaded: scsi_wait_scan]
[   10.129279] Pid: 1124, comm: modprobe Not tainted 2.6.34-rc5-sidux-amd64 #1
[   10.129281] Call Trace:
[   10.129285]  [<ffffffff8104ba83>] ? warn_slowpath_common+0x73/0xb0
[   10.129287]  [<ffffffff8104bb20>] ? warn_slowpath_fmt+0x40/0x50
[   10.129290]  [<ffffffff8114f545>] ? __xlate_proc_name+0xb5/0xd0
[   10.129292]  [<ffffffff8114fb2e>] ? __proc_create+0x7e/0x150
[   10.129294]  [<ffffffff811504e7>] ? proc_mkdir_mode+0x27/0x60
[   10.129297]  [<ffffffff8109fb55>] ? register_handler_proc+0x115/0x130
[   10.129300]  [<ffffffff8109d4c1>] ? __setup_irq+0x1d1/0x330
[   10.129303]  [<ffffffffa011b160>] ? flexcop_pci_isr+0x0/0x190 [b2c2_flexcop_pci]
[   10.129305]  [<ffffffff8109d735>] ? request_threaded_irq+0x115/0x1b0
[   10.129308]  [<ffffffffa011b495>] ? flexcop_pci_probe+0x1a5/0x330 [b2c2_flexcop_pci]
[   10.129312]  [<ffffffff811ceef2>] ? local_pci_probe+0x12/0x20
[   10.129314]  [<ffffffff811d02ca>] ? pci_device_probe+0x10a/0x130
[   10.129317]  [<ffffffff8125cdda>] ? driver_sysfs_add+0x5a/0x80
[   10.129320]  [<ffffffff8125cf03>] ? driver_probe_device+0x93/0x190
[   10.129322]  [<ffffffff8125d093>] ? __driver_attach+0x93/0xa0
[   10.129324]  [<ffffffff8125d000>] ? __driver_attach+0x0/0xa0
[   10.129326]  [<ffffffff8125c638>] ? bus_for_each_dev+0x58/0x80
[   10.129328]  [<ffffffff8125be70>] ? bus_add_driver+0xb0/0x250
[   10.129330]  [<ffffffff8125d38a>] ? driver_register+0x6a/0x130
[   10.129332]  [<ffffffff811d056c>] ? __pci_register_driver+0x4c/0xc0
[   10.129335]  [<ffffffffa012e000>] ? flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
[   10.129338]  [<ffffffff81002044>] ? do_one_initcall+0x34/0x1a0
[   10.129341]  [<ffffffff8107d15f>] ? sys_init_module+0xdf/0x260
[   10.129344]  [<ffffffff81009f42>] ? system_call_fastpath+0x16/0x1b
[   10.129345] ---[ end trace 370a62256537c67a ]---
[   10.134144] DVB: registering new adapter (FlexCop Digital TV device)
[   10.135610] b2c2-flexcop: MAC address = 00:d0:d7:0c:83:d6

Regards
	Stefan Lippers-Hollmann
