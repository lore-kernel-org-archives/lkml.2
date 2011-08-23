Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1HWSCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:02:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52948 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HWSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:01:58 -0400
Message-ID: <4E53EB01.7080905@gmail.com>
Date: Tue, 23 Aug 2011 11:01:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45
 [ttm]}
References: <4E506DEA.1070601@gmail.com> <20110821221602.GK25996@one.firstfloor.org>
In-Reply-To: <20110821221602.GK25996@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 03:16 PM, Andi Kleen wrote:
> On Sat, Aug 20, 2011 at 07:31:06PM -0700, Justin P. Mattock wrote:
>> not sure if I am running mce_test correctly, but during its routine of
>> testing things I do get a pause with everything, then the below shows up
>> in dmesg..:
>
> The message is expected, but there should be no noticeable
> pause.
>
> -Andi

o.k. I have reset the kernel to 2.6.36 and ran the test program in
init 3(since radeon is crapped out with that kernel). anyways
with 2.6.36 I can see the cursor on the bottom left blinking throught 
the whole tests telling me there is no pause(all timeouts given, give no 
pause).
with the current in init 3 I see the cursor pause for 2/3 seconds.

I will start a bisct on this, but need some help on how to proceed 
properly i.g. I get an error with gcc building:

   LD      init/built-in.o
   VDSO    arch/x86/vdso/vdso.so.dbg
gcc: error: elf_x86_64: No such file or directory
   VDSO    arch/x86/vdso/vdso32-int80.so.dbg
gcc: error: elf_i386: No such file or directory
   VDSO    arch/x86/vdso/vdso32-syscall.so.dbg
gcc: error: elf_i386: No such file or directory
   VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
gcc: error: elf_i386: No such file or directory
   CC      kernel/trace/trace.o

its easily fixable, but not sure its a good idea due to bisect going 
through commits(afraid I might go astray with the bisect if I add any 
patches).

Justin P. Mattock


