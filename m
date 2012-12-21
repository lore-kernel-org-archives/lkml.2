Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2LULwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:52:16 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51626 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2LULwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:52:07 -0500
Message-ID: <50D44D61.6090006@imgtec.com>
Date: Fri, 21 Dec 2012 11:52:01 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: CONFIG_GENERIC_SIGALTSTACK with asm-generic/syscalls.h (was Re:
 [git pull] signal.git pile 2)
References: <20121221002100.GM4939@ZenIV.linux.org.uk> <50D40088.3030304@synopsys.com>
In-Reply-To: <50D40088.3030304@synopsys.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_21_11_52_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/12 06:24, Vineet Gupta wrote:
> On Friday 21 December 2012 05:51 AM, Al Viro wrote:
>> sigaltstack infrastructure + conversion for x86, alpha and um,
>> COMPAT_SYSCALL_DEFINE infrastructure.  Note that there are several
>> conflicts between "unify SS_ONSTACK/SS_DISABLE definitions" and
>> UAPI patches in mainline; resolution is trivial - just remove definitions
>> of SS_ONSTACK and SS_DISABLED from arch/*/uapi/asm/signal.h; they are
>> all identical and include/uapi/linux/signal.h contains the unified
>> variant.  Please, pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
>>
> 
> Hi Arnd,
> 
> In Linus' tree with above merged, selecting CONFIG_GENERIC_SIGALTSTACK
> is causing build issues for ARC port (and possibly others as well) which
> use asm-generic/syscalls.h due to a different prototype for
> sys_sigaltstack coming in from linux/syscalls.h
> 
> While I can band-aid ARC port by #define sys_sigaltstack before
> including asm-generic, it might be better if we conditional-ize one of
> the prototypes. Following works for me.
> 
> diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
> index 58f466f..1db51b8 100644
> --- a/include/asm-generic/syscalls.h
> +++ b/include/asm-generic/syscalls.h
> @@ -21,10 +21,12 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
>                         unsigned long fd, off_t pgoff);
>  #endif
> 
> +#ifndef CONFIG_GENERIC_SIGALTSTACK
>  #ifndef sys_sigaltstack
>  asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
>                         struct pt_regs *);
>  #endif
> +#endif

Reviewed-by: James Hogan <james.hogan@imgtec.com>

I also see this issue with metag when I try and select
CONFIG_GENERIC_SIGALTSTACK. Until asm-generic/syscalls.h goes away it
seems a shame to have to keep a misleading #define sys_sigaltstack
sys_sigaltstack bodge in architecture's asm/syscalls.h.

Cheers
James

