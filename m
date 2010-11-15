Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab0KOSar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:30:47 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2327 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab0KOSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:30:45 -0500
Message-ID: <4CE17C4B.1070305@xs4all.nl>
Date: Mon, 15 Nov 2010 19:30:35 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101106 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de> <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
In-Reply-To: <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050903020504030201070704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903020504030201070704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/15/2010 07:08 PM, Linus Torvalds wrote:
> On Mon, Nov 15, 2010 at 9:40 AM, Jim Bos <jim876@xs4all.nl> wrote:
>>
>> Hmm, that doesn't work.
>>
>> [ Not sure if you read to whole thread but initial workaround was to
>> change the asm(..) to asm volatile(..) which did work. ]
> 
> Since I have a different gcc than yours (and I'm not going to compile
> my own), have you posted your broken .s file anywhere? In fact, with
> the noinline (and the removal of the "+m" thing - iow just the patch
> you tried), what does just the "i8k_smm" function assembly look like
> for you after you've done a "make drivers/char/i8k.s"?
> 
> If the asm just doesn't exist AT ALL, that's just odd. Because every
> single call-site of i8k_smm() clearly looks at the return value. So
> the volatile really shouldn't make any difference from that
> standpoint. Odd.
> 
>                        Linus
> 

Attached version with plain 2.6.36 source and version with the committed
patch, i.e with the '"+m" (*regs)'


_
Jim



--------------050903020504030201070704
Content-Type: text/plain;
 name="i8k.s-2.6.36"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i8k.s-2.6.36"

	.file	"i8k.c"
# GNU C (GCC) version 4.5.1 (i486-slackware-linux)
#	compiled by GNU C version 4.5.1, GMP version 5.0.1, MPFR version 2.4.2-p3, MPC version 0.8.2
# GGC heuristics: --param ggc-min-expand=81 --param ggc-min-heapsize=96817
# options passed:  -nostdinc -I/usr/src/linux-2.6.36/arch/x86/include
# -Iinclude -D__KERNEL__ -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
# -DCONFIG_AS_CFI_SECTIONS=1 -DMODULE -DKBUILD_STR(s)=#s
# -DKBUILD_BASENAME=KBUILD_STR(i8k) -DKBUILD_MODNAME=KBUILD_STR(i8k)
# -isystem /usr/lib/gcc/i486-slackware-linux/4.5.1/include -include
# include/generated/autoconf.h -MD drivers/char/.i8k.s.d drivers/char/i8k.c
# -m32 -msoft-float -mregparm=3 -mpreferred-stack-boundary=2 -march=i686
# -mtune=pentium3 -mtune=generic -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
# -auxbase-strip drivers/char/i8k.s -Os -Wall -Wundef -Wstrict-prototypes
# -Wno-trigraphs -Werror-implicit-function-declaration -Wno-format-security
# -Wno-sign-compare -Wframe-larger-than=1024 -Wdeclaration-after-statement
# -Wno-pointer-sign -fno-strict-aliasing -fno-common
# -fno-delete-null-pointer-checks -freg-struct-return -ffreestanding
# -fno-asynchronous-unwind-tables -fno-stack-protector -fomit-frame-pointer
# -fno-strict-overflow -fconserve-stack -fverbose-asm
# options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
# -fbranch-count-reg -fcaller-saves -fcprop-registers -fcrossjumping
# -fcse-follow-jumps -fdefer-pop -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -fexpensive-optimizations
# -fforward-propagate -ffunction-cse -fgcse -fgcse-lm
# -fguess-branch-probability -fident -fif-conversion -fif-conversion2
# -findirect-inlining -finline -finline-functions
# -finline-functions-called-once -finline-small-functions -fipa-cp
# -fipa-pure-const -fipa-reference -fipa-sra -fira-share-save-slots
# -fira-share-spill-slots -fivopts -fkeep-static-consts
# -fleading-underscore -fmath-errno -fmerge-constants -fmerge-debug-strings
# -fmove-loop-invariants -fomit-frame-pointer -foptimize-register-move
# -foptimize-sibling-calls -fpeephole -fpeephole2 -freg-struct-return
# -fregmove -freorder-blocks -freorder-functions -frerun-cse-after-loop
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-insns2 -fshow-column -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-wide-types -fthread-jumps
# -ftoplevel-reorder -ftrapping-math -ftree-builtin-call-dce -ftree-ccp
# -ftree-ch -ftree-copy-prop -ftree-copyrename -ftree-cselim -ftree-dce
# -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-im -ftree-loop-ivcanon -ftree-loop-optimize
# -ftree-parallelize-loops= -ftree-phiprop -ftree-pre -ftree-pta
# -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slp-vectorize
# -ftree-sra -ftree-switch-conversion -ftree-ter -ftree-vect-loop-version
# -ftree-vrp -funit-at-a-time -fvect-cost-model -fverbose-asm
# -fzero-initialized-in-bss -m32 -m96bit-long-double -malign-stringops
# -mfused-madd -mglibc -mieee-fp -mno-fancy-math-387 -mno-red-zone
# -mno-sse4 -mpush-args -msahf -mtls-direct-seg-refs

# Compiler executable checksum: 7ba2dc3c015559b9d16b297ee7f8d354

	.text
	.type	i8k_smm, @function
i8k_smm:
	pushl	%ebp	#
	movl	%eax, %ebp	# regs, regs
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$8, %esp	#,
	movl	(%eax), %eax	# regs_2(D)->eax,
	movl	%eax, 4(%esp)	#, %sfp
	movl	%ebp, %eax	# regs,
#APP
# 148 "drivers/char/i8k.c" 1
	pushl %eax
	movl 0(%eax),%edx
	push %edx
	movl 4(%eax),%ebx
	movl 8(%eax),%ecx
	movl 12(%eax),%edx
	movl 16(%eax),%esi
	movl 20(%eax),%edi
	popl %eax
	out %al,$0xb2
	out %al,$0x84
	xchgl %eax,(%esp)
	movl %ebx,4(%eax)
	movl %ecx,8(%eax)
	movl %edx,12(%eax)
	movl %esi,16(%eax)
	movl %edi,20(%eax)
	popl %edx
	movl %edx,0(%eax)
	lahf
	shrl $8,%eax
	andl $1,%eax

# 0 "" 2
#NO_APP
	testl	%eax, %eax	#
	movl	$-22, %edx	#, D.15130
	movl	%eax, (%esp)	#, %sfp
	jne	.L2	#,
	movl	0(%ebp), %ecx	# regs_2(D)->eax, D.15123
	cmpw	$-1, %cx	#, D.15123
	je	.L2	#,
	cmpl	4(%esp), %ecx	# %sfp, D.15123
	cmovne	%eax, %edx	#,, D.15130
.L2:
	addl	$8, %esp	#,
	movl	%edx, %eax	# D.15130,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_smm, .-i8k_smm
	.type	i8k_get_bios_version, @function
i8k_get_bios_version:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp61
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp62
	movl	%esp, %edi	#, tmp60
	rep stosl
	movl	%esp, %eax	#, tmp63
	movl	$166, (%esp)	#, regs.eax
	call	i8k_smm	#
	movl	$166, %edx	#, tmp65
	testl	%eax, %eax	# D.15225
	cmove	%edx, %eax	# D.15225,, tmp65, D.15225
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_bios_version, .-i8k_get_bios_version
	.type	i8k_get_fn_status, @function
i8k_get_fn_status:
	pushl	%edi	#
	movl	$6, %ecx	#, tmp63
	pushl	%ebx	#
	xorl	%ebx, %ebx	# tmp62
	subl	$24, %esp	#,
	movl	%ebx, %eax	# tmp62,
	movl	%esp, %edi	#, tmp61
	rep stosl
	movl	%esp, %eax	#, tmp64
	movl	$37, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	cmovg	%ebx, %eax	# rc,, tmp62, tmp65
	addl	$24, %esp	#,
	popl	%ebx	#
	popl	%edi	#
	ret
	.size	i8k_get_fn_status, .-i8k_get_fn_status
	.type	i8k_get_power_status, @function
