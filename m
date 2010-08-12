Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0HLJL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:11:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0HLJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:11:54 -0400
Date: Thu, 12 Aug 2010 11:11:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Heinz Diehl <htd@fritha.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100810223215.GA1609@arch.tripp.de>
Message-ID: <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz>
References: <20100810210941.GA7938@fritha.org> <20100810223215.GA1609@arch.tripp.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010, Markus Trippelsdorf wrote:

> > I'm getting this in my logs with the latest -git7/8/9 kernels. Thw apcups
> > is not defective, it works flawlessly with 2.6.34.X.
> > 
> > Aug 10 23:01:44 liesel apcupsd[7687]: apcupsd FATAL ERROR in linux-usb.c
> > at line 609 Cannot find UPS device -- For a link to detailed USB trouble
> > shooting information, please see <http://www.apcupsd.com/support.html>.
> > Aug 10 23:01:44 liesel apcupsd[7687]: apcupsd error shutdown completed
> > Aug 10 23:04:40 liesel kernel: ------------[ cut here ]------------
> > 
> > Aug 10 23:04:40 liesel kernel: WARNING: at lib/kobject.c:595 kobject_put+0x2f/0x50()
> > Aug 10 23:04:40 liesel kernel: Hardware name: GA-MA770-UD3 Aug 10 23:04:40 liesel kernel: kobject: '(null)' (ffff88022c651898): is
> > not initialized, yet kobject_put() is being called. Aug 10 23:04:40 liesel kernel: Modules linked in: xt_pkttype ipt_LOG
> > xt_limit aes_x86_64 aes_generic af_packet it87 hwmon_vid binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative
> > cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table mperf xt_NOTRACK xt_state iptable_raw nf_conntrack_netbios_ns
> > nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip6_tables ipt_REJECT iptable_filter ip_tables tcp_vegas uhci_hcd rt73usb rt2x00usb rt2x00lib
> > r8169 led_class mii mac80211 snd_hda_codec_realtek ppdev parport_pc cfg80211 parport snd_hda_intel snd_hda_codec snd_pcm snd_timer snd
> > soundcore sr_mod k10temp hwmon i2c_piix4 pcspkr cdrom button rfkill joydev snd_page_alloc i2c_core sg xts usbhid sd_mod ohci_hcd ehci_hcd rtc_cmos
> > rtc_core pata_atiixp rtc_lib usbcore ahci libahci hmac dm_snapshot dm_crypt dm_mod gf128mul sha512_generic sha256_generic twofish_x86_64
> > twofish_common serpent cbc tgr192 loop ecb arc4 fuse edd ide_pci_generic amd74xx ide_core fan pata_amd sata_nv libata scsi
> > Aug 10 23:04:40 liesel kernel: Pid: 1115, comm: khubd Not tainted 2.6.35-git9 #1
> > Aug 10 23:04:40 liesel kernel: Call Trace:
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff810414f1>] ? warn_slowpath_common+0x81/0xe0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff81041605>] ? warn_slowpath_fmt+0x45/0x50
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa00bea3e>] ? usbhid_disconnect+0x1e/0x40 [usbhid]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a7525>] ? usb_unbind_interface+0xc5/0x120 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8133ffc8>] ? __device_release_driver+0x78/0xf0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff81340125>] ? device_release_driver+0x25/0x40
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8133f4a2>] ? bus_remove_device+0xa2/0xf0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8133d7da>] ? device_del+0x12a/0x1d0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a4b8d>] ? usb_disable_device+0x8d/0x110 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa019f6bb>] ? usb_disconnect+0x7b/0x120 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a03c2>] ? hub_thread+0x322/0x11d0 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff81034a77>] ? set_next_entity+0x37/0x80
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8105c330>] ? autoremove_wake_function+0x0/0x30
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a00a0>] ? hub_thread+0x0/0x11d0 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a00a0>] ? hub_thread+0x0/0x11d0 [usbcore]
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8105be56>] ? kthread+0x96/0xb0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff81003b14>] ? kernel_thread_helper+0x4/0x10
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff8105bdc0>] ? kthread+0x0/0xb0
> > Aug 10 23:04:40 liesel kernel:  [<ffffffff81003b10>] ? kernel_thread_helper+0x0/0x10
> > Aug 10 23:04:40 liesel kernel: ---[ end trace 808e80ff1e6d651e ]---
> 
> I'm seeing something similar today:
> 
> hub 3-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
> usb 3-1: USB disconnect, address 2
> ------------[ cut here ]------------
> WARNING: at lib/kobject.c:595 kobject_put+0x37/0x4b()
> Hardware name: System Product Name
> kobject: '(null)' (ffff88011e9cd898): is not initialized, yet kobject_put() is being called.
> Pid: 310, comm: khubd Not tainted 2.6.35-06113-gf6cec0a-dirty #4
> Call Trace:
>  [<ffffffff8105e7f7>] warn_slowpath_common+0x80/0x98
>  [<ffffffff8105e8a2>] warn_slowpath_fmt+0x46/0x48
>  [<ffffffff8118fbad>] kobject_put+0x37/0x4b
>  [<ffffffff812aa88d>] put_device+0x17/0x19
>  [<ffffffff8132fef1>] hid_destroy_device+0x41/0x45
>  [<ffffffff81335e5f>] usbhid_disconnect+0x3e/0x4b
>  [<ffffffff812fbd0d>] usb_unbind_interface+0x4c/0xd3
>  [<ffffffff812ad746>] __device_release_driver+0x6c/0xb5
>  [<ffffffff812adc33>] device_release_driver+0x23/0x30
>  [<ffffffff812ace3b>] bus_remove_device+0x89/0x99
>  [<ffffffff812aaec6>] device_del+0x12d/0x17f
>  [<ffffffff812facc4>] usb_disable_device+0x86/0xfd
>  [<ffffffff812f446a>] usb_disconnect+0x8e/0xf6
>  [<ffffffff812f62fd>] hub_thread+0x3eb/0xcb5
>  [<ffffffff8140170b>] ? _raw_spin_unlock_irq+0x16/0x31
>  [<ffffffff81077ea3>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff812f5f12>] ? hub_thread+0x0/0xcb5
>  [<ffffffff8107750e>] kthread+0x82/0x8a
>  [<ffffffff8102f794>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8107748c>] ? kthread+0x0/0x8a
>  [<ffffffff8102f790>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 5707e7a0642da347 ]---
> ------------[ cut here ]------------
> WARNING: at lib/kobject.c:595 kobject_put+0x37/0x4b()
> Hardware name: System Product Name
> kobject: '(null)' (ffff88011e9fd898): is not initialized, yet kobject_put() is being called.
> Pid: 310, comm: khubd Tainted: G        W   2.6.35-06113-gf6cec0a-dirty #4
> Call Trace:
>  [<ffffffff8105e7f7>] warn_slowpath_common+0x80/0x98
>  [<ffffffff8105e8a2>] warn_slowpath_fmt+0x46/0x48
>  [<ffffffff8118fbad>] kobject_put+0x37/0x4b
>  [<ffffffff812aa88d>] put_device+0x17/0x19
>  [<ffffffff8132fef1>] hid_destroy_device+0x41/0x45
>  [<ffffffff81335e5f>] usbhid_disconnect+0x3e/0x4b
>  [<ffffffff812fbd0d>] usb_unbind_interface+0x4c/0xd3
>  [<ffffffff812ad746>] __device_release_driver+0x6c/0xb5
>  [<ffffffff812adc33>] device_release_driver+0x23/0x30
>  [<ffffffff812ace3b>] bus_remove_device+0x89/0x99
>  [<ffffffff812aaec6>] device_del+0x12d/0x17f
>  [<ffffffff812facc4>] usb_disable_device+0x86/0xfd
>  [<ffffffff812f446a>] usb_disconnect+0x8e/0xf6
>  [<ffffffff812f62fd>] hub_thread+0x3eb/0xcb5
>  [<ffffffff8140170b>] ? _raw_spin_unlock_irq+0x16/0x31
>  [<ffffffff81077ea3>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff812f5f12>] ? hub_thread+0x0/0xcb5
>  [<ffffffff8107750e>] kthread+0x82/0x8a
>  [<ffffffff8102f794>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8107748c>] ? kthread+0x0/0x8a
>  [<ffffffff8102f790>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 5707e7a0642da348 ]---
> usb 3-1: new full speed USB device using ohci_hcd and address 3
> input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input6
> generic-usb 0003:046D:C52B.0006: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-1/input0
> input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.1/input/input7
> generic-usb 0003:046D:C52B.0007: input,hiddev0,hidraw5: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-1/input1
> generic-usb 0003:046D:C52B.0008: hiddev0,hidraw6: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-1/input2

Addin Alan Ott to CC, who has reported similar problem.

I am not able to reproduce the problem here with current Linus' tree 
(5af568cbd55f60b5). This is what I see in dmesg when I do two rounds of 
disconnect-connect with my random USB mouse

usb 3-2: USB disconnect, address 7
usb 3-2: new low speed USB device using uhci_hcd and address 8
usb 3-2: New USB device found, idVendor=05b8, idProduct=3091
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: USB mouse with wheel
usb 3-2: Manufacturer: mouse
input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input16
generic-usb 0003:05B8:3091.000C: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input17
generic-usb 0003:05B8:3091.000D: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1
usb 3-2: USB disconnect, address 8
usb 3-2: new low speed USB device using uhci_hcd and address 9
usb 3-2: New USB device found, idVendor=05b8, idProduct=3091
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: USB mouse with wheel
usb 3-2: Manufacturer: mouse
input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input18
generic-usb 0003:05B8:3091.000E: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input19
generic-usb 0003:05B8:3091.000F: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1

I.e. now BUG from kobject refcounting, and hidraw numbers are stable as 
well.

Guys, could you please send me your .config with which you are 
experiencing the problem, so that I can try to reproduce it with it?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
