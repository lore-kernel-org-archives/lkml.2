Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1AVN5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:57:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35675 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1AVN5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:57:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=Qkr5MLZ5SCkGg1btbOHeo1B7wPgO3yvo1s9GHpi3r+BHHTjat6x64XKtgryNPKJvlq
         tUUigSjuBgG6doHXvzqg6rkmy0RtZA/Q5qB+wLcky1eC0PRU9H9oBgNJ71cOnessPTUx
         sYfMmLHaGB/xgV4rvG8MV61ieIxCY9omCuAHk=
Date: Sat, 22 Jan 2011 14:56:54 +0100
From: Davor Emard <davoremard@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: memory or swap related crash?
Message-ID: <20110122135653.GC9774@emard.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI

I experience probably memory related kernel crashes.
Seen on debians 2.6.32, and self-compiled 2.6.35.10 and 2.6.37.

Tyipically it heppens as corrupted page table 
with the most intensive memory bandwidth appilication,
more often in combination with raid1 resync.

I swap on a lvm volume inside of raid1.

Now I'm running without swap but havent't observed
the problem yet.

Tried booting to memtest, all tests pass and it can be 
left running for hours without any error.

sky2 0000:02:00.0: eth1: disabling interface
br0: port 2(veth2H9WWj) entering forwarding state
br0: port 1(eth0) entering forwarding state
skge 0000:05:02.0: eth0: disabling interface
device eth0 left promiscuous mode
br0: port 1(eth0) entering disabled state
br0: port 2(veth2H9WWj) entering disabled state
device eth0 entered promiscuous mode
skge 0000:05:02.0: eth0: enabling interface
skge 0000:05:02.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
br0: port 1(eth0) entering forwarding state
br0: port 1(eth0) entering forwarding state
br0: port 1(eth0) entering forwarding state
skge 0000:05:02.0: eth0: disabling interface
device eth0 left promiscuous mode
br0: port 1(eth0) entering disabled state
Adding 4194300k swap on /dev/mapper/emard320-swap0.  Priority:-1 extents:1 across:4194300k 
device eth0 entered promiscuous mode
skge 0000:05:02.0: eth0: enabling interface
skge 0000:05:02.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
br0: port 1(eth0) entering forwarding state
br0: port 1(eth0) entering forwarding state
md: md209: recovery done.
RAID1 conf printout:
 --- wd:3 rd:3
 disk 0, wo:0, o:1, dev:sdb9
 disk 1, wo:0, o:1, dev:sda9
 disk 2, wo:0, o:1, dev:sdc9
