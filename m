Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2IUR0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:26:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42794 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2IUR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120921165137.GB28875@flint.arm.linux.org.uk>
References: <1348243081-6725-1-git-send-email-keescook@chromium.org>
	<20120921165137.GB28875@flint.arm.linux.org.uk>
Date: Fri, 21 Sep 2012 10:26:29 -0700
X-Google-Sender-Auth: MDjNCIY9BaeiRshTgLlB-mCj4ng
Message-ID: <CAGXu5jJ75hhb4N_C+3Trp8=LWFMkA52CUmwv+1P9p-6OqMhjEw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: add finit_module syscall to ARM
From: Kees Cook <keescook@chromium.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 9:51 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Fri, Sep 21, 2012 at 08:58:00AM -0700, Kees Cook wrote:
>> Add finit_module syscall to the ARM syscall list.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Russell King <rmk@arm.linux.org.uk>
>> ---
>>  arch/arm/include/asm/unistd.h |    1 +
>>  arch/arm/kernel/calls.S       |    1 +
>>  2 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
>> index 0cab47d..904b579 100644
>> --- a/arch/arm/include/asm/unistd.h
>> +++ b/arch/arm/include/asm/unistd.h
>> @@ -404,6 +404,7 @@
>>  #define __NR_setns                   (__NR_SYSCALL_BASE+375)
>>  #define __NR_process_vm_readv                (__NR_SYSCALL_BASE+376)
>>  #define __NR_process_vm_writev               (__NR_SYSCALL_BASE+377)
>> +#define __NR_finit_module            (__NR_SYSCALL_BASE+378)
>
> This gives us a different syscall ordering if we add the kcmp syscall.
>
> That brings up another question though - when was kcmp added to x86, and
> why aren't we getting notifications from checksyscalls.sh that ARM hasn't
> been updated?
>
> It seems to be that the script was broken, and no one has noticed.
>
> commit 29dc54c673ea2531d589400badb4ada5f5f60dae
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Nov 11 15:57:53 2011 -0800
>
>     checksyscalls: Use arch/x86/syscalls/syscall_32.tbl as source
>
>     Use the new arch/x86/syscalls/syscall_32.tbl file as source instead of
>     arch/x86/include/asm/unistd_32.h.
>
>     Cc: Michal Marek <mmarek@suse.cz>
>     Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>     Cc: Sam Ravnborg <sam@ravnborg.org>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>
> is the culpret, more specifically this fragment:
>
> +           echo <<EOF
> +#if !defined(__NR_${name}) && !defined(__IGNORE_${name})
> +#warning syscall ${name} not implemented
> +#endif
> +EOF
>
> "echo <<EOF" doesn't read from its stdin and output to stdout, so the
> above just generates a blank line for each entry in x86's syscalls_32.tbl,
> resulting in the compiler doing no checking for us.
>
> That "echo <<EOF" should be "cat <<EOF"... and with that fixed we get:
>
> <stdin>:1220:2: warning: #warning syscall kcmp not implemented
>
> So, actually, I want to add this kcmp syscall _now_ into -rc which I'm
> afraid will break your patch, and bump your syscall number on ARM to 379.

That's fine by me. I'll adjust my patch series.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
