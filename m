Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab0KWBqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 20:46:19 -0500
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:32998 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750756Ab0KWBqS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 20:46:18 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 20:46:17 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=nIfvAhlIPTWjrwHC58hza0ga20Lq203tzUtwrDInMmouUkhz1t/GJ9Eey6kAwGtaEPXBwfQG/vX1n5VD33Gyl2GP0MzOq67Q8QZy6+u18ZxRTv1Q6QT73wtIQDeP5cvlM/FovwbaunMzMagkGqZixnlNDOuXmnydcrq1sNdkjZk=;
Message-ID: <824504.64343.qm@web52908.mail.re2.yahoo.com>
X-YMail-OSG: W7w4D2cVM1mKQoyjX3dlDHzt3wUa3nsLLyrCQt3lUaU2SM7
 JUfqOJDB_92uNzjPh_ErU85kCcvL0.mVqJdddcXe1gziXTl2TFxyzHuw79An
 0kMvuNyYdmgsZJWK0h_8l_YfMCICiDc7SjYPX7FEGvNP401y_2W1NU.gBhfD
 aREgSYcH2wfT3kRoouNBYAQ3Vzh5tqpWDaLFSpWgNR5ke9EzvaXWAsLPKjiH
 vgsjp_bNZyMS.xMdiiMxTmPAq1udFEE7QvewAnIQADpLbEPeCDeqvmkMvGnY
 V3oaCMgKviZMHi4PXjujyS8nvgb6xrfy7rJUFgN4bDccbm8OuwOA7Ws3xpD6
 YJ.kl
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 22 Nov 2010 17:39:37 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Re: Linux 2.6.35.9
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just testing my latest 2.6.35.9 kernel by playing WoW (with multiple Java processes and a VPN running in the background) when I saw this BUG (below). I've never seen anything like this before with earlier kernels and so doubt that this is a hardware error. I suppose it *might* be caused by a bad incremental build, and so I've deleted all my .o and .ko files and rebuilt my kernel. But it could equally be something deeper (and nastier).

The hardware is a dual hyperthreaded P4 Xeon (4 logical CPUs) with 2 GB of RAM and a RV350 graphics card.

Cheers,
Chris

-- snip ------------------------------------------------------------
swap_free: Unused swap offset entry 0000006c
BUG: Bad page map in process explorer.exe  pte:0000d800 pmd:36a23067
addr:7e9d6000 vm_flags:08000075 anon_vma:(null) mapping:ecb94fc8 index:99
vma->vm_ops->fault: filemap_fault+0x0/0x30c
vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x39
Pid: 21815, comm: explorer.exe Not tainted 2.6.35.9 #1
Call Trace:
 [<c107105b>] ? print_bad_pte+0x138/0x149
 [<c107b415>] ? swap_info_get+0x5a/0x80
 [<c10723f3>] ? unmap_vmas+0x36d/0x584
 [<c10758a9>] ? exit_mmap+0x9b/0x131
 [<c1022b1a>] ? mmput+0x30/0xa4
 [<c102702b>] ? exit_mm+0xe4/0xec
 [<c10535a4>] ? audit_free+0x15f/0x181
 [<c1027200>] ? do_exit+0x1cd/0x5c4
 [<c10201a8>] ? sub_preempt_count+0x74/0x80
 [<c11e3849>] ? _raw_spin_unlock_irq+0xd/0x20
 [<c10277f9>] ? do_group_exit+0x5a/0x7d
 [<c102782d>] ? sys_exit_group+0x11/0x14
 [<c100270c>] ? sysenter_do_call+0x12/0x22
Disabling lock debugging due to kernel taint
BUG: Bad page map in process explorer.exe  pte:186f3747 pmd:36a23067
addr:7e9de000 vm_flags:08100073 anon_vma:f3115510 mapping:ecb94fc8 index:a1
vma->vm_ops->fault: filemap_fault+0x0/0x30c
vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x39
Pid: 21815, comm: explorer.exe Tainted: G    B       2.6.35.9 #1
Call Trace:
 [<c107105b>] ? print_bad_pte+0x138/0x149
 [<c1071771>] ? vm_normal_page+0x26/0x4d
 [<c1072222>] ? unmap_vmas+0x19c/0x584
 [<c10758a9>] ? exit_mmap+0x9b/0x131
 [<c1022b1a>] ? mmput+0x30/0xa4
 [<c102702b>] ? exit_mm+0xe4/0xec
 [<c10535a4>] ? audit_free+0x15f/0x181
 [<c1027200>] ? do_exit+0x1cd/0x5c4
 [<c10201a8>] ? sub_preempt_count+0x74/0x80
 [<c11e3849>] ? _raw_spin_unlock_irq+0xd/0x20
 [<c10277f9>] ? do_group_exit+0x5a/0x7d
 [<c102782d>] ? sys_exit_group+0x11/0x14
 [<c100270c>] ? sysenter_do_call+0x12/0x22
