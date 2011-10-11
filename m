Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1JKRYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:24:38 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:56070 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab1JKRYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:24:37 -0400
X-AuditID: 12074422-b7ff56d00000092f-17-4e947bd4bca0
Message-ID: <4E947BC9.7040805@mit.edu>
Date: Tue, 11 Oct 2011 10:24:25 -0700
From: Andrew Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] fixing the UML failure root cause
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com> <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com> <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com> <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com> <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com> <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com> <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com> <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com> <20111010114840.GC17079@elte.hu> <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com> <20111011062253.GA3589@elte.hu>
In-Reply-To: <20111011062253.GA3589@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------020100000502090503070403"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsUixCmqrHuleoqfQfMBCYueRRvYLW7+uMxi
	cXnXHDaLLZeaWS0uHVjAZPFh4gY2i82bpjJbPOp7y27xY8NjVgdOj1ttf5g9ds66y+6xaVUn
	m8e7c+fYPU7M+M3iMe9koMf7fVfZPHqez2Py+LxJLoAzissmJTUnsyy1SN8ugStjccss1oIv
	qhUTutazNjCuke1i5OSQEDCR+HV+ByOELSZx4d56ti5GLg4hgX2MEn+eTGIHSQgJbGCUWPDN
	CSJxl0li/fb7bCAJXgE1iY+rulhBbBYBVYmXOzvBbDag+N2z7UwgtqhAmMSCJVtYIOoFJU7O
	fAJmiwjIS+w59oUVZCizwAkmiXVbJoA1CwsYSJzauI4JYttOVolNux+BbeMU0JHYfPIj2FRm
	gQCJRXu6GScwCsxCMngWkhSErSPxru8BM4QtL7H97RwgmwPINpP4+j0aVRjEdpTofbyVcQEj
	+ypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdU73czBK91JTSTYygmGR3UdrB+POg0iFGAQ5GJR7e
	jd2T/YRYE8uKK3MPMUpyMCmJ8l6rnOInxJeUn1KZkVicEV9UmpNafIhRgoNZSYT3Vx5Qjjcl
	sbIqtSgfJiXNwaIkzsu108FPSCA9sSQ1OzW1ILUIJivDwaEkwRtcBdQoWJSanlqRlplTgpBm
	4uAEGc4DNJwDpIa3uCAxtzgzHSJ/ilFRSpxXGpj0hARAEhmleXC9sJT5ilEc6BVhXk6QKh5g
	uoXrfgU0mAlo8PQpk0AGlyQipKQaGLsWeH54ZFpge/SE4+8V388d0U9ybvmVL1fzYNJU1TmJ
	jqbbO8Rc7Cacb59VFvK9IpfJYdP96ndC9e7vlR+fEDTY8MRZ5enXRxMO/n06X8b096yWc4nB
	zNWLGDc6zIhTCFk5ucNB5oqH58Yv7gIP1l6MUzbcpSK3vSHkZXajwvzLS0VT9RSn1CqxFGck
	GmoxFxUnAgCbi4R7dAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020100000502090503070403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/10/2011 11:22 PM, Ingo Molnar wrote:
> 
> * Andrew Lutomirski <luto@mit.edu> wrote:
> 
>>> Andrew?
>>
>> I think I know what the root cause is and I have most of a patch to 
>> fix it.  It doesn't compile (yet), it's a little less trivial than 
>> I'd like for something this late in the -rc cycle, and it adds 16 
>> bytes to thread_struct (ugh!).
>>
>> I think I can make a follow-up patch that removes 32 bytes of 
>> per-thread state to restore my karma, though, but that will 
>> definitely not be 3.1 material.
> 
> Ok, i've queued up the vsyscall=native patch in tip:x86/urgent for 
> now - we can re-try in v3.2 (perhaps) if a satisfactory solution is 
> found.

Getting full cause information for uaccess failure was messy enough that
I gave up.  There are a *lot* of uaccess failure paths to work through.