i8k_get_power_status:
	pushl	%edi	#
	movl	$6, %ecx	#, tmp63
	pushl	%ebx	#
	xorl	%ebx, %ebx	# tmp62
	subl	$24, %esp	#,
	movl	%ebx, %eax	# tmp62,
	movl	%esp, %edi	#, tmp61
	rep stosl
	movl	%esp, %eax	#, tmp64
	movl	$105, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	cmovg	%ebx, %eax	# rc,, tmp62, tmp65
	addl	$24, %esp	#,
	popl	%ebx	#
	popl	%edi	#
	ret
	.size	i8k_get_power_status, .-i8k_get_power_status
	.type	i8k_get_fan_status, @function
i8k_get_fan_status:
	pushl	%edi	#
	movl	%eax, %edx	# fan, fan
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp64
	movl	%esp, %edi	#, tmp63
	movl	$6, %ecx	#, tmp65
	rep stosl
	andl	$255, %edx	#, tmp66
	movl	%esp, %eax	#, tmp67
	movl	%edx, 4(%esp)	# tmp66, regs.ebx
	movl	$163, (%esp)	#, regs.eax
	call	i8k_smm	#
	movl	$163, %edx	#, tmp69
	testl	%eax, %eax	# D.15134
	cmove	%edx, %eax	# D.15134,, tmp69, D.15134
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_fan_status, .-i8k_get_fan_status
	.type	i8k_get_fan_speed, @function
i8k_get_fan_speed:
	pushl	%edi	#
	movl	%eax, %edx	# fan, fan
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp67
	movl	%esp, %edi	#, tmp66
	movl	$6, %ecx	#, tmp68
	rep stosl
	andl	$255, %edx	#, tmp69
	movl	%esp, %eax	#, tmp70
	movl	$675, (%esp)	#, regs.eax
	movl	%edx, 4(%esp)	# tmp69, regs.ebx
	call	i8k_smm	#
	testl	%eax, %eax	# D.15145
	jne	.L13	#,
	imull	$675, fan_mult, %eax	#, fan_mult, D.15145
.L13:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_fan_speed, .-i8k_get_fan_speed
	.type	i8k_get_dell_signature, @function
i8k_get_dell_signature:
	pushl	%edi	#
	movl	%eax, %edx	# req_fn, req_fn
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp63
	movl	%esp, %edi	#, tmp62
	movl	$6, %ecx	#, tmp64
	rep stosl
	movl	%esp, %eax	#, tmp65
	movl	%edx, (%esp)	# req_fn, regs.eax
	call	i8k_smm	#
	movl	$-1, %edx	#, tmp67
	testl	%eax, %eax	# rc
	cmovns	%edx, %eax	# rc,, tmp67, rc
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_dell_signature, .-i8k_get_dell_signature
	.type	i8k_open_fs, @function
i8k_open_fs:
	movl	%edx, %eax	# file, file
	xorl	%ecx, %ecx	#
	movl	$i8k_proc_show, %edx	#,
	jmp	single_open	#
	.size	i8k_open_fs, .-i8k_open_fs
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"?"
	.text
	.type	i8k_get_dmi_data, @function
i8k_get_dmi_data:
	call	dmi_get_system_info	#
	testl	%eax, %eax	# dmi_data
	je	.L20	#,
	cmpb	$0, (%eax)	#,* dmi_data
	movl	$.LC0, %edx	#, tmp63
	cmove	%edx, %eax	# dmi_data,, tmp63, dmi_data
	ret
.L20:
	movl	$.LC0, %eax	#, dmi_data
	ret
	.size	i8k_get_dmi_data, .-i8k_get_dmi_data
	.type	i8k_get_temp.clone.1, @function
i8k_get_temp.clone.1:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp61
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp62
	movl	%esp, %edi	#, tmp60
	rep stosl
	movl	%esp, %eax	#, tmp63
	movl	$4259, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	js	.L22	#,
	movl	prev.12857, %eax	# prev, rc
	movl	$127, prev.12857	#, prev
.L22:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_temp.clone.1, .-i8k_get_temp.clone.1
	.section	.rodata.str1.1
.LC1:
	.string	"1.0"
.LC2:
	.string	"%s %s %s %d %d %d %d %d %d %d\n"
	.text
	.type	i8k_proc_show, @function
i8k_proc_show:
	pushl	%ebp	#
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	orl	$-1, %ebx	#, ac_power
	subl	$16, %esp	#,
	movl	%eax, 12(%esp)	# seq, %sfp
	call	i8k_get_temp.clone.1	#
	movl	%eax, (%esp)	#, %sfp
	movl	$1, %eax	#,
	call	i8k_get_fan_status	#
	movl	%eax, 4(%esp)	#, %sfp
	xorl	%eax, %eax	#
	call	i8k_get_fan_status	#
	movl	%eax, %esi	#, right_fan
	movl	$1, %eax	#,
	call	i8k_get_fan_speed	#
	movl	%eax, %edi	#, left_speed
	xorl	%eax, %eax	#
	call	i8k_get_fan_speed	#
	movl	%eax, %ebp	#, right_speed
	call	i8k_get_fn_status	#
	cmpl	$0, power_status	#, power_status
	movl	%eax, 8(%esp)	#, %sfp
	je	.L24	#,
	call	i8k_get_power_status	#
	movl	%eax, %ebx	#, ac_power
.L24:
	movl	$7, %eax	#,
	call	i8k_get_dmi_data	#
	pushl	8(%esp)	# %sfp
	pushl	%ebx	# ac_power
	pushl	%ebp	# right_speed
	pushl	%edi	# left_speed
	pushl	%esi	# right_fan
	pushl	24(%esp)	# %sfp
	pushl	24(%esp)	# %sfp
	pushl	%eax	# D.15110
	pushl	$bios_version	#
	pushl	$.LC1	#
	pushl	$.LC2	#
	pushl	56(%esp)	# %sfp
	call	seq_printf	#
	addl	$64, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_proc_show, .-i8k_proc_show
	.type	copy_from_user.clone.2, @function
copy_from_user.clone.2:
	movl	$4, %ecx	#,
	jmp	_copy_from_user	#
	.size	copy_from_user.clone.2, .-copy_from_user.clone.2
	.type	i8k_ioctl, @function
i8k_ioctl:
	pushl	%ebp	#
	movl	%edx, %ebp	# cmd, cmd
	pushl	%edi	#
	pushl	%esi	#
	movl	$-22, %esi	#, ret
	pushl	%ebx	#
	movl	%ecx, %ebx	# arg, arg
	subl	$48, %esp	#,
	testl	%ecx, %ecx	# arg
	movl	$0, 44(%esp)	#, val
	je	.L28	#,
	cmpl	$-2147194493, %edx	#, cmd
	je	.L32	#,
	ja	.L37	#,
	cmpl	$-2147194495, %edx	#, cmd
	je	.L30	#,
	ja	.L31	#,
	cmpl	$-2147194496, %edx	#, cmd
	jne	.L46	#,
	jmp	.L58	#
.L37:
	cmpl	$-1073452667, %edx	#, cmd
	je	.L34	#,
	ja	.L38	#,
	cmpl	$-2147194492, %edx	#, cmd
	jne	.L46	#,
	jmp	.L59	#
.L38:
	cmpl	$-1073452666, %edx	#, cmd
	je	.L35	#,
	cmpl	$-1073452665, %edx	#, cmd
	jne	.L46	#,
	jmp	.L60	#
.L58:
	call	i8k_get_bios_version	#
	jmp	.L41	#
