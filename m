Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab0G2Pp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:45:26 -0400
Received: from v-smtp-auth-relay-5.gradwell.net ([79.135.125.99]:45962 "EHLO
	v-smtp-auth-relay-5.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab0G2PpZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:45:25 -0400
Subject: 2.6.34 BUG on stopping md device
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Thu, 29 Jul 2010 16:45:19 +0100
Message-ID: <1280418319.24015.3.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Ever since I upgraded to 2.6.34, I've been getting kernel bugs whenever
I stop a md array. 

Last night I got a kernel BUG last night after stopping an md device. I
had to reboot as I could not do anything with the machine. Here's the
following dmesg output:

Jul 29 13:17:20 lithium kernel: md: md0 stopped.
Jul 29 13:17:20 lithium kernel: md: unbind<sdb1>
Jul 29 13:17:20 lithium kernel: md: export_rdev(sdb1)
Jul 29 13:17:20 lithium kernel: md: unbind<sdc1>
Jul 29 13:17:20 lithium kernel: md: export_rdev(sdc1)
Jul 29 13:17:20 lithium kernel: md0: detected capacity change from 360086110208 to 0
Jul 29 13:17:20 lithium kernel: BUG: unable to handle kernel paging request at 6b736964
Jul 29 13:17:20 lithium kernel: IP: [<c11c76da>] strcmp+0x7/0x19
Jul 29 13:17:20 lithium kernel: *pde = 00000000
Jul 29 13:17:20 lithium kernel: Oops: 0000 [#1] PREEMPT SMP
Jul 29 13:17:20 lithium kernel: last sysfs file: /sys/devices/virtual/block/md0/md/array_state
Jul 29 13:17:20 lithium kernel: Modules linked in: linear bridge stp rndis_host cdc_ether usbnet xt_tcpudp xt_state ipt_LOG rfcomm l2cap bluetooth ipv6 iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_DSCP xt_dscp xt_string xt_NFQUEUE xt_multiport xt_MARK xt_mark xt_iprange xt_hashlimit xt_conntrack xt_CONNMARK xt_connmark nf_conntrack ip_tables x_tables snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ppdev lp arc4 pcmcia ecb b43 mac80211 snd_intel8x0 cfg80211 snd_ac97_codec nouveau ac97_bus ttm snd_pcm drm_kms_helper b44 rfkill intel_agp snd_timer drm snd yenta_socket rsrc_nonstatic video backlight i2c_algo_bit rtc_cmos rtc_core dcdbas ssb snd_page_alloc output i2c_core mii agpgart processor pcmcia_core rtc_lib pcspkr battery button thermal rng_core ac joydev tg3 libphy e1000 fuse nfs auth_rpcgss lockd sunrpc raid10 raid1 raid0 md_mod dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd usbhid ohci_hcd uhci_hcd usb_storage ehci_hcd usbcore lpfc scsi_transport_fc megaraid_mbox megaraid_mm aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx atp870u dc395x sim710 53c700 qla1280 imm parport dmx3191d sym53c8xx qlogicfas408 gdth aha1740 initio BusLogic aic7xxx aic79xx scsi_transport_spi sg [last unloaded: vmnet]
Jul 29 13:17:20 lithium kernel: 
Jul 29 13:17:20 lithium kernel: Pid: 10, comm: events/1 Not tainted 2.6.34-gentoo-r1 #1 0W0941/Inspiron 5150
Jul 29 13:17:20 lithium kernel: EIP: 0060:[<c11c76da>] EFLAGS: 00010286 CPU: 1
Jul 29 13:17:20 lithium kernel: EIP is at strcmp+0x7/0x19
Jul 29 13:17:20 lithium kernel: EAX: f8f0ed6c EBX: efdd9a30 ECX: 00000000 EDX: 6b736964
Jul 29 13:17:20 lithium kernel: ESI: f8f0ede1 EDI: 6b736964 EBP: d003242c ESP: f7057f48
Jul 29 13:17:20 lithium kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 29 13:17:20 lithium kernel: Process events/1 (pid: 10, ti=f7057000 task=f704d3e0 task.ti=f7057000)
Jul 29 13:17:20 lithium kernel: Stack:
Jul 29 13:17:20 lithium kernel: 6b736964 eac2e680 c10b1638 efdd9a04 efdd9a04 c10b1665 6b736964 d00325d4
Jul 29 13:17:20 lithium kernel: <0> c10b2aa8 d00325d4 d0032400 d003242c d00325d4 f8f052c4 c2a08f00 f704d3e0
Jul 29 13:17:20 lithium kernel: <0> d00325d8 c1033db9 f8f0528c c2a08f04 c2a08f0c f704d5e0 00000000 f704d3e0
Jul 29 13:17:20 lithium kernel: Call Trace:
Jul 29 13:17:20 lithium kernel: [<c10b1638>] ? sysfs_find_dirent+0x13/0x23
Jul 29 13:17:20 lithium kernel: [<c10b1665>] ? sysfs_get_dirent+0x1d/0x4a
Jul 29 13:17:20 lithium kernel: [<c10b2aa8>] ? sysfs_remove_group+0x18/0x9c
Jul 29 13:17:20 lithium kernel: [<f8f052c4>] ? mddev_delayed_delete+0x38/0x7b [md_mod]
Jul 29 13:17:20 lithium kernel: [<c1033db9>] ? worker_thread+0xd6/0x15a
Jul 29 13:17:20 lithium kernel: [<f8f0528c>] ? mddev_delayed_delete+0x0/0x7b [md_mod]
Jul 29 13:17:20 lithium kernel: [<c1036630>] ? autoremove_wake_function+0x0/0x29
Jul 29 13:17:20 lithium kernel: [<c1033ce3>] ? worker_thread+0x0/0x15a
Jul 29 13:17:20 lithium kernel: [<c1036337>] ? kthread+0x5f/0x64
Jul 29 13:17:20 lithium kernel: [<c10362d8>] ? kthread+0x0/0x64
Jul 29 13:17:20 lithium kernel: [<c1002b36>] ? kernel_thread_helper+0x6/0x10
Jul 29 13:17:20 lithium kernel: Code: c3 89 cd 89 d6 89 c7 31 c0 83 c9 ff f2 ae 4f 89 e9 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 89 d8 5b 5e 5f 5d c3 57 56 89 c6 89 d7 ac <ae> 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f c3 57 56 89
Jul 29 13:17:20 lithium kernel: EIP: [<c11c76da>] strcmp+0x7/0x19 SS:ESP 0068:f7057f48
Jul 29 13:17:20 lithium kernel: CR2: 000000006b736964
Jul 29 13:17:20 lithium kernel: ---[ end trace 3ac7a01cafe75bda ]---

Is this fixed in 2.6.34.1? 
-- 
http://www.munted.org.uk

One very high maintenance cat living here.