So here's a different approach.  It's not perfect: it always blames
SEGV_MAPERR instead of SEGV_ACCERR.  I implemented it for vgettimeofday
but not the other two vsyscalls.

What do you think of this approach?  If it seems good, I'll finish the
patch and submit it.

With this patch applied, UML appears to work, but it fills the log with
exploit attempt warnings.  Any ideas on what to do about that?

--Andy

> 
> Thanks,
> 
> 	Ingo


--------------020100000502090503070403
Content-Type: text/plain;
 name="vsyscall_hack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vsyscall_hack.patch"

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 18ae83d..c0bafec 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -139,6 +139,42 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
+/* Copy data to user space, forcing signals on failure. */
+static int copy_to_user_sig(unsigned long dest, const void *src, size_t len)
+{
+	/*
+	 * This may be the slowest memcpy ever written.  We don't really care.
+	 */
+	size_t i;
+	for (i = 0; i < len; i++) {
+		char __user *user_byte = (char __user *)(dest + i);
+		if (put_user(((char*)src)[i], user_byte) != 0) {
+			/* Report full siginfo and context */
+			struct task_struct *tsk = current;
+			siginfo_t info;
+			memset(&info, 0, sizeof(info));
+			info.si_signo = SIGSEGV;
+			/*
+			 * Could be SEGV_ACCERR -- we don't distinguish it
+			 * correctly.
+			 */
+			info.si_code = SEGV_MAPERR;
+			info.si_addr = user_byte;
+			/*
+			 * Write fault in user mode.  We don't distinguish
+			 * protection fault from no page found.
+			 */
+			tsk->thread.error_code = 6;
+			tsk->thread.cr2 = (unsigned long)user_byte;
+			tsk->thread.trap_no = 14;
+			force_sig_info(SIGSEGV, &info, tsk);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
 bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
@@ -181,10 +217,19 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 	switch (vsyscall_nr) {
 	case 0:
-		ret = sys_gettimeofday(
-			(struct timeval __user *)regs->di,
-			(struct timezone __user *)regs->si);
+	{
+		struct timeval tv;
+		do_gettimeofday(&tv);
+
+		if (regs->di && copy_to_user_sig(regs->di, &tv, sizeof(tv)))
+			goto warn_fault;
+		if (regs->si && copy_to_user_sig(regs->si, &sys_tz,
+		                                 sizeof(struct timezone)))
+			goto warn_fault;
+
+		ret = 0;
 		break;
+	}
 
 	case 1:
 		ret = sys_time((time_t __user *)regs->di);
@@ -197,19 +242,6 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 		break;
 	}
 
-	if (ret == -EFAULT) {
-		/*
-		 * Bad news -- userspace fed a bad pointer to a vsyscall.
-		 *
-		 * With a real vsyscall, that would have caused SIGSEGV.
-		 * To make writing reliable exploits using the emulated
-		 * vsyscalls harder, generate SIGSEGV here as well.
-		 */
-		warn_bad_vsyscall(KERN_INFO, regs,
-				  "vsyscall fault (exploit attempt?)");
-		goto sigsegv;
-	}
-
 	regs->ax = ret;
 
 	/* Emulate a ret instruction. */
@@ -221,6 +253,19 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 sigsegv:
 	force_sig(SIGSEGV, current);
 	return true;
+
+warn_fault:
+	/*
+	 * Bad news -- userspace fed a bad pointer to a vsyscall.
+	 *
+	 * With a real vsyscall, that would have caused SIGSEGV.
+	 * To make writing reliable exploits using the emulated
+	 * vsyscalls harder, generate SIGSEGV here as well.
+	 */
+
+	warn_bad_vsyscall(KERN_INFO, regs,
+	                  "vsyscall fault (exploit attempt?)");
+	return true;
 }
 
 /*

--------------020100000502090503070403--
