Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2JVE4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:56:25 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36118 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2JVE4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:56:24 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120920233700.GA3363@www.outflux.net>
References: <20120920233700.GA3363@www.outflux.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 22 Oct 2012 06:56:03 +0200
Message-ID: <CAKgNAkiYpct9iHwVC38oOF4dRizCRu0v7gwbfv5sVV1gxomuKA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] prctl: update seccomp sections for mode 2 (BPF)
To: Kees Cook <keescook@chromium.org>
Cc: linux-man@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wad@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

On Fri, Sep 21, 2012 at 1:37 AM, Kees Cook <keescook@chromium.org> wrote:
> This adds a short summary of the arguments used for "mode 2" (BPF)
> seccomp.

Thanks very much. Applied.

Cheers,

Michael


> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  man2/prctl.2 |   40 ++++++++++++++++++++++++++++++----------
>  1 files changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index eb53aa8..a44aa32 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -41,11 +41,12 @@
>  .\" 2012-04 Cyrill Gorcunov, Document PR_SET_MM
>  .\" 2012-04-25 Michael Kerrisk, Document PR_TASK_PERF_EVENTS_DISABLE and
>  .\"                            PR_TASK_PERF_EVENTS_ENABLE
> +.\" 2012-09-20 Kees Cook, update PR_SET_SECCOMP for mode 2
>  .\"
>  .\" FIXME: Document PR_SET_TIMERSLACK and PR_GET_TIMERSLACK (new in 2.6.28)
>  .\"            commit 6976675d94042fbd446231d1bd8b7de71a980ada
>  .\"
> -.TH PRCTL 2 2012-04-23 "Linux" "Linux Programmer's Manual"
> +.TH PRCTL 2 2012-09-20 "Linux" "Linux Programmer's Manual"
>  .SH NAME
>  prctl \- operations on a process
>  .SH SYNOPSIS
> @@ -235,11 +236,17 @@ in the location pointed to by
>  .\" See http://thread.gmane.org/gmane.linux.kernel/542632
>  .\" [PATCH 0 of 2] seccomp updates
>  .\" andrea@cpushare.com
> -Set the secure computing mode for the calling thread.
> -In the current implementation,
> +Set the secure computing mode for the calling thread, to limit
> +the available syscalls.
> +The seccomp mode is selected via
> +.IR arg2 .
> +(The seccomp constants are defined in
> +.IR <linux/seccomp.h> .)
> +
> +With
>  .IR arg2
> -must be 1.
> -After the secure computing mode has been set to 1,
> +set to
> +.BR SECCOMP_MODE_STRICT
>  the only system calls that the thread is permitted to make are
>  .BR read (2),
>  .BR write (2),
> @@ -249,22 +256,35 @@ and
>  Other system calls result in the delivery of a
>  .BR SIGKILL
>  signal.
> -Secure computing mode is useful for number-crunching applications
> +Strict secure computing mode is useful for number-crunching applications
>  that may need to execute untrusted byte code,
>  perhaps obtained by reading from a pipe or socket.
>  This operation is only available
>  if the kernel is configured with CONFIG_SECCOMP enabled.
> +
> +With
> +.IR arg2
> +set to
> +.BR SECCOMP_MODE_FILTER " (since Linux 3.5)"
> +the system calls allowed are
> +defined by a pointer passed in
> +.IR arg3
> +to a Berkeley Packet Filter, which can be designed to filter
> +arbitrary syscalls and syscall arguments.
> +This mode is only available if the kernel is configured with
> +CONFIG_SECCOMP_FILTER enabled.
> +
>  .TP
>  .BR PR_GET_SECCOMP " (since Linux 2.6.23)"
>  Return the secure computing mode of the calling thread.
> -Not very useful for the current implementation (mode equals 1),
> -but may be useful for other possible future modes:
> -if the caller is not in secure computing mode, this operation returns 0;
> -if the caller is in secure computing mode, then the
> +If the caller is not in secure computing mode, this operation returns 0;
> +if the caller is in strict secure computing mode, then the
>  .BR prctl ()
>  call will cause a
>  .B SIGKILL
>  signal to be sent to the process.
> +If the caller is in filter mode, and this syscall is allowed by the
> +seccomp filters, it returns 2.
>  This operation is only available
>  if the kernel is configured with CONFIG_SECCOMP enabled.
>  .TP
> --
> 1.7.0.4
>
> --
> Kees Cook
> Chrome OS Security



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
