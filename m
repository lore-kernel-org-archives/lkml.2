Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1FBVU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:20:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44315 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1FBVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:20:26 -0400
Message-ID: <4DE7FE2A.10107@zytor.com>
Date: Thu, 02 Jun 2011 14:18:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
        jdike@addtoit.com, richard@nod.at, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, viro@zeniv.linux.org.uk,
        oleg@redhat.com, akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] Audit: push audit success and retcode into arch ptrace.h
References: <20110602210458.23613.24076.stgit@paris.rdu.redhat.com>
In-Reply-To: <20110602210458.23613.24076.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 02:04 PM, Eric Paris wrote:
> The audit system previously expected arches calling to audit_syscall_exit to
> supply as arguments if the syscall was a success and what the return code was.
> Audit also provides a helper AUDITSC_RESULT which was supposed to simplify by
> converting from negative retcodes to an audit internal magic value stating
> success or failure.  This helper was wrong and could indicate that a valid
> pointer returned to userspace was a failed syscall.  The fix is to fix the
> layering foolishness.  We now pass audit_syscall_exit a struct pt_reg and it
> in turns calls back into arch code to collect the return value and to
> determine if the syscall was a success or failure.
> 
> In arch/sh/kernel/ptrace_64.c I see that we were using regs[9] in the old
> audit code.  But the ptrace_64.h code was previously using regs[3] for the
> regs_return_value().  I have no idea which one is correct, but this patch now
> uses regs[3].
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

For the x86 portions:

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
