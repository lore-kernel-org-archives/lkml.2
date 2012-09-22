Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2IVK4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 06:56:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47061 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2IVK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 06:56:43 -0400
MIME-Version: 1.0
Date: Sat, 22 Sep 2012 12:56:42 +0200
X-Google-Sender-Auth: 6VDjRa6QOaFna-ZcJqGE_3HKdJQ
Message-ID: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
Subject: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to ARM)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 6:51 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> That brings up another question though - when was kcmp added to x86, and
> why aren't we getting notifications from checksyscalls.sh that ARM hasn't
> been updated?
>
> It seems to be that the script was broken, and no one has noticed.

It seems Heiko did notice: http://www.serverphorums.com/read.php?12,559093

Now, I'm a bit puzzled by what follows: Heiko proposes a patch to
ignore sys_kcmp,
as it's x86-specific, which is acked by Cyrill. Then it suddenly
switches to Heiko
enabling it on s390 anyway?

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

With a CC to stable for v3.5? ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