vdr-sxfe: Corrupted page table at address 7fe4c4f58000
PGD 7c610067 PUD 72359067 PMD 70d3d067 PTE ffffffff120d8067
Bad pagetable: 000f [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/coretemp.3/temp1_input
CPU 1 
Modules linked in: parport_pc sco bnep veth rfcomm l2cap bluetooth uinput cls_u32 sch_htb sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_hashlimit xt_comment xt_owner xt_recent xt_iprange xt_policy xt_multiport ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_mark xt_mac xt_limit xt_length xt_helper xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat iptable_mangle nfnetlink iptable_filter ip_tables x_tables fuse bridge stp llc aes_x86_64 aes_generic nf_conntrack_ftp coretemp hwmon parport tun kvm_intel kvm sbp2 qt1010 zl10353 saa7134_dvb videobuf_dvb snd_hda_codec_analog tuner_xc2028 tuner arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib rc_videomate_t750 led_class mac80211 snd_hda_intel stv0299 saa7134 snd_hda_codec cfg80211 v4l2_common ir_sony_decoder videodev ves1x93 ir_jvc_decoder ir_rc6_decoder rtc_cmos snd_pcm rtc_core v4l1_compat ir_rc5_decoder snd_seq v4l2_compat_ioctl32 videobuf_dma_sg budget pcspkr rtc_lib budget_core i2c_i801 snd_timer ir_nec_decoder saa7146 videobuf_core snd_seq_device ir_common ir_core ttpci_eeprom tveeprom snd dvb_core button processor snd_page_alloc usbhid hid firewire_ohci firewire_core sg sr_mod ohci1394 cdrom skge ieee1394 sky2 pata_marvell uhci_hcd thermal ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 22841, comm: vdr-sxfe Not tainted 2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4 P5Q3 DELUXE/P5Q3 DELUXE
RIP: 0033:[<00007fe4d611e211>]  [<00007fe4d611e211>] 0x7fe4d611e211
RSP: 002b:00007fe4ced4b8e0  EFLAGS: 00010212
RAX: 00000000006d3b60 RBX: 0000000000a1c040 RCX: 000000000122a1b0
RDX: 00007fe4c4f57ff0 RSI: 0000000001318cdc RDI: 0000000001740848
RBP: 0000000000002816 R08: 000000000122a1ac R09: 000000000122a370
R10: 00000000000002eb R11: 0000000000000f90 R12: 0000000000000012
R13: 0000000000000f90 R14: fffffffffffff070 R15: 0000000001af1920
FS:  00007fe4ced4c710(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe4c4f58000 CR3: 0000000071d97000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vdr-sxfe (pid: 22841, threadinfo ffff8800709aa000, task ffff8800710c2280)

RIP  [<00007fe4d611e211>] 0x7fe4d611e211
 RSP <00007fe4ced4b8e0>
---[ end trace f47060e664cbf334 ]---
BUG: Bad page map in process vdr-sxfe  pte:ffffffff120d8067 pmd:70d3d067
addr:00007fe4c4f58000 vm_flags:080000fb anon_vma:(null) mapping:ffff8800719b1860 index:260
vma->vm_ops->fault: shm_fault+0x0/0x1b
vma->vm_file->f_op->mmap: shm_mmap+0x0/0x5c
Pid: 22839, comm: vdr-sxfe Tainted: G      D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4
Call Trace:
 [<ffffffff81095031>] print_bad_pte+0x1d7/0x1f0
 [<ffffffff81095083>] vm_normal_page+0x39/0x52
 [<ffffffff810984ee>] unmap_vmas+0x32a/0x8d6
 [<ffffffff8109a99b>] exit_mmap+0xcf/0x17a
 [<ffffffff81036589>] mmput+0x28/0xce
 [<ffffffff8103a4b5>] exit_mm+0x113/0x120
 [<ffffffff8103bdb0>] do_exit+0x1f4/0x70e
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff8103c33c>] do_group_exit+0x72/0x9a
 [<ffffffff81046a06>] get_signal_to_deliver+0x37d/0x39f
 [<ffffffff810802d6>] ? perf_event_task_sched_out+0x26/0x30c
 [<ffffffff81001ea3>] do_signal+0x6d/0x673
 [<ffffffff81404a42>] ? _raw_spin_unlock_irq+0x11/0x2c
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff81053e97>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810024d0>] do_notify_resume+0x27/0x69
 [<ffffffff81002b4b>] int_signal+0x12/0x17
BUG: Bad page map in process vdr-sxfe  pte:ffffffffffffffff pmd:70d3d067
addr:00007fe4c4f59000 vm_flags:080000fb anon_vma:(null) mapping:ffff8800719b1860 index:261
vma->vm_ops->fault: shm_fault+0x0/0x1b
vma->vm_file->f_op->mmap: shm_mmap+0x0/0x5c
Pid: 22839, comm: vdr-sxfe Tainted: G    B D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4
Call Trace:
 [<ffffffff81095031>] print_bad_pte+0x1d7/0x1f0
 [<ffffffff81095083>] vm_normal_page+0x39/0x52
 [<ffffffff810984ee>] unmap_vmas+0x32a/0x8d6
 [<ffffffff8109a99b>] exit_mmap+0xcf/0x17a
 [<ffffffff81036589>] mmput+0x28/0xce
 [<ffffffff8103a4b5>] exit_mm+0x113/0x120
 [<ffffffff8103bdb0>] do_exit+0x1f4/0x70e
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff8103c33c>] do_group_exit+0x72/0x9a
 [<ffffffff81046a06>] get_signal_to_deliver+0x37d/0x39f
 [<ffffffff810802d6>] ? perf_event_task_sched_out+0x26/0x30c
 [<ffffffff81001ea3>] do_signal+0x6d/0x673
 [<ffffffff81404a42>] ? _raw_spin_unlock_irq+0x11/0x2c
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff81053e97>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810024d0>] do_notify_resume+0x27/0x69
 [<ffffffff81002b4b>] int_signal+0x12/0x17
