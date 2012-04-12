Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913Ab2DLWQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:16:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59731 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab2DLWQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <1334267284-19166-14-git-send-email-wad@chromium.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org>
	<1334267284-19166-14-git-send-email-wad@chromium.org>
Date: Thu, 12 Apr 2012 15:16:04 -0700
X-Google-Sender-Auth: OvNbGz1gkTVcVCoxM4ARvXNrJH8
Message-ID: <CAGXu5j+6kWpuNudi_43J1coK-fN5NTrev=ycYSmcbr+dFBJMFg@mail.gmail.com>
Subject: Re: [PATCH v18 14/15] x86: Enable HAVE_ARCH_SECCOMP_FILTER
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:48 PM, Will Drewry <wad@chromium.org> wrote:
> Enable support for seccomp filter on x86:
> - syscall_get_arch()
> - syscall_get_arguments()
> - syscall_rollback()
> - syscall_set_return_value()
> - SIGSYS siginfo_t support
> - secure_computing is called from a ptrace_event()-safe context
> - secure_computing return value is checked (see below).
>
> SECCOMP_RET_TRACE and SECCOMP_RET_TRAP may result in seccomp needing to
> skip a system call without killing the process.  This is done by
> returning a non-zero (-1) value from secure_computing.  This change
> makes x86 respect that return value.
>
> To ensure that minimal kernel code is exposed, a non-zero return value
> results in an immediate return to user space (with an invalid syscall
> number).
>
> Signed-off-by: Will Drewry <wad@chromium.org>
> Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> Acked-by: Eric Paris <eparis@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