.L30:
	leal	24(%esp), %esi	#, tmp93
	xorl	%eax, %eax	# tmp95
	movl	%esi, %edi	# tmp93, tmp94
	movl	$4, %ecx	#, tmp96
	rep stosl
	movb	$7, %al	#,
	call	i8k_get_dmi_data	#
	movl	$16, %ecx	#,
	movl	%eax, %edx	# D.15468,
	movl	%esi, %eax	# tmp93,
	call	strlcpy	#
	jmp	.L39	#
.L32:
	call	i8k_get_fn_status	#
	jmp	.L41	#
.L31:
	call	i8k_get_power_status	#
	jmp	.L41	#
.L59:
	call	i8k_get_temp.clone.1	#
	jmp	.L41	#
.L34:
	leal	44(%esp), %eax	#, tmp98
	movl	%ecx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15473
	jne	.L28	#,
	movl	44(%esp), %eax	# val,
	call	i8k_get_fan_speed	#
	jmp	.L41	#
.L35:
	leal	44(%esp), %eax	#, tmp100
	movl	%ecx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15476
	jne	.L28	#,
	movl	44(%esp), %eax	# val,
	jmp	.L57	#
.L60:
	cmpl	$0, restricted	#, restricted
	je	.L40	#,
	movl	$21, %eax	#,
	orl	$-1, %esi	#, ret
	call	capable	#
	testl	%eax, %eax	# D.15479
	je	.L28	#,
.L40:
	leal	44(%esp), %eax	#, tmp102
	movl	%ebx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15480
	jne	.L28	#,
	leal	4(%ebx), %edx	#, tmp103
	leal	40(%esp), %eax	#, tmp104
	call	copy_from_user.clone.2	#
	testl	%eax, %eax	# D.15482
	jne	.L28	#,
	movl	%esp, %edi	#, tmp105
	movl	$6, %ecx	#, tmp107
	movl	40(%esp), %edx	# speed, speed.19
	rep stosl
	movl	44(%esp), %esi	# val, val.15
	movl	$419, (%esp)	#, regs.eax
	cmpl	$2, %edx	#, speed.19
	movb	$2, %cl	#,
	cmovle	%edx, %ecx	# speed.19,, speed
	movl	%esi, %edx	# val.15, tmp112
	testl	%ecx, %ecx	# speed
	cmovns	%ecx, %eax	# speed,, tmp113
	andl	$255, %edx	#, tmp112
	sall	$8, %eax	#, tmp113
	orl	%edx, %eax	# tmp112, tmp113
	movl	%eax, 4(%esp)	# tmp113, regs.ebx
	movl	%esp, %eax	#, tmp114
	call	i8k_smm	#
	testl	%eax, %eax	# D.15487
	jne	.L41	#,
	movl	%esi, %eax	# val.15,
.L57:
	call	i8k_get_fan_status	#
.L41:
	movl	%eax, 44(%esp)	# D.15487, val
.L39:
	movl	44(%esp), %esi	# val, ret
	testl	%esi, %esi	# ret
	js	.L28	#,
	cmpl	$-2147194496, %ebp	#, cmd
	je	.L55	#,
	cmpl	$-2147194495, %ebp	#, cmd
	jne	.L55	#,
	leal	24(%esp), %edx	#, tmp116
	movl	$16, %ecx	#,
.L56:
	movl	%ebx, %eax	# arg,
	call	copy_to_user	#
	cmpl	$1, %eax	#, D.15485
	sbbl	%esi, %esi	# ret
	notl	%esi	# ret
	andl	$-14, %esi	#, ret
	jmp	.L28	#
.L55:
	leal	44(%esp), %edx	#, tmp117
	movl	$4, %ecx	#,
	jmp	.L56	#
.L46:
	movl	$-22, %esi	#, ret
.L28:
	addl	$48, %esp	#,
	movl	%esi, %eax	# ret,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_ioctl, .-i8k_ioctl
	.section	.rodata.str1.1
.LC3:
	.string	"<6>i8k: not running on a supported Dell system.\n"
.LC4:
	.string	"<6>i8k: vendor=%s, model=%s, version=%s\n"
.LC5:
	.string	"<3>i8k: unable to get SMM Dell signature\n"
.LC6:
	.string	"<4>i8k: unable to get SMM BIOS version\n"
.LC7:
	.string	"<4>i8k: BIOS version mismatch: %s != %s\n"
.LC8:
	.string	"1.14 21/02/2005"
.LC9:
	.string	"<6>Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n"
.LC10:
	.string	"i8k"
	.section	.init.text,"ax",@progbits
	.type	i8k_init, @function
i8k_init:
	pushl	%esi	#
	movl	$i8k_dmi_table, %eax	#,
	pushl	%ebx	#
	subl	$4, %esp	#,
	call	dmi_check_system	#
	testl	%eax, %eax	# D.15529
	jne	.L62	#,
	cmpl	$0, ignore_dmi	#, ignore_dmi
	jne	.L63	#,
	cmpl	$0, force	#, force
	movl	$-19, %eax	#, D.15099
	je	.L64	#,
.L63:
	pushl	$.LC3	#
	call	printk	#
	movl	$2, %eax	#,
	call	i8k_get_dmi_data	#
	movl	%eax, %esi	#, D.15525
	movl	$5, %eax	#,
	call	i8k_get_dmi_data	#
	movl	%eax, %ebx	#, D.15524
	movl	$4, %eax	#,
	call	i8k_get_dmi_data	#
	pushl	%esi	# D.15525
	pushl	%ebx	# D.15524
	pushl	%eax	# D.15523
	pushl	$.LC4	#
	call	printk	#
	addl	$20, %esp	#,
.L62:
	movl	$2, %eax	#,
	call	i8k_get_dmi_data	#
	movl	$4, %ecx	#,
	movl	%eax, %edx	# D.15522,
	movl	$bios_version, %eax	#,
	call	strlcpy	#
	movl	$65187, %eax	#,
	call	i8k_get_dell_signature	#
	testl	%eax, %eax	# D.15521
	je	.L65	#,
	movl	$65443, %eax	#,
	call	i8k_get_dell_signature	#
	testl	%eax, %eax	# D.15520
	je	.L65	#,
	pushl	$.LC5	#
	call	printk	#
	movl	$-19, %eax	#, D.15099
	cmpl	$0, force	#, force
	popl	%edx	#
	je	.L64	#,
.L65:
	call	i8k_get_bios_version	#
	testl	%eax, %eax	# version
	jg	.L66	#,
	pushl	$.LC6	#
	call	printk	#
	popl	%eax	#
	jmp	.L67	#
.L66:
	movl	%eax, %edx	# version, tmp79
	sarl	$16, %edx	#, tmp79
	movb	%dl, (%esp)	# tmp79, buff
	movl	%eax, %edx	# version, tmp80
	sarl	$8, %edx	#, tmp80
	movb	%al, 2(%esp)	# version, buff
	movl	$2, %eax	#,
	movb	%dl, 1(%esp)	# tmp80, buff
	movb	$0, 3(%esp)	#, buff
	call	dmi_get_system_info	#
	testl	%eax, %eax	# D.15514
	jne	.L68	#,
	movl	%esp, %edx	#, tmp81
	movl	$4, %ecx	#,
	movl	$bios_version, %eax	#,
	call	strlcpy	#
.L68:
	movl	$4, %ecx	#,
	movl	$bios_version, %edx	#,
	movl	%esp, %eax	#,
	movl	%esp, %ebx	#, tmp82
	call	strncmp	#
	testl	%eax, %eax	# D.15513
	je	.L67	#,
	pushl	$bios_version	#
	pushl	%ebx	# tmp82
	pushl	$.LC7	#
	call	printk	#
	addl	$12, %esp	#,
	jmp	.L67	#
