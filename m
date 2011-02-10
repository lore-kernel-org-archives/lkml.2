Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab1BJFAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:00:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62818 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1BJFAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:00:10 -0500
Date: Wed, 9 Feb 2011 20:58:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.38-rc4 (other bugs: x25)
Message-Id: <20110209205842.c25aa64a.randy.dunlap@oracle.com>
In-Reply-To: <20110209.140115.183045242.davem@davemloft.net>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110209093656.2b23b80b.randy.dunlap@oracle.com>
	<20110209.140115.183045242.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D5370D3.0100:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Feb 2011 14:01:15 -0800 (PST) David Miller wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 9 Feb 2011 09:36:56 -0800
> 
> > 
> > There are also bugs or other oopses etc. with ipmi, x25 (rmmod hangs system),
> > and (usb gadget) g_audio, but I don't have logs for them yet...
> > Someone else could do those.
> 
> Randy if you could simply get a CPU program counter when the x25
> rmmod hang happens, I can probably fix it quickly.
> 
> But if you don't have time I can fiddle around with it myself.
> --

Hi Dave,

Here's what I captured before the system hung and the beeper stayed
on constantly.  ;)


[  300.488956] calling  x25_init+0x0/0x106 [x25] @ 2571
[  300.494055] NET: Registered protocol family 9
[  300.498609] X.25 for Linux Version 0.2
[  300.503565] initcall x25_init+0x0/0x106 [x25] returned 0 after 9284 usecs
[  303.931229] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[  303.934923] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
[  303.934923] CPU 1 
[  303.934923] Modules linked in: x25(-) af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod joydev mousedev evdev mac_hid snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usbmouse usbkbd usbhid snd_pcm hid snd_timer sr_mod tg3 pcspkr rtc_cmos dcdbas sg snd iTCO_wdt cdrom i2c_i801 rtc_core processor iTCO_vendor_support rtc_lib 8250_pnp soundcore thermal_sys intel_agp button intel_gtt snd_page_alloc hwmon unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unloaded: microcode]
[  303.934923] 
[  303.934923] Pid: 2573, comm: rmmod Not tainted 2.6.38-rc4 #3 0TY565/OptiPlex 745                 
[  303.934923] RIP: 0010:[<ffffffffa069c131>]  [<ffffffffa069c131>] x25_link_free+0x41/0x81 [x25]
[  303.934923] RSP: 0018:ffff880061777eb8  EFLAGS: 00010202
[  303.934923] RAX: 6b6b6b6b6b6b6b6b RBX: ffffffffa06a03d0 RCX: 0010000000004040
[  303.934923] RDX: 00000000001c0016 RSI: ffff88005ecc6438 RDI: 0000000000000216
[  303.934923] RBP: ffff880061777ec8 R08: ffff88007f004c80 R09: 000000000000005a
[  303.934923] R10: ffffffff8182c266 R11: ffff880061777e18 R12: ffffffffa06a03d0
[  303.934923] R13: 00007fff94141220 R14: 0000000000000000 R15: 0000000000000001
[  303.934923] FS:  00007fc688ac36f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  303.934923] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  303.934923] CR2: 00000000008faf20 CR3: 000000006873c000 CR4: 00000000000006e0
[  303.934923] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  303.934923] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  303.934923] Process rmmod (pid: 2573, threadinfo ffff880061776000, task ffff88005cec3000)
[  303.934923] Stack:
[  303.934923]  ffffffffa06a0b10 0000000000000000 ffff880061777ed8 ffffffffa069c085
[  303.934923]  ffff880061777f78 ffffffff810d3e94 ffffffffa06a0b10 0000000000000880
[  303.934923]  ffff880061777f14 ffffffff8155da0e ffff880061777f28 0000000081136a5f
[  303.934923] Call Trace:
[  303.934923]  [<ffffffffa069c085>] x25_exit+0x21/0x8c [x25]
[  303.934923]  [<ffffffff810d3e94>] sys_delete_module+0x2d6/0x368
[  303.934923]  [<ffffffff8155da0e>] ? lockdep_sys_exit_thunk+0x35/0x67
[  303.934923]  [<ffffffff810fd3f2>] ? audit_syscall_entry+0x172/0x1a5
[  303.934923]  [<ffffffff8155d998>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  303.934923]  [<ffffffff8100e942>] system_call_fastpath+0x16/0x1b
[  303.934923] Code: 56 6a 00 00 e8 6e 22 ec e0 48 8b 1d ba 42 00 00 4c 8b 23 eb 2e 48 89 df 48 ff 05 4b 6a 00 00 e8 62 d1 ff ff 48 8b 43 10 4c 89 e3 <48> 8b 80 80 04 00 00 65 ff 08 49 8b 04 24 48 ff 05 22 6a 00 00 
[  303.934923] RIP  [<ffffffffa069c131>] x25_link_free+0x41/0x81 [x25]
[  303.934923]  RSP <ffff880061777eb8>


HTH.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
