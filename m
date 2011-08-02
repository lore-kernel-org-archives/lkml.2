Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1HBXUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 19:20:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57308 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753460Ab1HBXUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 19:20:30 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/bDv9VSyDbAgObspL9mWOnGBu+rhZ49KpgEIlxCM
	jiqMAFARUYJbYL
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless adapter
Date: Wed, 3 Aug 2011 01:20:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-0.slh.5-aptosid-686; KDE/4.6.5; i686; ; )
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201108022229.58532.s.L-H@gmx.de> <4E386FB9.2040507@lwfinger.net> <201108030035.50214.s.L-H@gmx.de>
In-Reply-To: <201108030035.50214.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108030120.21059.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 03 August 2011, Stefan Lippers-Hollmann wrote:
> On Wednesday 03 August 2011, Larry Finger wrote:
> > On 08/02/2011 03:43 PM, Stefan Lippers-Hollmann wrote:
> > > On Tuesday 02 August 2011, Stefan Lippers-Hollmann wrote:
> > > [1]	http://aptosid.com/index.php?name=PNphpBB2&file=viewtopic&t=1550&start=0
> > > [2]	http://pastebin.com/ppZJ0GmU
[...]
> - no Oops if his USB ID is compiled into the module, that only happens
>   if he tries to inject it into an unpatched kernel with:
>   echo -n "050d 2103">  /sys/bus/usb/drivers/rtl8192cu/new_id
>   (and I'm reluctant to raise this as potential issue completely, due
>   to the tainted kernel condition on his system).

I can reproduce the reported Oops by injecting a (wrong) USB ID into 
rtl8192cu myself on an untainted system. For reproducing the Oops, I 
inject an unknown (wrong, the device I'm abusing for this test is a 
Netgear WG111T, Atheros AR5523 based - no linux driver exists for this 
device and no module claims its device IDs 0x1385 0x4251) USB ID 
through sysfs facilities into rtl8192cu; all tests with kernel 
3.0 + current -stable queue:

# cat /proc/sys/kernel/tainted
0
# modprobe rtl8192cu
# echo -n "1385 4251" > /sys/bus/usb/drivers/rtl8192cu/new_id
[hotplug device]
# dmesg
[...]
[   86.420998] usbcore: registered new interface driver rtl8192cu
[  110.778029] usb 1-7: new high speed USB device number 5 using ehci_hcd
[  110.893824] usb 1-7: New USB device found, idVendor=1385, idProduct=4251
[  110.893830] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  110.893836] usb 1-7: Product: WG111T
[  110.893841] usb 1-7: Manufacturer: Atheros Communications Inc
[  110.893845] usb 1-7: SerialNumber: 1.0
[  110.894760] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[  110.894903] IP: [<ffffffffa0604747>] rtl_usb_probe+0x19b/0x74d [rtlwifi]
[  110.895012] PGD 0 
[  110.895012] Oops: 0000 [#1] PREEMPT SMP 
[  110.895012] CPU 0 
[  110.895012] Modules linked in: rtl8192cu rtl8192c_common rtlwifi mac80211 cfg80211 rfkill cpufreq_stats cpufreq_ondemand cpufreq_powersave cpufreq_conservative ppdev lp cpufreq_performance af_packet fuse nls_utf8 ntfs powernow_k8 freq_table mperf tda18218 af9013 ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder dvb_usb_af9015 dvb_usb dvb_core rc_core edac_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq snd_timer snd_seq_device radeon parport_pc ttm drm_kms_helper drm i2c_algo_bit k8temp pcspkr evdev psmouse edac_mce_amd serio_raw power_supply parport snd i2c_nforce2 i2c_core button soundcore processor snd_page_alloc ext4 mbcache jbd2 crc16 dm_mod btrfs zlib_deflate crc32c libcrc32c sg sr_mod sd_mod cdrom crc_t10dif ata_generic usbhid hid floppy thermal fan firewire_ohci pata_acpi firewire_core crc_itu_t pata_amd sata_nv e1000 libata ohci_hcd forcedeth scsi_mod ehci_hcd usbcore ssb mmc_core pcmcia pcmcia_core [last unloaded: scsi_wait_scan]
[  110.895012] 
[  110.895012] Pid: 577, comm: khubd Not tainted 3.0-0.slh.6-aptosid-amd64 #1 MICRO-STAR INTERNATIONAL CO., LTD MS-7185/MS-7185
[  110.895012] RIP: 0010:[<ffffffffa0604747>]  [<ffffffffa0604747>] rtl_usb_probe+0x19b/0x74d [rtlwifi]
[  110.895012] RSP: 0018:ffff88011da77a60  EFLAGS: 00010246
[  110.895012] RAX: 0000000000000000 RBX: ffff88011fc09ca0 RCX: 0000000000000000
[  110.895012] RDX: ffffffffa0608618 RSI: ffffffffa0607819 RDI: ffff88011fc08520
[  110.895012] RBP: ffff88011f0a7088 R08: 000000000000ffff R09: 000000000000ffff
[  110.895012] R10: 0000000000000000 R11: 000000000000fffb R12: ffff88011d5a6c30
[  110.895012] R13: ffff88011fd54090 R14: ffff88011fc08520 R15: ffff88011fc09ca0
[  110.895012] FS:  00007f6e9e1d37a0(0000) GS:ffff880127c00000(0000) knlGS:0000000000000000
[  110.895012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  110.895012] CR2: 0000000000000018 CR3: 000000011fe0f000 CR4: 00000000000006f0
[  110.895012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  110.895012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  110.895012] Process khubd (pid: 577, threadinfo ffff88011da76000, task ffff88011dc5b700)
[  110.895012] Stack:
[  110.895012]  0000000000000246 ffffffff8129f3d2 ffff88011fd54090 ffff88011f0a7000
[  110.895012]  ffff88011f0a7088 ffff88011d5a6c30 ffff88011f0a7000 ffffffffa0639528
[  110.895012]  ffff88011fd54090 ffff88011d5a6c00 0000000000000000 ffffffffa0051f05
[  110.895012] Call Trace:
[  110.895012]  [<ffffffff8129f3d2>] ? __pm_runtime_set_status+0x132/0x1e0
[  110.895012]  [<ffffffffa0051f05>] ? usb_probe_interface+0xe5/0x1e0 [usbcore]
[  110.895012]  [<ffffffff8129657f>] ? driver_probe_device+0x6f/0x190
[  110.895012]  [<ffffffff81296740>] ? __driver_attach+0xa0/0xa0
[  110.895012]  [<ffffffff812952d3>] ? bus_for_each_drv+0x53/0x80
[  110.895012]  [<ffffffff812964cf>] ? device_attach+0x9f/0xc0
[  110.895012]  [<ffffffff81295c7d>] ? bus_probe_device+0x2d/0x50
[  110.895012]  [<ffffffff81293f8d>] ? device_add+0x5ad/0x670
[  110.895012]  [<ffffffff812927b2>] ? dev_set_name+0x42/0x50
[  110.895012]  [<ffffffffa0050577>] ? usb_set_configuration+0x5d7/0x6d0 [usbcore]
[  110.895012]  [<ffffffffa005904b>] ? generic_probe+0x3b/0xa0 [usbcore]
[  110.895012]  [<ffffffff8129657f>] ? driver_probe_device+0x6f/0x190
[  110.895012]  [<ffffffff81296740>] ? __driver_attach+0xa0/0xa0
[  110.895012]  [<ffffffff812952d3>] ? bus_for_each_drv+0x53/0x80
[  110.895012]  [<ffffffff812964cf>] ? device_attach+0x9f/0xc0
[  110.895012]  [<ffffffff81295c7d>] ? bus_probe_device+0x2d/0x50
[  110.895012]  [<ffffffff81293f8d>] ? device_add+0x5ad/0x670
[  110.895012]  [<ffffffffa0048cd2>] ? usb_new_device+0x122/0x1b0 [usbcore]
[  110.895012]  [<ffffffffa0049cb0>] ? hub_thread+0x7c0/0x1310 [usbcore]
[  110.895012]  [<ffffffff813c8ed7>] ? schedule+0x2b7/0x860
[  110.895012]  [<ffffffff81044616>] ? try_to_wake_up+0x1b6/0x270
[  110.895012]  [<ffffffff8106a020>] ? abort_exclusive_wait+0xb0/0xb0
[  110.895012]  [<ffffffffa00494f0>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[  110.895012]  [<ffffffff8106985e>] ? kthread+0x7e/0x90
[  110.895012]  [<ffffffff813cd1a4>] ? kernel_thread_helper+0x4/0x10
[  110.895012]  [<ffffffff810697e0>] ? kthread_worker_fn+0x180/0x180
[  110.895012]  [<ffffffff813cd1a0>] ? gs_change+0x13/0x13
[  110.895012] Code: 29 60 a0 48 c7 83 60 06 00 00 70 29 60 a0 48 c7 83 68 06 00 00 50 29 60 a0 48 c7 83 70 06 00 00 f0 2b 60 a0 49 8b 87 38 27 00 00 
[  110.895012]  8b 40 18 ff 50 10 49 8b 87 38 27 00 00 4c 89 f7 48 8b 40 18 
[  110.895012] RIP  [<ffffffffa0604747>] rtl_usb_probe+0x19b/0x74d [rtlwifi]
[  110.895012]  RSP <ffff88011da77a60>
[  110.895012] CR2: 0000000000000018
[  110.944291] ---[ end trace aa8fb4280a86af53 ]---
# cat /proc/sys/kernel/tainted
128

The same procedure (after rebooting) doesn't result in an Oops with 
other modules, although they can't initialize this 'unknown' device 
either, using rt2500usb as example:
# cat /proc/sys/kernel/tainted
0
# modprobe rt2500usb
# echo -n "1385 4251" > /sys/bus/usb/drivers/rt2500usb/new_id
[hotplug device]
# dmesg
[...]
[  112.676033] usb 1-7: new high speed USB device number 5 using ehci_hcd
[  112.791945] usb 1-7: New USB device found, idVendor=1385, idProduct=4251
[  112.791951] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  112.791957] usb 1-7: Product: WG111T
[  112.791961] usb 1-7: Manufacturer: Atheros Communications Inc
[  112.791965] usb 1-7: SerialNumber: 1.0
[  112.895037] usb 1-7: reset high speed USB device number 5 using ehci_hcd
[  113.108950] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -32.
[  113.208947] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x04d0 with error -32.
[  113.308946] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x04ce with error -32.
[  113.408950] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x04d0 with error -32.
[  113.508946] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x04ce with error -32.
[  113.608450] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -32.
[  113.608457] phy0 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
[  113.608463] phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
[everything fine, as expected no issues - the wrong device just can't 
 get initialized]
# cat /proc/sys/kernel/tainted
0
# reboot

So at least the reported Oops is not specific to 050d:2103, but happens
for any USB ID injected at runtime through sysfs and therefore appears
to be a general issue with rtl8192cu.

Regards
	Stefan Lippers-Hollmann