.L74:
	pushl	$.LC8	#
	pushl	$.LC9	#
	call	printk	#
	xorl	%eax, %eax	# D.15099
	popl	%ebx	#
	popl	%esi	#
.L64:
	addl	$4, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	ret
.L67:
	pushl	$0	#
	xorl	%ecx, %ecx	#
	xorl	%edx, %edx	#
	movl	$.LC10, %eax	#,
	pushl	$i8k_fops	#
	call	proc_create_data	#
	movl	%eax, %edx	#, proc_i8k
	testl	%edx, %edx	# proc_i8k
	popl	%eax	#
	movl	$-2, %eax	#, D.15099
	popl	%ecx	#
	je	.L64	#,
	jmp	.L74	#
	.size	i8k_init, .-i8k_init
	.section	.exit.text,"ax",@progbits
	.type	i8k_exit, @function
i8k_exit:
	xorl	%edx, %edx	#
	movl	$.LC10, %eax	#,
	jmp	remove_proc_entry	#
	.size	i8k_exit, .-i8k_exit
	.section	.modinfo,"a",@progbits
	.align 4
	.type	__mod_fan_mult83, @object
	.size	__mod_fan_mult83, 48
__mod_fan_mult83:
	.string	"parm=fan_mult:Factor to multiply fan speed with"
	.align 4
	.type	__mod_fan_multtype82, @object
	.size	__mod_fan_multtype82, 22
__mod_fan_multtype82:
	.string	"parmtype=fan_mult:int"
	.section	__param,"a",@progbits
	.align 4
	.type	__param_fan_mult, @object
	.size	__param_fan_mult, 16
__param_fan_mult:
# name:
	.long	__param_str_fan_mult
# ops:
	.long	param_ops_int
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	fan_mult
	.section	.modinfo
	.align 4
	.type	__mod_power_status79, @object
	.size	__mod_power_status79, 51
__mod_power_status79:
	.string	"parm=power_status:Report power status in /proc/i8k"
	.align 4
	.type	__mod_power_statustype78, @object
	.size	__mod_power_statustype78, 27
__mod_power_statustype78:
	.string	"parmtype=power_status:bool"
	.section	__param
	.align 4
	.type	__param_power_status, @object
	.size	__param_power_status, 16
__param_power_status:
# name:
	.long	__param_str_power_status
# ops:
	.long	param_ops_bool
# perm:
	.value	384
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	power_status
	.section	.modinfo
	.align 4
	.type	__mod_restricted75, @object
	.size	__mod_restricted75, 62
__mod_restricted75:
	.string	"parm=restricted:Allow fan control if SYS_ADMIN capability set"
	.align 4
	.type	__mod_restrictedtype74, @object
	.size	__mod_restrictedtype74, 25
__mod_restrictedtype74:
	.string	"parmtype=restricted:bool"
	.section	__param
	.align 4
	.type	__param_restricted, @object
	.size	__param_restricted, 16
__param_restricted:
# name:
	.long	__param_str_restricted
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	restricted
	.section	.modinfo
	.align 4
	.type	__mod_ignore_dmi71, @object
	.size	__mod_ignore_dmi71, 74
__mod_ignore_dmi71:
	.string	"parm=ignore_dmi:Continue probing hardware even if DMI data does not match"
	.align 4
	.type	__mod_ignore_dmitype70, @object
	.size	__mod_ignore_dmitype70, 25
__mod_ignore_dmitype70:
	.string	"parmtype=ignore_dmi:bool"
	.section	__param
	.align 4
	.type	__param_ignore_dmi, @object
	.size	__param_ignore_dmi, 16
__param_ignore_dmi:
# name:
	.long	__param_str_ignore_dmi
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	ignore_dmi
	.section	.modinfo
	.align 4
	.type	__mod_force67, @object
	.size	__mod_force67, 63
__mod_force67:
	.string	"parm=force:Force loading without checking for supported models"
	.align 4
	.type	__mod_forcetype66, @object
	.size	__mod_forcetype66, 20
__mod_forcetype66:
	.string	"parmtype=force:bool"
	.section	__param
	.align 4
	.type	__param_force, @object
	.size	__param_force, 16
__param_force:
# name:
	.long	__param_str_force
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	force
	.section	.modinfo
	.align 4
	.type	__mod_license63, @object
	.size	__mod_license63, 12
__mod_license63:
	.string	"license=GPL"
	.align 4
	.type	__mod_description62, @object
	.size	__mod_description62, 58
__mod_description62:
	.string	"description=Driver for accessing SMM BIOS on Dell laptops"
	.align 4
	.type	__mod_author61, @object
	.size	__mod_author61, 41
__mod_author61:
	.string	"author=Massimo Dal Zotto (dz@debian.org)"
	.data
	.align 4
	.type	fan_mult, @object
	.size	fan_mult, 4
fan_mult:
	.long	30
	.local	power_status
	.comm	power_status,4,4
	.local	restricted
	.comm	restricted,4,4
	.local	ignore_dmi
	.comm	ignore_dmi,4,4
	.local	force
	.comm	force,4,4
	.section	.rodata
	.align 4
	.type	i8k_fops, @object
	.size	i8k_fops, 100
i8k_fops:
# owner:
	.long	__this_module
# llseek:
	.long	seq_lseek
# read:
	.long	seq_read
# unlocked_ioctl:
	.zero	20
	.long	i8k_ioctl
# open:
	.zero	8
	.long	i8k_open_fs
# release:
	.zero	4
	.long	single_release
	.zero	44
	.local	bios_version
	.comm	bios_version,4,4
	.local	prev.12857
	.comm	prev.12857,4,4
	.section	.rodata.str1.1
.LC11:
	.string	"Dell Inspiron"
.LC12:
	.string	"Dell Latitude"
.LC13:
	.string	"Dell Inspiron 2"
.LC14:
	.string	"Dell Latitude 2"
.LC15:
	.string	"Dell Inspiron 3"
.LC16:
	.string	"Dell Precision"
.LC17:
	.string	"Dell Vostro"
	.section	.init.data,"aw",@progbits
	.align 4
	.type	i8k_dmi_table, @object
	.size	i8k_dmi_table, 2988
i8k_dmi_table:
# ident:
	.zero	4
	.long	.LC11
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Computer"
	.zero	65
# slot:
	.byte	5
# substr:
	.string	"Inspiron"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC12
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Computer"
	.zero	65
# slot:
	.byte	5
# substr:
	.string	"Latitude"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC13
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Inspiron"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC14
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Latitude"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC15
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"MM061"
	.zero	73
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC15
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"MP061"
	.zero	73
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC16
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Precision"
	.zero	69
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC17
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Vostro"
	.zero	72
	.zero	160
	.zero	4
	.zero	332
	.section	.rodata
	.align 4
	.type	__param_str_fan_mult, @object
	.size	__param_str_fan_mult, 9
__param_str_fan_mult:
	.string	"fan_mult"
	.align 4
	.type	__param_str_power_status, @object
	.size	__param_str_power_status, 13
__param_str_power_status:
	.string	"power_status"
	.align 4
	.type	__param_str_restricted, @object
	.size	__param_str_restricted, 11
__param_str_restricted:
	.string	"restricted"
	.align 4
	.type	__param_str_ignore_dmi, @object
	.size	__param_str_ignore_dmi, 11
__param_str_ignore_dmi:
	.string	"ignore_dmi"
	.align 4
	.type	__param_str_force, @object
	.size	__param_str_force, 6
__param_str_force:
	.string	"force"
.globl init_module
	.set	init_module,i8k_init
.globl cleanup_module
	.set	cleanup_module,i8k_exit
	.ident	"GCC: (GNU) 4.5.1"
	.section	.note.GNU-stack,"",@progbits

--------------050903020504030201070704
Content-Type: text/plain;
 name="i8k.s-2.6.36+patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i8k.s-2.6.36+patch"

	.file	"i8k.c"
