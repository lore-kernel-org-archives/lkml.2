Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2J2NT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:19:58 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53241 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2J2NT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:19:57 -0400
Message-ID: <508E8264.8070807@ahsoftware.de>
Date: Mon, 29 Oct 2012 14:19:32 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
References: <508E58FD.2000707@ahsoftware.de>
In-Reply-To: <508E58FD.2000707@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.10.2012 11:22, schrieb Alexander Holler:
> Hello,
>
> I've just bisected a problem with 3.6.4.
>
> I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6
> (1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box
> didn't boot.
>
> I can't provide any output, because I don't see if that commit is
> applied. ;)

That sentence missed an 'any'. But I've now attached a serial, here is
the output:

------
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.4 (root@krabat.ahsoftware) (gcc version
4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #265 SMP Mon Oct 29 14:07:32
CET 2012
[    0.000000] Command line: ro root=/dev/sdb2 rootfstype=ext4
enforcing=0 cgroup_disable=memory vga=0x346 video=vesafb:mtrr:3,ywrap
radeon.modeset=0 earlycon=uart8250,io,0x3f8,115200n8
earlyprintk=ttyS0,115200
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009d7cafff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d7cb000-0x000000009dd6afff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009dd6b000-0x000000009dd7afff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009dd7b000-0x000000009e0e6fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e0e7000-0x000000009e669fff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009e66a000-0x000000009e66afff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e66b000-0x000000009e870fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e871000-0x000000009ec8ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ec90000-0x000000009eff3fff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009eff4000-0x000000009effffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x00000001beffffff] usable
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200n8')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.4 (root@krabat.ahsoftware) (gcc version
4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #265 SMP Mon Oct 29 14:07:32
CET 2012
[    0.000000] Command line: ro root=/dev/sdb2 rootfstype=ext4
enforcing=0 cgroup_disable=memory vga=0x346 video=vesafb:mtrr:3,ywrap
radeon.modeset=0 earlycon=uart8250,io,0x3f8,115200n8
earlyprintk=ttyS0,115200
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009d7cafff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d7cb000-0x000000009dd6afff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009dd6b000-0x000000009dd7afff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009dd7b000-0x000000009e0e6fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e0e7000-0x000000009e669fff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009e66a000-0x000000009e66afff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e66b000-0x000000009e870fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e871000-0x000000009ec8ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ec90000-0x000000009eff3fff]
reserved
[    0.000000] BIOS-e820: [mem 0x000000009eff4000-0x000000009effffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x00000001beffffff] usable
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200n8')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI 2.7 present.
[    0.000000] No AGP bridge found
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1bf000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x1bf000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820: last_pfn = 0x9f000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x9f000 max_arch_pfn = 0x400000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9effffff]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9effffff]
[    0.000000] init_memory_mapping: [mem 0x100001000-0x1beffffff]
[    0.000000] init_memory_mapping: [mem 0x100001000-0x1beffffff]
[    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
[    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
[    0.000000] Pid: 0, comm: swapper Not tainted 3.6.4 #265
[    0.000000] Pid: 0, comm: swapper Not tainted 3.6.4 #265
[    0.000000] Call Trace:
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813e2a76>] ? panic+0xbf/0x1bb
[    0.000000]  [<ffffffff813e2a76>] ? panic+0xbf/0x1bb
[    0.000000]  [<ffffffff813cfa3f>] ? alloc_low_page+0x54/0x7f
[    0.000000]  [<ffffffff813cfa3f>] ? alloc_low_page+0x54/0x7f
[    0.000000]  [<ffffffff8169c987>] ? phys_pud_init+0x1a9/0x25a
[    0.000000]  [<ffffffff8169c987>] ? phys_pud_init+0x1a9/0x25a
[    0.000000]  [<ffffffff8169caf7>] ?
kernel_physical_mapping_init+0xbf/0x17f
[    0.000000]  [<ffffffff8169caf7>] ?
kernel_physical_mapping_init+0xbf/0x17f
[    0.000000]  [<ffffffff813cf6de>] ? init_memory_mapping+0x2de/0x5b0
[    0.000000]  [<ffffffff813cf6de>] ? init_memory_mapping+0x2de/0x5b0
[    0.000000]  [<ffffffff81671da2>] ? setup_arch+0x672/0x8b0
[    0.000000]  [<ffffffff81671da2>] ? setup_arch+0x672/0x8b0
[    0.000000]  [<ffffffff81670815>] ? start_kernel+0x86/0x2ef
[    0.000000]  [<ffffffff81670815>] ? start_kernel+0x86/0x2ef
------

Don't ask me, why some lines are twice there. I assume it's because I 
have earlycon and earlyprintk enabled in the command line. I've never 
used the serial before to debug a kernel on x86, I just have experience 
debugging ARMs using the serial. ;)


Regards,

Alexander
