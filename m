Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1HYEbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:31:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37659 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1HYEa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MXy6vyeLeTbZ+8OXfMowO2j0avSy6XgYJQ-C9N9YyU3GQ@mail.gmail.com>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
	<CACqU3MXy6vyeLeTbZ+8OXfMowO2j0avSy6XgYJQ-C9N9YyU3GQ@mail.gmail.com>
Date: Thu, 25 Aug 2011 00:30:57 -0400
Message-ID: <CACqU3MVPrjNH8Gh=74K-oTPzUiTygS2yWkeuccpYRirxebHtBw@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 24
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 24, 2011 at 9:38 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Wed, Aug 24, 2011 at 2:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> The powerpc allyesconfig build still fails today.
>>
>> Changes since 20110823:
>>
>> New tree: kvmtool
>>
>> The security tree lost its build failure.
>>
>> The ptrace tree gained a build failure (yeaterday) for which I have
>> reveretd a commit.
>>
>> The tty tree gained a build failure so I used the version from
>> next-20110823.
>>
>> The staging tree gained a conflict against the fbdev tree and a build
>> failure for which I reverted a commit.
>>
>> The moduleh tree gained a conflict against the staging tree.
>>
> Quickly testing a new configuration blows up on the following:
>
> console [ttyS0] enabled
> Fast TSC calibration failed
> TSC: Unable to calibrate against PIT
> TSC: No reference (HPET/PMTIMER) available
> Marking TSC unstable due to could not calculate TSC khz
> Calibrating delay loop... 154.88 BogoMIPS (lpj=77440)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> CPU: Intel QEMU Virtual CPU version 0.13.0 stepping 03
> BUG: unable to handle kernel paging request at 827bf688
> IP: [<c13945e2>] apply_alternatives+0xc3/0x18a
> *pde = 00000000
> Oops: 0000 [#1] DEBUG_PAGEALLOC
>
> Pid: 0, comm: swapper Not tainted 3.1.0-rc3-next-20110824+ #5 Bochs Bochs
> EIP: 0060:[<c13945e2>] EFLAGS: 00000286 CPU: 0
> EIP is at apply_alternatives+0xc3/0x18a
> EAX: ffffffff EBX: c13df690 ECX: 00000005 EDX: 827bf688
> ESI: 827bf688 EDI: c1367e9e EBP: c1367fa8 ESP: c1367e70
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c1366000 task=c136c340 task.ti=c1366000)
> Stack:
>  00000002 c137b700 c1142ac0 00000dc6 c1367e9e 8268a422 00000005 827bf688
>  c13dffd8 c1367e05 05000086 f6890046 00f69000 c1367eb0 00000086 00000000
>  00000046 c1367ec0 00000046 00000000 c1367edc c101f3cc 00000dd3 00000000
> Call Trace:
>  [<c1142ac0>] ? serial8250_start_tx+0xe0/0xe0
>  [<c101f3cc>] ? console_unlock+0x10c/0x150
>  [<c12ab669>] ? common_interrupt+0x29/0x30
>  [<c1023c64>] ? irq_exit+0x54/0x90
>  [<c1003a93>] ? do_IRQ+0x43/0xa0
>  [<c12ab669>] ? common_interrupt+0x29/0x30
>  [<c13954a8>] ? check_fpu+0xae/0xdc
>  [<c13946c0>] alternative_instructions+0x17/0x32
>  [<c1395567>] check_bugs+0x91/0x93
>  [<c138f6bb>] start_kernel+0x28e/0x299
>  [<c138f1b7>] ? loglevel+0x1a/0x1a
>  [<c138f0b3>] i386_start_kernel+0xb3/0xbb
> Code: ec fe ff ff 8d 0c 0b 89 8d dc fe ff ff 8d 54 13 04 8b bd d8 fe
> ff ff 89 95 e4 fe ff ff 89 b5 e0 fe ff ff 8b 8d e0 fe ff ff 89 d6 <f3>
> a4 80 bd f6 fe ff ff e8 75 17 80 bd ec fe ff ff 05 75 0e 89
> EIP: [<c13945e2>] apply_alternatives+0xc3/0x18a SS:ESP 0068:c1367e70
> CR2: 00000000827bf688
> ---[ end trace 4eaa2a86a8e2da22 ]---
>
> .config attached. I'll try to bisect it.
>
ok, this is a regression in 3.1, continuing bisection...

 - Arnaud
