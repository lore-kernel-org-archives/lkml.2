Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2DOEKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 00:10:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42692 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2DOEKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 00:10:46 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120324061704.GA4324@moon>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-2-git-send-email-gorcunov@openvz.org> <CAKgNAkgJm01K9+GhnouxUwOUW3gk+YiuHLfofrs7adWzEqqO8Q@mail.gmail.com>
 <20120320222424.GL14269@moon> <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
 <20120324061704.GA4324@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 15 Apr 2012 16:10:24 +1200
Message-ID: <CAKgNAkiqWe4ygWpAr4yEx09=SdS8qvXTwsuefQT1zq1w8t_qqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl.2: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

I've had a look at your PR_SET_MM patch for the prctl.2 man page. I've
made various edits and added various FIXMEs relating to questions I
have.

At this stage, please do *not* send me a new patch, Just add your
responses to the FIXMES inline in a reply mail, and I'll further tune
my patch before sending it to you for further review.

Cheers,

Michael

diff --git a/man2/prctl.2 b/man2/prctl.2
index effad2a..d3294e2 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -43,7 +43,7 @@
 .\" FIXME: Document PR_TASK_PERF_EVENTS_DISABLE and
 .\"        PR_TASK_PERF_EVENTS_ENABLE (new in 2.6.32)
 .\"
-.TH PRCTL 2 2011-09-17 "Linux" "Linux Programmer's Manual"
+.TH PRCTL 2 2012-04-14 "Linux" "Linux Programmer's Manual"
 .SH NAME
 prctl \- operations on a process
 .SH SYNOPSIS
@@ -378,6 +378,144 @@ Return the current per-process machine check kill policy.
 All unused
 .BR prctl ()
 arguments must be zero.
+.TP
+.BR PR_SET_MM " (since Linux 3.3)"
+Modify certain kernel memory map descriptor fields
+of the calling process.
+Usually these fields are set by the kernel and dynamic loader (see
+.BR ld.so (8)
+for more information) and a regular application should not use this feature.
+However, there are cases, such as self-modifying programs,
+where a program might find it useful to change its own memory map.
+This feature is available only if the kernel is built with the
+.BR CONFIG_CHECKPOINT_RESTORE
+option enabled.
+The calling process must have the
+.BR CAP_SYS_RESOURCE
+capability.
+The value in
+.I arg2
+is one of the options below, while
+.I arg3
+provides a new value for the option.
+.RS
+.TP
+.BR PR_SET_MM_START_CODE
+Set the address above which the program text can run.
+The corresponding memory area must be readable and executable,
+but not writable or sharable (see
+.BR mprotect (2)
+and
+.BR mmap (2)
+for more information).
+.TP
+.BR PR_SET_MM_END_CODE
+Set the address below which the program text can run.
+The corresponding memory area must be readable and executable,
+but not writable or sharable.
+.TP
+.BR PR_SET_MM_START_DATA
+Set the address above which initialized and
+uninitialized (bss) data are placed.
+The corresponding memory area must be readable and writable,
+but not executable or sharable.
+.TP
+.B PR_SET_MM_END_DATA
+Set the address below which initialized and
+uninitialized (bss) data are placed.
+The corresponding memory area must be readable and writable,
+but not executable or sharable.
+.TP
+.BR PR_SET_MM_START_STACK
+Set the start address of the stack.
+The corresponding memory area must be readable and writable.
+.TP
+.BR PR_SET_MM_START_BRK
+Set the address above which the program heap can be expanded with
+.BR brk (2)
+call.
+.\" FIXME In the next sentence, shouldn't "not be greater" be "be greater"?
+The address must not be greater than the ending address of
+the current program data segment.
+.\" FIXME I completely rewrote the following sentence. Is it okay?
+.\" FIXME Is the following error documented in ERRORS?
+In addition, the combined size of the resulting heap and
+the size of the data segment can't exceed the
+.BR RLIMIT_DATA
+resource limit (see
+.BR setrlimit (2)).
+.TP
+.BR PR_SET_MM_BRK
+Set the current
+.BR brk (2)
+value.
+The requirements for the address are the same as for the
+.BR PR_SET_MM_START_BRK
+option.
+.\" FIXME Delete or comment out the following? (until ========)
+.\" None of the following constants exist in current kernel source
+.\" What is the state of the kernel patches for these?
+.TP
+.BR PR_SET_MM_ARG_START
+Set the address above which the program command line is placed.
+.TP
+.BR PR_SET_MM_ARG_END
+Set the address below which the program command line is placed.
+.TP
+.BR PR_SET_MM_ENV_START
+Set the address above which the program environment is placed.
+.TP
+.BR PR_SET_MM_ENV_END
+Set the address below which the program environment is placed.
+.IP
+The address passed with
+.BR PR_SET_MM_ARG_START ,
+.BR PR_SET_MM_ARG_END ,
+.BR PR_SET_MM_ENV_START ,
+and
+.BR PR_SET_MM_ENV_END
+should belong to a process stack area.
+Thus, the corresponding memory area must be readable, writable, and
+(depending on the kernel configuration) have the
+.BR MAP_GROWSDOWN
+attribute set (see
+.BR mmap (2)).
+.TP
+.BR PR_SET_MM_AUXV
+Set a new auxiliary vector.
+The
+.I arg3
+argument should provide the address of the vector.
+The
+.I arg4
+is the size of the vector.
+.TP
+.BR PR_SET_MM_EXE_FILE
+Supersede the
+.IR /proc/pid/exe
+symbolic link with a new one pointing to a new executable file
+identified by the file descriptor provided in
+.I arg3
+argument.
+The file descriptor should be obtained with a regular
+.BR open (2)
+call.
+.IP
+To change the symbolic link, one needs to unmap all existing
+executable memory areas, including those created by the kernel itself
+(for example the kernel usually creates at least one executable
+memory area for the ELF
+.IR \.text
+section).
+.IP
+The second limitation is that such transitions can be done only once
+in a process life time.
+Any further attempts will be rejected.
+This should help system administrators to monitor the unusual
+symbolic-link transitions over all process running in a system.
+.\" ========== END FIXME
+.RE
+.\"
 .SH "RETURN VALUE"
 On success,
 .BR PR_GET_DUMPABLE ,
