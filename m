Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0EEASL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:18:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:44571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752950Ab0EEASI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:18:08 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX182zD4xtag2yK3lEFluaCFajwVDMQCii5CFD9sLrO
	WNe0CzjHkJD9cd
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Wed, 5 May 2010 02:18:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc6-sidux-686; KDE/4.4.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Kujau" <lists@nerdbynature.de>, linux-media@vger.kernel.org
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera> <8VO9AsMlpMD.A.IFC.aKJ4LB@chimera>
In-Reply-To: <8VO9AsMlpMD.A.IFC.aKJ4LB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005050218.02620.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 05 May 2010, Rafael J. Wysocki wrote:
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
> Date		: 2010-03-13 23:53 (53 days old)
> Message-ID	: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
> References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2

Still valid for b2c2_flexcop_pci in 2.6.34-rc6-git2:

[    8.736930] Linux video capture interface: v2.00
[    8.809720] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[    8.818680] flexcop-pci: will use the HW PID filter.
[    8.818685] flexcop-pci: card revision 2
[    8.818694] b2c2_flexcop_pci 0000:06:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.818794] ------------[ cut here ]------------
[    8.818799] WARNING: at /tmp/buildd/linux-sidux-2.6-2.6.34~rc6-git2/debian/build/source_amd64_none/fs/proc/generic.c:317 __xlate_proc_name+0xb5/0xd0()
[    8.818801] Hardware name: EP45-DS3
[    8.818802] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
[    8.818804] Modules linked in: b2c2_flexcop_pci(+) cx88xx b2c2_flexcop rfkill v4l2_common ir_common videodev drm snd_pcm snd_seq rtc_cmos snd_timer rtc_core snd_seq_device rtc_lib v4l1_compat tveeprom v4l2_compat_ioctl32 ir_core dvb_core snd videobuf_dma_sg cx24123 cx24113 videobuf_core s5h1420 tpm_tis led_class btcx_risc tpm i2c_i801 i2c_algo_bit tpm_bios i2c_core evdev intel_agp soundcore snd_page_alloc button processor ext4 mbcache jbd2 crc16 dm_mod sg sr_mod cdrom sd_mod usbhid hid uhci_hcd ahci firewire_ohci libata firewire_core crc_itu_t ehci_hcd r8169 mii scsi_mod thermal usbcore nls_base [last unloaded: scsi_wait_scan]
[    8.818832] Pid: 1064, comm: modprobe Not tainted 2.6.34-rc6-sidux-amd64 #1
[    8.818833] Call Trace:
[    8.818837]  [<ffffffff8104ba83>] ? warn_slowpath_common+0x73/0xb0
[    8.818839]  [<ffffffff8104bb20>] ? warn_slowpath_fmt+0x40/0x50
[    8.818842]  [<ffffffff8114f545>] ? __xlate_proc_name+0xb5/0xd0
[    8.818844]  [<ffffffff8114fb2e>] ? __proc_create+0x7e/0x150
[    8.818846]  [<ffffffff811504e7>] ? proc_mkdir_mode+0x27/0x60
[    8.818849]  [<ffffffff8109fb55>] ? register_handler_proc+0x115/0x130
[    8.818852]  [<ffffffff8109d4c1>] ? __setup_irq+0x1d1/0x330
[    8.818855]  [<ffffffffa03bc160>] ? flexcop_pci_isr+0x0/0x190 [b2c2_flexcop_pci]
[    8.818858]  [<ffffffff8109d735>] ? request_threaded_irq+0x115/0x1b0
[    8.818860]  [<ffffffffa03bc495>] ? flexcop_pci_probe+0x1a5/0x330 [b2c2_flexcop_pci]
[    8.818864]  [<ffffffff811ceef2>] ? local_pci_probe+0x12/0x20
[    8.818867]  [<ffffffff811d02ca>] ? pci_device_probe+0x10a/0x130
[    8.818870]  [<ffffffff8125cdda>] ? driver_sysfs_add+0x5a/0x80
[    8.818872]  [<ffffffff8125cf03>] ? driver_probe_device+0x93/0x190
[    8.818874]  [<ffffffff8125d093>] ? __driver_attach+0x93/0xa0
[    8.818876]  [<ffffffff8125d000>] ? __driver_attach+0x0/0xa0
[    8.818878]  [<ffffffff8125c638>] ? bus_for_each_dev+0x58/0x80
[    8.818880]  [<ffffffff8125be70>] ? bus_add_driver+0xb0/0x250
[    8.818882]  [<ffffffff8125d38a>] ? driver_register+0x6a/0x130
[    8.818884]  [<ffffffff811d056c>] ? __pci_register_driver+0x4c/0xc0
[    8.818887]  [<ffffffffa03bf000>] ? flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
[    8.818890]  [<ffffffff81002044>] ? do_one_initcall+0x34/0x1a0
[    8.818893]  [<ffffffff8107d15f>] ? sys_init_module+0xdf/0x260
[    8.818896]  [<ffffffff81009f42>] ? system_call_fastpath+0x16/0x1b
[    8.818897] ---[ end trace 46b5c98323696f39 ]---
[    8.822389] DVB: registering new adapter (FlexCop Digital TV device)
[    8.823874] b2c2-flexcop: MAC address = 00:d0:d7:0c:83:d6

Regards
	Stefan Lippers-Hollmann
