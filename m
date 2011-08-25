Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1HYTr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:47:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55666 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1HYTr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu>
	<CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
	<CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
	<CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
	<CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com>
Date: Thu, 25 Aug 2011 15:47:26 -0400
Message-ID: <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 3:16 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Aug 25, 2011 at 10:06 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> On Thu, Aug 25, 2011 at 7:51 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Thu, Aug 25, 2011 at 1:58 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>> Hi,
>
>>>>
>>>> commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
>>>> Author: Andy Lutomirski <luto@mit.edu>
>>>> Date:   Wed Jul 13 09:24:10 2011 -0400
>>>>
>>>>    x86: Make alternative instruction pointers relative
>>>>
>>>>    This save a few bytes on x86-64 and means that future patches can
>>>>    apply alternatives to unrelocated code.
>>>>
>>>>    Signed-off-by: Andy Lutomirski <luto@mit.edu>
>>>>    Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7.1310563276.git.luto@mit.edu
>>>>    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>>>
>>>
>>> I probably missed a hardcoded alternative entry that depends on
>>> config.  Can you send me your System.map and the output of objdump -s
>>> -j .altinstructions vmlinux?
>>>
>> see attached.
>>
>>> I'm also having issues building from your .config.  Building
>>> 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93 asks me about Moorestown MID
>>> platform, Ethernet, etc.
>>>
>> yes, the config is against -rc3. An `oldnoconfig' should do the job
>> before the build.
>>
>
> I still can't reproduce this.  I'm building the attached .config on
> the v3.1-rc3, running make ARCH=i386 oldnoconfig (which spews a lot of
> changes), then building with ARCH=i386 and test-booting in KVM.   No
> panic.
>
> Can you either send me a real .config and exact commit that you're
> building or try the attached patch and tell me what it says?
>
Trace:

CPU: Intel QEMU Virtual CPU version 0.14.50 stepping 03
About to apply_alternatives
start=c13bee88 a=0 instr_offset=-3922530 instr=cpu_idle+0x26/0x60
repl_offset=2336 repl=__alt_instructions_end+0x0/0x29f instrlen=5
repllen=3
  done
start=c13bee88 a=1 instr_offset=-3922053
instr=prepare_to_copy+0xf/0x90 repl_offset=0
repl=__alt_instructions+0x10/0x924 instrlen=2 repllen=0
  no change
start=c13bee88 a=2 instr_offset=-3922050
instr=prepare_to_copy+0x1e/0x90 repl_offset=2315
repl=__alt_instructions_end+0x3/0x29f instrlen=3 repllen=3
  no change
start=c13bee88 a=3 instr_offset=-3922038
instr=prepare_to_copy+0x36/0x90 repl_offset=2306
repl=__alt_instructions_end+0x6/0x29f instrlen=10 repllen=8
  no change
start=c13bee88 a=4 instr_offset=-3922000
instr=prepare_to_copy+0x68/0x90 repl_offset=0
repl=__alt_instructions+0x34/0x924 instrlen=2 repllen=0
  done
start=c13bee88 a=5 instr_offset=-3921520 instr=__switch_to+0x34/0x1b0
repl_offset=0 repl=__alt_instructions+0x40/0x924 instrlen=5 repllen=0
  no change
start=c13bee88 a=6 instr_offset=-3921514 instr=__switch_to+0x46/0x1b0
repl_offset=2278 repl=__alt_instructions_end+0xe/0x29f instrlen=3
repllen=3
  no change
start=c13bee88 a=7 instr_offset=-3921498 instr=__switch_to+0x62/0x1b0
repl_offset=2269 repl=__alt_instructions_end+0x11/0x29f instrlen=10
repllen=8
  no change
start=c13bee88 a=8 instr_offset=-3921461 instr=__switch_to+0x93/0x1b0
repl_offset=2265 repl=__alt_instructions_end+0x19/0x29f instrlen=4
repllen=3
  done
start=c13bee88 a=9 instr_offset=-3921284 instr=__switch_to+0x150/0x1b0
repl_offset=0 repl=__alt_instructions+0x70/0x924 instrlen=2 repllen=0
  done
start=c13bee88 a=10 instr_offset=-1054249774 instr=0x82655bd2
repl_offset=-1053034552 repl=0x8277e6cc instrlen=5 repllen=5
BUG: unable to handle kernel paging request at 8277e6cc
IP: [<c1376672>] apply_alternatives+0x13a/0x222
*pde = 00000000
Oops: 0000 [#1] DEBUG_PAGEALLOC

Pid: 0, comm: swapper Not tainted 3.1.0-rc3+ #26 Bochs Bochs
EIP: 0060:[<c1376672>] EFLAGS: 00000286 CPU: 0
EIP is at apply_alternatives+0x13a/0x222
EAX: ffffffff EBX: c13bee88 ECX: 00000005 EDX: c13bef00
ESI: 8277e6cc EDI: c1349e9a EBP: c1349fa4 ESP: c1349e50
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c1348000 task=c134e340 task.ti=c1348000)
Stack:
 c130f040 c13bee88 0000000a c1296cd2 82655bd2 c13bf7c8 8277e6cc 00000005
 00000005 c1349e9a 82655bd2 05140e31 00000005 c1349e05 8277e6cc 00000078
 c13bf7ac c13bef00 f689001c c1f69000 00000000 00000001 c1418560 c1418570
Call Trace:
 [<c1296cd2>] ? simd_coprocessor_error+0x2/0x10
 [<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
 [<c101ec59>] ? __call_console_drivers+0x59/0x70
 [<c101f29c>] ? console_unlock+0x10c/0x150
 [<c1023b24>] ? irq_exit+0x54/0x90
 [<c10039c3>] ? do_IRQ+0x43/0xa0
 [<c1294d59>] ? printk+0x18/0x1f
 [<c12975a9>] ? common_interrupt+0x29/0x30
 [<c1376780>] alternative_instructions+0x26/0x4d
 [<c1377605>] check_bugs+0x91/0x93
 [<c13716b6>] start_kernel+0x289/0x294
 [<c13711b7>] ? loglevel+0x1a/0x1a
 [<c13710b3>] i386_start_kernel+0xb3/0xbb

 - Arnaud

> Thanks,
> Andy
>