@@ -411,7 +549,9 @@ is not recognized.
 is
 .BR PR_MCE_KILL
 or
-.BR PR_MCE_KILL_GET ,
+.BR PR_MCE_KILL_GET
+or
+.BR PR_SET_MM ,
 and unused
 .BR prctl ()
 arguments were not specified as zero.
@@ -429,6 +569,48 @@ or
 .BR PR_SET_SECCOMP ,
 and the kernel was not configured with
 .BR CONFIG_SECCOMP .
+.\" FIXME I added the following lengthy EINVAL entry. Is it correct?
+.TP
+.B EINVAL
+.I option
+is
+.BR PR_SET_MM ,
+and one of the following is true
+.RS
+.IP * 3
+.I arg4
+or
+.I arg5
+is nonzero;
+.IP *
+.I arg3
+is greater than
+.B TASK_SIZE
+(the limit on the size of the user address space for this architecture);
+.IP *
+.I arg2
+is
+.BR PR_SET_MM_START_CODE ,
+.BR PR_SET_MM_END_CODE ,
+.BR PR_SET_MM_START_DATA ,
+.BR PR_SET_MM_END_DATA ,
+or
+.BR PR_SET_MM_START_STACK,
+and the permissions of the corresponding memory area are not as required;
+.IP *
+.I arg2
+is
+.BR PR_SET_MM_START_BRK
+or
+.BR PR_SET_MM_BRK ,
+and
+.I arg3
+.\" FIXME Is the following correct (see earlier comment)
+is less than or equal to the end of the data segment
+or specifies a value that would cause the
+.B RLIMIT_DATA
+resource limit to be exceeded.
+.RE
 .TP
 .B EPERM
 .I option
@@ -459,6 +641,49 @@ is
 and the caller does not have the
 .B CAP_SETPCAP
 capability.
+.TP
+.B EPERM
+.I option
+is
+.BR PR_SET_MM ,
+and the caller does not have the
+.B CAP_SYS_RESOURCE
+capability.
+.TP
+.B EACCES
+.I option
+is
+.BR PR_SET_MM ,
+and
+.I arg3
+is
+.\" FIXME PR_SET_MM_EXE_FILE is not in the kernel sources
+.BR PR_SET_MM_EXE_FILE ,
+the file is not executable.
+.TP
+.B EBUSY
+.I option
+is
+.BR PR_SET_MM ,
+.I arg3
+is
+.\" FIXME PR_SET_MM_EXE_FILE is not in the kernel sources
+.BR PR_SET_MM_EXE_FILE ,
+and this the second attempt to change the
+.I /proc/pid/exe
+symbolic link, which is prohibited.
+.TP
+.B EBADF
+.I option
+is
+.BR PR_SET_MM ,
+.I arg3
+is
+.\" FIXME PR_SET_MM_EXE_FILE is not in the kernel sources
+.BR PR_SET_MM_EXE_FILE ,
+and the file descriptor passed in
+.I arg4
+is not valid.
 .\" The following can't actually happen, because prctl() in
 .\" seccomp mode will cause SIGKILL.
 .\" .TP


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
