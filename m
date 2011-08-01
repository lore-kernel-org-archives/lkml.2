Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1HAI1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:27:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60264 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1HAI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:27:05 -0400
MIME-Version: 1.0
Date: Mon, 1 Aug 2011 10:27:02 +0200
Message-ID: <CAC9WiBipw7i8eaOSYuWwXmed6ddQOgwFRbV0-cOiqHZcVt_-Tg@mail.gmail.com>
Subject: v3.0: WARNING: at fs/sysfs/dir.c:455 sysfs_add_one
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is triggering a couple of time on my laptop when plugging my
wireless ralink 2870 USB adapter or after resuming the system:

Aug  1 09:08:40 tsunami kernel: [18606.523463] Freezing remaining
freezable tasks ... (elapsed 0.01 seconds) done.
Aug  1 09:08:40 tsunami kernel: [18613.301110] Suspending console(s)
(use no_console_suspend to debug)
Aug  1 09:08:40 tsunami kernel: [18613.322450] Disabling non-boot CPUs ...
Aug  1 09:08:40 tsunami kernel: [18613.326533] Broke affinity for irq 12
Aug  1 09:08:40 tsunami kernel: [18613.326563] Broke affinity for irq 23
Aug  1 09:08:40 tsunami kernel: [18613.648409] usb usb1: root hub lost
power or was reset
Aug  1 09:08:40 tsunami kernel: [18613.652424] usb usb2: root hub lost
power or was reset
Aug  1 09:08:40 tsunami kernel: [18615.155053] rt2800usb 2-1.3:1.0: no
reset_resume for driver rt2800usb?
Aug  1 09:08:40 tsunami kernel: [18615.351794] Restarting tasks ... done.
Aug  1 10:12:50 tsunami kernel: [22466.153450] ------------[ cut here
]------------
Aug  1 10:12:50 tsunami kernel: [22466.153460] WARNING: at
fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
Aug  1 10:12:50 tsunami kernel: [22466.153463] Hardware name: Vostro 3500
Aug  1 10:12:50 tsunami kernel: [22466.153466] sysfs: cannot create
duplicate filename '/bus/usb/drivers/usb/2-1.3'
Aug  1 10:12:50 tsunami kernel: [22466.153469] Modules linked in:
zcache(PC) sit tunnel4 fuse af_packet ipv6 snd_hda_codec_hdmi
snd_hda_codec_idt arc4 brcmsmac(C) rt2800usb rt2800lib rt2x00usb r
t2x00lib brcmutil(C) uvcvideo mac80211 snd_hda_intel snd_hda_codec
snd_hwdep videodev snd_seq_dummy snd_seq_oss r8169 sg iTCO_wdt sr_mod
dell_laptop dcdbas media v4l2_compat_ioctl32 iTCO_vendor_
support mii snd_seq_midi_event intel_ips snd_seq snd_seq_device
snd_pcm_oss snd_pcm cfg80211 rfkill snd_timer snd_mixer_oss snd
soundcore snd_page_alloc mei(C) i2c_i801 crc_ccitt i915 drm_kms_he
lper drm i2c_algo_bit i2c_core coretemp binfmt_misc cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
nvram dell_wmi sparse_keymap dm_mod joydev evdev video b
attery wmi kvm_intel kvm ata_piix ahci libahci libata sd_mod scsi_mod
crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid
usbcore
Aug  1 10:12:50 tsunami kernel: [22466.153570] Pid: 54, comm: khubd
Tainted: P         C  3.0.0+-desktop #34
Aug  1 10:12:50 tsunami kernel: [22466.153573] Call Trace:
Aug  1 10:12:50 tsunami kernel: [22466.153582]  [<ffffffff8106197f>]
warn_slowpath_common+0x7f/0xc0
Aug  1 10:12:50 tsunami kernel: [22466.153587]  [<ffffffff81061a76>]
warn_slowpath_fmt+0x46/0x50
Aug  1 10:12:50 tsunami kernel: [22466.153592]  [<ffffffff811d0fc1>]
sysfs_add_one+0xc1/0xf0
Aug  1 10:12:50 tsunami kernel: [22466.153598]  [<ffffffff811d165b>]
sysfs_do_create_link+0x13b/0x210
Aug  1 10:12:50 tsunami kernel: [22466.153605]  [<ffffffff810897e5>] ?
__blocking_notifier_call_chain+0x65/0x80
Aug  1 10:12:50 tsunami kernel: [22466.153611]  [<ffffffff811d1763>]
sysfs_create_link+0x13/0x20
Aug  1 10:12:50 tsunami kernel: [22466.153616]  [<ffffffff813047c2>]
driver_sysfs_add+0x52/0xb0
Aug  1 10:12:50 tsunami kernel: [22466.153623]  [<ffffffff81304972>]
driver_probe_device+0x82/0x2c0
Aug  1 10:12:50 tsunami kernel: [22466.153629]  [<ffffffff81304bb0>] ?
driver_probe_device+0x2c0/0x2c0
Aug  1 10:12:50 tsunami kernel: [22466.153634]  [<ffffffff81304c03>]
__device_attach+0x53/0x60
Aug  1 10:12:50 tsunami kernel: [22466.153641]  [<ffffffff81303958>]
bus_for_each_drv+0x68/0x90
Aug  1 10:12:50 tsunami kernel: [22466.153646]  [<ffffffff81304e77>]
device_attach+0xa7/0xc0
Aug  1 10:12:50 tsunami kernel: [22466.153651]  [<ffffffff813036ed>]
bus_probe_device+0x2d/0x50
Aug  1 10:12:50 tsunami kernel: [22466.153657]  [<ffffffff813024e9>]
device_add+0x619/0x710
Aug  1 10:12:50 tsunami kernel: [22466.153679]  [<ffffffffa000c7b9>] ?
usb_cache_string+0x99/0xb0 [usbcore]
Aug  1 10:12:50 tsunami kernel: [22466.153713]  [<ffffffffa0002753>]
usb_new_device+0x173/0x240 [usbcore]
Aug  1 10:12:50 tsunami kernel: [22466.153734]  [<ffffffffa0005548>]
hub_thread+0xdb8/0x1780 [usbcore]
Aug  1 10:12:50 tsunami kernel: [22466.153743]  [<ffffffff81059ea3>] ?
perf_event_task_sched_out+0x33/0xa0
Aug  1 10:12:50 tsunami kernel: [22466.153752]  [<ffffffff81083db0>] ?
wake_up_bit+0x40/0x40
Aug  1 10:12:50 tsunami kernel: [22466.153772]  [<ffffffffa0004790>] ?
hub_disconnect+0x100/0x100 [usbcore]
Aug  1 10:12:50 tsunami kernel: [22466.153779]  [<ffffffff81083866>]
kthread+0x96/0xa0
Aug  1 10:12:50 tsunami kernel: [22466.153789]  [<ffffffff81436ca4>]
kernel_thread_helper+0x4/0x10
Aug  1 10:12:50 tsunami kernel: [22466.153797]  [<ffffffff810837d0>] ?
kthread_worker_fn+0x190/0x190
Aug  1 10:12:50 tsunami kernel: [22466.153804]  [<ffffffff81436ca0>] ?
gs_change+0x13/0x13
Aug  1 10:12:50 tsunami kernel: [22466.153809] ---[ end trace
ae985b8b8f50099d ]---
Aug  1 10:12:50 tsunami kernel: [22466.153828] usb: probe of 2-1.3
failed with error 0

Thanks
-- 
Francis
