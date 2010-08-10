Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0HJQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:25:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932300Ab0HJQZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com>
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Aug 2010 09:24:18 -0700
Message-ID: <AANLkTimT6++6MogcBoop-fPEguh-fkOt6SQGfUQrpb5u@mail.gmail.com>
Subject: Re: [GIT] writable_limits for 2.6.36
To: Jiri Slaby <jslaby@suse.cz>, Chris Metcalf <cmetcalf@tilera.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 9:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, so the code looks fine, and I don't have any real objections any
> more. I don't know how much use this will get, but it doesn't appear
> to be "wrong" in any way. So I was going to pull it.
>
> However, in the meantime we have commit 5360bd776f73 ("Fix up the
> "generic" unistd.h ABI to be more useful") that clashes with it. Now,
> the conflict is trivial to resolve, and I could do that easily - it's
> not a technical problem. But that commit code comments say
>
>  + * Architectures may provide up to 16 syscalls of their own
>  + * starting with this value.
>  + */
>  +#define __NR_arch_specific_syscall 244
>
> and the new writable rlimits syscall is obviously 244.

I should have clarified that. The new asm-generic prlimit64 system
call was added at the end (as 244), not in general. Only tilera and
score use that "generic" unistd.h file currently, and score doesn't do
any other system calls, which is why it's really only arch/tile that
is affected by this. Of course, new architectures are likely to use
that model, but we don't care about those yet.

I still think that starting the arch-specific ones at 512 is likely
the right model. I just wanted to clarify in case somebody thought
that x86 put a new system call at 244.

                        Linus