------------[ cut here ]------------
WARNING: at /home/chris/LINUX/linux-2.6.35/fs/buffer.c:668 __set_page_dirty+0x3d/0x7f()
Hardware name: Precision WorkStation 650    
Modules linked in: snd_seq_oss snd_seq_midi snd_seq_dummy tun nfs fuse cpufreq_ondemand nfsd lockd auth_rpcgss exportfs autofs4 sunrpc p4_clockmod speedstep_lib af_packet ipt_LOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_LOG nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod uinput snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_ac97_codec snd_usb_audio ac97_bus snd_seq snd_pcm snd_timer joydev ppdev uvcvideo snd_usbmidi_lib psmouse usbhid snd_page_alloc snd_util_mem parport_pc floppy videodev serio_raw firewire_ohci parport snd_hwdep firewire_core crc_itu_t v4l1_compat dcdbas snd_rawmidi snd_seq_device snd pcspkr sg i2c_i801 soundcore ext3 jbd mbcache sr_mod cdrom sd_mod sata_sil pata_acpi uhci_hcd ata_piix libata ehci_hcd scsi_mod e1000 usbcore thermal button radeon intel_agp ttm
 drm_kms_helper drm agpgart i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect [last unloaded: mperf]
Pid: 21794, comm: WoW.exe Tainted: G    B       2.6.35.9 #1
Call Trace:
 [<c10248a6>] ? warn_slowpath_common+0x6a/0x7d
 [<c10a3f7d>] ? __set_page_dirty+0x3d/0x7f
 [<c10248c6>] ? warn_slowpath_null+0xd/0x10
 [<c10a3f7d>] ? __set_page_dirty+0x3d/0x7f
 [<c10a41e6>] ? __set_page_dirty_buffers+0x77/0x81
 [<c10669c8>] ? set_page_dirty+0x2f/0x4c
 [<c1072310>] ? unmap_vmas+0x28a/0x584
 [<c1074907>] ? unmap_region+0xab/0x13d
 [<c10756c0>] ? do_munmap+0x1c0/0x208
 [<c1076056>] ? mmap_region+0x78/0x395
 [<c107669f>] ? sys_mmap_pgoff+0x75/0x9a
 [<c100270c>] ? sysenter_do_call+0x12/0x22
---[ end trace 4098e2b13de2a43d ]---
BUG: Bad page map in process WoW.exe  pte:28c60047 pmd:351e9067
page:c186cc00 count:2 mapcount:-1 mapping:f6c23740 index:0x92702b
page flags: 0x40000874(referenced|dirty|lru|active|private)
addr:041c3000 vm_flags:00100073 anon_vma:f518d930 mapping:(null) index:41c3
Pid: 21794, comm: WoW.exe Tainted: G    B   W   2.6.35.9 #1
Call Trace:
 [<c107105b>] ? print_bad_pte+0x138/0x149
 [<c106eebf>] ? __dec_zone_state+0x13/0x6a
 [<c1072359>] ? unmap_vmas+0x2d3/0x584
 [<c1074907>] ? unmap_region+0xab/0x13d
 [<c10756c0>] ? do_munmap+0x1c0/0x208
 [<c1076056>] ? mmap_region+0x78/0x395
 [<c107669f>] ? sys_mmap_pgoff+0x75/0x9a
 [<c100270c>] ? sysenter_do_call+0x12/0x22
BUG: Bad page map in process java  pte:1e6b0047 pmd:35e36067
page:c1721600 count:2 mapcount:-1 mapping:f6c23740 index:0x93a804
page flags: 0x40000874(referenced|dirty|lru|active|private)
addr:94f4d000 vm_flags:00100077 anon_vma:f5a9e540 mapping:(null) index:94f4d
Pid: 19805, comm: java Tainted: G    B   W   2.6.35.9 #1
Call Trace:
 [<c107105b>] ? print_bad_pte+0x138/0x149
 [<c106eebf>] ? __dec_zone_state+0x13/0x6a
 [<c1072359>] ? unmap_vmas+0x2d3/0x584
 [<c10758a9>] ? exit_mmap+0x9b/0x131
 [<c1022b1a>] ? mmput+0x30/0xa4
 [<c102702b>] ? exit_mm+0xe4/0xec
 [<c10535a4>] ? audit_free+0x15f/0x181
 [<c1027200>] ? do_exit+0x1cd/0x5c4
 [<c102d520>] ? recalc_sigpending+0xf/0x2a
 [<c102dcbb>] ? dequeue_signal+0xa4/0x114
 [<c10277f9>] ? do_group_exit+0x5a/0x7d
 [<c102f0fe>] ? get_signal_to_deliver+0x342/0x359
 [<c1001b74>] ? do_signal+0x58/0x674
 [<c1021886>] ? try_to_wake_up+0x22a/0x246
 [<c10093aa>] ? syscall_trace_leave+0x29/0xc3
 [<c105e12d>] ? perf_event_task_sched_in+0xe/0x77
 [<c11e3849>] ? _raw_spin_unlock_irq+0xd/0x20
 [<c1042207>] ? sys_futex+0xe6/0xf3
 [<c1053723>] ? audit_syscall_entry+0x15d/0x17f
 [<c10023fe>] ? do_notify_resume+0x20/0x56
 [<c11e3e1a>] ? work_notifysig+0x13/0x19




      
