Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1FGDhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:37:21 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:33553 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1FGDhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=jeffunit.com; h=message-id:date
	:from:mime-version:to:subject:content-type:
	content-transfer-encoding; q=dns; s=jeffunit.com; b=wR7TAoeB88XO
	9sNpTISIF2YtEe0oHBYw78pkScAHxqg/TgxwLi4GI4n30tWmDp8BQuvkGgV1Lt/d
	wIDqB+hNKlZ0vC2YFPorQUOPCttKSS+khcDhAxHenNLT7slR98shf8Q5ka6k6b4b
	xymF5Ut8vRZTe83+EOazeKz2yNzM7y4=
Message-ID: <4DED9CB7.3090906@jeffunit.com>
Date: Mon, 06 Jun 2011 20:36:23 -0700
From: jeff <jeff@jeffunit.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: oops with flaky usb hard drive - 2.6.38
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running mageia which is using the 2.6.38 32 bit kernel.
I have an external usb hard drive which is a bit flakey, and has one
ext4 partition for the entire drive.

Using the 2.6.33 32 bit kernel with mandriva 2010.2, the hard drive
would just go offline, and
I could umount it then mount it.

With the 2.6.38 kernel from mageia, I get an oops.

Enclosed is the syslog output showing 3 oops messages, with the text
around the time of the problem.

jeff



