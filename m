Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0JHJCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:02:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0JHJCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:02:09 -0400
Message-ID: <4CAEDE0D.2040009@cn.fujitsu.com>
Date: Fri, 08 Oct 2010 17:02:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
References: <4CAEC81C.1070108@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------040608040608010502050903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040608040608010502050903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Fri, 8 Oct 2010 15:42:45 +0800, Ma, Ling wrote:
> Could you please give us full address for each comparison result,we will do some tests on my machine.
> For unaligned cases older cpus will crossing cache line and slow down caused by load and store, but for nhm, no necessary to care about it.
> By the way in kernel 64bit mode, our access mode should be around 8byte aligned.

Would you need my benchmark tool? I think it is helpful for your test.

Thanks
Miao

> Thanks
> Ling
>
>> -----Original Message-----
>> From: Miao Xie [mailto:miaox@cn.fujitsu.com]
>> Sent: Friday, October 08, 2010 3:28 PM
>> To: Ingo Molnar; Andi Kleen; Ma, Ling; H. Peter Anvin; Thomas Gleixner; Zhao,
>> Yakui
>> Cc: Linux Kernel
>> Subject: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for
>> unaligned copy
>>
>> memcpy of x86_64 hasn't been optimized for the unaligned copy like other
>> architecture, this patch fixed this problem.
>>
>> I have tested this patch by my benchmark tool(doing 500 bytes memory copy
>> for 5,000,000 times)with various alignments and buffer sizes on my Core2
>> box.
>>
>> Len	Src/Dst	Old memcpy	New memcpy
>> 	align
>> ---	-------	-------------	-------------
>> 1	0/0	0s 47015us	0s 28265us
>> 1	0/4	0s 28201us	0s 28199us
>> 1	4/0	0s 28200us	0s 28199us
>> 1	4/4	0s 28199us	0s 28206us
>> 7	0/0	0s 24441us	0s 24438us
>> 7	0/4	0s 24439us	0s 24438us
>> 7	4/0	0s 24439us	0s 24438us
>> 7	4/4	0s 24439us	0s 24439us
>> 8	0/0	0s 20699us	0s 20687us
>> 8	0/4	0s 20689us	0s 20901us
>> 8	4/0	0s 20692us	0s 20679us
>> 8	4/4	0s 20679us	0s 20679us
>> 16	0/0	0s 18807us	0s 18802us
>> 16	0/4	0s 26319us	0s 18800us
>> 16	4/0	0s 18800us	0s 18806us
>> 16	4/4	0s 26317us	0s 18803us
>> 32	0/0	0s 35728us	0s 18800us
>> 32	0/4	0s 35716us	0s 18800us
>> 32	4/0	0s 35717us	0s 18800us
>> 32	4/4	0s 35724us	0s 18803us
>> 48	0/0	0s 26897us	0s 30080us
>> 48	0/4	0s 33837us	0s 33838us
>> 48	4/0	0s 27600us	0s 30079us
>> 48	4/4	0s 30087us	0s 33854us
>> 64	0/0	0s 41369us	0s 45115us
>> 64	0/4	0s 62042us	0s 65800us
>> 64	4/0	0s 56400us	0s 58278us
>> 64	4/4	0s 84596us	0s 84606us
>> 80	0/0	0s 35877us	0s 37611us
>> 80	0/4	0s 77083us	0s 56404us
>> 80	4/0	0s 52652us	0s 55611us
>> 80	4/4	0s 75200us	0s 78968us
>> 128	0/0	0s 52642us	0s 56403us
>> 128	0/4	0s 95883us	0s 95891us
>> 128	4/0	0s 114683us	0s 108511us
>> 128	4/4	0s 144780us	0s 110927us
>> 256	0/0	0s 80832us	0s 86489us
>> 256	0/4	0s 178586us	0s 163562us
>> 256	4/0	0s 208670us	0s 181719us
>> 256	4/4	0s 270705us	0s 148525us
>> 512	0/0	0s 156049us	0s 148348us
>> 512	0/4	0s 313933us	0s 298908us
>> 512	4/0	0s 411671us	0s 329025us
>> 512	4/4	0s 516971us	0s 208746us
>> 1024	0/0	0s 297067us	0s 274019us
>> 1024	0/4	0s 584703us	0s 569604us
>> 1024	4/0	0s 818104us	0s 616419us
>> 1024	4/4	1s 22839us	0s 328953us
>> 2048	0/0	0s 577077us	0s 524148us
>> 2048	0/4	1s 125953us	1s 111258us
>> 2048	4/0	1s 894000us	1s 202724us
>> 2048	4/4	2s 331807us	0s 822437us
>> 4096	0/0	1s 25881us	1s 34128us
>> 4096	0/4	2s 619273us	2s 606489us
>> 4096	4/0	3s 553989us	2s 390272us
>> 4096	4/4	4s 737789us	1s 433213us
>>
>> Signed-off-by: Miao Xie<miaox@cn.fujitsu.com>
>> ---
>>   arch/x86/lib/memcpy_64.S |  135
>> +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 134 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
>> index 75ef61e..b0224f8 100644
>> --- a/arch/x86/lib/memcpy_64.S
>> +++ b/arch/x86/lib/memcpy_64.S
>> @@ -46,9 +46,39 @@ ENTRY(memcpy)
>>   	 * Use 32bit CMP here to avoid long NOP padding.
>>   	 */
>>   	cmp  $0x20, %edx
>> -	jb .Lhandle_tail
>> +	jbe .Lhandle_tail
>>
>>   	/*
>> +	 * the code for unaligned copy is good for large-size copy(>100),
>> +	 * so if the size is small, we needn't check dst and src is aligned
>> +	 * or not.
>> +	 */
>> +	cmp $100, %edx
>> +	jb .Lboth_aligned
>> +
>> +	/*
>> +	 * unaligned access always leads to bad performance, so in order to
>> +	 * avoid unaligned access, we align the address(both src and dest)
>> +	 * first, and then copy from a aligned src to an aligned dst by using
>> +	 * shifts.
>> +	 * But we found if src is aligned, although dest is unaligned, the
>> +	 * performance of generic memory copy (That is reading data aligned
>> +	 * from the source and writing data unaligned to the dest) is better
>> +	 * than the one that uses shifts to avoid unaligned access.
>> +	 * So if src is aligned, we needn't check dest is aligned or not, just
>> +	 * goto .Lboth_aligned
>> +	 */
>> +	test $7, %esi		/* src align check */
>> +	jz .Lboth_aligned
>> +
>> +	/* if dest and src both are unaligned, goto unaligned copy */
>> +	test $7, %edi
>> +	jnz .Ldst_unaligned
>> +
>> +	jmp .Lsrc_unaligned_dst_aligned
>> +
>> +.Lboth_aligned:
>> +	/*
>>   	 * We check whether memory false dependece could occur,
>>   	 * then jump to corresponding copy mode.
>>   	 */
>> @@ -166,6 +196,109 @@ ENTRY(memcpy)
>>
>>   .Lend:
>>   	retq
>> +
>> +	.p2align 4
>> +.Ldst_unaligned:
>> +	movq %rdi, %rcx
>> +	andq $7, %rcx		/* Align the destination */
>> +	negq %rcx
>> +	andq $7, %rcx
>> +	subq %rcx, %rdx
>> +
>> +	/* tune dst address */
>> +	movq (%rsi), %r8
>> +	movq %r8, (%rdi)
>> +	addq %rcx, %rdi
>> +	addq %rcx, %rsi
>> +
>> +	test $7, %esi		/* src align check */
>> +	jz .Lboth_aligned
>> +
>> +	.p2align 4
>> +.Lsrc_unaligned_dst_aligned:
>> +	push %rbx
>> +	push %r12
>> +	push %r13
>> +	push %r14
>> +	push %r15
>> +	/*
>> +	 * Calculate how to shift a word read at the memory operation
>> +	 * aligned srcp to make it aligned for copy.
>> +	 */
>> +	movq %rsi, %r14
>> +	andq $7, %r14
>> +	shlq $3, %r14
>> +
>> +	movq $64, %r15
>> +	subq %r14, %r15
>> +
>> +	andq $-8, %rsi		/* src aligned */
>> +	movq 0*8(%rsi), %r8
>> +
>> +	movq %rdx, %rbx
>> +	shrq $5, %rbx
>> +	jz .Lsrc_unaligned_less32
>> +
>> +	/*
>> +	 * %r8 : store src[0]
>> +	 * %r9 : store src[1]
>> +	 * %r10: store src[2]
>> +	 * %r11: store src[3]
>> +	 * %r12: store src[4]
>> +	 * %r13: store the tmp data
>> +	 */
>> +	.p2align 4
>> +.Lsrc_unaligned_loop32:
>> +	movq 1*8(%rsi), %r9
>> +	movq 2*8(%rsi), %r10
>> +	movq 3*8(%rsi), %r11
>> +	movq 4*8(%rsi), %r12
>> +
>> +	movq %r9, %r13
>> +	movb %r14b, %cl
>> +	shrq %cl, %r8
>> +	shrq %cl, %r13
>> +	movb %r15b, %cl
>> +	shlq  %cl, %r9
>> +	orq %r8, %r9
>> +	movq %r10, %r8
>> +	shlq  %cl, %r10
>> +	orq %r13, %r10
>> +
>> +	movq %r11, %r13
>> +	movb %r14b, %cl
>> +	shrq %cl, %r8
>> +	shrq %cl, %r13
>> +	movb %r15b, %cl
>> +	shlq  %cl, %r11
>> +	orq %r8, %r11
>> +	movq %r12, %r8
>> +	shlq  %cl, %r12
>> +	orq %r13, %r12
>> +
>> +	movq %r9, 0*8(%rdi)
>> +	movq %r10, 1*8(%rdi)
>> +	movq %r11, 2*8(%rdi)
>> +	movq %r12, 3*8(%rdi)
>> +
>> +	leaq 4*8(%rdi), %rdi
>> +	leaq 4*8(%rsi), %rsi
>> +	decq %rbx
>> +	jnz .Lsrc_unaligned_loop32
>> +
>> +	.p2align 4
>> +.Lsrc_unaligned_less32:
>> +	shrq $3, %r14
>> +	addq %r14, %rsi
>> +	pop %r15
>> +	pop %r14
>> +	pop %r13
>> +	pop %r12
>> +	pop %rbx
>> +	andq $31, %rdx
>> +	jnz .Lhandle_tail
>> +	retq
>> +
>>   	CFI_ENDPROC
>>   ENDPROC(memcpy)
>>   ENDPROC(__memcpy)
>> --
>> 1.7.0.1
>
>


--------------040608040608010502050903
Content-Type: application/x-gzip;
 name="benchmark.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="benchmark.tar.gz"

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

--------------040608040608010502050903--
