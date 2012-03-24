Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2CXDAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 23:00:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab2CXDAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 23:00:09 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120320222424.GL14269@moon>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-2-git-send-email-gorcunov@openvz.org> <CAKgNAkgJm01K9+GhnouxUwOUW3gk+YiuHLfofrs7adWzEqqO8Q@mail.gmail.com>
 <20120320222424.GL14269@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 24 Mar 2012 15:59:49 +1300
Message-ID: <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl.2: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:24 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Wed, Mar 21, 2012 at 06:21:19AM +1300, Michael Kerrisk (man-pages) wrote:
>> Hello Cyrill,
>>
>> The PR_SET_MM operation adds a number of new error cases to prctl(2).
>> Could you extend you patch to add these under ERRORS?
>>
>
> Hi Michael,
>
> here is an update on previous patch. Please take a look and
> tell me what you think when you get time. Complains are welcome!

Hi Cyrill,

I only just had a chance to look at this now and realize that this is
a patch on a patch. Could you just send me a complete  patch with all
the changes?

Thanks,

Michael

> ---
> From 10dbf8dc2e40426c56a6d2a2414bcb9d3a0f5ff3 Mon Sep 17 00:00:00 2001
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Date: Wed, 21 Mar 2012 02:20:11 +0400
> Subject: [PATCH] prctl.2: Update description for PR_SET_MM option
>
> New feature PR_SET_MM_EXE_FILE added, also
> error codes updated.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  man2/prctl.2 |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 69 insertions(+), 1 deletions(-)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 7a50ac1..de15426 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -481,6 +481,30 @@ argument should provide the address of the vector.
>  The
>  .I arg4
>  is the size of the vector.
> +
> +.BR PR_SET_MM_EXE_FILE
> +to supersede
> +.IR /proc/pid/exe
> +symbolic link with a new one pointing to a new executable file
> +which descriptor is provided provided in the
> +.I arg3
> +argument.
> +The file descriptor should be obtaned with a regular
> +.BR open (2)
> +call.
> +
> +To change the symlink, one needs to unmap all existing
> +executable memory areas being created by the kernel itself
> +(for example the kernel usually creates at least one executable
> +memory area for Elf file
> +.IR \.text
> +section).
> +
> +The second limitation is that such transition can be done once
> +in a process life time.
> +Any furter attempts will be rejected.
> +This should help system administrators to monitor the unusual
> +symlinks transitions over all process running in a system.
>  .\"
>  .SH "RETURN VALUE"
>  On success,
> @@ -515,7 +539,9 @@ is not recognized.
>  is
>  .BR PR_MCE_KILL
>  or
> -.BR PR_MCE_KILL_GET ,
> +.BR PR_MCE_KILL_GET
> +or
> +.BR PR_SET_MM ,
>  and unused
>  .BR prctl ()
>  arguments were not specified as zero.
> @@ -563,6 +589,48 @@ is
>  and the caller does not have the
>  .B CAP_SETPCAP
>  capability.
> +.TP
> +.B EPERM
> +.I option
> +is
> +.BR PR_SET_MM ,
> +and the caller does not have the
> +.B CAP_SYS_RESOURCE
> +capability.
> +.TP
> +.B EACCES
> +.I option
> +is
> +.BR PR_SET_MM ,
> +and the
> +.I arg3
> +is
> +.BR PR_SET_MM_EXE_FILE ,
> +the file is not executable one.
> +.TP
> +.B EBUSY
> +.I option
> +is
> +.BR PR_SET_MM ,
> +and the
> +.I arg3
> +is
> +.BR PR_SET_MM_EXE_FILE ,
> +the second attempt to change
> +.I /proc/pid/exe
> +symlink is prohibited.
> +.TP
> +.B EBADF
> +.I option
> +is
> +.BR PR_SET_MM ,
> +and the
> +.I arg3
> +is
> +.BR PR_SET_MM_EXE_FILE ,
> +the file descriptor passed in
> +.I arg4
> +is not found.
>  .\" The following can't actually happen, because prctl() in
>  .\" seccomp mode will cause SIGKILL.
>  .\" .TP
> --
> 1.7.7.6
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