Jun  5 09:51:35 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 09:51:50 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:52:05 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:52:06 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 09:52:21 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:52:36 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:52:36 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 09:52:41 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 09:52:46 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 09:52:46 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 09:52:51 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 09:52:56 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 09:52:57 localhost kernel: usb 6-3: USB disconnect, address 2
Jun  5 09:52:57 localhost kernel: sd 2:0:0:0: Device offlined - not
ready after error recovery
Jun  5 09:52:57 localhost kernel: sd 2:0:0:0: [sdb] Unhandled error code
Jun  5 09:52:57 localhost kernel: sd 2:0:0:0: [sdb]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  5 09:52:57 localhost kernel: sd 2:0:0:0: [sdb] CDB: Read(10): 28 00
09 22 86 6f 00 00 20 00
Jun  5 09:52:57 localhost kernel: end_request: I/O error, dev sdb,
sector 153257583
Jun  5 09:52:57 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 3
Jun  5 09:52:57 localhost halevt: Running: halevt-umount -u
/org/freedesktop/Hal/devices/volume_uuid_85403341_48d8_413b_96f5_88482539b799;
halevt-umount -s
Jun  5 09:53:03 localhost kernel: Aborting journal on device sdb1-8.
Jun  5 09:53:03 localhost kernel: BUG: unable to handle kernel paging
request at 2e8d2000
Jun  5 09:53:03 localhost kernel: IP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0
Jun  5 09:53:03 localhost kernel: *pde = 00000000
Jun  5 09:53:03 localhost kernel: Oops: 0000 [#1] SMP
Jun  5 09:53:03 localhost kernel: last sysfs file:
/sys/devices/virtual/thermal/thermal_zone0/temp
Jun  5 09:53:03 localhost kernel: Modules linked in: sit tunnel4
ipt_IFWLOG xt_state ipt_LOG xt_time xt_connlimit xt_helper xt_realm
xt_NFQUEUE xt_tcpmss xt_tcpudp ipt_addrtype xt_pkttype xt_set
ip_set_hash_ip ip_set nfnetlink iptable_raw xt_TPROXY nf_tproxy_core
ip6_tables nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment
ipt_REJECT xt_length xt_connmark xt_owner xt_recent xt_iprange
xt_physdev xt_policy xt_multiport iptable_mangle iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
iptable_filter ip_tables x_tables nfsd exportfs nfs lockd fscache
nfs_acl auth_rpcgss sunrpc af_packet ipv6 binfmt_misc loop fuse
dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
nvram uas usb_storage snd_maestro3 snd_ac97_codec ac97_bus snd_seq_dummy
snd_seq_oss snd_seq_midi_event firewire_ohci firewire_core crc_itu_t
snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer pcmcia
snd_page_alloc snd_mixer_oss snd yenta_socket pcm
Jun  5 09:53:03 localhost kernel: cia_rsrc ppdev e100 parport_pc mii
soundcore pcmcia_core parport irda crc_ccitt floppy rng_core shpchp
processor sg joydev sr_mod iTCO_wdt container evdev thermal button
pci_hotplug battery ac iTCO_vendor_support fan serio_raw ide_pci_generic
pata_acpi ata_generic piix ide_gd_mod ide_core ahci libahci ata_piix
libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd
ehci_hcd usbhid hid usbcore radeon ttm drm_kms_helper drm i2c_algo_bit
i2c_core [last unloaded: scsi_wait_scan]
Jun  5 09:53:03 localhost kernel:
Jun  5 09:53:03 localhost kernel: Pid: 1049, comm: jbd2/sdb1-8 Not
tainted 2.6.38.7-desktop-1.mga #1 Compaq Evo
N600c                           /0744
Jun  5 09:53:03 localhost kernel: EIP: 0060:[<c02d7254>] EFLAGS:
00010096 CPU: 0
Jun  5 09:53:03 localhost kernel: EIP is at __percpu_counter_add+0x14/0xa0
Jun  5 09:53:03 localhost kernel: EAX: 00000000 EBX: ee3f2e48 ECX:
00000000 EDX: 00000001
Jun  5 09:53:03 localhost kernel: ESI: efa38260 EDI: 00000000 EBP:
ee349e60 ESP: ee349e48
Jun  5 09:53:03 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068
Jun  5 09:53:03 localhost kernel: Process jbd2/sdb1-8 (pid: 1049,
ti=ee348000 task=ee720000 task.ti=ee348000)
Jun  5 09:53:03 localhost kernel: Stack:
Jun  5 09:53:03 localhost kernel: 00000003 eebaa948 efa38260 ee720000
efa38260 00000000 ee349e74 c01d61d8
Jun  5 09:53:03 localhost kernel: 00000008 eebaa948 efa38260 ee349e88
c023d4d8 e7c3fe00 e7813000 e7c3fe00
Jun  5 09:53:03 localhost kernel: ee349e94 c023d5aa ee61bc00 ee349eb8
f09f10a9 f09f3f34 ee349eb0 00000001
Jun  5 09:53:03 localhost kernel: Call Trace:
Jun  5 09:53:03 localhost kernel: [<c01d61d8>]
account_page_dirtied+0x68/0x90
Jun  5 09:53:03 localhost kernel: [<c023d4d8>] __set_page_dirty+0x38/0xb0
Jun  5 09:53:03 localhost kernel: [<c023d5aa>] mark_buffer_dirty+0x5a/0x90
Jun  5 09:53:03 localhost kernel: [<f09f10a9>]
jbd2_journal_update_superblock+0x79/0x120 [jbd2]
Jun  5 09:53:03 localhost kernel: [<f09f193c>]
__journal_abort_soft+0x4c/0x60 [jbd2]
Jun  5 09:53:03 localhost kernel: [<f09f195d>]
jbd2_journal_abort+0xd/0x10 [jbd2]
Jun  5 09:53:03 localhost kernel: [<f09ec0f1>]
jbd2_journal_commit_transaction+0xeb1/0x1050 [jbd2]
Jun  5 09:53:03 localhost kernel: [<c0158ac7>] ?
try_to_del_timer_sync+0x67/0xb0
Jun  5 09:53:03 localhost kernel: [<f09efd24>] kjournald2+0x94/0x1d0 [jbd2]
Jun  5 09:53:03 localhost kernel: [<c0168080>] ?
autoremove_wake_function+0x0/0x50
Jun  5 09:53:03 localhost kernel: [<f09efc90>] ? kjournald2+0x0/0x1d0 [jbd2]
Jun  5 09:53:03 localhost kernel: [<c0167b24>] kthread+0x74/0x80
Jun  5 09:53:03 localhost kernel: [<c0167ab0>] ? kthread+0x0/0x80
Jun  5 09:53:03 localhost kernel: [<c01040be>] kernel_thread_helper+0x6/0x10
Jun  5 09:53:03 localhost kernel: Code: 10 24 a5 68 c0 e8 cd 95 19 00 31
d2 89 d0 5b 5e 5d c3 90 8d 74 26 00 55 89 e5 83 ec 18 89 5d f4 89 c3 89
7d fc 89 75 f8 8b 40 14 <64> 8b 30 89 f7 c1 ff 1f 01 d6 8b 55 08 11 cf
89 d1 c1 f9 1f 39
Jun  5 09:53:03 localhost kernel: EIP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0 SS:ESP 0068:ee349e48
Jun  5 09:53:03 localhost kernel: CR2: 000000002e8d2000
Jun  5 09:53:03 localhost kernel: ---[ end trace 48131aec4cb6614d ]---
Jun  5 09:53:12 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:53:27 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 09:53:27 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 4



Jun  5 13:35:43 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 13:35:58 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:36:13 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:36:14 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 13:36:29 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:36:44 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:36:44 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 13:36:49 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:36:54 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:36:54 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 13:36:59 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:37:05 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:37:05 localhost kernel: usb 6-3: USB disconnect, address 2
Jun  5 13:37:05 localhost kernel: sd 2:0:0:0: Device offlined - not
ready after error recovery
Jun  5 13:37:05 localhost kernel: sd 2:0:0:0: [sdb] Unhandled error code
Jun  5 13:37:05 localhost kernel: sd 2:0:0:0: [sdb]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  5 13:37:05 localhost kernel: sd 2:0:0:0: [sdb] CDB: Read(10): 28 00
0d 6c 30 57 00 00 28 00
Jun  5 13:37:05 localhost kernel: end_request: I/O error, dev sdb,
sector 225194071
Jun  5 13:37:05 localhost halevt: Running: halevt-umount -u
/org/freedesktop/Hal/devices/volume_uuid_85403341_48d8_413b_96f5_88482539b799;
halevt-umount -s
Jun  5 13:37:05 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 3
Jun  5 13:37:11 localhost kernel: BUG: unable to handle kernel paging
request at 2e8d2000
Jun  5 13:37:11 localhost kernel: IP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0
Jun  5 13:37:11 localhost kernel: *pde = 00000000
Jun  5 13:37:11 localhost kernel: Oops: 0000 [#1] SMP
Jun  5 13:37:11 localhost kernel: last sysfs file:
/sys/devices/virtual/thermal/thermal_zone0/temp
Jun  5 13:37:11 localhost kernel: Modules linked in: sit tunnel4
ipt_IFWLOG xt_state ipt_LOG xt_time xt_connlimit xt_helper xt_realm
xt_NFQUEUE xt_tcpmss xt_tcpudp ipt_addrtype xt_pkttype xt_set
ip_set_hash_ip ip_set nfnetlink iptable_raw xt_TPROXY nf_tproxy_core
ip6_tables nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment
ipt_REJECT xt_length xt_connmark xt_owner xt_recent xt_iprange
xt_physdev xt_policy xt_multiport iptable_mangle iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
iptable_filter ip_tables x_tables nfsd exportfs nfs lockd fscache
nfs_acl auth_rpcgss sunrpc af_packet ipv6 binfmt_misc loop fuse
dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
nvram firewire_ohci uas firewire_core usb_storage crc_itu_t snd_maestro3
snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_seq_device snd_pcm_oss pcmcia snd_pcm ppdev parport_pc
yenta_socket snd_timer e100 snd_page_alloc
Jun  5 13:37:11 localhost kernel: pcmcia_rsrc parport snd_mixer_oss
pcmcia_core mii irda snd soundcore floppy crc_ccitt rng_core iTCO_wdt
shpchp iTCO_vendor_support sg sr_mod joydev processor pci_hotplug evdev
thermal battery container fan serio_raw button ac ide_pci_generic
pata_acpi ata_generic piix ide_gd_mod ide_core ahci libahci ata_piix
libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd
ehci_hcd usbhid hid usbcore radeon ttm drm_kms_helper drm i2c_algo_bit
i2c_core [last unloaded: scsi_wait_scan]
Jun  5 13:37:11 localhost kernel:
Jun  5 13:37:11 localhost kernel: Pid: 1062, comm: jbd2/sdb1-8 Not
tainted 2.6.38.7-desktop-1.mga #1 Compaq Evo
N600c                           /0744
Jun  5 13:37:11 localhost kernel: EIP: 0060:[<c02d7254>] EFLAGS:
00010086 CPU: 0
Jun  5 13:37:11 localhost kernel: EIP is at __percpu_counter_add+0x14/0xa0
Jun  5 13:37:11 localhost kernel: EAX: 00000000 EBX: ee3f2e48 ECX:
00000000 EDX: 00000001
Jun  5 13:37:11 localhost kernel: ESI: ef9d0280 EDI: 00000000 EBP:
ee4e5e78 ESP: ee4e5e60
Jun  5 13:37:11 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068
Jun  5 13:37:11 localhost kernel: Process jbd2/sdb1-8 (pid: 1062,
ti=ee4e4000 task=ee520c90 task.ti=ee4e4000)
Jun  5 13:37:11 localhost kernel: Stack:
Jun  5 13:37:11 localhost kernel: ef006540 e547c948 ef9d0280 ee520c90
ef9d0280 00000000 ee4e5e8c c01d61d8
Jun  5 13:37:11 localhost kernel: 00000008 e547c948 ef9d0280 ee4e5ea0
c023d4d8 e5503dc8 e4414000 e5503dc8
Jun  5 13:37:11 localhost kernel: ee4e5eac c023d5aa ee4c9000 ee4e5ed0
f09f10a9 00000001 2e5f3130 00000001
Jun  5 13:37:11 localhost kernel: Call Trace:
Jun  5 13:37:11 localhost kernel: [<c01d61d8>]
account_page_dirtied+0x68/0x90
Jun  5 13:37:11 localhost kernel: [<c023d4d8>] __set_page_dirty+0x38/0xb0
Jun  5 13:37:11 localhost kernel: [<c023d5aa>] mark_buffer_dirty+0x5a/0x90
Jun  5 13:37:11 localhost kernel: [<f09f10a9>]
jbd2_journal_update_superblock+0x79/0x120 [jbd2]
Jun  5 13:37:11 localhost kernel: [<f09ec112>]
jbd2_journal_commit_transaction+0xed2/0x1050 [jbd2]
Jun  5 13:37:11 localhost kernel: [<c014508f>] ? try_to_wake_up+0x21f/0x3e0
Jun  5 13:37:11 localhost kernel: [<c01680a0>] ?
autoremove_wake_function+0x20/0x50
Jun  5 13:37:11 localhost kernel: [<c0157a9b>] ?
lock_timer_base.clone.21+0x2b/0x50
Jun  5 13:37:11 localhost kernel: [<c0158ac7>] ?
try_to_del_timer_sync+0x67/0xb0
Jun  5 13:37:11 localhost kernel: [<f09efd24>] kjournald2+0x94/0x1d0 [jbd2]
Jun  5 13:37:11 localhost kernel: [<c0168080>] ?
autoremove_wake_function+0x0/0x50
Jun  5 13:37:11 localhost kernel: [<f09efc90>] ? kjournald2+0x0/0x1d0 [jbd2]
Jun  5 13:37:11 localhost kernel: [<c0167b24>] kthread+0x74/0x80
Jun  5 13:37:11 localhost kernel: [<c0167ab0>] ? kthread+0x0/0x80
Jun  5 13:37:11 localhost kernel: [<c01040be>] kernel_thread_helper+0x6/0x10
Jun  5 13:37:11 localhost kernel: Code: 10 24 a5 68 c0 e8 cd 95 19 00 31
d2 89 d0 5b 5e 5d c3 90 8d 74 26 00 55 89 e5 83 ec 18 89 5d f4 89 c3 89
7d fc 89 75 f8 8b 40 14 <64> 8b 30 89 f7 c1 ff 1f 01 d6 8b 55 08 11 cf
89 d1 c1 f9 1f 39
Jun  5 13:37:11 localhost kernel: EIP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0 SS:ESP 0068:ee4e5e60
Jun  5 13:37:11 localhost kernel: CR2: 000000002e8d2000
Jun  5 13:37:11 localhost kernel: ---[ end trace 19d4db19d5295630 ]---
Jun  5 13:37:20 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:37:35 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:37:35 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 4
Jun  5 13:37:50 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:38:06 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 13:38:06 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 5
Jun  5 13:38:11 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:38:16 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:38:16 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 6
Jun  5 13:38:21 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:38:26 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 13:38:26 localhost kernel: hub 6-0:1.0: unable to enumerate USB
device on port 3
Jun  5 13:38:27 localhost kernel: usb 4-2: new full speed USB device
using ohci_hcd and address 2
Jun  5 13:38:37 localhost kernel: hub 4-0:1.0: unable to enumerate USB
device on port 2
Jun  5 13:38:51 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 7
Jun  5 13:38:51 localhost kernel: usb 6-3: New USB device found,
idVendor=059b, idProduct=0472
Jun  5 13:38:51 localhost kernel: usb 6-3: New USB device strings:
Mfr=1, Product=2, SerialNumber=3
Jun  5 13:38:51 localhost kernel: usb 6-3: Product: Iomega eGo USB/FW400
Portable HDD
Jun  5 13:38:51 localhost kernel: usb 6-3: Manufacturer: Iomega
Jun  5 13:38:51 localhost kernel: usb 6-3: SerialNumber: 000000562002
Jun  5 13:38:51 localhost kernel: scsi3 : usb-storage 6-3:1.0
Jun  5 13:38:52 localhost kernel: scsi 3:0:0:0: Direct-Access     Ext
Hard  Disk                 PQ: 0 ANSI: 4
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: Attached scsi generic sg2
type 0
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] 625142448 512-byte
logical blocks: (320 GB/298 GiB)
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Write Protect is off
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Mode Sense: 10 00 00 00
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Assuming drive
cache: write through
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Assuming drive
cache: write through
Jun  5 13:38:52 localhost kernel: sdc: detected capacity change from 0
to 320072933376
Jun  5 13:38:52 localhost kernel: sdc: sdc1
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Assuming drive
cache: write through
Jun  5 13:38:52 localhost kernel: sd 3:0:0:0: [sdc] Attached SCSI disk
Jun  5 13:38:53 localhost halevt: Running: halevt-mount -u
/org/freedesktop/Hal/devices/volume_uuid_85403341_48d8_413b_96f5_88482539b799
-o flush



Jun  5 17:11:41 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 17:11:56 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:12:11 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:12:12 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 17:12:27 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:12:42 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:12:42 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 17:12:47 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:12:52 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:12:52 localhost kernel: usb 6-3: reset high speed USB device
using ehci_hcd and address 2
Jun  5 17:12:57 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:13:02 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:13:03 localhost kernel: usb 6-3: USB disconnect, address 2
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: Device offlined - not
ready after error recovery
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb] Unhandled error code
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb] CDB: Read(10): 28 00
22 07 22 7f 00 00 f0 00
Jun  5 17:13:03 localhost kernel: end_request: I/O error, dev sdb,
sector 570892927
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb] Unhandled error code
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  5 17:13:03 localhost kernel: sd 2:0:0:0: [sdb] CDB: Read(10): 28 00
22 07 23 6f 00 00 10 00
Jun  5 17:13:03 localhost kernel: end_request: I/O error, dev sdb,
sector 570893167
Jun  5 17:13:03 localhost halevt: Running: halevt-umount -u
/org/freedesktop/Hal/devices/volume_uuid_85403341_48d8_413b_96f5_88482539b799;
halevt-umount -s
Jun  5 17:13:03 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 3
Jun  5 17:13:08 localhost kernel: Aborting journal on device sdb1-8.
Jun  5 17:13:08 localhost kernel: BUG: unable to handle kernel paging
request at 2e8d2000
Jun  5 17:13:08 localhost kernel: IP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0
Jun  5 17:13:08 localhost kernel: *pde = 00000000
Jun  5 17:13:08 localhost kernel: Oops: 0000 [#1] SMP
Jun  5 17:13:08 localhost kernel: last sysfs file:
/sys/devices/virtual/thermal/thermal_zone0/temp
Jun  5 17:13:08 localhost kernel: Modules linked in: ipt_IFWLOG xt_state
ipt_LOG xt_time xt_connlimit xt_helper xt_realm xt_NFQUEUE xt_tcpmss
xt_tcpudp ipt_addrtype xt_pkttype xt_set ip_set_hash_ip ip_set nfnetlink
iptable_raw xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_ipv6
xt_CLASSIFY xt_mark xt_hashlimit xt_comment ipt_REJECT xt_length
xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy
xt_multiport iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables
x_tables nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
af_packet ipv6 binfmt_misc loop fuse dm_mirror dm_region_hash dm_log
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave
acpi_cpufreq freq_table mperf nvram uas usb_storage snd_maestro3
snd_ac97_codec firewire_ohci ac97_bus firewire_core snd_seq_dummy
crc_itu_t snd_seq_oss snd_seq_midi_event snd_seq pcmcia snd_seq_device
snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss yenta_socket
snd ppdev parport_p
Jun  5 17:13:08 localhost kernel: c e100 parport pcmcia_rsrc floppy
soundcore mii pcmcia_core irda crc_ccitt rng_core processor shpchp
joydev iTCO_wdt battery thermal button sg container ac fan sr_mod evdev
iTCO_vendor_support pci_hotplug serio_raw ide_pci_generic pata_acpi
ata_generic piix ide_gd_mod ide_core ahci libahci ata_piix libata sd_mod
scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid
hid usbcore radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
unloaded: scsi_wait_scan]
Jun  5 17:13:08 localhost kernel:
Jun  5 17:13:08 localhost kernel: Pid: 1050, comm: jbd2/sdb1-8 Not
tainted 2.6.38.7-desktop-1.mga #1 Compaq Evo
N600c                           /0744
Jun  5 17:13:08 localhost kernel: EIP: 0060:[<c02d7254>] EFLAGS:
00010096 CPU: 0
Jun  5 17:13:08 localhost kernel: EIP is at __percpu_counter_add+0x14/0xa0
Jun  5 17:13:08 localhost kernel: EAX: 00000000 EBX: ee3f2e48 ECX:
00000000 EDX: 00000001
Jun  5 17:13:08 localhost kernel: ESI: ef9f1200 EDI: 00000000 EBP:
ea27de60 ESP: ea27de48
Jun  5 17:13:08 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068
Jun  5 17:13:08 localhost kernel: Process jbd2/sdb1-8 (pid: 1050,
ti=ea27c000 task=eedf8000 task.ti=ea27c000)
Jun  5 17:13:08 localhost kernel: Stack:
Jun  5 17:13:08 localhost kernel: 00000003 e5869948 ef9f1200 eedf8000
ef9f1200 00000000 ea27de74 c01d61d8
Jun  5 17:13:08 localhost kernel: 00000008 e5869948 ef9f1200 ea27de88
c023d4d8 e590a428 e5490000 e590a428
Jun  5 17:13:08 localhost kernel: ea27de94 c023d5aa ee725000 ea27deb8
f09f10a9 f09f3f34 ea27deb0 00000001
Jun  5 17:13:08 localhost kernel: Call Trace:
Jun  5 17:13:08 localhost kernel: [<c01d61d8>]
account_page_dirtied+0x68/0x90
Jun  5 17:13:08 localhost kernel: [<c023d4d8>] __set_page_dirty+0x38/0xb0
Jun  5 17:13:08 localhost kernel: [<c023d5aa>] mark_buffer_dirty+0x5a/0x90
Jun  5 17:13:08 localhost kernel: [<f09f10a9>]
jbd2_journal_update_superblock+0x79/0x120 [jbd2]
Jun  5 17:13:08 localhost kernel: [<f09f193c>]
__journal_abort_soft+0x4c/0x60 [jbd2]
Jun  5 17:13:08 localhost kernel: [<f09f195d>]
jbd2_journal_abort+0xd/0x10 [jbd2]
Jun  5 17:13:08 localhost kernel: [<f09ec0f1>]
jbd2_journal_commit_transaction+0xeb1/0x1050 [jbd2]
Jun  5 17:13:08 localhost kernel: [<c0158ac7>] ?
try_to_del_timer_sync+0x67/0xb0
Jun  5 17:13:08 localhost kernel: [<f09efd24>] kjournald2+0x94/0x1d0 [jbd2]
Jun  5 17:13:08 localhost kernel: [<c0168080>] ?
autoremove_wake_function+0x0/0x50
Jun  5 17:13:08 localhost kernel: [<f09efc90>] ? kjournald2+0x0/0x1d0 [jbd2]
Jun  5 17:13:08 localhost kernel: [<c0167b24>] kthread+0x74/0x80
Jun  5 17:13:08 localhost kernel: [<c0167ab0>] ? kthread+0x0/0x80
Jun  5 17:13:08 localhost kernel: [<c01040be>] kernel_thread_helper+0x6/0x10
Jun  5 17:13:08 localhost kernel: Code: 10 24 a5 68 c0 e8 cd 95 19 00 31
d2 89 d0 5b 5e 5d c3 90 8d 74 26 00 55 89 e5 83 ec 18 89 5d f4 89 c3 89
7d fc 89 75 f8 8b 40 14 <64> 8b 30 89 f7 c1 ff 1f 01 d6 8b 55 08 11 cf
89 d1 c1 f9 1f 39
Jun  5 17:13:08 localhost kernel: EIP: [<c02d7254>]
__percpu_counter_add+0x14/0xa0 SS:ESP 0068:ea27de48
Jun  5 17:13:08 localhost kernel: CR2: 000000002e8d2000
Jun  5 17:13:08 localhost kernel: ---[ end trace 0242805874d5ad49 ]---
Jun  5 17:13:18 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:13:33 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:13:33 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 4
Jun  5 17:13:48 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:14:03 localhost kernel: usb 6-3: device descriptor read/64,
error -110
Jun  5 17:14:04 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 5
Jun  5 17:14:09 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:14:14 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:14:14 localhost kernel: usb 6-3: new high speed USB device
using ehci_hcd and address 6
Jun  5 17:14:19 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:14:24 localhost kernel: usb 6-3: device descriptor read/8,
error -110
Jun  5 17:14:24 localhost kernel: hub 6-0:1.0: unable to enumerate USB
device on port 3
Jun  5 17:14:25 localhost kernel: usb 4-2: new full speed USB device
using ohci_hcd and address 2
Jun  5 17:14:40 localhost kernel: usb 4-2: device descriptor read/64,
error -110
Jun  5 17:14:55 localhost kernel: usb 4-2: device descriptor read/64,
error -110
Jun  5 17:14:55 localhost kernel: usb 4-2: new full speed USB device
using ohci_hcd and address 3
Jun  5 17:15:10 localhost kernel: usb 4-2: device descriptor read/64,
error -110
Jun  5 17:15:26 localhost kernel: usb 4-2: device descriptor read/64,
error -110
Jun  5 17:15:26 localhost kernel: usb 4-2: new full speed USB device
using ohci_hcd and address 4
Jun  5 17:15:31 localhost kernel: usb 4-2: device descriptor read/8,
error -110
Jun  5 17:15:36 localhost kernel: usb 4-2: device descriptor read/8,
error -110
Jun  5 17:15:36 localhost kernel: usb 4-2: new full speed USB device
using ohci_hcd and address 5
Jun  5 17:15:41 localhost kernel: usb 4-2: device descriptor read/8,
error -110
Jun  5 17:15:46 localhost kernel: usb 4-2: device descriptor read/8,
error -110
Jun  5 17:15:47 localhost kernel: hub 4-0:1.0: unable to enumerate USB
device on port 2



