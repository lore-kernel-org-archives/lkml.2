Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1HWFK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:10:58 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:57909 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908Ab1HWFKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:10:51 -0400
X-AuditID: 12074422-b7ba7ae000000a14-70-4e53365386e6
Message-ID: <4E533651.8070205@mit.edu>
Date: Tue, 23 Aug 2011 01:10:41 -0400
From: Andrew Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
References: <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk> <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com> <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk> <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com> <20110822040759.GQ2203@ZenIV.linux.org.uk> <4E51D70A.1060001@zytor.com> <20110822042605.GR2203@ZenIV.linux.org.uk> <4E51E325.2050502@zytor.com>
In-Reply-To: <4E51E325.2050502@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixG6nohtiFuxncKKVyWLaRnGLy7vmsFlc
	OrCAyWLyzjeMFo/63rJbzOqdwmJx/u9xVgd2jxMzfrN47F7wmcnj5rxCj/f7rrJ5fN4k57Hp
	yVsmjxMtX1gD2KO4bFJSczLLUov07RK4Mo62P2UrWKxVcWD6UfYGxtuKXYycHBICJhIt/f0s
	ELaYxIV769m6GLk4hAT2MUrcODKDFcLZwCjxfOECFgjnLZPEtve32EBaeAXUJDq7LjOB2CwC
	qhKt51+xg9hsQPG7Z9vB4qICQRL3fzewQNQLSpyc+QTMFhFQkZj+8xMTyFBmgd+MEldXnQQb
	KiyQKfFp4V5GiG0HWSQ617wG6+AU0JSYMmclUBEHUIe6xPp5QiBhZgF5ie1v5zBPYBSchWTH
	LISqWUiqFjAyr2KUTcmt0s1NzMwpTk3WLU5OzMtLLdI11cvNLNFLTSndxAiOEBelHYw/Dyod
	YhTgYFTi4f15IMhPiDWxrLgy9xCjJAeTkihvtXGwnxBfUn5KZUZicUZ8UWlOavEhRgkOZiUR
	3oV3gMp5UxIrq1KL8mFS0hwsSuK8XDsd/IQE0hNLUrNTUwtSi2CyMhwcShK8i02BhgoWpaan
	VqRl5pQgpJk4OEGG8wAN7wap4S0uSMwtzkyHyJ9iVJQS510LkhAASWSU5sH1whLYK0ZxoFeE
	eXtBqniAyQ+u+xXQYCagwRy/QK4uLklESEk1MC5V/DNbfUuD5FYOH9lOU13Fry8EkqaLWh5d
	9efzz5fHZVrljXndbL2X/NCZcP9wVnC0101HllsLa1wNCzK9+B08OVb7VEzJOd1it0W5PCTe
	ZHXbTSZ5CSV/w1/Cy5/lT7jxIGZdy3HfWXELuA7wSra+iWUPP7rPWsv/8OsNvnzSU4R/cL60
	UmIpzkg01GIuKk4EAAemzdY7AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 01:03 AM, H. Peter Anvin wrote:
> On 08/21/2011 09:26 PM, Al Viro wrote:
>> On Sun, Aug 21, 2011 at 09:11:54PM -0700, H. Peter Anvin wrote:
>>>> lack of point - the *only* CPU where it would matter would be K6-2, IIRC,
>>>> and (again, IIRC) it had some differences in SYSCALL semantics compared to
>>>> K7 (which supports SYSENTER as well).  Bugger if I remember what those
>>>> differences might've been...  Some flag not cleared?
>>>
>>> The most likely reason for a binary to execute a stray SYSCALL is
>>> because they read it out of the vdso.  Totally daft, but we certainly
>>> see a lot of stupid things as evidenced by the JIT thread earlier this
>>> month.
>>
>> Um...  What, blindly, no matter what surrounds it in there?  What will
>> happen to the same eager JIT when it steps on SYSENTER?
> 
> The JIT will have had to manage SYSENTER already.  It's not a change,
> whereas SYSCALL would be.  We could just try it, and see if anything
> breaks, of course.

Here's a possible solution that works for standalone SYSCALL and vdso
SYSCALL.  The idea is to preserve the exact same SYSCALL invocation
sequence.  Logically, the SYSCALL instruction does:

push %ebp
mov %ebp,%ecx
mov 4(%esp),%ebp
call __fake_int80

and __fake_int80 is:
int 0x80
mov 4(%esp),%ebp
ret $4


The entire system call sequence is then (effectively):

push %ebp
movl %ecx,%ebp

; "SYSCALL" starts here
push %ebp
mov %ebp,%ecx
mov 4(%esp),%ebp
call __fake_int80
; "SYSCALL ends here

