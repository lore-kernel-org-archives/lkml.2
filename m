Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab2GZPmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:42:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2GZPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
References: <cover.1342566495.git.luto@amacapital.net> <912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jul 2012 08:41:56 -0700
Message-ID: <CALCETrUJiXoc8Jq-fdTsx4oq9j8e-NHSiYOJdy37o6uy2cJZuA@mail.gmail.com>
Subject: Re: [PATCH 3.5 2/2] seccomp: Future-proof against silly tracers
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 4:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, if a tracer changes a syscall nr to __NR_future_enosys,
> behavior will differ between kernels that know about
> __NR_future_enosys (and return -ENOSYS) and older kernels (which
> return the value from pt_regs).  This is silly; we should just
> return -ENOSYS.
>
> This is unlikely to ever happen on x86 because the return value in
> pt_regs starts out as -ENOSYS, but a silly tracer can change that.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  arch/x86/include/asm/syscall.h |   11 +++++++++++
>  kernel/seccomp.c               |   15 +++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)

Will, can you pick this, or some version of it, up in your
seccomp-for-ARM tree or wherever your development is?

--Andy
