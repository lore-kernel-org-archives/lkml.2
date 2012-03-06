Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2CFSAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:00:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42185 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2CFSAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:00:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mtk.manpages@gmail.com designates 10.43.48.202 as permitted sender) smtp.mail=mtk.manpages@gmail.com; dkim=pass header.i=mtk.manpages@gmail.com
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org> <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 7 Mar 2012 07:00:14 +1300
Message-ID: <CAKgNAkiOY-p7duD_wfed_Tk8T8SR5r1JCTa=0ne3-VQ30mQE-g@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Just a couple of comments for the moment.

On Thu, Mar 1, 2012 at 1:23 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> ---
>  man2/prctl.2 |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 104 insertions(+), 0 deletions(-)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index effad2a..4d6244f 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -378,6 +378,110 @@ Return the current per-process machine check kill policy.
>  All unused
>  .BR prctl ()
>  arguments must be zero.
> +.TP
> +.BR PR_SET_MM " (since Linux 3.3)"
> +Allows a user to modify certain kernel memory map descriptor fields
> +of the calling process.
> +Usually these fields are set by the kernel and dynamic loader (see
> +.BR ld.so (8)
> +for more information) and a regular application should not use this feature.
> +Still there are cases such as self-modifying programs, where a program might
> +find it useful to change its own memory map.

By the way, do you have a *simple* program that demonstrates some
usage of R_SET_MM?

> +The kernel must be built with
> +.BR CONFIG_CHECKPOINT_RESTORE
> +option turned on, otherwise this feature will not be accessible
> +from a user space level.
> +The calling process must have
> +.BR CAP_SYS_ADMIN
> +(see
> +.BR capabilities (7)
> +for details) capability granted.

As we discussed earlier (offlist), there are probably better choices
than the hugely overloaded CAP_SYS_ADMIN (see
http://man7.org/linux/man-pages/man7/capabilities.7.html). And if the
capability governing PR_SET_MM is to change, then it would be good to
do so before 3.3 is released. What are the plans on this point?

Cheers,

Michael


> +The value in
> +.I arg2
> +is one of the options below, while
> +.I arg3
> +provides a new value for this option.
> +
> +.BR PR_SET_MM_START_CODE
> +to set the address above which program text can run.
> +The corresponding memory area must be readable and executable,
> +but not writable or shareable (see
> +.BR mprotect (2)
> +and
> +.BR mmap (2)
> +for more information).
> +
> +.BR PR_SET_MM_END_CODE
> +to set the address below which program text can run.
> +The corresponding memory area must be readable and executable,
> +but not writable or shareable.
> +
> +.BR PR_SET_MM_START_DATA
> +to set the address above which program data+bss is placed.
> +The corresponding memory area must be readable and writable,
> +but not executable or shareable.
> +
> +.B PR_SET_MM_END_DATA
> +to set the address below which program data+bss is placed.
> +The corresponding memory area must be readable and writable,
> +but not executable or shareable.
> +
> +.BR PR_SET_MM_START_STACK
> +to set the start address of the stack.
> +The corresponding memory area must be readable and writable.
> +
> +.BR PR_SET_MM_START_BRK
> +to set the address above which program heap can be expanded with
> +.BR brk (2)
> +call.
> +The address must not be greater than ending address of
> +the current program data segment, neither it may exceed
> +resource limit for data (see
> +.BR setrlimit (2)
> +for more information).
> +
> +.BR PR_SET_MM_BRK
> +to set the current
> +.BR brk (2)
> +value.
> +The requirements for address are the same as for
> +.BR PR_SET_MM_START_BRK
> +option.
> +
> +.BR PR_SET_MM_ARG_START
> +to set the address above which program command line is placed.
> +
> +.BR PR_SET_MM_ARG_END
> +to set the address below which program command line is placed.
> +
> +.BR PR_SET_MM_ENV_START
> +to set the address above which program environment is placed.
> +
> +.BR PR_SET_MM_ENV_END
> +to set the address below which program environment is placed.
> +
> +The address passed with
> +.BR PR_SET_MM_ARG_START ,
> +.BR PR_SET_MM_ARG_END ,
> +.BR PR_SET_MM_ENV_START ,
> +.BR PR_SET_MM_ENV_END ,
> +should belong to a process stack area, thus corresponding memory area
> +must be readable, writable and (depending on the kernel
> +configuration) has
> +.BR MAP_GROWSDOWN
> +attribute set (see
> +.BR mmap (2)
> +for details).
> +
> +.BR PR_SET_MM_AUXV
> +to set a new auxiliary vector.
> +The
> +.I arg3
> +argument should provide the address of the vector.
> +The
> +.I arg4
> +is the size of the vector.
> +.\"
>  .SH "RETURN VALUE"
>  On success,
>  .BR PR_GET_DUMPABLE ,
> --
> 1.7.7.6
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
