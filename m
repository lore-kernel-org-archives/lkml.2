Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab0GIV03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:26:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0GIV01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100709203301.GA13839@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	<20100709203301.GA13839@merkur.ravnborg.org>
Date: Fri, 9 Jul 2010 14:25:57 -0700
Message-ID: <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to syscall 
	metadata declarations
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk,
       "Rutecki <"@antispam.struernethosting.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 1:33 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Something like this:
> (whitespace damaged)
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 48c5299..64430d3 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -133,7 +133,8 @@
>  #endif
>
>  #ifdef CONFIG_FTRACE_SYSCALLS
> -#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;        \
> +#define TRACE_SYSCALLS() . = ALIGN(8);                                 \
> +                        VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
>                         *(__syscalls_metadata)                         \
>                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
>  #else

If this is confirmed to fix it, then I would much prefer this version.

That said, I do wonder whether we shouldn't do the ALIGN(8) in the
DATA_DATA define instead. That's what we do for other things like this
(start_markers, start__verbose, etc etc)

                       Linus