BUG: Bad page map in process vdr-sxfe  pte:ffffffffffffffff pmd:70d3d067
addr:00007fe4c4f5a000 vm_flags:080000fb anon_vma:(null) mapping:ffff8800719b1860 index:262
vma->vm_ops->fault: shm_fault+0x0/0x1b
vma->vm_file->f_op->mmap: shm_mmap+0x0/0x5c
Pid: 22839, comm: vdr-sxfe Tainted: G    B D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4
Call Trace:
 [<ffffffff81095031>] print_bad_pte+0x1d7/0x1f0
 [<ffffffff81095083>] vm_normal_page+0x39/0x52
 [<ffffffff810984ee>] unmap_vmas+0x32a/0x8d6
 [<ffffffff8109a99b>] exit_mmap+0xcf/0x17a
 [<ffffffff81036589>] mmput+0x28/0xce
 [<ffffffff8103a4b5>] exit_mm+0x113/0x120
 [<ffffffff8103bdb0>] do_exit+0x1f4/0x70e
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff8103c33c>] do_group_exit+0x72/0x9a
 [<ffffffff81046a06>] get_signal_to_deliver+0x37d/0x39f
 [<ffffffff810802d6>] ? perf_event_task_sched_out+0x26/0x30c
 [<ffffffff81001ea3>] do_signal+0x6d/0x673
 [<ffffffff81404a42>] ? _raw_spin_unlock_irq+0x11/0x2c
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff81053e97>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810024d0>] do_notify_resume+0x27/0x69
 [<ffffffff81002b4b>] int_signal+0x12/0x17
BUG: Bad page map in process vdr-sxfe  pte:ffffffffffffffff pmd:70d3d067
addr:00007fe4c4f5b000 vm_flags:080000fb anon_vma:(null) mapping:ffff8800719b1860 index:263
vma->vm_ops->fault: shm_fault+0x0/0x1b
vma->vm_file->f_op->mmap: shm_mmap+0x0/0x5c
Pid: 22839, comm: vdr-sxfe Tainted: G    B D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4
Call Trace:
 [<ffffffff81095031>] print_bad_pte+0x1d7/0x1f0
 [<ffffffff81095083>] vm_normal_page+0x39/0x52
 [<ffffffff810984ee>] unmap_vmas+0x32a/0x8d6
 [<ffffffff8109a99b>] exit_mmap+0xcf/0x17a
 [<ffffffff81036589>] mmput+0x28/0xce
 [<ffffffff8103a4b5>] exit_mm+0x113/0x120
 [<ffffffff8103bdb0>] do_exit+0x1f4/0x70e
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff8103c33c>] do_group_exit+0x72/0x9a
 [<ffffffff81046a06>] get_signal_to_deliver+0x37d/0x39f
 [<ffffffff810802d6>] ? perf_event_task_sched_out+0x26/0x30c
 [<ffffffff81001ea3>] do_signal+0x6d/0x673
 [<ffffffff81404a42>] ? _raw_spin_unlock_irq+0x11/0x2c
 [<ffffffff8102eb08>] ? get_parent_ip+0x11/0x41
 [<ffffffff81053e97>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810024d0>] do_notify_resume+0x27/0x69
 [<ffffffff81002b4b>] int_signal+0x12/0x17
