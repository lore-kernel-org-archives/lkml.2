Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab2J2KXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:23:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38642 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2J2KXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:23:09 -0400
Message-ID: <508E58FD.2000707@ahsoftware.de>
Date: Mon, 29 Oct 2012 11:22:53 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED regions..."
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just bisected a problem with 3.6.4.

I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6 
(1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box 
didn't boot.

I can't provide any output, because I don't see if that commit is 
applied. ;)

Here is the start of the dmesg with the memory map (with the above 
commit reverted):

-------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.4-00001-gcccc924 
(root@krabat.ahsoftware) (gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) 
(GCC) ) #258 SMP Mon Oct 29 11:08:32 CET 2012
[    0.000000] Command line: ro root=/dev/sdb2 rootfstype=ext4 
enforcing=0 cgroup_disable=memory vga=0x346 video=vesafb:mtrr:3,ywrap 
radeon.modeset=0
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: System manufacturer System Product Name/F2A85-M, 
BIOS 5103 09/19/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1bf000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 00009F000000 mask FFFFFF000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 00000001bf000000 aka 7152M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820: update [mem 0x9f000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x9f000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9effffff]
[    0.000000]  [mem 0x00000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x9effffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x9effffff @ [mem 
0x1fbfe000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1beffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 1G
[    0.000000]  [mem 0x180000000-0x1beffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x1beffffff @ [mem 
0x9effe000-0x9effffff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02 ALASKA)
...
-------------

If I can help more, just ask.

Regards,

Alexander
