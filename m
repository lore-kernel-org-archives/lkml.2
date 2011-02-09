Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1BIRIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:08:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22348 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1BIRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:08:48 -0500
Date: Wed, 9 Feb 2011 09:08:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc4 (test_nx: BUG)
Message-Id: <20110209090804.5c1ecf8e.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D52C9FC.023C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


test_nx BUGs.
CONFIG_DEBUG_RODATA=y
(nearly allmodconfig, with a few changes)

Is that expected?


[  132.533559] Testing NX protection
[  132.533583] BUG: unable to handle kernel paging request at ffffffffa05fa178
[  132.533730] IP: [<ffffffffa05f905e>] fudze_exception_table+0x4c/0x58 [test_nx]
[  132.533835] PGD 1a14067 PUD 1a18063 PMD 78b1c067 PTE 800000006cebf161
[  132.534073] Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
[  132.534132] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
[  132.534138] CPU 0 
[  132.534140] Modules linked in: test_nx(+) af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod mousedev joydev evdev mac_hid snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq usbmouse snd_seq_device usbkbd usbhid snd_pcm hid 8250_pnp rtc_cmos snd_timer sr_mod pcspkr rtc_core dcdbas i2c_i801 cdrom 8250 snd sg rtc_lib processor tg3 serial_core soundcore thermal_sys intel_agp iTCO_wdt snd_page_alloc button iTCO_vendor_support intel_gtt hwmon unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unloaded: microcode]
[  132.534237] 
[  132.534241] Pid: 2526, comm: modprobe Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745                 
[  132.534245] RIP: 0010:[<ffffffffa05f905e>]  [<ffffffffa05f905e>] fudze_exception_table+0x4c/0x58 [test_nx]
[  132.534252] RSP: 0018:ffff88006cec1ec8  EFLAGS: 00010246
[  132.534254] RAX: ffffffffa05fa178 RBX: 0000000000000001 RCX: 0000000000000000
[  132.534257] RDX: 0000000000000000 RSI: ffff88006cec1ef8 RDI: ffffffffa05f909d
[  132.534261] RBP: ffff88006cec1ec8 R08: 0000000000000001 R09: 0000000000000000
[  132.534263] R10: 0000000000000000 R11: ffff88006cec1d68 R12: ffff88006cec1ef8
[  132.534266] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  132.534270] FS:  00007f420c3536f0(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[  132.534274] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  132.534277] CR2: ffffffffa05fa178 CR3: 000000006cef0000 CR4: 00000000000006f0
[  132.534280] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  132.534283] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  132.534287] Process modprobe (pid: 2526, threadinfo ffff88006cec0000, task ffff88006ce93000)
[  132.534289] Stack:
[  132.534291]  ffff88006cec1ee8 ffffffffa05f9094 ffffffffa05fb080 ffffffffa05f90d7
[  132.534299]  ffff88006cec1f18 ffffffffa05f911d 00000000000090c3 0000000000000000
[  132.534304]  ffff88006cec1f18 ffffffffa05fb080 ffff88006cec1f48 ffffffff810020e3
[  132.534310] Call Trace:
[  132.534318]  [<ffffffffa05f9094>] test_address+0x2a/0x33 [test_nx]
[  132.534325]  [<ffffffffa05f90d7>] ? test_NX+0x0/0x180 [test_nx]
[  132.534330]  [<ffffffffa05f911d>] test_NX+0x46/0x180 [test_nx]
[  132.534336]  [<ffffffff810020e3>] do_one_initcall+0xa9/0x1ef
[  132.534341]  [<ffffffff810d6674>] sys_init_module+0x12b/0x307
[  132.534345]  [<ffffffff8100e942>] system_call_fastpath+0x16/0x1b
[  132.534347] Code: 00 e8 4b 9d f5 e0 48 c7 c7 53 a0 5f a0 31 c0 48 ff 05 c7 22 00 00 e8 36 9d f5 e0 48 ff 05 c3 22 00 00 eb 11 48 8b 05 62 21 00 00 <48> 89 30 48 ff 05 b8 22 00 00 c9 c3 55 48 89 e5 41 54 53 0f 1f 
[  132.534381] RIP  [<ffffffffa05f905e>] fudze_exception_table+0x4c/0x58 [test_nx]
[  132.534386]  RSP <ffff88006cec1ec8>
[  132.534388] CR2: ffffffffa05fa178
[  132.534392] ---[ end trace c7905109946d6306 ]---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
