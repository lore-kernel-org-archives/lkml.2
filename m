Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2LMViY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:38:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39662 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab2LMViX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:38:23 -0500
Message-ID: <50CA4A7A.10104@zytor.com>
Date: Thu, 13 Dec 2012 13:36:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic>
In-Reply-To: <20121213191317.GE31485@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 11:13 AM, Borislav Petkov wrote:
> On Wed, Dec 12, 2012 at 09:26:47PM -0800, H. Peter Anvin wrote:
>>
>> Well, minus a simple brainfart now it actually gets into the page
>> table setup.
>
> If by this you mean that you can only see
>
> "Decompressing Linux...
> Parsing ELF.."
>
> and then the VM reboots (running it in KVM) then ok, I'm seeing this
> here too.
>

: tazenda 111 ; qemu-kvm -smp 2 -m 2048 -hda 
~/qemu/fc10/qemu-fc10-64.img -serial stdio -kernel 
o.x86_64/arch/x86/boot/bzImage -append 'ro root=/dev/sda1 console=ttyS0 
earlyprintk=serial,ttyS0 debug'
early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0+ (hpa@tazenda.hos.anvin.org) (gcc 
version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #16 SMP Wed Dec 12 
21:24:54 PST 2012
[    0.000000] Command line: ro root=/dev/sda1 console=ttyS0 
earlyprintk=serial,ttyS0 debug
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] 
reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped 
at [ffff8800000fdae0]
[    0.000000] initial memory mapped: [mem 0x00000000-0xffffffffffffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x7fffdfff]
[    0.000000]  [mem 0x00000000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
[    0.000000] Kernel panic - not syncing: Cannot find space for the 
kernel page tables
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0+ #16
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff817f0d2e>] panic+0xb6/0x1b5
[    0.000000]  [<ffffffff817e3801>] init_memory_mapping+0x471/0x5a0
[    0.000000]  [<ffffffff81ecd37f>] setup_arch+0x65c/0xb71
[    0.000000]  [<ffffffff81ec998e>] start_kernel+0x8a/0x348
[    0.000000]  [<ffffffff81ec9452>] x86_64_start_reservations+0x132/0x136
[    0.000000]  [<ffffffff81ec94fe>] x86_64_start_kernel+0xa8/0xad



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

