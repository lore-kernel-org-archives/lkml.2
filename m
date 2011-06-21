Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1FUVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 17:08:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:57797 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1FUVIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 17:08:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1308690491!29631915!5
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "mikpe@it.uu.se" <mikpe@it.uu.se>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>
Date: Tue, 21 Jun 2011 16:08:09 -0500
Subject: RE: [PATCH] ARM: quiet sparse noise due to
	__ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Thread-Topic: [PATCH] ARM: quiet sparse noise due to
	__ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Thread-Index: AcwwR76W/mr+5sfGTCGpB6/0GT57TQAACwsg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F38227C2CB@AUSP01VMBX24.collaborationhost.net>
References: <201106211209.46462.hartleys@visionengravers.com>
 <20110621191624.GK23234@n2100.arm.linux.org.uk>
In-Reply-To: <20110621191624.GK23234@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 21, 2011 12:16 PM, Russell King wrote:
> On Tue, Jun 21, 2011 at 12:09:45PM -0700, H Hartley Sweeten wrote:
>> ARM defines __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND) which
>> produces the following sparse warnings in kernel/signal.c:
>> 
>>   warning: symbol 'sys_rt_sigaction' was not declared. Should it be static?
>>   warning: symbol 'sys_rt_sigsuspend' was not declared. Should it be static?
>> 
>> Since ARM doesn't include <asm-generic/syscalls.h>, due to different
>> calling conventions for some system calls, prototype the functions
>> in <asm/unistd.h> to quiet the noise.
>
> NAK.
>
> asm/unistd.h is an exported header.  Please don't pollute it with kernel
> internal stuff.  Instead, follow the hint in asm-generic and create a new
> header file to describe syscalls called... asm/syscalls.h.
>
> And.. the problem is a lot larger than you mention above:
>
>     arch/arm/kernel/signal.c:68:16: warning: symbol 'sys_sigsuspend' was not declared. Should it be static?
>     arch/arm/kernel/signal.c:84:1: warning: symbol 'sys_sigaction' was not declared. Should it be static?
>     arch/arm/kernel/signal.c:328:16: warning: symbol 'sys_sigreturn' was not declared. Should it be static?
>     arch/arm/kernel/signal.c:360:16: warning: symbol 'sys_rt_sigreturn' was not declared. Should it be static?
>     arch/arm/kernel/sys_arm.c:34:16: warning: symbol 'sys_fork' was not declared. Should it be static?
>     arch/arm/kernel/sys_arm.c:47:16: warning: symbol 'sys_clone' was not declared. Should it be static?
>     arch/arm/kernel/sys_arm.c:57:16: warning: symbol 'sys_vfork' was not declared. Should it be static?
>     arch/arm/kernel/sys_arm.c:65:16: warning: symbol 'sys_execve' was not declared. Should it be static?
>     arch/arm/kernel/sys_arm.c:129:17: warning: symbol 'sys_arm_fadvise64_64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:144:17: warning: symbol 'sys_oabi_stat64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:154:17: warning: symbol 'sys_oabi_lstat64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:164:17: warning: symbol 'sys_oabi_fstat64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:174:17: warning: symbol 'sys_oabi_fstatat64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:196:17: warning: symbol 'sys_oabi_fcntl64' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:249:17: warning: symbol 'sys_oabi_epoll_ctl' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:270:17: warning: symbol 'sys_oabi_epoll_wait' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:304:17: warning: symbol 'sys_oabi_semtimedop' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:343:17: warning: symbol 'sys_oabi_semop' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:349:16: warning: symbol 'sys_oabi_ipc' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:367:17: warning: symbol 'sys_oabi_bind' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:377:17: warning: symbol 'sys_oabi_connect' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:387:17: warning: symbol 'sys_oabi_sendto' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:400:17: warning: symbol 'sys_oabi_sendmsg' was not declared. Should it be static?
>     arch/arm/kernel/sys_oabi-compat.c:426:17: warning: symbol 'sys_oabi_socketcall' was not declared. Should it be static?
>     arch/arm/kernel/traps.c:464:16: warning: symbol 'arm_syscall' was not declared. Should it be static?
> 
> So you actually need something like this (pasted, so whitespace
> damaged).  I'll pull it out of my low priority queue and queue it up
> for the next merge window.

Yes, the problem is bigger than just sys_rt_sig(action|suspend).

I was also working on fixing the issues above by adding an asm/syscalls.h.
I just wasn't sure how to handle the sys_rt_sig(action|suspend) functions.

Your patch was whitespace damaged so I applied it by hand to test.

It does fix the sparse issues you list above.  So FWIW....

Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>


But, it still does not fix the sparse warnings in kernel/signal.c:

	kernel/signal.c:2718:1: warning: symbol 'sys_rt_sigaction' was not declared. Should it be static?
	kernel/signal.c:2810:1: warning: symbol 'sys_rt_sigsuspend' was not declared. Should it be static?


FYI, there are a couple other related sparse warnings in arch/arm/kernel, but
these are not exactly "syscalls":

	arch/arm/kernel/ptrace.c:795:16: warning: symbol 'syscall_trace' was not declared. Should it be static?
	arch/arm/kernel/signal.c:787:1: warning: symbol 'do_notify_resume' was not declared. Should it be static?
	arch/arm/kernel/traps.c:343:29: warning: symbol 'do_undefinstr' was not declared. Should it be static?
	arch/arm/kernel/traps.c:386:17: warning: symbol 'do_unexp_fiq' was not declared. Should it be static?
	arch/arm/kernel/traps.c:398:17: warning: symbol 'bad_mode' was not declared. Should it be static?
	arch/arm/kernel/traps.c:661:6: warning: symbol '__bad_xchg' was not declared. Should it be static?
	arch/arm/kernel/traps.c:674:1: warning: symbol 'baddataabort' was not declared. Should it be static?
	arch/arm/kernel/traps.c:706:6: warning: symbol '__readwrite_bug' was not declared. Should it be static?
	arch/arm/kernel/traps.c:728:17: warning: symbol '__div0' was not declared. Should it be static?
	arch/arm/kernel/traps.c:735:6: warning: symbol 'abort' was not declared. Should it be static?

Regards,
Hartley