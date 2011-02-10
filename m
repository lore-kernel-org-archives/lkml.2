Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1BJTgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:36:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28386 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1BJTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:36:41 -0500
Date: Thu, 10 Feb 2011 11:34:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.38-rc4 (other bugs: ipmi Oops)
Message-Id: <20110210113456.93e8bc56.randy.dunlap@oracle.com>
In-Reply-To: <20110209093656.2b23b80b.randy.dunlap@oracle.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110209093656.2b23b80b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D543E42.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 09:36:56 -0800 Randy Dunlap wrote:

> 
> There are also bugs or other oopses etc. with ipmi, x25 (rmmod hangs system),
> and (usb gadget) g_audio, but I don't have logs for them yet...
> Someone else could do those.
> 
> Oh, and ext4, which was reported on the ext4 mailing list.


Loading ipmi_si module a second time causes an Oops:


[   66.603456] calling  ipmi_init_msghandler_mod+0x0/0x1000 [ipmi_msghandler] @ 2443
[   66.611879] ipmi message handler version 39.2
[   66.617403] initcall ipmi_init_msghandler_mod+0x0/0x1000 [ipmi_msghandler] returned 0 after 5548 usecs
[   66.707849] calling  init_ipmi_si+0x0/0x4cd [ipmi_si] @ 2443
[   66.713933] IPMI System Interface driver.
[   66.718605] ipmi_si: Adding default-specified kcs state machine
[   66.724835] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   66.735302] ipmi_si: Interface detection failed
[   66.762751] ipmi_si: Adding default-specified smic state machine
[   66.769292] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[   66.779869] ipmi_si: Interface detection failed
[   66.800186] ipmi_si: Adding default-specified bt state machine
[   66.806567] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[   66.816866] ipmi_si: Interface detection failed
[   66.836603] ipmi_si: Unable to find any System Interface(s)
[   66.842704] initcall init_ipmi_si+0x0/0x4cd [ipmi_si] returned -19 after 125889 usecs
[   68.105422] calling  init_ipmi_si+0x0/0x4cd [ipmi_si] @ 2453
[   68.111878] IPMI System Interface driver.
[   68.116576] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   68.120143] last sysfs file: /sys/module/ipmi_msghandler/initstate
[   68.120143] CPU 0 
[   68.120143] Modules linked in: ipmi_si(+) ipmi_msghandler af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod snd_hda_codec_analog joydev mousedev evdev mac_hid snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usbmouse snd_pcm usbkbd usbhid snd_timer hid snd sr_mod tg3 dcdbas cdrom pcspkr rtc_cmos i2c_i801 soundcore sg iTCO_wdt rtc_core processor snd_page_alloc iTCO_vendor_support intel_agp rtc_lib thermal_sys 8250_pnp intel_gtt button hwmon unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unloaded: microcode]
[   68.120143] 
[   68.120143] Pid: 2453, comm: modprobe Not tainted 2.6.38-rc4 #4 0TY565/OptiPlex 745                 
[   68.120143] RIP: 0010:[<ffffffff813fc579>]  [<ffffffff813fc579>] put_driver+0x10/0x22
[   68.120143] RSP: 0018:ffff88005ee8be98  EFLAGS: 00010202
[   68.120143] RAX: ffffffffa06a8430 RBX: ffffffffa06bd430 RCX: ffff88007c4187b0
[   68.120143] RDX: 00000000000b000a RSI: 0000000fdc10217c RDI: ffffffffa06a8430
[   68.120143] RBP: ffff88005ee8be98 R08: 0000000000000000 R09: 0000000000000000
[   68.120143] R10: ffffffff812be7f7 R11: ffff88005ee8bcd8 R12: ffffffffa06b86e9
[   68.120143] R13: 0000000000000000 R14: 0000000fdbc6e8dc R15: 0000000000000000
[   68.120143] FS:  00007fd2014156f0(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[   68.120143] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.120143] CR2: ffffffffa06a8490 CR3: 000000005cec7000 CR4: 00000000000006f0
[   68.120143] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.120143] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   68.120143] Process modprobe (pid: 2453, threadinfo ffff88005ee8a000, task ffff8800606ab000)
[   68.120143] Stack:
[   68.120143]  ffff88005ee8bec8 ffffffff813fc64b 0000000000000000 ffffffffa06b86e9
[   68.340115]  0000000000000000 0000000fdbc6e8dc ffff88005ee8bed8 ffffffff8137f5de
[   68.340115]  ffff88005ee8bf18 ffffffffa06b888d ffff88005ee8bf18 ffffffff810b5cee
[   68.340115] Call Trace:
[   68.340115]  [<ffffffff813fc64b>] driver_register+0xc0/0x1b2
[   68.340115]  [<ffffffffa06b86e9>] ? init_ipmi_si+0x0/0x4cd [ipmi_si]
[   68.340115]  [<ffffffff8137f5de>] pnp_register_driver+0x28/0x31
[   68.340115]  [<ffffffffa06b888d>] init_ipmi_si+0x1a4/0x4cd [ipmi_si]
[   68.340115]  [<ffffffff810b5cee>] ? ktime_get+0x88/0xde
[   68.340115]  [<ffffffffa06b86e9>] ? init_ipmi_si+0x0/0x4cd [ipmi_si]
[   68.340115]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1e3
[   68.340115]  [<ffffffff810d4998>] sys_init_module+0x12b/0x307
[   68.340115]  [<ffffffff8100e902>] system_call_fastpath+0x16/0x1b
[   68.340115] Code: 85 f6 75 d9 48 89 df e8 6f de ff ff 48 ff 05 d7 af 80 01 58 5b 41 5c 41 5d c9 c3 55 48 89 e5 0f 1f 44 00 00 48 ff 05 c7 af 80 01 <48> 8b 7f 60 e8 38 27 ec ff 48 ff 05 bf af 80 01 c9 c3 55 48 89 
[   68.340115] RIP  [<ffffffff813fc579>] put_driver+0x10/0x22
[   68.340115]  RSP <ffff88005ee8be98>
[   68.340115] CR2: ffffffffa06a8490
[   68.340115] ---[ end trace 0c99b6dc9c0e95a3 ]---


This is on x86_64, almost allmodconfig.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
