Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2BYUUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 15:20:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56648 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740Ab2BYUUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 15:20:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.60.28.10 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <1330140111-17201-7-git-send-email-wad@chromium.org>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-7-git-send-email-wad@chromium.org>
Date: Sat, 25 Feb 2012 12:20:13 -0800
X-Google-Sender-Auth: ALdPGJhNsVfBXMOriiUFrLMBPXw
Message-ID: <CAGXu5jLVwYev3EmLOKuEdyaqieGzWgVpFcgodnUbUkbMbiJVqQ@mail.gmail.com>
Subject: Re: [PATCH v11 07/12] seccomp: add SECCOMP_RET_ERRNO
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 7:21 PM, Will Drewry <wad@chromium.org> wrote:
> This change adds the SECCOMP_RET_ERRNO as a valid return value from a
> seccomp filter.  Additionally, it makes the first use of the lower
> 16-bits for storing a filter-supplied errno.  16-bits is more than
> enough for the errno-base.h calls.
>
> Returning errors instead of immediately terminating processes that
> violate seccomp policy allow for broader use of this functionality
> for kernel attack surface reduction.  For example, a linux container
> could maintain a whitelist of pre-existing system calls but drop
> all new ones with errnos.  This would keep a logically static attack
> surface while providing errnos that may allow for graceful failure
> without the downside of do_exit() on a bad call.
>
> v11: - check for NULL filter (keescook@chromium.org)
> v10: - change loaders to fn
>  v9: - n/a
>  v8: - update Kconfig to note new need for syscall_set_return_value.
>     - reordered such that TRAP behavior follows on later.
>     - made the for loop a little less indent-y
>  v7: - introduced
>
> Signed-off-by: Will Drewry <wad@chromium.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

> +       /* Ensure unexpected behavior doesn't result in failing open. */
> +       if (unlikely(current->seccomp.filter == NULL))
> +               ret = SECCOMP_RET_KILL;

Any reason to not just immediately return in this case?

-Kees

-- 
Kees Cook
ChromeOS Security
