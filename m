Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1AZJdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:33:41 -0500
Received: from smtp14.ono.com ([62.42.230.176]:58473 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039Ab1AZJdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:33:38 -0500
Date: Wed, 26 Jan 2011 10:33:33 +0100
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WiFi USB key
Message-ID: <20110126103333.4db50538@werewolf.home>
In-Reply-To: <20110126081712.GA18154@rhlx01.hs-esslingen.de>
References: <20110126005931.59fce843@werewolf.home>
	<20110126081712.GA18154@rhlx01.hs-esslingen.de>
X-Mailer: Claws Mail 3.7.8cvs33 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 09:17:12 +0100, Andreas Mohr <andi@lisas.de> wrote:

> Hi,
> 
> > I suppose it is because the module does not recognize the USB IDs in my
> > device. How can I force it to try without recompiling kernel ?
> > Is there any parameter o alias in modprobe.conf I could try ?
> 
> There are even _two_ ways for preliminary attempts at adding
> a new device ID to USB drivers:
> 
> quote
> "You can echo the vendor and device id to the "new_id" file in the
> /sys/bus/usb-serial/drivers/cp2102/ directory."
> 
> And at least for the ftdi_sio driver (and perhaps some others),
> there's the product/vendor module parameter (see modinfo ftdi_sio).
> 
> 
> http://www.ha19.no/usb/
> 
> 
> Thanks for the report!
> (and please notify or even write a patch in case the driver actually
> supports the device, and does so sufficiently successfully)
> 

Thanks! I was trying this step by step, but found some problems:

Just do a modprobe, without plugging the device, gives a backtrace on syslog:

modprobe r8192u-usb

Jan 26 10:21:44 werewolf kernel: r8192u_usb: module is from the staging directory, the quality is unknown, you have been warned.
Jan 26 10:21:44 werewolf kernel: ------------[ cut here ]------------
Jan 26 10:21:44 werewolf kernel: WARNING: at fs/proc/generic.c:589 proc_register+0x109/0x1f0()
Jan 26 10:21:44 werewolf kernel: Hardware name: P5Q-PRO
Jan 26 10:21:44 werewolf kernel: proc_dir_entry 'net/ieee80211' already registered
Jan 26 10:21:44 werewolf kernel: Modules linked in: r8192u_usb(C+) btrfs zlib_deflate crc32c libcrc32c fuse af_packet nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp binfmt_misc loop dm_mod nvidia(P) cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr kvm_intel kvm snd_hda_codec_hdmi sr_mod atl1e snd_hda_codec_realtek uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 shpchp uas snd_hda_intel processor joydev snd_usb_audio iTCO_wdt i2c_i801 floppy sg usb_storage pci_hotplug snd_hda_codec asus_atk0110 button iTCO_vendor_support snd_hwdep snd_usbmidi_lib snd_pcm snd_rawmidi snd_timer snd_seq_device snd serio_raw evdev i2c_core snd_page_alloc soundcore ipv6 autofs4 firewire_sbp2 firewire_ohci firewire_core crc_itu_t ata_piix sd_mod crc_t10dif uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore ext3 jbd ext4 jbd2 crc16 pata_marvell ahci libahci libata scsi_mod msr cpuid [last unloaded: r8192u_usb]
Jan 26 10:21:44 werewolf kernel: Pid: 24328, comm: modprobe Tainted: P        WC  2.6.37-desktop-1mnb #1
Jan 26 10:21:44 werewolf kernel: Call Trace:
Jan 26 10:21:44 werewolf kernel: [<ffffffff81060b5f>] warn_slowpath_common+0x7f/0xc0
Jan 26 10:21:44 werewolf kernel: [<ffffffff81060c56>] warn_slowpath_fmt+0x46/0x50
Jan 26 10:21:44 werewolf kernel: [<ffffffff811ad729>] proc_register+0x109/0x1f0
Jan 26 10:21:44 werewolf kernel: [<ffffffffa117d000>] ? rtl8192_usb_module_init+0x0/0x11c [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffff811ade4e>] create_proc_entry+0x5e/0xb0
Jan 26 10:21:44 werewolf kernel: [<ffffffffa117d243>] ieee80211_debug_init+0x28/0xa1 [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffffa117d00e>] rtl8192_usb_module_init+0xe/0x11c [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffff81002194>] do_one_initcall+0x44/0x190
Jan 26 10:21:44 werewolf kernel: [<ffffffff8109e563>] sys_init_module+0xc3/0x210
Jan 26 10:21:44 werewolf kernel: [<ffffffff8100bf52>] system_call_fastpath+0x16/0x1b
Jan 26 10:21:44 werewolf kernel: ---[ end trace 7d3227f9f6684b3d ]---
Jan 26 10:21:44 werewolf kernel: ieee80211_crypt: registered algorithm 'NULL'
Jan 26 10:21:44 werewolf kernel: ieee80211_crypt: registered algorithm 'TKIP'
Jan 26 10:21:44 werewolf kernel: ieee80211_crypt: registered algorithm 'CCMP'
Jan 26 10:21:44 werewolf kernel: ieee80211_crypt: registered algorithm 'WEP'
Jan 26 10:21:44 werewolf kernel:
Jan 26 10:21:44 werewolf kernel: Linux kernel driver for RTL8192 based WLAN cards
Jan 26 10:21:44 werewolf kernel: Copyright (c) 2007-2008, Realsil Wlan
Jan 26 10:21:44 werewolf kernel: ------------[ cut here ]------------
Jan 26 10:21:44 werewolf kernel: WARNING: at fs/proc/generic.c:589 proc_register+0x109/0x1f0()
Jan 26 10:21:44 werewolf kernel: Hardware name: P5Q-PRO
Jan 26 10:21:44 werewolf kernel: proc_dir_entry 'net/rtl819xU' already registered
Jan 26 10:21:44 werewolf kernel: Modules linked in: r8192u_usb(C+) btrfs zlib_deflate crc32c libcrc32c fuse af_packet nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp binfmt_misc loop dm_mod nvidia(P) cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr kvm_intel kvm snd_hda_codec_hdmi sr_mod atl1e snd_hda_codec_realtek uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 shpchp uas snd_hda_intel processor joydev snd_usb_audio iTCO_wdt i2c_i801 floppy sg usb_storage pci_hotplug snd_hda_codec asus_atk0110 button iTCO_vendor_support snd_hwdep snd_usbmidi_lib snd_pcm snd_rawmidi snd_timer snd_seq_device snd serio_raw evdev i2c_core snd_page_alloc soundcore ipv6 autofs4 firewire_sbp2 firewire_ohci firewire_core crc_itu_t ata_piix sd_mod crc_t10dif uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore ext3 jbd ext4 jbd2 crc16 pata_marvell ahci libahci libata scsi_mod msr cpuid [last unloaded: r8192u_usb]
Jan 26 10:21:44 werewolf kernel: Pid: 24328, comm: modprobe Tainted: P        WC  2.6.37-desktop-1mnb #1
Jan 26 10:21:44 werewolf kernel: Call Trace:
Jan 26 10:21:44 werewolf kernel: [<ffffffff81060b5f>] warn_slowpath_common+0x7f/0xc0
Jan 26 10:21:44 werewolf kernel: [<ffffffff81060c56>] warn_slowpath_fmt+0x46/0x50
Jan 26 10:21:44 werewolf kernel: [<ffffffff811ad729>] proc_register+0x109/0x1f0
Jan 26 10:21:44 werewolf kernel: [<ffffffffa117d000>] ? rtl8192_usb_module_init+0x0/0x11c [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffff811ade4e>] create_proc_entry+0x5e/0xb0
Jan 26 10:21:44 werewolf kernel: [<ffffffffa112f54a>] rtl8192_proc_module_init+0x2a/0x50 [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffffa117d0fa>] rtl8192_usb_module_init+0xfa/0x11c [r8192u_usb]
Jan 26 10:21:44 werewolf kernel: [<ffffffff81002194>] do_one_initcall+0x44/0x190
Jan 26 10:21:44 werewolf kernel: [<ffffffff8109e563>] sys_init_module+0xc3/0x210
Jan 26 10:21:44 werewolf kernel: [<ffffffff8100bf52>] system_call_fastpath+0x16/0x1b
Jan 26 10:21:44 werewolf kernel: ---[ end trace 7d3227f9f6684b3e ]---
Jan 26 10:21:44 werewolf kernel: usbcore: registered new interface driver rtl819xU


Is this serious ?

Echoed the vendor/id values to /sys, and plugging the device gives:

Jan 26 10:25:32 werewolf kernel: usb 1-4: new high speed USB device using ehci_hcd and address 4
Jan 26 10:25:32 werewolf kernel: usb 1-4: New USB device found, idVendor=050d, idProduct=1102
Jan 26 10:25:32 werewolf kernel: usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jan 26 10:25:32 werewolf kernel: usb 1-4: Product: 802.11n WLAN Adapter
Jan 26 10:25:32 werewolf kernel: usb 1-4: Manufacturer: Realtek
Jan 26 10:25:32 werewolf kernel: usb 1-4: SerialNumber: 00e04c000001
Jan 26 10:25:32 werewolf kernel: rtl819xU:EEPROM ID is invalid(is 0x0(should be 0x8129)
Jan 26 10:25:32 werewolf kernel:
Jan 26 10:25:32 werewolf kernel: Dot11d_Init()
Jan 26 10:25:32 werewolf kernel: End of initendpoints
Jan 26 10:25:32 werewolf kernel: ------------[ cut here ]------------
Jan 26 10:25:32 werewolf kernel: WARNING: at include/linux/netdevice.h:1557 rtl8192_usb_probe+0x15c/0x23d [r8192u_usb]()
Jan 26 10:25:32 werewolf kernel: Hardware name: P5Q-PRO
Jan 26 10:25:32 werewolf kernel: Modules linked in: r8192u_usb(C) btrfs zlib_deflate crc32c libcrc32c fuse af_packet nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp binfmt_misc loop dm_mod nvidia(P) cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr kvm_intel kvm snd_hda_codec_hdmi sr_mod atl1e snd_hda_codec_realtek uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 shpchp uas snd_hda_intel processor joydev snd_usb_audio iTCO_wdt i2c_i801 floppy sg usb_storage pci_hotplug snd_hda_codec asus_atk0110 button iTCO_vendor_support snd_hwdep snd_usbmidi_lib snd_pcm snd_rawmidi snd_timer snd_seq_device snd serio_raw evdev i2c_core snd_page_alloc soundcore ipv6 autofs4 firewire_sbp2 firewire_ohci firewire_core crc_itu_t ata_piix sd_mod crc_t10dif uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore ext3 jbd ext4 jbd2 crc16 pata_marvell ahci libahci libata scsi_mod msr cpuid [last unloaded: r8192u_usb]
Jan 26 10:25:32 werewolf kernel: Pid: 72, comm: khubd Tainted: P        WC  2.6.37-desktop-1mnb #1
Jan 26 10:25:32 werewolf kernel: Call Trace:
Jan 26 10:25:32 werewolf kernel: [<ffffffff81060b5f>] warn_slowpath_common+0x7f/0xc0
Jan 26 10:25:32 werewolf kernel: [<ffffffff81060bba>] warn_slowpath_null+0x1a/0x20
Jan 26 10:25:32 werewolf kernel: [<ffffffffa11b64b5>] rtl8192_usb_probe+0x15c/0x23d [r8192u_usb]
Jan 26 10:25:32 werewolf kernel: [<ffffffffa0178e15>] usb_probe_interface+0x185/0x250 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e054f>] driver_probe_device+0x8f/0x260
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e07d0>] ? __device_attach+0x0/0x60
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e0823>] __device_attach+0x53/0x60
Jan 26 10:25:32 werewolf kernel: [<ffffffff812def94>] bus_for_each_drv+0x64/0x90
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e03cf>] device_attach+0x8f/0xb0
Jan 26 10:25:32 werewolf kernel: [<ffffffff812dfa9d>] bus_probe_device+0x2d/0x50
Jan 26 10:25:32 werewolf kernel: [<ffffffff812dd35c>] device_add+0x51c/0x5f0
Jan 26 10:25:32 werewolf kernel: [<ffffffff812dbdd1>] ? dev_set_name+0x41/0x50
Jan 26 10:25:32 werewolf kernel: [<ffffffffa0176e3e>] usb_set_configuration+0x62e/0x750 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffffa0180a74>] generic_probe+0x44/0xa0 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffffa0178f21>] usb_probe_device+0x41/0xa0 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e054f>] driver_probe_device+0x8f/0x260
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e07d0>] ? __device_attach+0x0/0x60
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e0823>] __device_attach+0x53/0x60
Jan 26 10:25:32 werewolf kernel: [<ffffffff812def94>] bus_for_each_drv+0x64/0x90
Jan 26 10:25:32 werewolf kernel: [<ffffffff812e03cf>] device_attach+0x8f/0xb0
Jan 26 10:25:32 werewolf kernel: [<ffffffff812dfa9d>] bus_probe_device+0x2d/0x50
Jan 26 10:25:32 werewolf kernel: [<ffffffff812dd35c>] device_add+0x51c/0x5f0
Jan 26 10:25:32 werewolf kernel: [<ffffffffa016e9e2>] usb_new_device+0x112/0x1d0 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffffa0170048>] hub_thread+0xc58/0x1450 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffffa016f3f0>] ? hub_thread+0x0/0x1450 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffff810823a0>] ? autoremove_wake_function+0x0/0x40
Jan 26 10:25:32 werewolf kernel: [<ffffffffa016f3f0>] ? hub_thread+0x0/0x1450 [usbcore]
Jan 26 10:25:32 werewolf kernel: [<ffffffff81081e26>] kthread+0x96/0xa0
Jan 26 10:25:32 werewolf kernel: [<ffffffff8100cd64>] kernel_thread_helper+0x4/0x10
Jan 26 10:25:32 werewolf kernel: [<ffffffff81081d90>] ? kthread+0x0/0xa0
Jan 26 10:25:32 werewolf kernel: [<ffffffff8100cd60>] ? kernel_thread_helper+0x0/0x10
Jan 26 10:25:32 werewolf kernel: ---[ end trace 7d3227f9f6684b41 ]---
Jan 26 10:25:32 werewolf mtp-probe: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4"
Jan 26 10:25:32 werewolf mtp-probe: bus: 1, device: 4 was not an MTP device
Jan 26 10:25:32 werewolf mtp-probe: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4"
Jan 26 10:25:32 werewolf mtp-probe: bus: 1, device: 4 was not an MTP device
Jan 26 10:25:32 werewolf kernel: netif_stop_queue() cannot be called before register_netdev()
Jan 26 10:25:32 werewolf kernel: udev[29134]: renamed network interface wlan0 to wlan1
Jan 26 10:25:32 werewolf NetworkManager[2894]: <error> [1296033932.906434] [nm-device-wifi.c:3097] real_update_permanent_hw_address(): (wlan1): unable to read permanent MAC address (error 95)
Jan 26 10:25:32 werewolf NetworkManager[2894]: <info> (wlan1): driver supports SSID scans (scan_capa 0x01).

Why does it rename wlan0 -> wlan1 ?
I have no other wifi device on this box, I am testing on my desktop instead
of the laptop the device was inteded for use...

Then I tried:

werewolf:/etc# iw info
nl80211 not found.
werewolf:/etc# iw list
nl80211 not found.

Looks like a module is missing....

This is kernel 2.6.37.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