movl %ebp,%ecx
popl %ebp
ret

So we rearrange ebp and ecx and then immediately rearrange them back.
The landing point tweaks them again so that we preserve the old
semantics of SYSCALL.  But now the pt_regs values exactly match what
would have happened if we entered via the int 0x80 path, so there
shouldn't be any corner cases with ptrace or restart -- as far as either
one is concerned, we actually entered via int 0x80.  If we deliver a
signal, the signal handler returns to the int 0x80 instruction.

Am I missing something?  Extremely buggy, incomplete code that
implements this is:


diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a0e866d..6cda8ce 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -291,24 +291,59 @@ ENTRY(ia32_cstar_target)
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,0,0
 	movl 	%eax,%eax	/* zero extension */
-	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
-	movq	%rcx,RIP-ARGOFFSET(%rsp)
-	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	movq	%rbp,RCX-ARGOFFSET(%rsp) /* this lies slightly to ptrace */
-	movl	%ebp,%ecx
+
+	/*
+	 * This does (from the user's point of view):
+	 * push %ebp
+	 * mov %ebp, %ecx
+	 * mov 4(%esp), %ebp
+	 * call <function that does int 0x80; mov 4(%esp),%ebp; ret 4>
+	 *
+	 * User address access does not need access_ok check as r8
+	 * has been zero-extended, so even with the offsets it cannot
+	 * exceed 2**32 + 8.
+	 */
+
+	/* XXX: need to check that vdso actually exists. */
+	/* XXX: ia32_badarg may do bad things to the user state. */
+
+	/* move ebp into place on the user stack */
+	1:	movl	%ebp,-4(%r8)
+	.section __ex_table,"a"
+	.quad 1b,ia32_badarg
+	.previous
+
+	/* move eip into place on the user stack */
+	1:	movl	%ecx,-8(%r8)  /* user eip is in ecx */
+	.section __ex_table,"a"
+	.quad 1b,ia32_badarg
+	.previous
+
+	/* move ebp to ecx in CPU registers and argument save area */
+	mov %ebp,%ecx
+	movq %ecx,RCX-ARGOFFSET(%rsp)
+
+	/*
+	 * move arg6 to ebp in CPU registers and argument save area
+	 * minor optimization: the actual value of ebp is irrelevent,
+	 * so stick it straight into r9d -- see the definition of
+	 * IA32_ARG_FIXUP.
+	 */
+1:	movl	(%r8),%r9d
+	.section __ex_table,"a"
+	.quad 1b,ia32_badarg
+	.previous	
+
+	/* Do the fake call */
+	movl [insert address of int 0x80; ret helper + 2 here],RIP-ARGOFFSET(%rsp)
+	subl $8,%r8 /* we pushed twice */
+
 	movq	$__USER32_CS,CS-ARGOFFSET(%rsp)
 	movq	$__USER32_DS,SS-ARGOFFSET(%rsp)
 	movq	%r11,EFLAGS-ARGOFFSET(%rsp)
 	/*CFI_REL_OFFSET rflags,EFLAGS-ARGOFFSET*/
 	movq	%r8,RSP-ARGOFFSET(%rsp)	
 	CFI_REL_OFFSET rsp,RSP-ARGOFFSET
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-	/* hardware stack frame is complete now */	
-1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous	
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
diff --git a/arch/x86/vdso/vdso32/syscall.S b/arch/x86/vdso/vdso32/syscall.S
index 5415b56..a3e48b0 100644
--- a/arch/x86/vdso/vdso32/syscall.S
+++ b/arch/x86/vdso/vdso32/syscall.S
@@ -19,8 +19,8 @@ __kernel_vsyscall:
 .Lpush_ebp:
 	movl	%ecx, %ebp
 	syscall
-	movl	$__USER32_DS, %ecx
-	movl	%ecx, %ss
+	/* The ret in the fake int80 entry lands here */
+	/* ss is already correct AFAICS */
 	movl	%ebp, %ecx
 	popl	%ebp
 .Lpop_ebp:
@@ -28,6 +28,11 @@ __kernel_vsyscall:
 .LEND_vsyscall:
 	.size __kernel_vsyscall,.-.LSTART_vsyscall
 
+__kernel_vsyscall_fake_int80:
+	int 0x80
+	mov 4(%esp),%ebp
+	ret $4
+
 	.section .eh_frame,"a",@progbits
 .LSTARTFRAME:
 	.long .LENDCIE-.LSTARTCIE


This could be further simplified by checking if any work flags are set and bailing immediately to the right place in the int 0x80 entry.

--Andy
