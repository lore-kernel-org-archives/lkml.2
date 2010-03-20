Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0CTHBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:01:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50730 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab0CTHBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XxearSQFd0cpEbRVZLCHDfPdT3hyj0XD+bZrMpDKgX9EoqcMKX68zp9Omwq4yaQCVB
         PImylKuxm0QCa+yhZoaJFFTIX/qff6TQSA6bdNF9Hqt7hfYnXE3bRchPbCBElLfTDvqz
         lgJp2aFlV/0EM5SR2RDxeYokWzXkTFr1cc/4w=
MIME-Version: 1.0
In-Reply-To: <d311c6a81003180906i1b28b5c6k1c20d8bbb4c2fc37@mail.gmail.com>
References: <d311c6a81003180906i1b28b5c6k1c20d8bbb4c2fc37@mail.gmail.com>
Date: Sat, 20 Mar 2010 00:01:36 -0700
X-Google-Sender-Auth: 4e60974be7a3eb11
Message-ID: <86802c441003200001v237617e8pc1294b673e9a7947@mail.gmail.com>
Subject: Re: Memory Loss
From: Yinghai Lu <yinghai@kernel.org>
To: Tomasz Grzegurzko <tomasz89@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 9:06 AM, Tomasz Grzegurzko <tomasz89@gmail.com> wrote:
> Hi,
>
> I have a Dell PowerEdge 2900 reporting the loss of some memory at boot
> time. It runs Ubuntu Karmic kernel 2.6.31-19-server (internal name).
> The server is loaded with 42 GB of RAM but I get a little over 40GB,
> and the following message from dmesg after bootup accounting for the
> loss of RAM.
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.31-19-server (buildd@crested) (gcc
> version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #56-Ubuntu SMP Thu Jan 28
> 03:40:48 UTC 2010 (Ubuntu 2.6.31-19.56-server)
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.31-19-server
> root=UUID=53c9e374-ff9a-4c43-96ef-d5e3039d0eba ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfb50000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfb50000 - 00000000cfb66000 (reserved)
> [    0.000000]  BIOS-e820: 00000000cfb66000 - 00000000cfb85c00 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cfb85c00 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000ab0000000 (usable)
> [    0.000000] DMI 2.5 present.
> [    0.000000] last_pfn = 0xab0000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-D3FFF write-protect
> [    0.000000]   D4000-EBFFF uncachable
> [    0.000000]   EC000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 100000000 mask F00000000 write-back
> [    0.000000]   2 base 200000000 mask E00000000 write-back
> [    0.000000]   3 base 400000000 mask C00000000 write-back
> [    0.000000]   4 base 800000000 mask C00000000 write-back
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 0000000080000000 - 0000000100000000
> (usable) ==> (reserved)
> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,
> losing 1275MB of RAM.
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at
> /build/buildd/linux-2.6.31/arch/x86/kernel/cpu/mtrr/cleanup.c:1091
> mtrr_trim_uncached_memory+0x2a6/0x2d1()
> [    0.000000] Hardware name: PowerEdge 2900
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-19-server #56-Ubuntu
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8105e508>] warn_slowpath_common+0x78/0xb0
> [    0.000000]  [<ffffffff8105e54f>] warn_slowpath_null+0xf/0x20
> [    0.000000]  [<ffffffff8184150e>] mtrr_trim_uncached_memory+0x2a6/0x2d1
> [    0.000000]  [<ffffffff8183ccfa>] setup_arch+0x3d0/0x647
> [    0.000000]  [<ffffffff81524b0d>] ? printk+0x3c/0x3f
> [    0.000000]  [<ffffffff81837db3>] start_kernel+0xbe/0x35b
> [    0.000000]  [<ffffffff8183759a>] x86_64_start_reservations+0x125/0x129
> [    0.000000]  [<ffffffff81837698>] x86_64_start_kernel+0xfa/0x109
> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
> [    0.000000] update e820 for mtrr
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 00000000000a0000 (usable)
> [    0.000000]  modified: 0000000000100000 - 0000000080000000 (usable)
> [    0.000000]  modified: 0000000080000000 - 00000000cfb66000 (reserved)
> [    0.000000]  modified: 00000000cfb66000 - 00000000cfb85c00 (ACPI data)
> [    0.000000]  modified: 00000000cfb85c00 - 00000000d0000000 (reserved)
> [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  modified: 00000000fe000000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 0000000ab0000000 (usable)
> [    0.000000] last_pfn = 0xab0000 max_arch_pfn = 0x400000000
> [    0.000000] last_pfn = 0x80000 max_arch_pfn = 0x400000000
> [    0.000000] e820 update range: 0000000000001000 - 0000000000006000
> (usable) ==> (reserved)

because your BIOS doesn't set var mtrr correctly to cover all memory.
so kernel trim those memory.
otherwise system could be very slow when use those range.
[0x8000000, 0xd0000000)

you can specify "disable_mtrr_trim" in your boot command line of
/boot/grub/menu.lst.

then after boot, you could input that in command line after log on

echo "base=0x80000000 size=0x40000000 type=write-back" > /proc/mtrr
echo "base=0xc0000000 size=0x10000000 type=write-back" > /proc/mtrr

or call them with inittab or rc.d

YH