# GNU C (GCC) version 4.5.1 (i486-slackware-linux)
#	compiled by GNU C version 4.5.1, GMP version 5.0.1, MPFR version 2.4.2-p3, MPC version 0.8.2
# GGC heuristics: --param ggc-min-expand=81 --param ggc-min-heapsize=96817
# options passed:  -nostdinc -I/usr/src/linux-2.6.36/arch/x86/include
# -Iinclude -D__KERNEL__ -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
# -DCONFIG_AS_CFI_SECTIONS=1 -DMODULE -DKBUILD_STR(s)=#s
# -DKBUILD_BASENAME=KBUILD_STR(i8k) -DKBUILD_MODNAME=KBUILD_STR(i8k)
# -isystem /usr/lib/gcc/i486-slackware-linux/4.5.1/include -include
# include/generated/autoconf.h -MD drivers/char/.i8k.s.d drivers/char/i8k.c
# -m32 -msoft-float -mregparm=3 -mpreferred-stack-boundary=2 -march=i686
# -mtune=pentium3 -mtune=generic -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
# -auxbase-strip drivers/char/i8k.s -Os -Wall -Wundef -Wstrict-prototypes
# -Wno-trigraphs -Werror-implicit-function-declaration -Wno-format-security
# -Wno-sign-compare -Wframe-larger-than=1024 -Wdeclaration-after-statement
# -Wno-pointer-sign -fno-strict-aliasing -fno-common
# -fno-delete-null-pointer-checks -freg-struct-return -ffreestanding
# -fno-asynchronous-unwind-tables -fno-stack-protector -fomit-frame-pointer
# -fno-strict-overflow -fconserve-stack -fverbose-asm
# options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
# -fbranch-count-reg -fcaller-saves -fcprop-registers -fcrossjumping
# -fcse-follow-jumps -fdefer-pop -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -fexpensive-optimizations
# -fforward-propagate -ffunction-cse -fgcse -fgcse-lm
# -fguess-branch-probability -fident -fif-conversion -fif-conversion2
# -findirect-inlining -finline -finline-functions
# -finline-functions-called-once -finline-small-functions -fipa-cp
# -fipa-pure-const -fipa-reference -fipa-sra -fira-share-save-slots
# -fira-share-spill-slots -fivopts -fkeep-static-consts
# -fleading-underscore -fmath-errno -fmerge-constants -fmerge-debug-strings
# -fmove-loop-invariants -fomit-frame-pointer -foptimize-register-move
# -foptimize-sibling-calls -fpeephole -fpeephole2 -freg-struct-return
# -fregmove -freorder-blocks -freorder-functions -frerun-cse-after-loop
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-insns2 -fshow-column -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-wide-types -fthread-jumps
# -ftoplevel-reorder -ftrapping-math -ftree-builtin-call-dce -ftree-ccp
# -ftree-ch -ftree-copy-prop -ftree-copyrename -ftree-cselim -ftree-dce
# -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-im -ftree-loop-ivcanon -ftree-loop-optimize
# -ftree-parallelize-loops= -ftree-phiprop -ftree-pre -ftree-pta
# -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slp-vectorize
# -ftree-sra -ftree-switch-conversion -ftree-ter -ftree-vect-loop-version
# -ftree-vrp -funit-at-a-time -fvect-cost-model -fverbose-asm
# -fzero-initialized-in-bss -m32 -m96bit-long-double -malign-stringops
# -mfused-madd -mglibc -mieee-fp -mno-fancy-math-387 -mno-red-zone
# -mno-sse4 -mpush-args -msahf -mtls-direct-seg-refs

# Compiler executable checksum: 7ba2dc3c015559b9d16b297ee7f8d354

	.text
	.type	i8k_smm, @function
i8k_smm:
	pushl	%ebp	#
	movl	%eax, %ebp	# regs, regs
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	subl	$8, %esp	#,
	movl	(%eax), %eax	# regs_2(D)->eax,
	movl	%eax, 4(%esp)	#, %sfp
	movl	%ebp, %eax	# regs,
#APP
# 148 "drivers/char/i8k.c" 1
	pushl %eax
	movl 0(%eax),%edx
	push %edx
	movl 4(%eax),%ebx
	movl 8(%eax),%ecx
	movl 12(%eax),%edx
	movl 16(%eax),%esi
	movl 20(%eax),%edi
	popl %eax
	out %al,$0xb2
	out %al,$0x84
	xchgl %eax,(%esp)
	movl %ebx,4(%eax)
	movl %ecx,8(%eax)
	movl %edx,12(%eax)
	movl %esi,16(%eax)
	movl %edi,20(%eax)
	popl %edx
	movl %edx,0(%eax)
	lahf
	shrl $8,%eax
	andl $1,%eax

# 0 "" 2
#NO_APP
	testl	%eax, %eax	#
	movl	$-22, %edx	#, D.15130
	movl	%eax, (%esp)	#, %sfp
	jne	.L2	#,
	movl	0(%ebp), %ecx	# regs_2(D)->eax, D.15123
	cmpw	$-1, %cx	#, D.15123
	je	.L2	#,
	cmpl	4(%esp), %ecx	# %sfp, D.15123
	cmovne	%eax, %edx	#,, D.15130
.L2:
	addl	$8, %esp	#,
	movl	%edx, %eax	# D.15130,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_smm, .-i8k_smm
	.type	i8k_get_bios_version, @function
i8k_get_bios_version:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp62
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp63
	movl	%esp, %edi	#, tmp61
	rep stosl
	movl	%esp, %eax	#, tmp64
	movl	$166, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# D.15225
	cmove	(%esp), %eax	# regs.eax,, D.15225
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_bios_version, .-i8k_get_bios_version
	.type	i8k_get_fn_status, @function
i8k_get_fn_status:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp65
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp66
	movl	%esp, %edi	#, tmp64
	rep stosl
	movl	%esp, %eax	#, tmp67
	movl	$37, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	js	.L9	#,
	movl	(%esp), %eax	# regs.eax, csui.31
	shrl	$8, %eax	#, csui.31
	andl	$7, %eax	#, csui.31
	leal	-1(%eax), %edx	#, csui.31
	xorl	%eax, %eax	# rc
	cmpl	$3, %edx	#, csui.31
	ja	.L9	#,
	movl	CSWTCH.30(,%edx,4), %eax	# CSWTCH.30, rc
.L9:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_fn_status, .-i8k_get_fn_status
	.type	i8k_get_power_status, @function
i8k_get_power_status:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp63
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp64
	movl	%esp, %edi	#, tmp62
	rep stosl
	movl	%esp, %eax	#, tmp65
	movl	$105, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	js	.L12	#,
	xorl	%eax, %eax	# rc
	cmpb	$5, (%esp)	#, regs.eax
	sete	%al	#, rc
.L12:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_power_status, .-i8k_get_power_status
	.type	i8k_get_fan_status, @function
i8k_get_fan_status:
	pushl	%edi	#
	movl	%eax, %edx	# fan, fan
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp66
	movl	%esp, %edi	#, tmp65
	movl	$6, %ecx	#, tmp67
	rep stosl
	andl	$255, %edx	#, tmp68
	movl	%esp, %eax	#, tmp69
	movl	$163, (%esp)	#, regs.eax
	movl	%edx, 4(%esp)	# tmp68, regs.ebx
	call	i8k_smm	#
	testl	%eax, %eax	# D.15134
	jne	.L14	#,
	movl	(%esp), %eax	# regs.eax, regs.eax
	andl	$255, %eax	#, D.15134
.L14:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_fan_status, .-i8k_get_fan_status
	.type	i8k_get_fan_speed, @function
