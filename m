Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1L0SOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:14:25 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38834 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754662Ab1L0SOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:14:22 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/q+nkrC/zqeo7kS3UC/VXEQ4EoqSoVYYZkQ5POzc
	YLkq8wsYdz+yBO
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: kernel crashed after unplugging an (encrypted) USB stick
Date: Tue, 27 Dec 2011 19:14:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.6; KDE/4.7.3; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112271914.18564.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created an encrypted partition (LUKS), copied a file onto it,
closed that partition and unplugged the stick. The result with kernel 3.1.6 was:


2011-12-27T19:03:44.000+01:00 n22 dbus[2186]: [system] Rejected send message, 2 matched rules; type="error", sender=":1.14" (uid=0 pid=3706 
comm="/usr/libexec/udisks-daemon ") interface="(unset)" member="(unset)" error name="org.freedesktop.DBus.Error.UnknownMethod" 
requested_reply="0" destination=":1.86" (uid=1000 pid=19184 comm="kdeinit4: dolphin [kdeinit] --icon system-file-man")
2011-12-27T19:03:56.582+01:00 n22 kernel: usb 3-1: USB disconnect, device number 4
2011-12-27T19:03:56.681+01:00 n22 kernel: scsi 6:0:0:0: killing request
2011-12-27T19:03:56.681+01:00 n22 kernel: BUG: unable to handle kernel NULL pointer dereference at 00000004
2011-12-27T19:03:56.681+01:00 n22 kernel: IP: [<c12172e5>] sd_revalidate_disk+0x25/0x1d70
2011-12-27T19:03:56.681+01:00 n22 kernel: *pde = 00000000 
2011-12-27T19:03:56.681+01:00 n22 kernel: Oops: 0000 [#1] SMP 
2011-12-27T19:03:56.681+01:00 n22 kernel: Modules linked in: krng eseqiv rng xts gf128mul dm_crypt nls_iso8859_1 nls_cp437 vfat fat usb_storage 
cpufreq_stats loop rfcomm bnep ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_recent xt_tcpudp xt_mac nf_conntrack_ftp xt_state 
xt_limit ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic 
slhc bridge stp llc tun snd_seq snd_seq_device fuse dm_mod acpi_cpufreq mperf aes_generic fbcon font bitblit i915 softcursor drm_kms_helper usblp ecb 
drm btusb bluetooth snd_hda_codec_conexant snd_hda_intel cryptomgr fb hid_cherry crc16 usbhid hid sr_mod crypto_hash aead pcompress 
crypto_blkcipher snd_hda_codec cdrom arc4 sg fbdev snd_pcm i2c_algo_bit thinkpad_acpi crypto_algapi snd_timer cfbcopyarea intel_agp intel_gtt 
hwmon snd iwlagn agpgart uhci_hcd mac80211 cfg80211 psmouse 8250_pnp ehci_hcd 8250_pci rfkill usbcore 8250 soundcore i2c_i801 i2c_core 
cfbimgblt cfbfillrect serial_core nvram battery thermal video processor e1000e evdev wmi snd_page_alloc ac button [last unloaded: microcode]
2011-12-27T19:03:56.681+01:00 n22 kernel: 
2011-12-27T19:03:56.681+01:00 n22 kernel: Pid: 3714, comm: udisks-daemon Not tainted 3.1.6 #1 LENOVO 6474B84/6474B84
2011-12-27T19:03:56.681+01:00 n22 kernel: EIP: 0060:[<c12172e5>] EFLAGS: 00010246 CPU: 0
2011-12-27T19:03:56.681+01:00 n22 kernel: EIP is at sd_revalidate_disk+0x25/0x1d70
2011-12-27T19:03:56.681+01:00 n22 kernel: EAX: 00000000 EBX: f59a8c00 ECX: f59a8c00 EDX: 00000000
2011-12-27T19:03:56.681+01:00 n22 kernel: ESI: 00000000 EDI: 00000001 EBP: f53dbd3c ESP: f53dbcb0
2011-12-27T19:03:56.681+01:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
2011-12-27T19:03:56.681+01:00 n22 kernel: Process udisks-daemon (pid: 3714, ti=f53da000 task=f565c340 task.ti=f53da000)
2011-12-27T19:03:56.681+01:00 n22 kernel: Stack:
2011-12-27T19:03:56.681+01:00 n22 kernel: f501f000 f501f08c f53dbcd8 c118cc4d f53dbce0 c11008e0 c1117c60 f6831078
2011-12-27T19:03:56.681+01:00 n22 kernel: f602bc00 f59a8c3c f6831078 f602bc00 f53dbd00 c11015e5 f53dbd10 f59a8c3c
2011-12-27T19:03:56.681+01:00 n22 kernel: f59a8c00 f53dbd14 c118cc4d 00000001 f53dbd14 d38151c0 00000000 f53dbd24
2011-12-27T19:03:56.681+01:00 n22 kernel: Call Trace:
2011-12-27T19:03:56.681+01:00 n22 kernel: [<c118cc4d>] ? kobject_put+0x1d/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c11008e0>] ? find_inode+0x60/0xa0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1117c60>] ? I_BDEV+0x10/0x10
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c11015e5>] ? iget5_locked+0x75/0x180
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c118cc4d>] ? kobject_put+0x1d/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1101024>] ? iput+0x34/0x1a0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1118760>] ? bdput+0x10/0x20
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1138625>] rescan_partitions+0x95/0x530
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c118cc4d>] ? kobject_put+0x1d/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c12075e7>] ? scsi_device_put+0x47/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c12075d5>] ? scsi_device_put+0x35/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c111940e>] __blkdev_get+0x23e/0x360
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c111957b>] blkdev_get+0x4b/0x2c0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1119842>] blkdev_open+0x52/0x70
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10e97ee>] __dentry_open.clone.15+0xee/0x2d0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10f5f53>] ? do_lookup+0x43/0x380
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10ea994>] nameidata_to_filp+0x54/0x70
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c11197f0>] ? blkdev_get+0x2c0/0x2c0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10f7f6f>] do_last+0x1ef/0x7b0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10f8610>] path_openat+0xa0/0x330
2011-12-27T19:03:56.682+01:00 n22 kernel: [<f8227a5b>] ? sr_lock_door+0x1b/0x20 [sr_mod]
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c118cc4d>] ? kobject_put+0x1d/0x50
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10f89b5>] do_filp_open+0x35/0x80
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c119589a>] ? strncpy_from_user+0x3a/0x70
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c1102ecc>] ? alloc_fd+0x3c/0xf0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10eaaa0>] do_sys_open+0xf0/0x1c0
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c10eab9e>] sys_open+0x2e/0x40
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c12cee13>] sysenter_do_call+0x12/0x22
2011-12-27T19:03:56.682+01:00 n22 kernel: [<c12c0000>] ? pci_rescan_bus+0x50/0x90
2011-12-27T19:03:56.682+01:00 n22 kernel: Code: bc 27 00 00 00 00 55 89 e5 57 56 53 83 c4 80 3e 8d 74 26 00 89 45 b4 65 a1 14 00 00 00 89 45 f0 
31 c0 8b 55 b4 8b 92 e0 01 00 00 <8b> 4a 04 89 55 c0 8b 81 84 03 00 00 31 d2 89 4d b8 83 f8 04 0f 
2011-12-27T19:03:56.682+01:00 n22 kernel: EIP: [<c12172e5>] sd_revalidate_disk+0x25/0x1d70 SS:ESP 0068:f53dbcb0
2011-12-27T19:03:56.682+01:00 n22 kernel: CR2: 0000000000000004
2011-12-27T19:03:56.767+01:00 n22 kernel: ---[ end trace d4f46f8200bfe670 ]---
2011-12-27T19:05:01.000+01:00 n22 kerneloops: Submitted 1 kernel oopses to www.kerneloops.org
2011-12-27T19:05:01.000+01:00 n22 cron[19705]: (root) CMD (/usr/lib/sa/sa1 60 5 >/dev/null)
2011-12-27T19:05:10.715+01:00 n22 kernel: SysRq : Emergency Sync
2011-12-27T19:05:10.722+01:00 n22 kernel: Emergency Sync complete
2011-12-27T19:05:11.279+01:00 n22 kernel: SysRq : Emergency Remount R/O


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
