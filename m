Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0I3Sdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:33:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47046 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750998Ab0I3Sdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:33:39 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+uLmBclJyu3g5kMd/SDurNiLyWYc3Y8hR4/MNyD3
	4RJEH9u9eP8reo
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.35.5->6 : i915 regression halts my system
Date: Thu, 30 Sep 2010 20:33:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.5; KDE/4.4.5; i686; ; )
Cc: dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009302033.35280.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 2nd time in a row vanilla kernel 2.6.35.6 hangs my system (ThinkPad T400 + GM45 graphic)
with these messages within syslog (2.6.35.5 didn't showed that issue),
furtunately at least SysRq keys were working:

...
2010-09-30T20:23:39.245+02:00 n22 kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
2010-09-30T20:23:39.245+02:00 n22 kernel: [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 19850 at 19849)
2010-09-30T20:23:39.356+02:00 n22 kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
2010-09-30T20:23:39.356+02:00 n22 kernel: [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 19851 at 19849)
2010-09-30T20:23:39.467+02:00 n22 kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
...
2010-09-30T20:24:25.064+02:00 n22 kernel: ata1: hard resetting link
2010-09-30T20:24:25.373+02:00 n22 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
2010-09-30T20:24:25.374+02:00 n22 kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
2010-09-30T20:24:25.374+02:00 n22 kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
2010-09-30T20:24:25.375+02:00 n22 kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
2010-09-30T20:24:25.375+02:00 n22 kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
2010-09-30T20:24:25.379+02:00 n22 kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
2010-09-30T20:24:25.379+02:00 n22 kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
2010-09-30T20:24:25.379+02:00 n22 kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
2010-09-30T20:24:25.379+02:00 n22 kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
2010-09-30T20:24:25.380+02:00 n22 kernel: ata1.00: configured for UDMA/100
2010-09-30T20:24:25.382+02:00 n22 kernel: ata1.00: configured for UDMA/100
2010-09-30T20:24:25.382+02:00 n22 kernel: ata1: EH complete
2010-09-30T20:24:25.383+02:00 n22 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2010-09-30T20:24:25.671+02:00 n22 kernel: ------------[ cut here ]------------
2010-09-30T20:24:25.671+02:00 n22 kernel: kernel BUG at drivers/gpu/drm/i915/i915_gem.c:4198!
2010-09-30T20:24:25.671+02:00 n22 kernel: invalid opcode: 0000 [#1] SMP
2010-09-30T20:24:25.671+02:00 n22 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/enable
2010-09-30T20:24:25.671+02:00 n22 kernel: Modules linked in: krng eseqiv rng aes_generic xts gf128mul dm_crypt usb_storage loop tun pppoe pppox 
ppp_generic slhc rfcomm sco bnep l2cap crc16 hid_cherry usblp 8250_pnp bridge stp llc ipt_MASQUERADE ipt_REJECT xt_recent xt_tcpudp 
nf_conntrack_ftp xt_state xt_limit ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_owner xt_multiport 
ip_tables x_tables af_packet snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse dm_mod fbcon font bitblit 
softcursor acpi_cpufreq mperf arc4 ecb btusb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi bluetooth i915 usbhid hid iwlagn 
drm_kms_helper snd_hda_codec_conexant drm fb fbdev iwlcore snd_hda_intel ehci_hcd uhci_hcd usbcore i2c_algo_bit mac80211 snd_hda_codec 
snd_pcm cfg80211 thinkpad_acpi sr_mod cfbcopyarea 8250_pci hwmon 8250 snd_timer snd soundcore psmouse led_class cfbimgblt intel_agp agpgart 
i2c_i801 serial_core rfkill snd_page_alloc cfbfillrect wmi video nvram cdrom nls_base e1000e i2c_core battery processor ac button thermal output evdev 
[last unloaded: microcode]
2010-09-30T20:24:25.671+02:00 n22 kernel: 
2010-09-30T20:24:25.671+02:00 n22 kernel: Pid: 12171, comm: X Not tainted 2.6.35.6 #2 6474B84/6474B84
2010-09-30T20:24:25.671+02:00 n22 kernel: EIP: 0060:[<f8b5a753>] EFLAGS: 00213286 CPU: 1
2010-09-30T20:24:25.671+02:00 n22 kernel: EIP is at i915_gem_object_unpin+0xb3/0xc0 [i915]
2010-09-30T20:24:25.671+02:00 n22 kernel: EAX: f4bd7900 EBX: f6493000 ECX: 00025487 EDX: fffffff9
2010-09-30T20:24:25.673+02:00 n22 kernel: ESI: 00024000 EDI: f62be000 EBP: f5f4fd60 ESP: f5f4fd54
2010-09-30T20:24:25.673+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
2010-09-30T20:24:25.673+02:00 n22 kernel: Process X (pid: 12171, ti=f5f4e000 task=f72817d0 task.ti=f5f4e000)
2010-09-30T20:24:25.673+02:00 n22 kernel: Stack:
2010-09-30T20:24:25.673+02:00 n22 kernel: 00000001 00000003 f33e8220 f5f4fe00 f8b5eac1 f62be014 03308000 00000000
2010-09-30T20:24:25.673+02:00 n22 kernel: <0> c1126476 0000fdb8 c13f9394 00000000 c9db4eac c9db4eac 00000001 00000002
2010-09-30T20:24:25.673+02:00 n22 kernel: <0> 00000000 f62be014 f33e8220 00000000 f6493014 f62be000 00000002 00000003
2010-09-30T20:24:25.673+02:00 n22 kernel: Call Trace:
2010-09-30T20:24:25.673+02:00 n22 kernel: [<f8b5eac1>] ? i915_gem_do_execbuffer+0x791/0xfd0 [i915]
2010-09-30T20:24:25.673+02:00 n22 kernel: [<c1126476>] ? prio_tree_insert+0x1f6/0x240
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c12300d7>] ? kmemleak_alloc+0x27/0x50
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c109cddf>] ? __kmalloc+0xcf/0x110
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c112c628>] ? _copy_from_user+0x38/0x130
2010-09-30T20:24:25.674+02:00 n22 kernel: [<f8b5f377>] ? i915_gem_execbuffer2+0x77/0x1e0 [i915]
2010-09-30T20:24:25.674+02:00 n22 kernel: [<f89e608b>] ? drm_ioctl+0x1ab/0x430 [drm]
2010-09-30T20:24:25.674+02:00 n22 kernel: [<f8b5f300>] ? i915_gem_execbuffer2+0x0/0x1e0 [i915]
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c104d434>] ? sched_clock_local+0xb4/0x190
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c1127cc3>] ? rb_insert_color+0xd3/0x110
2010-09-30T20:24:25.674+02:00 n22 kernel: [<c10aefcd>] ? vfs_ioctl+0x2d/0xc0
2010-09-30T20:24:25.674+02:00 n22 kernel: [<f89e5ee0>] ? drm_ioctl+0x0/0x430 [drm]
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c10af1aa>] ? do_vfs_ioctl+0x6a/0x590
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c102d513>] ? finish_task_switch+0x33/0xa0
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c123c4f1>] ? schedule+0x211/0x780
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c10508cb>] ? ktime_get_ts+0xdb/0x110
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c10af709>] ? sys_ioctl+0x39/0x60
2010-09-30T20:24:25.675+02:00 n22 kernel: [<c1002d97>] ? sysenter_do_call+0x12/0x26
2010-09-30T20:24:25.675+02:00 n22 kernel: Code: d1 8b 50 5c 8b 70 58 8d 48 58 89 56 04 89 32 8b 97 00 10 00 00 89 8f 00 10 00 00 81 c7 fc 0f 00 
00 89 50 5c 89 78 58 89 0a eb a7 <0f> 0b eb fe 0f 0b eb fe 90 8d 74 26 00 55 89 e5 83 ec 08 89 1c
2010-09-30T20:24:25.675+02:00 n22 kernel: EIP: [<f8b5a753>] i915_gem_object_unpin+0xb3/0xc0 [i915] SS:ESP 0068:f5f4fd54
2010-09-30T20:24:25.675+02:00 n22 kernel: ---[ end trace aae3dbe5a3fcb9bf ]---
2010-09-30T20:24:32.000+02:00 n22 kerneloops: Submitted 1 kernel oopses to www.kerneloops.org
2010-09-30T20:24:46.201+02:00 n22 kernel: SysRq : Emergency Sync
2010-09-30T20:24:46.206+02:00 n22 kernel: Emergency Sync complete
2010-09-30T20:24:46.889+02:00 n22 kernel: SysRq : Emergency Remount R/O


-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