i8k_get_fan_speed:
	pushl	%edi	#
	movl	%eax, %edx	# fan, fan
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp69
	movl	%esp, %edi	#, tmp68
	movl	$6, %ecx	#, tmp70
	rep stosl
	andl	$255, %edx	#, tmp71
	movl	%esp, %eax	#, tmp72
	movl	$675, (%esp)	#, regs.eax
	movl	%edx, 4(%esp)	# tmp71, regs.ebx
	call	i8k_smm	#
	testl	%eax, %eax	# D.15145
	jne	.L16	#,
	movl	(%esp), %eax	# regs.eax, regs.eax
	andl	$65535, %eax	#, D.15145
	imull	fan_mult, %eax	# fan_mult, D.15145
.L16:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_fan_speed, .-i8k_get_fan_speed
	.type	i8k_get_dell_signature, @function
i8k_get_dell_signature:
	pushl	%edi	#
	movl	%eax, %edx	# req_fn, req_fn
	subl	$24, %esp	#,
	xorl	%eax, %eax	# tmp65
	movl	%esp, %edi	#, tmp64
	movl	$6, %ecx	#, tmp66
	rep stosl
	movl	%esp, %eax	#, tmp67
	movl	%edx, (%esp)	# req_fn, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	js	.L18	#,
	orl	$-1, %eax	#, rc
	cmpl	$1145651527, (%esp)	#, regs.eax
	jne	.L18	#,
	xorl	%eax, %eax	# rc
	cmpl	$1145392204, 12(%esp)	#, regs.edx
	sete	%al	#, rc
	decl	%eax	# rc
.L18:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_dell_signature, .-i8k_get_dell_signature
	.type	i8k_open_fs, @function
i8k_open_fs:
	movl	%edx, %eax	# file, file
	xorl	%ecx, %ecx	#
	movl	$i8k_proc_show, %edx	#,
	jmp	single_open	#
	.size	i8k_open_fs, .-i8k_open_fs
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"?"
	.text
	.type	i8k_get_dmi_data, @function
i8k_get_dmi_data:
	call	dmi_get_system_info	#
	testl	%eax, %eax	# dmi_data
	je	.L24	#,
	cmpb	$0, (%eax)	#,* dmi_data
	movl	$.LC0, %edx	#, tmp63
	cmove	%edx, %eax	# dmi_data,, tmp63, dmi_data
	ret
.L24:
	movl	$.LC0, %eax	#, dmi_data
	ret
	.size	i8k_get_dmi_data, .-i8k_get_dmi_data
	.type	i8k_get_temp.clone.1, @function
i8k_get_temp.clone.1:
	pushl	%edi	#
	xorl	%eax, %eax	# tmp63
	subl	$24, %esp	#,
	movl	$6, %ecx	#, tmp64
	movl	%esp, %edi	#, tmp62
	rep stosl
	movl	%esp, %eax	#, tmp65
	movl	$4259, (%esp)	#, regs.eax
	call	i8k_smm	#
	testl	%eax, %eax	# rc
	js	.L26	#,
	movl	(%esp), %eax	# regs.eax, regs.eax
	andl	$255, %eax	#, rc
	cmpl	$127, %eax	#, rc
	jle	.L27	#,
	movl	prev.12857, %eax	# prev, rc
	movl	$127, prev.12857	#, prev
	jmp	.L26	#
.L27:
	movl	%eax, prev.12857	# rc, prev
.L26:
	addl	$24, %esp	#,
	popl	%edi	#
	ret
	.size	i8k_get_temp.clone.1, .-i8k_get_temp.clone.1
	.section	.rodata.str1.1
.LC1:
	.string	"1.0"
.LC2:
	.string	"%s %s %s %d %d %d %d %d %d %d\n"
	.text
	.type	i8k_proc_show, @function
i8k_proc_show:
	pushl	%ebp	#
	pushl	%edi	#
	pushl	%esi	#
	pushl	%ebx	#
	orl	$-1, %ebx	#, ac_power
	subl	$16, %esp	#,
	movl	%eax, 12(%esp)	# seq, %sfp
	call	i8k_get_temp.clone.1	#
	movl	%eax, (%esp)	#, %sfp
	movl	$1, %eax	#,
	call	i8k_get_fan_status	#
	movl	%eax, 4(%esp)	#, %sfp
	xorl	%eax, %eax	#
	call	i8k_get_fan_status	#
	movl	%eax, %esi	#, right_fan
	movl	$1, %eax	#,
	call	i8k_get_fan_speed	#
	movl	%eax, %edi	#, left_speed
	xorl	%eax, %eax	#
	call	i8k_get_fan_speed	#
	movl	%eax, %ebp	#, right_speed
	call	i8k_get_fn_status	#
	cmpl	$0, power_status	#, power_status
	movl	%eax, 8(%esp)	#, %sfp
	je	.L29	#,
	call	i8k_get_power_status	#
	movl	%eax, %ebx	#, ac_power
.L29:
	movl	$7, %eax	#,
	call	i8k_get_dmi_data	#
	pushl	8(%esp)	# %sfp
	pushl	%ebx	# ac_power
	pushl	%ebp	# right_speed
	pushl	%edi	# left_speed
	pushl	%esi	# right_fan
	pushl	24(%esp)	# %sfp
	pushl	24(%esp)	# %sfp
	pushl	%eax	# D.15110
	pushl	$bios_version	#
	pushl	$.LC1	#
	pushl	$.LC2	#
	pushl	56(%esp)	# %sfp
	call	seq_printf	#
	addl	$64, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_proc_show, .-i8k_proc_show
	.type	copy_from_user.clone.2, @function
copy_from_user.clone.2:
	movl	$4, %ecx	#,
	jmp	_copy_from_user	#
	.size	copy_from_user.clone.2, .-copy_from_user.clone.2
	.type	i8k_ioctl, @function
i8k_ioctl:
	pushl	%ebp	#
	movl	%edx, %ebp	# cmd, cmd
	pushl	%edi	#
	pushl	%esi	#
	movl	$-22, %esi	#, ret
	pushl	%ebx	#
	movl	%ecx, %ebx	# arg, arg
	subl	$48, %esp	#,
	testl	%ecx, %ecx	# arg
	movl	$0, 44(%esp)	#, val
	je	.L33	#,
	cmpl	$-2147194493, %edx	#, cmd
	je	.L37	#,
	ja	.L42	#,
	cmpl	$-2147194495, %edx	#, cmd
	je	.L35	#,
	ja	.L36	#,
	cmpl	$-2147194496, %edx	#, cmd
	jne	.L51	#,
	jmp	.L63	#
.L42:
	cmpl	$-1073452667, %edx	#, cmd
	je	.L39	#,
	ja	.L43	#,
	cmpl	$-2147194492, %edx	#, cmd
	jne	.L51	#,
	jmp	.L64	#
.L43:
	cmpl	$-1073452666, %edx	#, cmd
	je	.L40	#,
	cmpl	$-1073452665, %edx	#, cmd
	jne	.L51	#,
	jmp	.L65	#
.L63:
	call	i8k_get_bios_version	#
	jmp	.L46	#
.L35:
	leal	24(%esp), %esi	#, tmp93
	xorl	%eax, %eax	# tmp95
	movl	%esi, %edi	# tmp93, tmp94
	movl	$4, %ecx	#, tmp96
	rep stosl
	movb	$7, %al	#,
	call	i8k_get_dmi_data	#
	movl	$16, %ecx	#,
	movl	%eax, %edx	# D.15467,
	movl	%esi, %eax	# tmp93,
	call	strlcpy	#
	jmp	.L44	#
.L37:
	call	i8k_get_fn_status	#
	jmp	.L46	#
.L36:
	call	i8k_get_power_status	#
	jmp	.L46	#
.L64:
	call	i8k_get_temp.clone.1	#
	jmp	.L46	#
