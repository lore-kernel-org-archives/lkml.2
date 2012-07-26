Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2GZPoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:44:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34248 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2GZPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <26cf6de3bf332e8bb5cf384b2bb6708e1651bb9c.1342566495.git.luto@amacapital.net>
References: <cover.1342566495.git.luto@amacapital.net> <26cf6de3bf332e8bb5cf384b2bb6708e1651bb9c.1342566495.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jul 2012 08:43:51 -0700
Message-ID: <CALCETrUg5Yh0dE1AatTkSyHXcj5rheZjXZ+2pQW-YafL1XW5OQ@mail.gmail.com>
Subject: Re: [PATCH 3.5 1/2] seccomp: Make syscall skipping and nr changes
 more consistent
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 4:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This fixes two issues that could cause incompatibility between
> kernel versions:
>
>  - If a tracer uses SECCOMP_RET_TRACE to select a syscall number
>    higher than the largest known syscall, emulate the unknown
>    vsyscall by returning -ENOSYS.  (This is unlikely to make a
>    noticeable difference on x86-64 due to the way the system call
>    entry works.)
>
>  - On x86-64 with vsyscall=emulate, skipped vsyscalls were buggy.
>
> This updates the documentation accordingly.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  Documentation/prctl/seccomp_filter.txt |   74 ++++++++++++++++++++--
>  arch/x86/kernel/vsyscall_64.c          |  110 +++++++++++++++++---------------
>  kernel/seccomp.c                       |   13 +++-
>  3 files changed, 137 insertions(+), 60 deletions(-)

This is still necessary for vsyscall emulation to play nicely with
fancy seccomp tricks.  Can any of you (James?) send it toward Linus?

We might want to tag this for -stable as well if it survives in the
3.6 tree for a while.

--Andy
