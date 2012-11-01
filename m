Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab2KAUuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:50:15 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41631 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2KAUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121101203338.GU21164@n2100.arm.linux.org.uk>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org>
	<1351799199-6853-3-git-send-email-keescook@chromium.org>
	<20121101203338.GU21164@n2100.arm.linux.org.uk>
Date: Thu, 1 Nov 2012 13:50:11 -0700
X-Google-Sender-Auth: nreihxWrVCl3186UU0qQHK7KVKA
Message-ID: <CAGXu5jLohAwgRFRrakFMYCRoSumY5NyW+bQ5=Wzq17b6xzpDNw@mail.gmail.com>
Subject: Re: [PATCH 2/4] arch/arm: move secure_computing into trace
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 1:33 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> It's pointless having:
>
>         tst     r10, #_TIF_SECCOMP
>         bne     __sys_trace
>         tst     r10, #_TIF_SYSCALL_WORK
>         bne     __sys_trace
>
> Instead, make TIF_SECCOMP be bit 11, combine it into _TIF_SYSCALL_WORK, and
> eliminate all of that CONFIG_SECCOMP block.

Ah! Good point; I'd missed that _WORK was a bit field. I'll make those changes.

>> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
>> index 739db3a..6b0e14b 100644
>> --- a/arch/arm/kernel/ptrace.c
>> +++ b/arch/arm/kernel/ptrace.c
>> @@ -916,13 +916,15 @@ enum ptrace_syscall_dir {
>>       PTRACE_SYSCALL_EXIT,
>>  };
>>
>> -static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
>> -                             enum ptrace_syscall_dir dir)
>> +asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>
> I'm not sure this change is correct (combined with your hunk below).
> What if we have auditing enabled but trace disabled?  How do we reach
> audit_syscall_entry()?  Or the tracehook stuff?
>
> This patch looks wrong in too many ways.

Oh, yeah, you're totally right. I will fix that up. Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