.L39:
	leal	44(%esp), %eax	#, tmp98
	movl	%ecx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15472
	jne	.L33	#,
	movl	44(%esp), %eax	# val,
	call	i8k_get_fan_speed	#
	jmp	.L46	#
.L40:
	leal	44(%esp), %eax	#, tmp100
	movl	%ecx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15475
	jne	.L33	#,
	movl	44(%esp), %eax	# val,
	jmp	.L62	#
.L65:
	cmpl	$0, restricted	#, restricted
	je	.L45	#,
	movl	$21, %eax	#,
	orl	$-1, %esi	#, ret
	call	capable	#
	testl	%eax, %eax	# D.15478
	je	.L33	#,
.L45:
	leal	44(%esp), %eax	#, tmp102
	movl	%ebx, %edx	# arg,
	call	copy_from_user.clone.2	#
	movl	$-14, %esi	#, ret
	testl	%eax, %eax	# D.15479
	jne	.L33	#,
	leal	4(%ebx), %edx	#, tmp103
	leal	40(%esp), %eax	#, tmp104
	call	copy_from_user.clone.2	#
	testl	%eax, %eax	# D.15481
	jne	.L33	#,
	movl	%esp, %edi	#, tmp105
	movl	$6, %ecx	#, tmp107
	movl	40(%esp), %edx	# speed, speed.19
	rep stosl
	movl	44(%esp), %esi	# val, val.15
	movl	$419, (%esp)	#, regs.eax
	cmpl	$2, %edx	#, speed.19
	movb	$2, %cl	#,
	cmovle	%edx, %ecx	# speed.19,, speed
	movl	%esi, %edx	# val.15, tmp112
	testl	%ecx, %ecx	# speed
	cmovns	%ecx, %eax	# speed,, tmp113
	andl	$255, %edx	#, tmp112
	sall	$8, %eax	#, tmp113
	orl	%edx, %eax	# tmp112, tmp113
	movl	%eax, 4(%esp)	# tmp113, regs.ebx
	movl	%esp, %eax	#, tmp114
	call	i8k_smm	#
	testl	%eax, %eax	# D.15486
	jne	.L46	#,
	movl	%esi, %eax	# val.15,
.L62:
	call	i8k_get_fan_status	#
.L46:
	movl	%eax, 44(%esp)	# D.15486, val
.L44:
	movl	44(%esp), %esi	# val, ret
	testl	%esi, %esi	# ret
	js	.L33	#,
	cmpl	$-2147194496, %ebp	#, cmd
	je	.L60	#,
	cmpl	$-2147194495, %ebp	#, cmd
	jne	.L60	#,
	leal	24(%esp), %edx	#, tmp116
	movl	$16, %ecx	#,
.L61:
	movl	%ebx, %eax	# arg,
	call	copy_to_user	#
	cmpl	$1, %eax	#, D.15484
	sbbl	%esi, %esi	# ret
	notl	%esi	# ret
	andl	$-14, %esi	#, ret
	jmp	.L33	#
.L60:
	leal	44(%esp), %edx	#, tmp117
	movl	$4, %ecx	#,
	jmp	.L61	#
.L51:
	movl	$-22, %esi	#, ret
.L33:
	addl	$48, %esp	#,
	movl	%esi, %eax	# ret,
	popl	%ebx	#
	popl	%esi	#
	popl	%edi	#
	popl	%ebp	#
	ret
	.size	i8k_ioctl, .-i8k_ioctl
	.section	.rodata.str1.1
.LC3:
	.string	"<6>i8k: not running on a supported Dell system.\n"
.LC4:
	.string	"<6>i8k: vendor=%s, model=%s, version=%s\n"
.LC5:
	.string	"<3>i8k: unable to get SMM Dell signature\n"
.LC6:
	.string	"<4>i8k: unable to get SMM BIOS version\n"
.LC7:
	.string	"<4>i8k: BIOS version mismatch: %s != %s\n"
.LC8:
	.string	"1.14 21/02/2005"
.LC9:
	.string	"<6>Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n"
.LC10:
	.string	"i8k"
	.section	.init.text,"ax",@progbits
	.type	i8k_init, @function
i8k_init:
	pushl	%esi	#
	movl	$i8k_dmi_table, %eax	#,
	pushl	%ebx	#
	subl	$4, %esp	#,
	call	dmi_check_system	#
	testl	%eax, %eax	# D.15529
	jne	.L67	#,
	cmpl	$0, ignore_dmi	#, ignore_dmi
	jne	.L68	#,
	cmpl	$0, force	#, force
	movl	$-19, %eax	#, D.15099
	je	.L69	#,
.L68:
	pushl	$.LC3	#
	call	printk	#
	movl	$2, %eax	#,
	call	i8k_get_dmi_data	#
	movl	%eax, %esi	#, D.15525
	movl	$5, %eax	#,
	call	i8k_get_dmi_data	#
	movl	%eax, %ebx	#, D.15524
	movl	$4, %eax	#,
	call	i8k_get_dmi_data	#
	pushl	%esi	# D.15525
	pushl	%ebx	# D.15524
	pushl	%eax	# D.15523
	pushl	$.LC4	#
	call	printk	#
	addl	$20, %esp	#,
.L67:
	movl	$2, %eax	#,
	call	i8k_get_dmi_data	#
	movl	$4, %ecx	#,
	movl	%eax, %edx	# D.15522,
	movl	$bios_version, %eax	#,
	call	strlcpy	#
	movl	$65187, %eax	#,
	call	i8k_get_dell_signature	#
	testl	%eax, %eax	# D.15521
	je	.L70	#,
	movl	$65443, %eax	#,
	call	i8k_get_dell_signature	#
	testl	%eax, %eax	# D.15520
	je	.L70	#,
	pushl	$.LC5	#
	call	printk	#
	movl	$-19, %eax	#, D.15099
	cmpl	$0, force	#, force
	popl	%edx	#
	je	.L69	#,
.L70:
	call	i8k_get_bios_version	#
	testl	%eax, %eax	# version
	jg	.L71	#,
	pushl	$.LC6	#
	call	printk	#
	popl	%eax	#
	jmp	.L72	#
.L71:
	movl	%eax, %edx	# version, tmp79
	sarl	$16, %edx	#, tmp79
	movb	%dl, (%esp)	# tmp79, buff
	movl	%eax, %edx	# version, tmp80
	sarl	$8, %edx	#, tmp80
	movb	%al, 2(%esp)	# version, buff
	movl	$2, %eax	#,
	movb	%dl, 1(%esp)	# tmp80, buff
	movb	$0, 3(%esp)	#, buff
	call	dmi_get_system_info	#
	testl	%eax, %eax	# D.15514
	jne	.L73	#,
	movl	%esp, %edx	#, tmp81
	movl	$4, %ecx	#,
	movl	$bios_version, %eax	#,
	call	strlcpy	#
.L73:
	movl	$4, %ecx	#,
	movl	$bios_version, %edx	#,
	movl	%esp, %eax	#,
	movl	%esp, %ebx	#, tmp82
	call	strncmp	#
	testl	%eax, %eax	# D.15513
	je	.L72	#,
	pushl	$bios_version	#
	pushl	%ebx	# tmp82
	pushl	$.LC7	#
	call	printk	#
	addl	$12, %esp	#,
	jmp	.L72	#
.L79:
	pushl	$.LC8	#
	pushl	$.LC9	#
	call	printk	#
	xorl	%eax, %eax	# D.15099
	popl	%ebx	#
	popl	%esi	#
.L69:
	addl	$4, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	ret