------------[ cut here ]------------
kernel BUG at mm/filemap.c:128!
invalid opcode: 0000 [#2] PREEMPT SMP 
last sysfs file: /sys/devices/platform/coretemp.3/temp1_input
CPU 2 
Modules linked in: parport_pc sco bnep veth rfcomm l2cap bluetooth uinput cls_u32 sch_htb sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_hashlimit xt_comment xt_owner xt_recent xt_iprange xt_policy xt_multiport ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_mark xt_mac xt_limit xt_length xt_helper xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat iptable_mangle nfnetlink iptable_filter ip_tables x_tables fuse bridge stp llc aes_x86_64 aes_generic nf_conntrack_ftp coretemp hwmon parport tun kvm_intel kvm sbp2 qt1010 zl10353 saa7134_dvb videobuf_dvb snd_hda_codec_analog tuner_xc2028 tuner arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib rc_videomate_t750 led_class mac80211 snd_hda_intel stv0299 saa7134 snd_hda_codec cfg80211 v4l2_common ir_sony_decoder videodev ves1x93 ir_jvc_decoder ir_rc6_decoder rtc_cmos snd_pcm rtc_core v4l1_compat ir_rc5_decoder snd_seq v4l2_compat_ioctl32 videobuf_dma_sg budget pcspkr rtc_lib budget_core i2c_i801 snd_timer ir_nec_decoder saa7146 videobuf_core snd_seq_device ir_common ir_core ttpci_eeprom tveeprom snd dvb_core button processor snd_page_alloc usbhid hid firewire_ohci firewire_core sg sr_mod ohci1394 cdrom skge ieee1394 sky2 pata_marvell uhci_hcd thermal ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 6034, comm: Xorg Tainted: G    B D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4 P5Q3 DELUXE/P5Q3 DELUXE
RIP: 0010:[<ffffffff81083097>]  [<ffffffff81083097>] __remove_from_page_cache+0x54/0xa5
RSP: 0018:ffff8800721dbc58  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffea00003f2f40 RCX: 000000000000000d
RDX: ffff880001914c38 RSI: 0000000000000016 RDI: ffffffff8165ccc0
RBP: ffff8800721dbc68 R08: ffff8800721dbc58 R09: 0000000000000260
R10: ffff88000e4dba80 R11: ffff8800721dbc68 R12: ffff8800719b1860
R13: ffff8800719b1860 R14: ffff8800721dbce8 R15: ffffffffffffffff
FS:  00007feb48d51700(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000068e138 CR3: 0000000070e74000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 6034, threadinfo ffff8800721da000, task ffff880071436080)
Stack:
 ffffea00003f2f40 ffff8800719b1878 ffff8800721dbc88 ffffffff81083113
<0> ffffea00003f2f40 ffff8800719b1860 ffff8800721dbca8 ffffffff8108a665
<0> 0000000000000000 0000000000000260 ffff8800721dbd98 ffffffff8108a743
Call Trace:
 [<ffffffff81083113>] remove_from_page_cache+0x2b/0x40
 [<ffffffff8108a665>] truncate_inode_page+0x6e/0x82
 [<ffffffff8108a743>] truncate_inode_pages_range+0xca/0x38e
 [<ffffffff8108aa14>] truncate_inode_pages+0xd/0xf
 [<ffffffff81090400>] shmem_delete_inode+0x2d/0xd3
 [<ffffffff810c4c88>] generic_delete_inode+0x8e/0x114
 [<ffffffff810c3db8>] iput+0x61/0x65
 [<ffffffff810c0f19>] dentry_iput+0xbd/0xd5
 [<ffffffff810c0f74>] d_kill+0x43/0x63
 [<ffffffff810c16d5>] dput+0x14c/0x159
 [<ffffffff810b289a>] fput+0x1ab/0x1d0
 [<ffffffff8109a8a4>] remove_vma+0x37/0x5f
 [<ffffffff8109b963>] do_munmap+0x2ff/0x321
 [<ffffffff8120ca94>] sys_shmdt+0x9b/0x12d
 [<ffffffff8100292b>] system_call_fastpath+0x16/0x1b
Code: 49 ff 4c 24 48 48 89 df e8 9a f2 00 00 48 8b 03 a9 00 00 10 00 74 0d be 16 00 00 00 48 89 df e8 83 f2 00 00 8b 43 0c 85 c0 78 04 <0f> 0b eb fe f6 03 10 74 43 49 8b 44 24 68 f6 40 30 01 75 38 48 
RIP  [<ffffffff81083097>] __remove_from_page_cache+0x54/0xa5
 RSP <ffff8800721dbc58>
---[ end trace f47060e664cbf335 ]---
note: Xorg[6034] exited with preempt_count 1
BUG: scheduling while atomic: Xorg/6034/0x00000002
Modules linked in: parport_pc sco bnep veth rfcomm l2cap bluetooth uinput cls_u32 sch_htb sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_hashlimit xt_comment xt_owner xt_recent xt_iprange xt_policy xt_multiport ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_mark xt_mac xt_limit xt_length xt_helper xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat iptable_mangle nfnetlink iptable_filter ip_tables x_tables fuse bridge stp llc aes_x86_64 aes_generic nf_conntrack_ftp coretemp hwmon parport tun kvm_intel kvm sbp2 qt1010 zl10353 saa7134_dvb videobuf_dvb snd_hda_codec_analog tuner_xc2028 tuner arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib rc_videomate_t750 led_class mac80211 snd_hda_intel stv0299 saa7134 snd_hda_codec cfg80211 v4l2_common ir_sony_decoder videodev ves1x93 ir_jvc_decoder ir_rc6_decoder rtc_cmos snd_pcm rtc_core v4l1_compat ir_rc5_decoder snd_seq v4l2_compat_ioctl32 videobuf_dma_sg budget pcspkr rtc_lib budget_core i2c_i801 snd_timer ir_nec_decoder saa7146 videobuf_core snd_seq_device ir_common ir_core ttpci_eeprom tveeprom snd dvb_core button processor snd_page_alloc usbhid hid firewire_ohci firewire_core sg sr_mod ohci1394 cdrom skge ieee1394 sky2 pata_marvell uhci_hcd thermal ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 6034, comm: Xorg Tainted: G    B D     2.6.35.10-amd64-asus-p5q3-deluxe-wifi #4
Call Trace:
 [<ffffffff8102eb8f>] __schedule_bug+0x57/0x5b
 [<ffffffff8140228d>] schedule+0xd4/0x7da
 [<ffffffff8140482e>] rwsem_down_failed_common+0x1a9/0x1dd
 [<ffffffff81038dba>] ? release_console_sem+0x18b/0x1bc
 [<ffffffff814048b2>] rwsem_down_read_failed+0x26/0x30
 [<ffffffff8124ad74>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff81403cd4>] ? down_read+0x12/0x14
 [<ffffffff8103a3d9>] exit_mm+0x37/0x120
 [<ffffffff8103bdb0>] do_exit+0x1f4/0x70e
 [<ffffffff81404a6f>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
 [<ffffffff8100661d>] oops_end+0xb1/0xb9
 [<ffffffff810067e9>] die+0x55/0x5e
 [<ffffffff81003d7a>] do_trap+0x11c/0x12b
 [<ffffffff810040e6>] do_invalid_op+0x91/0x9a
 [<ffffffff81083097>] ? __remove_from_page_cache+0x54/0xa5
 [<ffffffff810034d5>] invalid_op+0x15/0x20
 [<ffffffff81083097>] ? __remove_from_page_cache+0x54/0xa5
 [<ffffffff81083090>] ? __remove_from_page_cache+0x4d/0xa5
 [<ffffffff81083113>] remove_from_page_cache+0x2b/0x40
 [<ffffffff8108a665>] truncate_inode_page+0x6e/0x82
 [<ffffffff8108a743>] truncate_inode_pages_range+0xca/0x38e
 [<ffffffff8108aa14>] truncate_inode_pages+0xd/0xf
 [<ffffffff81090400>] shmem_delete_inode+0x2d/0xd3
 [<ffffffff810c4c88>] generic_delete_inode+0x8e/0x114
 [<ffffffff810c3db8>] iput+0x61/0x65
 [<ffffffff810c0f19>] dentry_iput+0xbd/0xd5
 [<ffffffff810c0f74>] d_kill+0x43/0x63
 [<ffffffff810c16d5>] dput+0x14c/0x159
 [<ffffffff810b289a>] fput+0x1ab/0x1d0
 [<ffffffff8109a8a4>] remove_vma+0x37/0x5f
 [<ffffffff8109b963>] do_munmap+0x2ff/0x321
 [<ffffffff8120ca94>] sys_shmdt+0x9b/0x12d
 [<ffffffff8100292b>] system_call_fastpath+0x16/0x1b
