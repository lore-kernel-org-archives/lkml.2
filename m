Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0CYJmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:42:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59328 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0CYJmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=anuH+dpC6Yyf+cGvaREtCBA7/k+BO6MiuDHuwHnp1j/+ySdyEUphpqE6vo7av2Eps1
         XbY/yt9jIzJMTFd46RpagmFgINQG2bdS53EXMNn/4nQy+wsiPt4fJQeznZL0DzU9eFeC
         bYSRvbz+PzkxL4Ndpz/VDLvasxPnMScHrp8F4=
MIME-Version: 1.0
In-Reply-To: <86802c441003200001v237617e8pc1294b673e9a7947@mail.gmail.com>
References: <d311c6a81003180906i1b28b5c6k1c20d8bbb4c2fc37@mail.gmail.com>
	 <86802c441003200001v237617e8pc1294b673e9a7947@mail.gmail.com>
Date: Thu, 25 Mar 2010 09:42:13 +0000
Message-ID: <d311c6a81003250242y5f625ba3i6e1c6946c9739111@mail.gmail.com>
Subject: Re: Memory Loss
From: Tomasz Grzegurzko <tomasz89@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 20, 2010 at 7:01 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Mar 18, 2010 at 9:06 AM, Tomasz Grzegurzko <tomasz89@gmail.com> wrote:
>> Hi,
>>
>> I have a Dell PowerEdge 2900 reporting the loss of some memory at boot
>> time. It runs Ubuntu Karmic kernel 2.6.31-19-server (internal name).
>> The server is loaded with 42 GB of RAM but I get a little over 40GB,
>> and the following message from dmesg after bootup accounting for the
>> loss of RAM.
>>
>> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,
>> losing 1275MB of RAM.
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at
>> /build/buildd/linux-2.6.31/arch/x86/kernel/cpu/mtrr/cleanup.c:1091
>> mtrr_trim_uncached_memory+0x2a6/0x2d1()
>> [    0.000000] Hardware name: PowerEdge 2900
>> [    0.000000] Modules linked in:
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-19-server #56-Ubuntu
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff8105e508>] warn_slowpath_common+0x78/0xb0
>> [    0.000000]  [<ffffffff8105e54f>] warn_slowpath_null+0xf/0x20
>> [    0.000000]  [<ffffffff8184150e>] mtrr_trim_uncached_memory+0x2a6/0x2d1
>> [    0.000000]  [<ffffffff8183ccfa>] setup_arch+0x3d0/0x647
>> [    0.000000]  [<ffffffff81524b0d>] ? printk+0x3c/0x3f
>> [    0.000000]  [<ffffffff81837db3>] start_kernel+0xbe/0x35b
>> [    0.000000]  [<ffffffff8183759a>] x86_64_start_reservations+0x125/0x129
>> [    0.000000]  [<ffffffff81837698>] x86_64_start_kernel+0xfa/0x109
>> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
>
> because your BIOS doesn't set var mtrr correctly to cover all memory.
> so kernel trim those memory.
> otherwise system could be very slow when use those range.
> [0x8000000, 0xd0000000)
>
> you can specify "disable_mtrr_trim" in your boot command line of
> /boot/grub/menu.lst.
>
> then after boot, you could input that in command line after log on
>
> echo "base=0x80000000 size=0x40000000 type=write-back" > /proc/mtrr
> echo "base=0xc0000000 size=0x10000000 type=write-back" > /proc/mtrr
>


I've given this a go, it seems to run fine (no slowness issues
reported yet..). Memory available has gone up. I'll let it run for a
few days and see how it goes..

# free -m
             total       used       free     shared    buffers     cached
Mem:         42337      11397      30940          0         36       5520
-/+ buffers/cache:       5840      36497

# cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
reg02: base=0x200000000 ( 8192MB), size= 8192MB, count=1: write-back
reg03: base=0x400000000 (16384MB), size=16384MB, count=1: write-back
reg04: base=0x800000000 (32768MB), size=16384MB, count=1: write-back
reg05: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg06: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back

Regards,
Tomasz