.L72:
	pushl	$0	#
	xorl	%ecx, %ecx	#
	xorl	%edx, %edx	#
	movl	$.LC10, %eax	#,
	pushl	$i8k_fops	#
	call	proc_create_data	#
	movl	%eax, %edx	#, proc_i8k
	testl	%edx, %edx	# proc_i8k
	popl	%eax	#
	movl	$-2, %eax	#, D.15099
	popl	%ecx	#
	je	.L69	#,
	jmp	.L79	#
	.size	i8k_init, .-i8k_init
	.section	.exit.text,"ax",@progbits
	.type	i8k_exit, @function
i8k_exit:
	xorl	%edx, %edx	#
	movl	$.LC10, %eax	#,
	jmp	remove_proc_entry	#
	.size	i8k_exit, .-i8k_exit
	.section	.modinfo,"a",@progbits
	.align 4
	.type	__mod_fan_mult83, @object
	.size	__mod_fan_mult83, 48
__mod_fan_mult83:
	.string	"parm=fan_mult:Factor to multiply fan speed with"
	.align 4
	.type	__mod_fan_multtype82, @object
	.size	__mod_fan_multtype82, 22
__mod_fan_multtype82:
	.string	"parmtype=fan_mult:int"
	.section	__param,"a",@progbits
	.align 4
	.type	__param_fan_mult, @object
	.size	__param_fan_mult, 16
__param_fan_mult:
# name:
	.long	__param_str_fan_mult
# ops:
	.long	param_ops_int
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	fan_mult
	.section	.modinfo
	.align 4
	.type	__mod_power_status79, @object
	.size	__mod_power_status79, 51
__mod_power_status79:
	.string	"parm=power_status:Report power status in /proc/i8k"
	.align 4
	.type	__mod_power_statustype78, @object
	.size	__mod_power_statustype78, 27
__mod_power_statustype78:
	.string	"parmtype=power_status:bool"
	.section	__param
	.align 4
	.type	__param_power_status, @object
	.size	__param_power_status, 16
__param_power_status:
# name:
	.long	__param_str_power_status
# ops:
	.long	param_ops_bool
# perm:
	.value	384
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	power_status
	.section	.modinfo
	.align 4
	.type	__mod_restricted75, @object
	.size	__mod_restricted75, 62
__mod_restricted75:
	.string	"parm=restricted:Allow fan control if SYS_ADMIN capability set"
	.align 4
	.type	__mod_restrictedtype74, @object
	.size	__mod_restrictedtype74, 25
__mod_restrictedtype74:
	.string	"parmtype=restricted:bool"
	.section	__param
	.align 4
	.type	__param_restricted, @object
	.size	__param_restricted, 16
__param_restricted:
# name:
	.long	__param_str_restricted
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	restricted
	.section	.modinfo
	.align 4
	.type	__mod_ignore_dmi71, @object
	.size	__mod_ignore_dmi71, 74
__mod_ignore_dmi71:
	.string	"parm=ignore_dmi:Continue probing hardware even if DMI data does not match"
	.align 4
	.type	__mod_ignore_dmitype70, @object
	.size	__mod_ignore_dmitype70, 25
__mod_ignore_dmitype70:
	.string	"parmtype=ignore_dmi:bool"
	.section	__param
	.align 4
	.type	__param_ignore_dmi, @object
	.size	__param_ignore_dmi, 16
__param_ignore_dmi:
# name:
	.long	__param_str_ignore_dmi
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	ignore_dmi
	.section	.modinfo
	.align 4
	.type	__mod_force67, @object
	.size	__mod_force67, 63
__mod_force67:
	.string	"parm=force:Force loading without checking for supported models"
	.align 4
	.type	__mod_forcetype66, @object
	.size	__mod_forcetype66, 20
__mod_forcetype66:
	.string	"parmtype=force:bool"
	.section	__param
	.align 4
	.type	__param_force, @object
	.size	__param_force, 16
__param_force:
# name:
	.long	__param_str_force
# ops:
	.long	param_ops_bool
# perm:
	.value	0
# flags:
	.value	0
# <anonymous>:
# arg:
	.long	force
	.section	.modinfo
	.align 4
	.type	__mod_license63, @object
	.size	__mod_license63, 12
__mod_license63:
	.string	"license=GPL"
	.align 4
	.type	__mod_description62, @object
	.size	__mod_description62, 58
__mod_description62:
	.string	"description=Driver for accessing SMM BIOS on Dell laptops"
	.align 4
	.type	__mod_author61, @object
	.size	__mod_author61, 41
__mod_author61:
	.string	"author=Massimo Dal Zotto (dz@debian.org)"
	.data
	.align 4
	.type	fan_mult, @object
	.size	fan_mult, 4
fan_mult:
	.long	30
	.local	power_status
	.comm	power_status,4,4
	.local	restricted
	.comm	restricted,4,4
	.local	ignore_dmi
	.comm	ignore_dmi,4,4
	.local	force
	.comm	force,4,4
	.section	.rodata
	.align 4
	.type	i8k_fops, @object
	.size	i8k_fops, 100
i8k_fops:
# owner:
	.long	__this_module
# llseek:
	.long	seq_lseek
# read:
	.long	seq_read
# unlocked_ioctl:
	.zero	20
	.long	i8k_ioctl
# open:
	.zero	8
	.long	i8k_open_fs
# release:
	.zero	4
	.long	single_release
	.zero	44
	.local	bios_version
	.comm	bios_version,4,4
	.local	prev.12857
	.comm	prev.12857,4,4
	.section	.rodata.str1.1
.LC11:
	.string	"Dell Inspiron"
.LC12:
	.string	"Dell Latitude"
.LC13:
	.string	"Dell Inspiron 2"
.LC14:
	.string	"Dell Latitude 2"
.LC15:
	.string	"Dell Inspiron 3"
.LC16:
	.string	"Dell Precision"
.LC17:
	.string	"Dell Vostro"
	.section	.init.data,"aw",@progbits
	.align 4
	.type	i8k_dmi_table, @object
	.size	i8k_dmi_table, 2988
i8k_dmi_table:
# ident:
	.zero	4
	.long	.LC11
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Computer"
	.zero	65
# slot:
	.byte	5
# substr:
	.string	"Inspiron"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC12
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Computer"
	.zero	65
# slot:
	.byte	5
# substr:
	.string	"Latitude"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC13
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Inspiron"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC14
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Latitude"
	.zero	70
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC15
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"MM061"
	.zero	73
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC15
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"MP061"
	.zero	73
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC16
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Precision"
	.zero	69
	.zero	160
	.zero	4
# ident:
	.zero	4
	.long	.LC17
# matches:
# slot:
	.byte	4
# substr:
	.string	"Dell Inc."
	.zero	69
# slot:
	.byte	5
# substr:
	.string	"Vostro"
	.zero	72
	.zero	160
	.zero	4
	.zero	332
	.section	.rodata
	.align 4
	.type	CSWTCH.30, @object
	.size	CSWTCH.30, 16
CSWTCH.30:
	.long	1
	.long	2
	.long	0
	.long	4
	.align 4
	.type	__param_str_fan_mult, @object
	.size	__param_str_fan_mult, 9
__param_str_fan_mult:
	.string	"fan_mult"
	.align 4
	.type	__param_str_power_status, @object
	.size	__param_str_power_status, 13
__param_str_power_status:
	.string	"power_status"
	.align 4
	.type	__param_str_restricted, @object
	.size	__param_str_restricted, 11
__param_str_restricted:
	.string	"restricted"
	.align 4
	.type	__param_str_ignore_dmi, @object
	.size	__param_str_ignore_dmi, 11
__param_str_ignore_dmi:
	.string	"ignore_dmi"
	.align 4
	.type	__param_str_force, @object
	.size	__param_str_force, 6
__param_str_force:
	.string	"force"
.globl init_module
	.set	init_module,i8k_init
.globl cleanup_module
	.set	cleanup_module,i8k_exit
	.ident	"GCC: (GNU) 4.5.1"
	.section	.note.GNU-stack,"",@progbits

--------------050903020504030201070704--
