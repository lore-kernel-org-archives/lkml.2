Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0DBVrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:47:48 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57010 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab0DBVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:47:41 -0400
Date: Fri, 2 Apr 2010 14:47:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: BUG: physmap modprobe & rmmod
Message-Id: <20100402144727.2c80a6b2.randy.dunlap@oracle.com>
In-Reply-To: <20100402134058.c4682716.randy.dunlap@oracle.com>
References: <20100402134058.c4682716.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB665F8.000D:SCFMA4539814,ss=1,pt=DBB_66871,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 13:40:58 -0700 Randy Dunlap wrote:

> 2.6.34-rc2 kernel:
> 
> Boot up on a common PC, then: modprobe physmap ; rmmod physmap
> and bang.
> 
> [  127.836202] calling  init_mtd+0x0/0x88 [mtd] @ 3566
> [  127.841742] initcall init_mtd+0x0/0x88 [mtd] returned 0 after 514 usecs
> [  127.863465] calling  physmap_init+0x0/0x49 [physmap] @ 3566
> [  127.869454] physmap-flash.0: failed to claim resource 0
> [  127.874760] initcall physmap_init+0x0/0x49 [physmap] returned 0 after 5450 usecs
> [  150.353495] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [  150.354142] IP: [<ffffffff8137c655>] device_pm_remove+0xcb/0xff
> [  150.354142] PGD 6d931067 PUD 6da98067 PMD 0 
> [  150.354142] Oops: 0002 [#1] SMP 
> [  150.354142] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/devnum
> [  150.354142] CPU 1 
> [  150.354142] Modules linked in: physmap(-) mtd chipreg map_funcs ipt_MASQUERADE iptable_nat nf_nat nfsd sco bridge lockd nfs_acl stp auth_rpcgss llc exportfs bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput snd_intel8x0 joydev snd_ac97_codec ac97_bus snd_seq snd_seq_device usbhid snd_pcm snd_timer led_class snd psmouse iTCO_wdt i2c_i801 rtc_cmos iTCO_vendor_support evdev ppdev parport_pc serio_raw parport sg rtc_core i2c_core rtc_lib pcspkr soundcore snd_page_alloc rng_core button thermal intel_agp thermal_sys agpgart hwmon sr_mod cdrom dcdbas ata_generic pata_acpi ata_piix libata ide_pci_generic ide_core sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core ehci_h!
 cd!
>   usbcore nls_base [last unloaded: processor]
> [  150.354142] 
> [  150.354142] Pid: 3575, comm: rmmod Not tainted 2.6.34-rc2 #2 0HH807/OptiPlex GX620               
> [  150.354142] RIP: 0010:[<ffffffff8137c655>]  [<ffffffff8137c655>] device_pm_remove+0xcb/0xff
> [  150.354142] RSP: 0018:ffff88006d96de48  EFLAGS: 00010202
> [  150.354142] RAX: ffffffffa02f8960 RBX: ffffffffa02f8880 RCX: 0000000000000000
> [  150.354142] RDX: 0000000000000000 RSI: ffffffff81ab6940 RDI: ffffffff81ab6940
> [  150.354142] RBP: ffff88006d96de58 R08: 0000000000000001 R09: 0000000000000000
> [  150.354142] R10: ffffffff81ab69b0 R11: 0000000000000000 R12: ffffffff81ab5b00
> [  150.354142] R13: 00007ffff41a5f60 R14: 0000000000000000 R15: 0000000000000001
> [  150.354142] FS:  00007f05a3e8c6f0(0000) GS:ffff880005600000(0000) knlGS:0000000000000000
> [  150.354142] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  150.354142] CR2: 0000000000000008 CR3: 000000007b21d000 CR4: 00000000000006e0
> [  150.354142] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  150.354142] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  150.354142] Process rmmod (pid: 3575, threadinfo ffff88006d96c000, task ffff88006daa8000)
> [  150.354142] Stack:
> [  150.354142]  ffff88006d96de58 ffffffffa02f8880 ffff88006d96de88 ffffffff8136f54f
> [  150.354142] <0> 0000000000000000 0000000000000000 ffffffffa02f8870 00007ffff41a5f60
> [  150.354142] <0> ffff88006d96dea8 ffffffff813765b5 ffffffffa02f8870 0000000000000000
> [  150.354142] Call Trace:
> [  150.354142]  [<ffffffff8136f54f>] device_del+0x59/0x24e
> [  150.354142]  [<ffffffff813765b5>] platform_device_del+0x2d/0x89
> [  150.354142]  [<ffffffff81376dbf>] platform_device_unregister+0x1d/0x37
> [  150.354142]  [<ffffffffa02f8604>] physmap_exit+0x1c/0x38 [physmap]
> [  150.354142]  [<ffffffff810b38f2>] sys_delete_module+0x2cd/0x391
> [  150.354142]  [<ffffffff814d24a7>] ? lockdep_sys_exit_thunk+0x35/0x67
> [  150.354142]  [<ffffffff810dd36a>] ? audit_syscall_entry+0x172/0x1a5
> [  150.354142]  [<ffffffff8100c6f2>] system_call_fastpath+0x16/0x1b
> [  150.354142] Code: 33 59 01 e8 c4 49 15 00 48 ff 05 9f 33 59 01 48 8d 83 e0 00 00 00 48 c7 c7 40 69 ab 81 48 8b 8b e0 00 00 00 48 8b 93 e8 00 00 00 <48> 89 51 08 48 89 0a 48 89 83 e8 00 00 00 48 89 83 e0 00 00 00 
> [  150.354142] RIP  [<ffffffff8137c655>] device_pm_remove+0xcb/0xff
> [  150.354142]  RSP <ffff88006d96de48>
> [  150.354142] CR2: 0000000000000008
> [  150.800000] ---[ end trace 9a6eaeb4fd0889df ]---


This is with close to an allmodconfig on x86_64, including:

CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2

---
~Randy
