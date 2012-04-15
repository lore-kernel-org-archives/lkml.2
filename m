Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2DOWfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:35:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2DOWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:35:14 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkie6d8vn76x+Aa03Ciw=R-8PSWFfbeyrr4deeS8_8k3gQ@mail.gmail.com>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-2-git-send-email-gorcunov@openvz.org> <CAKgNAkgJm01K9+GhnouxUwOUW3gk+YiuHLfofrs7adWzEqqO8Q@mail.gmail.com>
 <20120320222424.GL14269@moon> <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
 <20120324061704.GA4324@moon> <CAKgNAkiqWe4ygWpAr4yEx09=SdS8qvXTwsuefQT1zq1w8t_qqw@mail.gmail.com>
 <20120415215531.GA2229@moon> <CAKgNAkie6d8vn76x+Aa03Ciw=R-8PSWFfbeyrr4deeS8_8k3gQ@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 16 Apr 2012 10:34:53 +1200
Message-ID: <CAKgNAkhdjTitkiVcNbxFz=q9_hR3Lkt26Gh5icQyhi-t_=9uhg@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl.2: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f2352f5b0697204bdbf5113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f2352f5b0697204bdbf5113
Content-Type: text/plain; charset=ISO-8859-1

Hi Cyrill,

Below (and also attached) is the current draft of the prctl.2 page
with your PR_SET_MM materials.

Cheers,

Michael

.\" Hey Emacs! This file is -*- nroff -*- source.
.\"
.\" Copyright (C) 1998 Andries Brouwer (aeb@cwi.nl)
.\" and Copyright (C) 2002 Michael Kerrisk <mtk.manpages@gmail.com>
.\" and Copyright Guillem Jover <guillem@hadrons.org>
.\"
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\"
.\" Modified Thu Nov 11 04:19:42 MET 1999, aeb: added PR_GET_PDEATHSIG
.\" Modified 27 Jun 02, Michael Kerrisk
.\" 	Added PR_SET_DUMPABLE, PR_GET_DUMPABLE,
.\"	PR_SET_KEEPCAPS, PR_GET_KEEPCAPS
.\" Modified 2006-08-30 Guillem Jover <guillem@hadrons.org>
.\"	Updated Linux versions where the options where introduced.
.\"	Added PR_SET_TIMING, PR_GET_TIMING, PR_SET_NAME, PR_GET_NAME,
.\"	PR_SET_UNALIGN, PR_GET_UNALIGN, PR_SET_FPEMU, PR_GET_FPEMU,
.\"	PR_SET_FPEXC, PR_GET_FPEXC
.\" 2008-04-29 Serge Hallyn, Document PR_CAPBSET_READ and PR_CAPBSET_DROP
.\" 2008-06-13 Erik Bosman, <ejbosman@cs.vu.nl>
.\"     Document PR_GET_TSC and PR_SET_TSC.
.\" 2008-06-15 mtk, Document PR_SET_SECCOMP, PR_GET_SECCOMP
.\" 2009-10-03 Andi Kleen, document PR_MCE_KILL_*
.\"
.\" FIXME: Document PR_SET_TIMERSLACK and PR_GET_TIMERSLACK (new in 2.6.28)
.\" FIXME: Document PR_TASK_PERF_EVENTS_DISABLE and
.\"        PR_TASK_PERF_EVENTS_ENABLE (new in 2.6.32)
.\"
.TH PRCTL 2 2012-04-14 "Linux" "Linux Programmer's Manual"
.SH NAME
prctl \- operations on a process
.SH SYNOPSIS
.nf
.B #include <sys/prctl.h>
.sp
.BI "int prctl(int " option ", unsigned long " arg2 ", unsigned long " arg3 ,
.BI "          unsigned long " arg4 ", unsigned long " arg5 );
.fi
.SH DESCRIPTION
.BR prctl ()
is called with a first argument describing what to do
(with values defined in \fI<linux/prctl.h>\fP), and further
arguments with a significance depending on the first one.
The first argument can be:
.TP
.BR PR_CAPBSET_READ " (since Linux 2.6.25)"
Return (as the function result) 1 if the capability specified in
.I arg2
is in the calling thread's capability bounding set,
or 0 if it is not.
(The capability constants are defined in
.IR <linux/capability.h> .)
The capability bounding set dictates
whether the process can receive the capability through a
file's permitted capability set on a subsequent call to
.BR execve (2).

If the capability specified in
.I arg2
is not valid, then the call fails with the error
.BR EINVAL .
.TP
.BR PR_CAPBSET_DROP " (since Linux 2.6.25)"
If the calling thread has the
.B CAP_SETPCAP
capability, then drop the capability specified by
.I arg2
from the calling thread's capability bounding set.
Any children of the calling thread will inherit the newly
reduced bounding set.

The call fails with the error:
.B EPERM
if the calling thread does not have the
.BR CAP_SETPCAP ;
.BR EINVAL
if
.I arg2
does not represent a valid capability; or
.BR EINVAL
if file capabilities are not enabled in the kernel,
in which case bounding sets are not supported.
.TP
.BR PR_SET_DUMPABLE " (since Linux 2.3.20)"
Set the state of the flag determining whether core dumps are produced
for this process upon delivery of a signal whose default behavior is
to produce a core dump.
(Normally this flag is set for a process by default, but it is cleared
when a set-user-ID or set-group-ID program is executed and also by
various system calls that manipulate process UIDs and GIDs).
In kernels up to and including 2.6.12,
.I arg2
must be either 0 (process is not dumpable) or 1 (process is dumpable).
Between kernels 2.6.13 and 2.6.17, the value 2 was also permitted,
which caused any binary which normally would not be dumped
to be dumped readable by root only;
for security reasons, this feature has been removed.
.\" See http://marc.theaimsgroup.com/?l=linux-kernel&m=115270289030630&w=2
.\" Subject:    Fix prctl privilege escalation (CVE-2006-2451)
.\" From:       Marcel Holtmann <marcel () holtmann ! org>
.\" Date:       2006-07-12 11:12:00
(See also the description of
.I /proc/sys/fs/suid_dumpable
in
.BR proc (5).)
Processes that are not dumpable can not be attached via
.BR ptrace(2)
.BR PTRACE_ATTACH .
.TP
.BR PR_GET_DUMPABLE " (since Linux 2.3.20)"
Return (as the function result) the current state of the calling
process's dumpable flag.
.\" Since Linux 2.6.13, the dumpable flag can have the value 2,
.\" but in 2.6.13 PR_GET_DUMPABLE simply returns 1 if the dumpable
.\" flags has a nonzero value.  This was fixed in 2.6.14.
.TP
.BR PR_SET_ENDIAN " (since Linux 2.6.18, PowerPC only)"
Set the endian-ness of the calling process to the value given
in \fIarg2\fP, which should be one of the following:
.\" Respectively 0, 1, 2
.BR PR_ENDIAN_BIG ,
.BR PR_ENDIAN_LITTLE ,
or
.B PR_ENDIAN_PPC_LITTLE
(PowerPC pseudo little endian).
.TP
.BR PR_GET_ENDIAN " (since Linux 2.6.18, PowerPC only)"
Return the endian-ness of the calling process,
in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.BR PR_SET_FPEMU " (since Linux 2.4.18, 2.5.9, only on ia64)"
Set floating-point emulation control bits to \fIarg2\fP.
Pass \fBPR_FPEMU_NOPRINT\fP to silently emulate fp operations accesses, or
\fBPR_FPEMU_SIGFPE\fP to not emulate fp operations and send
.B SIGFPE
instead.
.TP
.BR PR_GET_FPEMU " (since Linux 2.4.18, 2.5.9, only on ia64)"
Return floating-point emulation control bits,
in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.BR PR_SET_FPEXC " (since Linux 2.4.21, 2.5.32, only on PowerPC)"
Set floating-point exception mode to \fIarg2\fP.
Pass \fBPR_FP_EXC_SW_ENABLE\fP to use FPEXC for FP exception enables,
\fBPR_FP_EXC_DIV\fP for floating-point divide by zero,
\fBPR_FP_EXC_OVF\fP for floating-point overflow,
\fBPR_FP_EXC_UND\fP for floating-point underflow,
\fBPR_FP_EXC_RES\fP for floating-point inexact result,
\fBPR_FP_EXC_INV\fP for floating-point invalid operation,
\fBPR_FP_EXC_DISABLED\fP for FP exceptions disabled,
\fBPR_FP_EXC_NONRECOV\fP for async nonrecoverable exception mode,
\fBPR_FP_EXC_ASYNC\fP for async recoverable exception mode,
\fBPR_FP_EXC_PRECISE\fP for precise exception mode.
.TP
.BR PR_GET_FPEXC " (since Linux 2.4.21, 2.5.32, only on PowerPC)"
Return floating-point exception mode,
in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.BR PR_SET_KEEPCAPS " (since Linux 2.2.18)"
Set the state of the thread's "keep capabilities" flag,
which determines whether the threads's permitted
capability set is cleared when a change is made to the threads's user IDs
such that the threads's real UID, effective UID, and saved set-user-ID
all become nonzero when at least one of them previously had the value 0.
By default, the permitted capability set is cleared when such a change is made;
setting the "keep capabilities" flag prevents it from being cleared.
.I arg2
must be either 0 (permitted capabilities are cleared)
or 1 (permitted capabilities are kept).
(A thread's
.I effective
capability set is always cleared when such a credential change is made,
regardless of the setting of the "keep capabilities" flag.)
The "keep capabilities" value will be reset to 0 on subsequent calls to
.BR execve (2).
.TP
.BR PR_GET_KEEPCAPS " (since Linux 2.2.18)"
Return (as the function result) the current state of the calling threads's
"keep capabilities" flag.
.TP
.BR PR_SET_NAME " (since Linux 2.6.9)"
Set the process name for the calling process,
using the value in the location pointed to by
.IR "(char\ *) arg2" .
The name can be up to 16 bytes long,
.\" TASK_COMM_LEN in include/linux/sched.h
and should be null-terminated if it contains fewer bytes.
.TP
.BR PR_GET_NAME " (since Linux 2.6.11)"
Return the process name for the calling process,
in the buffer pointed to by
.IR "(char\ *) arg2" .
The buffer should allow space for up to 16 bytes;
the returned string will be null-terminated if it is shorter than that.
.TP
.BR PR_SET_PDEATHSIG " (since Linux 2.1.57)"
Set the parent process death signal
of the calling process to \fIarg2\fP (either a signal value
in the range 1..maxsig, or 0 to clear).
This is the signal that the calling process will get when its
parent dies.
This value is cleared for the child of a
.BR fork (2).
.TP
.BR PR_GET_PDEATHSIG " (since Linux 2.3.15)"
Return the current value of the parent process death signal,
in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.BR PR_SET_SECCOMP " (since Linux 2.6.23)"
.\" See http://thread.gmane.org/gmane.linux.kernel/542632
.\" [PATCH 0 of 2] seccomp updates
.\" andrea@cpushare.com
Set the secure computing mode for the calling thread.
In the current implementation,
.IR arg2
must be 1.
After the secure computing mode has been set to 1,
the only system calls that the thread is permitted to make are
.BR read (2),
.BR write (2),
.BR _exit (2),
and
.BR sigreturn (2).
Other system calls result in the delivery of a
.BR SIGKILL
signal.
Secure computing mode is useful for number-crunching applications
that may need to execute untrusted byte code,
perhaps obtained by reading from a pipe or socket.
This operation is only available
if the kernel is configured with CONFIG_SECCOMP enabled.
.TP
.BR PR_GET_SECCOMP " (since Linux 2.6.23)"
Return the secure computing mode of the calling thread.
Not very useful for the current implementation (mode equals 1),
but may be useful for other possible future modes:
if the caller is not in secure computing mode, this operation returns 0;
if the caller is in secure computing mode, then the
.BR prctl ()
call will cause a
.B SIGKILL
signal to be sent to the process.
This operation is only available
if the kernel is configured with CONFIG_SECCOMP enabled.
.TP
.BR PR_SET_SECUREBITS " (since Linux 2.6.26)"
Set the "securebits" flags of the calling thread to the value supplied in
.IR arg2 .
See
.BR capabilities (7).
.TP
.BR PR_GET_SECUREBITS " (since Linux 2.6.26)"
Return (as the function result)
the "securebits" flags of the calling thread.
See
.BR capabilities (7).
.TP
.BR PR_SET_TIMING " (since Linux 2.6.0-test4)"
Set whether to use (normal, traditional) statistical process timing or
accurate timestamp-based process timing, by passing
.B PR_TIMING_STATISTICAL
.\" 0
or
.B PR_TIMING_TIMESTAMP
.\" 1
to \fIarg2\fP.
.B PR_TIMING_TIMESTAMP
is not currently implemented
(attempting to set this mode will yield the error
.BR EINVAL ).
.\" PR_TIMING_TIMESTAMP doesn't do anything in 2.6.26-rc8,
.\" and looking at the patch history, it appears
.\" that it never did anything.
.TP
.BR PR_GET_TIMING " (since Linux 2.6.0-test4)"
Return (as the function result) which process timing method is currently
in use.
.TP
.BR PR_SET_TSC " (since Linux 2.6.26, x86 only)"
Set the state of the flag determining whether the timestamp counter
can be read by the process.
Pass
.B PR_TSC_ENABLE
to
.I arg2
to allow it to be read, or
.B PR_TSC_SIGSEGV
to generate a
.B SIGSEGV
when the process tries to read the timestamp counter.
.TP
.BR PR_GET_TSC " (since Linux 2.6.26, x86 only)"
Return the state of the flag determining whether the timestamp counter
can be read,
in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.B PR_SET_UNALIGN
(Only on: ia64, since Linux 2.3.48; parisc, since Linux 2.6.15;
PowerPC, since Linux 2.6.18; Alpha, since Linux 2.6.22)
Set unaligned access control bits to \fIarg2\fP.
Pass
\fBPR_UNALIGN_NOPRINT\fP to silently fix up unaligned user accesses,
or \fBPR_UNALIGN_SIGBUS\fP to generate
.B SIGBUS
on unaligned user access.
.TP
.B PR_GET_UNALIGN
(see
.B PR_SET_UNALIGN
for information on versions and architectures)
Return unaligned access control bits, in the location pointed to by
.IR "(int\ *) arg2" .
.TP
.BR PR_MCE_KILL " (since Linux 2.6.32)"
Set the machine check memory corruption kill policy for the current thread.
If
.I arg2
is
.BR PR_MCE_KILL_CLEAR ,
clear the thread memory corruption kill policy and use the system-wide default.
(The system-wide default is defined by
.IR /proc/sys/vm/memory_failure_early_kill ;
see
.BR proc (5).)
If
.I arg2
is
.BR PR_MCE_KILL_SET ,
use a thread-specific memory corruption kill policy.
In this case,
.I arg3
defines whether the policy is
.I early kill
.RB ( PR_MCE_KILL_EARLY ),
.I late kill
.RB ( PR_MCE_KILL_LATE ),
or the system-wide default
.RB ( PR_MCE_KILL_DEFAULT ).
Early kill means that the thread receives a
.B SIGBUS
signal as soon as hardware memory corruption is detected inside
its address space.
In late kill mode, the process is only killed when it accesses a corrupted page.
See
.BR sigaction (2)
for more information on the
.BR SIGBUS
signal.
The policy is inherited by children.
The remaining unused
.BR prctl ()
arguments must be zero for future compatibility.
.TP
.BR PR_MCE_KILL_GET " (since Linux 2.6.32)"
Return the current per-process machine check kill policy.
All unused
.BR prctl ()
arguments must be zero.
.TP
.BR PR_SET_MM " (since Linux 3.3)"
Modify certain kernel memory map descriptor fields
of the calling process.
Usually these fields are set by the kernel and dynamic loader (see
.BR ld.so (8)
for more information) and a regular application should not use this feature.
However, there are cases, such as self-modifying programs,
where a program might find it useful to change its own memory map.
This feature is available only if the kernel is built with the
.BR CONFIG_CHECKPOINT_RESTORE
option enabled.
The calling process must have the
.BR CAP_SYS_RESOURCE
capability.
The value in
.I arg2
is one of the options below, while
.I arg3
provides a new value for the option.
.RS
.TP
.BR PR_SET_MM_START_CODE
Set the address above which the program text can run.
The corresponding memory area must be readable and executable,
but not writable or sharable (see
.BR mprotect (2)
and
.BR mmap (2)
for more information).
.TP
.BR PR_SET_MM_END_CODE
Set the address below which the program text can run.
The corresponding memory area must be readable and executable,
but not writable or sharable.
.TP
.BR PR_SET_MM_START_DATA
Set the address above which initialized and
uninitialized (bss) data are placed.
The corresponding memory area must be readable and writable,
but not executable or sharable.
.TP
.B PR_SET_MM_END_DATA
Set the address below which initialized and
uninitialized (bss) data are placed.
The corresponding memory area must be readable and writable,
but not executable or sharable.
.TP
.BR PR_SET_MM_START_STACK
Set the start address of the stack.
The corresponding memory area must be readable and writable.
.TP
.BR PR_SET_MM_START_BRK
Set the address above which the program heap can be expanded with
.BR brk (2)
call.
The address must be greater than the ending address of
the current program data segment.
In addition, the combined size of the resulting heap and
the size of the data segment can't exceed the
.BR RLIMIT_DATA
resource limit (see
.BR setrlimit (2)).
.TP
.BR PR_SET_MM_BRK
Set the current
.BR brk (2)
value.
The requirements for the address are the same as for the
.BR PR_SET_MM_START_BRK
option.
.\" FIXME The following (until ========) is not yet in mainline kernel,
.\" so commented out for the moment.
.\" .TP
.\" .BR PR_SET_MM_ARG_START
.\" Set the address above which the program command line is placed.
.\" .TP
.\" .BR PR_SET_MM_ARG_END
.\" Set the address below which the program command line is placed.
.\" .TP
.\" .BR PR_SET_MM_ENV_START
.\" Set the address above which the program environment is placed.
.\" .TP
.\" .BR PR_SET_MM_ENV_END
.\" Set the address below which the program environment is placed.
.\" .IP
.\" The address passed with
.\" .BR PR_SET_MM_ARG_START ,
.\" .BR PR_SET_MM_ARG_END ,
.\" .BR PR_SET_MM_ENV_START ,
.\" and
.\" .BR PR_SET_MM_ENV_END
.\" should belong to a process stack area.
.\" Thus, the corresponding memory area must be readable, writable, and
.\" (depending on the kernel configuration) have the
.\" .BR MAP_GROWSDOWN
.\" attribute set (see
.\" .BR mmap (2)).
.\" .TP
.\" .BR PR_SET_MM_AUXV
.\" Set a new auxiliary vector.
.\" The
.\" .I arg3
.\" argument should provide the address of the vector.
.\" The
.\" .I arg4
.\" is the size of the vector.
.\" .TP
.\" .BR PR_SET_MM_EXE_FILE
.\" Supersede the
.\" .IR /proc/pid/exe
.\" symbolic link with a new one pointing to a new executable file
.\" identified by the file descriptor provided in
.\" .I arg3
.\" argument.
.\" The file descriptor should be obtained with a regular
.\" .BR open (2)
.\" call.
.\" .IP
.\" To change the symbolic link, one needs to unmap all existing
.\" executable memory areas, including those created by the kernel itself
.\" (for example the kernel usually creates at least one executable
.\" memory area for the ELF
.\" .IR \.text
.\" section).
.\" .IP
.\" The second limitation is that such transitions can be done only once
.\" in a process life time.
.\" Any further attempts will be rejected.
.\" This should help system administrators to monitor unusual
.\" symbolic-link transitions over all process running in a system.
.\" ========== END FIXME
.RE
.\"
.SH "RETURN VALUE"
On success,
.BR PR_GET_DUMPABLE ,
.BR PR_GET_KEEPCAPS ,
.BR PR_CAPBSET_READ ,
.BR PR_GET_TIMING ,
.BR PR_GET_SECUREBITS ,
.BR PR_MCE_KILL_GET ,
and (if it returns)
.BR PR_GET_SECCOMP
return the nonnegative values described above.
All other
.I option
values return 0 on success.
On error, \-1 is returned, and
.I errno
is set appropriately.
.SH ERRORS
.TP
.B EFAULT
.I arg2
is an invalid address.
.TP
.B EINVAL
The value of
.I option
is not recognized.
.TP
.B EINVAL
.I option
is
.BR PR_MCE_KILL
or
.BR PR_MCE_KILL_GET
or
.BR PR_SET_MM ,
and unused
.BR prctl ()
arguments were not specified as zero.
.TP
.B EINVAL
.I arg2
is not valid value for this
.IR option .
.TP
.B EINVAL
.I option
is
.BR PR_SET_SECCOMP
or
.BR PR_SET_SECCOMP ,
and the kernel was not configured with
.BR CONFIG_SECCOMP .
.TP
.B EINVAL
.I option
is
.BR PR_SET_MM ,
and one of the following is true
.RS
.IP * 3
.I arg4
or
.I arg5
is nonzero;
.IP *
.I arg3
is greater than
.B TASK_SIZE
(the limit on the size of the user address space for this architecture);
.IP *
.I arg2
is
.BR PR_SET_MM_START_CODE ,
.BR PR_SET_MM_END_CODE ,
.BR PR_SET_MM_START_DATA ,
.BR PR_SET_MM_END_DATA ,
or
.BR PR_SET_MM_START_STACK,
and the permissions of the corresponding memory area are not as required;
.IP *
.I arg2
is
.BR PR_SET_MM_START_BRK
or
.BR PR_SET_MM_BRK ,
and
.I arg3
is less than or equal to the end of the data segment
or specifies a value that would cause the
.B RLIMIT_DATA
resource limit to be exceeded.
.RE
.TP
.B EPERM
.I option
is
.BR PR_SET_SECUREBITS ,
and the caller does not have the
.B CAP_SETPCAP
capability,
or tried to unset a "locked" flag,
or tried to set a flag whose corresponding locked flag was set
(see
.BR capabilities (7)).
.TP
.B EPERM
.I option
is
.BR PR_SET_KEEPCAPS ,
and the callers's
.B SECURE_KEEP_CAPS_LOCKED
flag is set
(see
.BR capabilities (7)).
.TP
.B EPERM
.I option
is
.BR PR_CAPBSET_DROP ,
and the caller does not have the
.B CAP_SETPCAP
capability.
.TP
.B EPERM
.I option
is
.BR PR_SET_MM ,
and the caller does not have the
.B CAP_SYS_RESOURCE
capability.
.\" FIXME The following (until ========) is not yet in mainline kernel,
.\" so commented out for the moment.
.\" .TP
.\" .B EACCES
.\" .I option
.\" is
.\" .BR PR_SET_MM ,
.\" and
.\" .I arg3
.\" is
.\" .BR PR_SET_MM_EXE_FILE ,
.\" the file is not executable.
.\" .TP
.\" .B EBUSY
.\" .I option
.\" is
.\" .BR PR_SET_MM ,
.\" .I arg3
.\" is
.\" .BR PR_SET_MM_EXE_FILE ,
.\" and this the second attempt to change the
.\" .I /proc/pid/exe
.\" symbolic link, which is prohibited.
.\" .TP
.\" .B EBADF
.\" .I option
.\" is
.\" .BR PR_SET_MM ,
.\" .I arg3
.\" is
.\" .BR PR_SET_MM_EXE_FILE ,
.\" and the file descriptor passed in
.\" .I arg4
.\" is not valid.
.\" ========== END FIXME
.\" The following can't actually happen, because prctl() in
.\" seccomp mode will cause SIGKILL.
.\" .TP
.\" .B EPERM
.\" .I option
.\" is
.\" .BR PR_SET_SECCOMP ,
.\" and secure computing mode is already 1.
.SH VERSIONS
The
.BR prctl ()
system call was introduced in Linux 2.1.57.
.\" The library interface was added in glibc 2.0.6
.SH "CONFORMING TO"
This call is Linux-specific.
IRIX has a
.BR prctl ()
system call (also introduced in Linux 2.1.44
as irix_prctl on the MIPS architecture),
with prototype
.sp
.BI "ptrdiff_t prctl(int " option ", int " arg2 ", int " arg3 );
.sp
and options to get the maximum number of processes per user,
get the maximum number of processors the calling process can use,
find out whether a specified process is currently blocked,
get or set the maximum stack size, etc.
.SH "SEE ALSO"
.BR signal (2),
.BR core (5)

--e89a8f2352f5b0697204bdbf5113
Content-Type: application/octet-stream; name="prctl.2"
Content-Disposition: attachment; filename="prctl.2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h12o8gq60

LlwiIEhleSBFbWFjcyEgVGhpcyBmaWxlIGlzIC0qLSBucm9mZiAtKi0gc291cmNlLgouXCIKLlwi
IENvcHlyaWdodCAoQykgMTk5OCBBbmRyaWVzIEJyb3V3ZXIgKGFlYkBjd2kubmwpCi5cIiBhbmQg
Q29weXJpZ2h0IChDKSAyMDAyIE1pY2hhZWwgS2VycmlzayA8bXRrLm1hbnBhZ2VzQGdtYWlsLmNv
bT4KLlwiIGFuZCBDb3B5cmlnaHQgR3VpbGxlbSBKb3ZlciA8Z3VpbGxlbUBoYWRyb25zLm9yZz4K
LlwiCi5cIiBQZXJtaXNzaW9uIGlzIGdyYW50ZWQgdG8gbWFrZSBhbmQgZGlzdHJpYnV0ZSB2ZXJi
YXRpbSBjb3BpZXMgb2YgdGhpcwouXCIgbWFudWFsIHByb3ZpZGVkIHRoZSBjb3B5cmlnaHQgbm90
aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIGFyZQouXCIgcHJlc2VydmVkIG9uIGFsbCBj
b3BpZXMuCi5cIgouXCIgUGVybWlzc2lvbiBpcyBncmFudGVkIHRvIGNvcHkgYW5kIGRpc3RyaWJ1
dGUgbW9kaWZpZWQgdmVyc2lvbnMgb2YgdGhpcwouXCIgbWFudWFsIHVuZGVyIHRoZSBjb25kaXRp
b25zIGZvciB2ZXJiYXRpbSBjb3B5aW5nLCBwcm92aWRlZCB0aGF0IHRoZQouXCIgZW50aXJlIHJl
c3VsdGluZyBkZXJpdmVkIHdvcmsgaXMgZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIGEK
LlwiIHBlcm1pc3Npb24gbm90aWNlIGlkZW50aWNhbCB0byB0aGlzIG9uZS4KLlwiCi5cIiBTaW5j
ZSB0aGUgTGludXgga2VybmVsIGFuZCBsaWJyYXJpZXMgYXJlIGNvbnN0YW50bHkgY2hhbmdpbmcs
IHRoaXMKLlwiIG1hbnVhbCBwYWdlIG1heSBiZSBpbmNvcnJlY3Qgb3Igb3V0LW9mLWRhdGUuICBU
aGUgYXV0aG9yKHMpIGFzc3VtZSBubwouXCIgcmVzcG9uc2liaWxpdHkgZm9yIGVycm9ycyBvciBv
bWlzc2lvbnMsIG9yIGZvciBkYW1hZ2VzIHJlc3VsdGluZyBmcm9tCi5cIiB0aGUgdXNlIG9mIHRo
ZSBpbmZvcm1hdGlvbiBjb250YWluZWQgaGVyZWluLiAgVGhlIGF1dGhvcihzKSBtYXkgbm90Ci5c
IiBoYXZlIHRha2VuIHRoZSBzYW1lIGxldmVsIG9mIGNhcmUgaW4gdGhlIHByb2R1Y3Rpb24gb2Yg
dGhpcyBtYW51YWwsCi5cIiB3aGljaCBpcyBsaWNlbnNlZCBmcmVlIG9mIGNoYXJnZSwgYXMgdGhl
eSBtaWdodCB3aGVuIHdvcmtpbmcKLlwiIHByb2Zlc3Npb25hbGx5LgouXCIKLlwiIEZvcm1hdHRl
ZCBvciBwcm9jZXNzZWQgdmVyc2lvbnMgb2YgdGhpcyBtYW51YWwsIGlmIHVuYWNjb21wYW5pZWQg
YnkKLlwiIHRoZSBzb3VyY2UsIG11c3QgYWNrbm93bGVkZ2UgdGhlIGNvcHlyaWdodCBhbmQgYXV0
aG9ycyBvZiB0aGlzIHdvcmsuCi5cIgouXCIgTW9kaWZpZWQgVGh1IE5vdiAxMSAwNDoxOTo0MiBN
RVQgMTk5OSwgYWViOiBhZGRlZCBQUl9HRVRfUERFQVRIU0lHCi5cIiBNb2RpZmllZCAyNyBKdW4g
MDIsIE1pY2hhZWwgS2VycmlzawouXCIgCUFkZGVkIFBSX1NFVF9EVU1QQUJMRSwgUFJfR0VUX0RV
TVBBQkxFLAouXCIJUFJfU0VUX0tFRVBDQVBTLCBQUl9HRVRfS0VFUENBUFMKLlwiIE1vZGlmaWVk
IDIwMDYtMDgtMzAgR3VpbGxlbSBKb3ZlciA8Z3VpbGxlbUBoYWRyb25zLm9yZz4KLlwiCVVwZGF0
ZWQgTGludXggdmVyc2lvbnMgd2hlcmUgdGhlIG9wdGlvbnMgd2hlcmUgaW50cm9kdWNlZC4KLlwi
CUFkZGVkIFBSX1NFVF9USU1JTkcsIFBSX0dFVF9USU1JTkcsIFBSX1NFVF9OQU1FLCBQUl9HRVRf
TkFNRSwKLlwiCVBSX1NFVF9VTkFMSUdOLCBQUl9HRVRfVU5BTElHTiwgUFJfU0VUX0ZQRU1VLCBQ
Ul9HRVRfRlBFTVUsCi5cIglQUl9TRVRfRlBFWEMsIFBSX0dFVF9GUEVYQwouXCIgMjAwOC0wNC0y
OSBTZXJnZSBIYWxseW4sIERvY3VtZW50IFBSX0NBUEJTRVRfUkVBRCBhbmQgUFJfQ0FQQlNFVF9E
Uk9QCi5cIiAyMDA4LTA2LTEzIEVyaWsgQm9zbWFuLCA8ZWpib3NtYW5AY3MudnUubmw+Ci5cIiAg
ICAgRG9jdW1lbnQgUFJfR0VUX1RTQyBhbmQgUFJfU0VUX1RTQy4KLlwiIDIwMDgtMDYtMTUgbXRr
LCBEb2N1bWVudCBQUl9TRVRfU0VDQ09NUCwgUFJfR0VUX1NFQ0NPTVAKLlwiIDIwMDktMTAtMDMg
QW5kaSBLbGVlbiwgZG9jdW1lbnQgUFJfTUNFX0tJTExfKgouXCIKLlwiIEZJWE1FOiBEb2N1bWVu
dCBQUl9TRVRfVElNRVJTTEFDSyBhbmQgUFJfR0VUX1RJTUVSU0xBQ0sgKG5ldyBpbiAyLjYuMjgp
Ci5cIiBGSVhNRTogRG9jdW1lbnQgUFJfVEFTS19QRVJGX0VWRU5UU19ESVNBQkxFIGFuZAouXCIg
ICAgICAgIFBSX1RBU0tfUEVSRl9FVkVOVFNfRU5BQkxFIChuZXcgaW4gMi42LjMyKQouXCIKLlRI
IFBSQ1RMIDIgMjAxMi0wNC0xNCAiTGludXgiICJMaW51eCBQcm9ncmFtbWVyJ3MgTWFudWFsIgou
U0ggTkFNRQpwcmN0bCBcLSBvcGVyYXRpb25zIG9uIGEgcHJvY2VzcwouU0ggU1lOT1BTSVMKLm5m
Ci5CICNpbmNsdWRlIDxzeXMvcHJjdGwuaD4KLnNwCi5CSSAiaW50IHByY3RsKGludCAiIG9wdGlv
biAiLCB1bnNpZ25lZCBsb25nICIgYXJnMiAiLCB1bnNpZ25lZCBsb25nICIgYXJnMyAsCi5CSSAi
ICAgICAgICAgIHVuc2lnbmVkIGxvbmcgIiBhcmc0ICIsIHVuc2lnbmVkIGxvbmcgIiBhcmc1ICk7
Ci5maQouU0ggREVTQ1JJUFRJT04KLkJSIHByY3RsICgpCmlzIGNhbGxlZCB3aXRoIGEgZmlyc3Qg
YXJndW1lbnQgZGVzY3JpYmluZyB3aGF0IHRvIGRvCih3aXRoIHZhbHVlcyBkZWZpbmVkIGluIFxm
STxsaW51eC9wcmN0bC5oPlxmUCksIGFuZCBmdXJ0aGVyCmFyZ3VtZW50cyB3aXRoIGEgc2lnbmlm
aWNhbmNlIGRlcGVuZGluZyBvbiB0aGUgZmlyc3Qgb25lLgpUaGUgZmlyc3QgYXJndW1lbnQgY2Fu
IGJlOgouVFAKLkJSIFBSX0NBUEJTRVRfUkVBRCAiIChzaW5jZSBMaW51eCAyLjYuMjUpIgpSZXR1
cm4gKGFzIHRoZSBmdW5jdGlvbiByZXN1bHQpIDEgaWYgdGhlIGNhcGFiaWxpdHkgc3BlY2lmaWVk
IGluCi5JIGFyZzIKaXMgaW4gdGhlIGNhbGxpbmcgdGhyZWFkJ3MgY2FwYWJpbGl0eSBib3VuZGlu
ZyBzZXQsCm9yIDAgaWYgaXQgaXMgbm90LgooVGhlIGNhcGFiaWxpdHkgY29uc3RhbnRzIGFyZSBk
ZWZpbmVkIGluCi5JUiA8bGludXgvY2FwYWJpbGl0eS5oPiAuKQpUaGUgY2FwYWJpbGl0eSBib3Vu
ZGluZyBzZXQgZGljdGF0ZXMKd2hldGhlciB0aGUgcHJvY2VzcyBjYW4gcmVjZWl2ZSB0aGUgY2Fw
YWJpbGl0eSB0aHJvdWdoIGEKZmlsZSdzIHBlcm1pdHRlZCBjYXBhYmlsaXR5IHNldCBvbiBhIHN1
YnNlcXVlbnQgY2FsbCB0bwouQlIgZXhlY3ZlICgyKS4KCklmIHRoZSBjYXBhYmlsaXR5IHNwZWNp
ZmllZCBpbgouSSBhcmcyCmlzIG5vdCB2YWxpZCwgdGhlbiB0aGUgY2FsbCBmYWlscyB3aXRoIHRo
ZSBlcnJvcgouQlIgRUlOVkFMIC4KLlRQCi5CUiBQUl9DQVBCU0VUX0RST1AgIiAoc2luY2UgTGlu
dXggMi42LjI1KSIKSWYgdGhlIGNhbGxpbmcgdGhyZWFkIGhhcyB0aGUKLkIgQ0FQX1NFVFBDQVAK
Y2FwYWJpbGl0eSwgdGhlbiBkcm9wIHRoZSBjYXBhYmlsaXR5IHNwZWNpZmllZCBieQouSSBhcmcy
CmZyb20gdGhlIGNhbGxpbmcgdGhyZWFkJ3MgY2FwYWJpbGl0eSBib3VuZGluZyBzZXQuCkFueSBj
aGlsZHJlbiBvZiB0aGUgY2FsbGluZyB0aHJlYWQgd2lsbCBpbmhlcml0IHRoZSBuZXdseQpyZWR1
Y2VkIGJvdW5kaW5nIHNldC4KClRoZSBjYWxsIGZhaWxzIHdpdGggdGhlIGVycm9yOgouQiBFUEVS
TQppZiB0aGUgY2FsbGluZyB0aHJlYWQgZG9lcyBub3QgaGF2ZSB0aGUKLkJSIENBUF9TRVRQQ0FQ
IDsKLkJSIEVJTlZBTAppZgouSSBhcmcyCmRvZXMgbm90IHJlcHJlc2VudCBhIHZhbGlkIGNhcGFi
aWxpdHk7IG9yCi5CUiBFSU5WQUwKaWYgZmlsZSBjYXBhYmlsaXRpZXMgYXJlIG5vdCBlbmFibGVk
IGluIHRoZSBrZXJuZWwsCmluIHdoaWNoIGNhc2UgYm91bmRpbmcgc2V0cyBhcmUgbm90IHN1cHBv
cnRlZC4KLlRQCi5CUiBQUl9TRVRfRFVNUEFCTEUgIiAoc2luY2UgTGludXggMi4zLjIwKSIKU2V0
IHRoZSBzdGF0ZSBvZiB0aGUgZmxhZyBkZXRlcm1pbmluZyB3aGV0aGVyIGNvcmUgZHVtcHMgYXJl
IHByb2R1Y2VkCmZvciB0aGlzIHByb2Nlc3MgdXBvbiBkZWxpdmVyeSBvZiBhIHNpZ25hbCB3aG9z
ZSBkZWZhdWx0IGJlaGF2aW9yIGlzCnRvIHByb2R1Y2UgYSBjb3JlIGR1bXAuCihOb3JtYWxseSB0
aGlzIGZsYWcgaXMgc2V0IGZvciBhIHByb2Nlc3MgYnkgZGVmYXVsdCwgYnV0IGl0IGlzIGNsZWFy
ZWQKd2hlbiBhIHNldC11c2VyLUlEIG9yIHNldC1ncm91cC1JRCBwcm9ncmFtIGlzIGV4ZWN1dGVk
IGFuZCBhbHNvIGJ5CnZhcmlvdXMgc3lzdGVtIGNhbGxzIHRoYXQgbWFuaXB1bGF0ZSBwcm9jZXNz
IFVJRHMgYW5kIEdJRHMpLgpJbiBrZXJuZWxzIHVwIHRvIGFuZCBpbmNsdWRpbmcgMi42LjEyLAou
SSBhcmcyCm11c3QgYmUgZWl0aGVyIDAgKHByb2Nlc3MgaXMgbm90IGR1bXBhYmxlKSBvciAxIChw
cm9jZXNzIGlzIGR1bXBhYmxlKS4KQmV0d2VlbiBrZXJuZWxzIDIuNi4xMyBhbmQgMi42LjE3LCB0
aGUgdmFsdWUgMiB3YXMgYWxzbyBwZXJtaXR0ZWQsCndoaWNoIGNhdXNlZCBhbnkgYmluYXJ5IHdo
aWNoIG5vcm1hbGx5IHdvdWxkIG5vdCBiZSBkdW1wZWQKdG8gYmUgZHVtcGVkIHJlYWRhYmxlIGJ5
IHJvb3Qgb25seTsKZm9yIHNlY3VyaXR5IHJlYXNvbnMsIHRoaXMgZmVhdHVyZSBoYXMgYmVlbiBy
ZW1vdmVkLgouXCIgU2VlIGh0dHA6Ly9tYXJjLnRoZWFpbXNncm91cC5jb20vP2w9bGludXgta2Vy
bmVsJm09MTE1MjcwMjg5MDMwNjMwJnc9MgouXCIgU3ViamVjdDogICAgRml4IHByY3RsIHByaXZp
bGVnZSBlc2NhbGF0aW9uIChDVkUtMjAwNi0yNDUxKQouXCIgRnJvbTogICAgICAgTWFyY2VsIEhv
bHRtYW5uIDxtYXJjZWwgKCkgaG9sdG1hbm4gISBvcmc+Ci5cIiBEYXRlOiAgICAgICAyMDA2LTA3
LTEyIDExOjEyOjAwCihTZWUgYWxzbyB0aGUgZGVzY3JpcHRpb24gb2YKLkkgL3Byb2Mvc3lzL2Zz
L3N1aWRfZHVtcGFibGUKaW4KLkJSIHByb2MgKDUpLikKUHJvY2Vzc2VzIHRoYXQgYXJlIG5vdCBk
dW1wYWJsZSBjYW4gbm90IGJlIGF0dGFjaGVkIHZpYQouQlIgcHRyYWNlKDIpCi5CUiBQVFJBQ0Vf
QVRUQUNIIC4KLlRQCi5CUiBQUl9HRVRfRFVNUEFCTEUgIiAoc2luY2UgTGludXggMi4zLjIwKSIK
UmV0dXJuIChhcyB0aGUgZnVuY3Rpb24gcmVzdWx0KSB0aGUgY3VycmVudCBzdGF0ZSBvZiB0aGUg
Y2FsbGluZwpwcm9jZXNzJ3MgZHVtcGFibGUgZmxhZy4KLlwiIFNpbmNlIExpbnV4IDIuNi4xMywg
dGhlIGR1bXBhYmxlIGZsYWcgY2FuIGhhdmUgdGhlIHZhbHVlIDIsCi5cIiBidXQgaW4gMi42LjEz
IFBSX0dFVF9EVU1QQUJMRSBzaW1wbHkgcmV0dXJucyAxIGlmIHRoZSBkdW1wYWJsZQouXCIgZmxh
Z3MgaGFzIGEgbm9uemVybyB2YWx1ZS4gIFRoaXMgd2FzIGZpeGVkIGluIDIuNi4xNC4KLlRQCi5C
UiBQUl9TRVRfRU5ESUFOICIgKHNpbmNlIExpbnV4IDIuNi4xOCwgUG93ZXJQQyBvbmx5KSIKU2V0
IHRoZSBlbmRpYW4tbmVzcyBvZiB0aGUgY2FsbGluZyBwcm9jZXNzIHRvIHRoZSB2YWx1ZSBnaXZl
bgppbiBcZklhcmcyXGZQLCB3aGljaCBzaG91bGQgYmUgb25lIG9mIHRoZSBmb2xsb3dpbmc6Ci5c
IiBSZXNwZWN0aXZlbHkgMCwgMSwgMgouQlIgUFJfRU5ESUFOX0JJRyAsCi5CUiBQUl9FTkRJQU5f
TElUVExFICwKb3IKLkIgUFJfRU5ESUFOX1BQQ19MSVRUTEUKKFBvd2VyUEMgcHNldWRvIGxpdHRs
ZSBlbmRpYW4pLgouVFAKLkJSIFBSX0dFVF9FTkRJQU4gIiAoc2luY2UgTGludXggMi42LjE4LCBQ
b3dlclBDIG9ubHkpIgpSZXR1cm4gdGhlIGVuZGlhbi1uZXNzIG9mIHRoZSBjYWxsaW5nIHByb2Nl
c3MsCmluIHRoZSBsb2NhdGlvbiBwb2ludGVkIHRvIGJ5Ci5JUiAiKGludFwgKikgYXJnMiIgLgou
VFAKLkJSIFBSX1NFVF9GUEVNVSAiIChzaW5jZSBMaW51eCAyLjQuMTgsIDIuNS45LCBvbmx5IG9u
IGlhNjQpIgpTZXQgZmxvYXRpbmctcG9pbnQgZW11bGF0aW9uIGNvbnRyb2wgYml0cyB0byBcZklh
cmcyXGZQLgpQYXNzIFxmQlBSX0ZQRU1VX05PUFJJTlRcZlAgdG8gc2lsZW50bHkgZW11bGF0ZSBm
cCBvcGVyYXRpb25zIGFjY2Vzc2VzLCBvcgpcZkJQUl9GUEVNVV9TSUdGUEVcZlAgdG8gbm90IGVt
dWxhdGUgZnAgb3BlcmF0aW9ucyBhbmQgc2VuZAouQiBTSUdGUEUKaW5zdGVhZC4KLlRQCi5CUiBQ
Ul9HRVRfRlBFTVUgIiAoc2luY2UgTGludXggMi40LjE4LCAyLjUuOSwgb25seSBvbiBpYTY0KSIK
UmV0dXJuIGZsb2F0aW5nLXBvaW50IGVtdWxhdGlvbiBjb250cm9sIGJpdHMsCmluIHRoZSBsb2Nh
dGlvbiBwb2ludGVkIHRvIGJ5Ci5JUiAiKGludFwgKikgYXJnMiIgLgouVFAKLkJSIFBSX1NFVF9G
UEVYQyAiIChzaW5jZSBMaW51eCAyLjQuMjEsIDIuNS4zMiwgb25seSBvbiBQb3dlclBDKSIKU2V0
IGZsb2F0aW5nLXBvaW50IGV4Y2VwdGlvbiBtb2RlIHRvIFxmSWFyZzJcZlAuClBhc3MgXGZCUFJf
RlBfRVhDX1NXX0VOQUJMRVxmUCB0byB1c2UgRlBFWEMgZm9yIEZQIGV4Y2VwdGlvbiBlbmFibGVz
LApcZkJQUl9GUF9FWENfRElWXGZQIGZvciBmbG9hdGluZy1wb2ludCBkaXZpZGUgYnkgemVybywK
XGZCUFJfRlBfRVhDX09WRlxmUCBmb3IgZmxvYXRpbmctcG9pbnQgb3ZlcmZsb3csClxmQlBSX0ZQ
X0VYQ19VTkRcZlAgZm9yIGZsb2F0aW5nLXBvaW50IHVuZGVyZmxvdywKXGZCUFJfRlBfRVhDX1JF
U1xmUCBmb3IgZmxvYXRpbmctcG9pbnQgaW5leGFjdCByZXN1bHQsClxmQlBSX0ZQX0VYQ19JTlZc
ZlAgZm9yIGZsb2F0aW5nLXBvaW50IGludmFsaWQgb3BlcmF0aW9uLApcZkJQUl9GUF9FWENfRElT
QUJMRURcZlAgZm9yIEZQIGV4Y2VwdGlvbnMgZGlzYWJsZWQsClxmQlBSX0ZQX0VYQ19OT05SRUNP
VlxmUCBmb3IgYXN5bmMgbm9ucmVjb3ZlcmFibGUgZXhjZXB0aW9uIG1vZGUsClxmQlBSX0ZQX0VY
Q19BU1lOQ1xmUCBmb3IgYXN5bmMgcmVjb3ZlcmFibGUgZXhjZXB0aW9uIG1vZGUsClxmQlBSX0ZQ
X0VYQ19QUkVDSVNFXGZQIGZvciBwcmVjaXNlIGV4Y2VwdGlvbiBtb2RlLgouVFAKLkJSIFBSX0dF
VF9GUEVYQyAiIChzaW5jZSBMaW51eCAyLjQuMjEsIDIuNS4zMiwgb25seSBvbiBQb3dlclBDKSIK
UmV0dXJuIGZsb2F0aW5nLXBvaW50IGV4Y2VwdGlvbiBtb2RlLAppbiB0aGUgbG9jYXRpb24gcG9p
bnRlZCB0byBieQouSVIgIihpbnRcICopIGFyZzIiIC4KLlRQCi5CUiBQUl9TRVRfS0VFUENBUFMg
IiAoc2luY2UgTGludXggMi4yLjE4KSIKU2V0IHRoZSBzdGF0ZSBvZiB0aGUgdGhyZWFkJ3MgImtl
ZXAgY2FwYWJpbGl0aWVzIiBmbGFnLAp3aGljaCBkZXRlcm1pbmVzIHdoZXRoZXIgdGhlIHRocmVh
ZHMncyBwZXJtaXR0ZWQKY2FwYWJpbGl0eSBzZXQgaXMgY2xlYXJlZCB3aGVuIGEgY2hhbmdlIGlz
IG1hZGUgdG8gdGhlIHRocmVhZHMncyB1c2VyIElEcwpzdWNoIHRoYXQgdGhlIHRocmVhZHMncyBy
ZWFsIFVJRCwgZWZmZWN0aXZlIFVJRCwgYW5kIHNhdmVkIHNldC11c2VyLUlECmFsbCBiZWNvbWUg
bm9uemVybyB3aGVuIGF0IGxlYXN0IG9uZSBvZiB0aGVtIHByZXZpb3VzbHkgaGFkIHRoZSB2YWx1
ZSAwLgpCeSBkZWZhdWx0LCB0aGUgcGVybWl0dGVkIGNhcGFiaWxpdHkgc2V0IGlzIGNsZWFyZWQg
d2hlbiBzdWNoIGEgY2hhbmdlIGlzIG1hZGU7CnNldHRpbmcgdGhlICJrZWVwIGNhcGFiaWxpdGll
cyIgZmxhZyBwcmV2ZW50cyBpdCBmcm9tIGJlaW5nIGNsZWFyZWQuCi5JIGFyZzIKbXVzdCBiZSBl
aXRoZXIgMCAocGVybWl0dGVkIGNhcGFiaWxpdGllcyBhcmUgY2xlYXJlZCkKb3IgMSAocGVybWl0
dGVkIGNhcGFiaWxpdGllcyBhcmUga2VwdCkuCihBIHRocmVhZCdzCi5JIGVmZmVjdGl2ZQpjYXBh
YmlsaXR5IHNldCBpcyBhbHdheXMgY2xlYXJlZCB3aGVuIHN1Y2ggYSBjcmVkZW50aWFsIGNoYW5n
ZSBpcyBtYWRlLApyZWdhcmRsZXNzIG9mIHRoZSBzZXR0aW5nIG9mIHRoZSAia2VlcCBjYXBhYmls
aXRpZXMiIGZsYWcuKQpUaGUgImtlZXAgY2FwYWJpbGl0aWVzIiB2YWx1ZSB3aWxsIGJlIHJlc2V0
IHRvIDAgb24gc3Vic2VxdWVudCBjYWxscyB0bwouQlIgZXhlY3ZlICgyKS4KLlRQCi5CUiBQUl9H
RVRfS0VFUENBUFMgIiAoc2luY2UgTGludXggMi4yLjE4KSIKUmV0dXJuIChhcyB0aGUgZnVuY3Rp
b24gcmVzdWx0KSB0aGUgY3VycmVudCBzdGF0ZSBvZiB0aGUgY2FsbGluZyB0aHJlYWRzJ3MKImtl
ZXAgY2FwYWJpbGl0aWVzIiBmbGFnLgouVFAKLkJSIFBSX1NFVF9OQU1FICIgKHNpbmNlIExpbnV4
IDIuNi45KSIKU2V0IHRoZSBwcm9jZXNzIG5hbWUgZm9yIHRoZSBjYWxsaW5nIHByb2Nlc3MsCnVz
aW5nIHRoZSB2YWx1ZSBpbiB0aGUgbG9jYXRpb24gcG9pbnRlZCB0byBieQouSVIgIihjaGFyXCAq
KSBhcmcyIiAuClRoZSBuYW1lIGNhbiBiZSB1cCB0byAxNiBieXRlcyBsb25nLAouXCIgVEFTS19D
T01NX0xFTiBpbiBpbmNsdWRlL2xpbnV4L3NjaGVkLmgKYW5kIHNob3VsZCBiZSBudWxsLXRlcm1p
bmF0ZWQgaWYgaXQgY29udGFpbnMgZmV3ZXIgYnl0ZXMuCi5UUAouQlIgUFJfR0VUX05BTUUgIiAo
c2luY2UgTGludXggMi42LjExKSIKUmV0dXJuIHRoZSBwcm9jZXNzIG5hbWUgZm9yIHRoZSBjYWxs
aW5nIHByb2Nlc3MsCmluIHRoZSBidWZmZXIgcG9pbnRlZCB0byBieQouSVIgIihjaGFyXCAqKSBh
cmcyIiAuClRoZSBidWZmZXIgc2hvdWxkIGFsbG93IHNwYWNlIGZvciB1cCB0byAxNiBieXRlczsK
dGhlIHJldHVybmVkIHN0cmluZyB3aWxsIGJlIG51bGwtdGVybWluYXRlZCBpZiBpdCBpcyBzaG9y
dGVyIHRoYW4gdGhhdC4KLlRQCi5CUiBQUl9TRVRfUERFQVRIU0lHICIgKHNpbmNlIExpbnV4IDIu
MS41NykiClNldCB0aGUgcGFyZW50IHByb2Nlc3MgZGVhdGggc2lnbmFsCm9mIHRoZSBjYWxsaW5n
IHByb2Nlc3MgdG8gXGZJYXJnMlxmUCAoZWl0aGVyIGEgc2lnbmFsIHZhbHVlCmluIHRoZSByYW5n
ZSAxLi5tYXhzaWcsIG9yIDAgdG8gY2xlYXIpLgpUaGlzIGlzIHRoZSBzaWduYWwgdGhhdCB0aGUg
Y2FsbGluZyBwcm9jZXNzIHdpbGwgZ2V0IHdoZW4gaXRzCnBhcmVudCBkaWVzLgpUaGlzIHZhbHVl
IGlzIGNsZWFyZWQgZm9yIHRoZSBjaGlsZCBvZiBhCi5CUiBmb3JrICgyKS4KLlRQCi5CUiBQUl9H
RVRfUERFQVRIU0lHICIgKHNpbmNlIExpbnV4IDIuMy4xNSkiClJldHVybiB0aGUgY3VycmVudCB2
YWx1ZSBvZiB0aGUgcGFyZW50IHByb2Nlc3MgZGVhdGggc2lnbmFsLAppbiB0aGUgbG9jYXRpb24g
cG9pbnRlZCB0byBieQouSVIgIihpbnRcICopIGFyZzIiIC4KLlRQCi5CUiBQUl9TRVRfU0VDQ09N
UCAiIChzaW5jZSBMaW51eCAyLjYuMjMpIgouXCIgU2VlIGh0dHA6Ly90aHJlYWQuZ21hbmUub3Jn
L2dtYW5lLmxpbnV4Lmtlcm5lbC81NDI2MzIKLlwiIFtQQVRDSCAwIG9mIDJdIHNlY2NvbXAgdXBk
YXRlcwouXCIgYW5kcmVhQGNwdXNoYXJlLmNvbQpTZXQgdGhlIHNlY3VyZSBjb21wdXRpbmcgbW9k
ZSBmb3IgdGhlIGNhbGxpbmcgdGhyZWFkLgpJbiB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiwK
LklSIGFyZzIKbXVzdCBiZSAxLgpBZnRlciB0aGUgc2VjdXJlIGNvbXB1dGluZyBtb2RlIGhhcyBi
ZWVuIHNldCB0byAxLAp0aGUgb25seSBzeXN0ZW0gY2FsbHMgdGhhdCB0aGUgdGhyZWFkIGlzIHBl
cm1pdHRlZCB0byBtYWtlIGFyZQouQlIgcmVhZCAoMiksCi5CUiB3cml0ZSAoMiksCi5CUiBfZXhp
dCAoMiksCmFuZAouQlIgc2lncmV0dXJuICgyKS4KT3RoZXIgc3lzdGVtIGNhbGxzIHJlc3VsdCBp
biB0aGUgZGVsaXZlcnkgb2YgYQouQlIgU0lHS0lMTApzaWduYWwuClNlY3VyZSBjb21wdXRpbmcg
bW9kZSBpcyB1c2VmdWwgZm9yIG51bWJlci1jcnVuY2hpbmcgYXBwbGljYXRpb25zCnRoYXQgbWF5
IG5lZWQgdG8gZXhlY3V0ZSB1bnRydXN0ZWQgYnl0ZSBjb2RlLApwZXJoYXBzIG9idGFpbmVkIGJ5
IHJlYWRpbmcgZnJvbSBhIHBpcGUgb3Igc29ja2V0LgpUaGlzIG9wZXJhdGlvbiBpcyBvbmx5IGF2
YWlsYWJsZQppZiB0aGUga2VybmVsIGlzIGNvbmZpZ3VyZWQgd2l0aCBDT05GSUdfU0VDQ09NUCBl
bmFibGVkLgouVFAKLkJSIFBSX0dFVF9TRUNDT01QICIgKHNpbmNlIExpbnV4IDIuNi4yMykiClJl
dHVybiB0aGUgc2VjdXJlIGNvbXB1dGluZyBtb2RlIG9mIHRoZSBjYWxsaW5nIHRocmVhZC4KTm90
IHZlcnkgdXNlZnVsIGZvciB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiAobW9kZSBlcXVhbHMg
MSksCmJ1dCBtYXkgYmUgdXNlZnVsIGZvciBvdGhlciBwb3NzaWJsZSBmdXR1cmUgbW9kZXM6Cmlm
IHRoZSBjYWxsZXIgaXMgbm90IGluIHNlY3VyZSBjb21wdXRpbmcgbW9kZSwgdGhpcyBvcGVyYXRp
b24gcmV0dXJucyAwOwppZiB0aGUgY2FsbGVyIGlzIGluIHNlY3VyZSBjb21wdXRpbmcgbW9kZSwg
dGhlbiB0aGUKLkJSIHByY3RsICgpCmNhbGwgd2lsbCBjYXVzZSBhCi5CIFNJR0tJTEwKc2lnbmFs
IHRvIGJlIHNlbnQgdG8gdGhlIHByb2Nlc3MuClRoaXMgb3BlcmF0aW9uIGlzIG9ubHkgYXZhaWxh
YmxlCmlmIHRoZSBrZXJuZWwgaXMgY29uZmlndXJlZCB3aXRoIENPTkZJR19TRUNDT01QIGVuYWJs
ZWQuCi5UUAouQlIgUFJfU0VUX1NFQ1VSRUJJVFMgIiAoc2luY2UgTGludXggMi42LjI2KSIKU2V0
IHRoZSAic2VjdXJlYml0cyIgZmxhZ3Mgb2YgdGhlIGNhbGxpbmcgdGhyZWFkIHRvIHRoZSB2YWx1
ZSBzdXBwbGllZCBpbgouSVIgYXJnMiAuClNlZQouQlIgY2FwYWJpbGl0aWVzICg3KS4KLlRQCi5C
UiBQUl9HRVRfU0VDVVJFQklUUyAiIChzaW5jZSBMaW51eCAyLjYuMjYpIgpSZXR1cm4gKGFzIHRo
ZSBmdW5jdGlvbiByZXN1bHQpCnRoZSAic2VjdXJlYml0cyIgZmxhZ3Mgb2YgdGhlIGNhbGxpbmcg
dGhyZWFkLgpTZWUKLkJSIGNhcGFiaWxpdGllcyAoNykuCi5UUAouQlIgUFJfU0VUX1RJTUlORyAi
IChzaW5jZSBMaW51eCAyLjYuMC10ZXN0NCkiClNldCB3aGV0aGVyIHRvIHVzZSAobm9ybWFsLCB0
cmFkaXRpb25hbCkgc3RhdGlzdGljYWwgcHJvY2VzcyB0aW1pbmcgb3IKYWNjdXJhdGUgdGltZXN0
YW1wLWJhc2VkIHByb2Nlc3MgdGltaW5nLCBieSBwYXNzaW5nCi5CIFBSX1RJTUlOR19TVEFUSVNU
SUNBTAouXCIgMApvcgouQiBQUl9USU1JTkdfVElNRVNUQU1QCi5cIiAxCnRvIFxmSWFyZzJcZlAu
Ci5CIFBSX1RJTUlOR19USU1FU1RBTVAKaXMgbm90IGN1cnJlbnRseSBpbXBsZW1lbnRlZAooYXR0
ZW1wdGluZyB0byBzZXQgdGhpcyBtb2RlIHdpbGwgeWllbGQgdGhlIGVycm9yCi5CUiBFSU5WQUwg
KS4KLlwiIFBSX1RJTUlOR19USU1FU1RBTVAgZG9lc24ndCBkbyBhbnl0aGluZyBpbiAyLjYuMjYt
cmM4LAouXCIgYW5kIGxvb2tpbmcgYXQgdGhlIHBhdGNoIGhpc3RvcnksIGl0IGFwcGVhcnMKLlwi
IHRoYXQgaXQgbmV2ZXIgZGlkIGFueXRoaW5nLgouVFAKLkJSIFBSX0dFVF9USU1JTkcgIiAoc2lu
Y2UgTGludXggMi42LjAtdGVzdDQpIgpSZXR1cm4gKGFzIHRoZSBmdW5jdGlvbiByZXN1bHQpIHdo
aWNoIHByb2Nlc3MgdGltaW5nIG1ldGhvZCBpcyBjdXJyZW50bHkKaW4gdXNlLgouVFAKLkJSIFBS
X1NFVF9UU0MgIiAoc2luY2UgTGludXggMi42LjI2LCB4ODYgb25seSkiClNldCB0aGUgc3RhdGUg
b2YgdGhlIGZsYWcgZGV0ZXJtaW5pbmcgd2hldGhlciB0aGUgdGltZXN0YW1wIGNvdW50ZXIKY2Fu
IGJlIHJlYWQgYnkgdGhlIHByb2Nlc3MuClBhc3MKLkIgUFJfVFNDX0VOQUJMRQp0bwouSSBhcmcy
CnRvIGFsbG93IGl0IHRvIGJlIHJlYWQsIG9yCi5CIFBSX1RTQ19TSUdTRUdWCnRvIGdlbmVyYXRl
IGEKLkIgU0lHU0VHVgp3aGVuIHRoZSBwcm9jZXNzIHRyaWVzIHRvIHJlYWQgdGhlIHRpbWVzdGFt
cCBjb3VudGVyLgouVFAKLkJSIFBSX0dFVF9UU0MgIiAoc2luY2UgTGludXggMi42LjI2LCB4ODYg
b25seSkiClJldHVybiB0aGUgc3RhdGUgb2YgdGhlIGZsYWcgZGV0ZXJtaW5pbmcgd2hldGhlciB0
aGUgdGltZXN0YW1wIGNvdW50ZXIKY2FuIGJlIHJlYWQsCmluIHRoZSBsb2NhdGlvbiBwb2ludGVk
IHRvIGJ5Ci5JUiAiKGludFwgKikgYXJnMiIgLgouVFAKLkIgUFJfU0VUX1VOQUxJR04KKE9ubHkg
b246IGlhNjQsIHNpbmNlIExpbnV4IDIuMy40ODsgcGFyaXNjLCBzaW5jZSBMaW51eCAyLjYuMTU7
ClBvd2VyUEMsIHNpbmNlIExpbnV4IDIuNi4xODsgQWxwaGEsIHNpbmNlIExpbnV4IDIuNi4yMikK
U2V0IHVuYWxpZ25lZCBhY2Nlc3MgY29udHJvbCBiaXRzIHRvIFxmSWFyZzJcZlAuClBhc3MKXGZC
UFJfVU5BTElHTl9OT1BSSU5UXGZQIHRvIHNpbGVudGx5IGZpeCB1cCB1bmFsaWduZWQgdXNlciBh
Y2Nlc3NlcywKb3IgXGZCUFJfVU5BTElHTl9TSUdCVVNcZlAgdG8gZ2VuZXJhdGUKLkIgU0lHQlVT
Cm9uIHVuYWxpZ25lZCB1c2VyIGFjY2Vzcy4KLlRQCi5CIFBSX0dFVF9VTkFMSUdOCihzZWUKLkIg
UFJfU0VUX1VOQUxJR04KZm9yIGluZm9ybWF0aW9uIG9uIHZlcnNpb25zIGFuZCBhcmNoaXRlY3R1
cmVzKQpSZXR1cm4gdW5hbGlnbmVkIGFjY2VzcyBjb250cm9sIGJpdHMsIGluIHRoZSBsb2NhdGlv
biBwb2ludGVkIHRvIGJ5Ci5JUiAiKGludFwgKikgYXJnMiIgLgouVFAKLkJSIFBSX01DRV9LSUxM
ICIgKHNpbmNlIExpbnV4IDIuNi4zMikiClNldCB0aGUgbWFjaGluZSBjaGVjayBtZW1vcnkgY29y
cnVwdGlvbiBraWxsIHBvbGljeSBmb3IgdGhlIGN1cnJlbnQgdGhyZWFkLgpJZgouSSBhcmcyCmlz
Ci5CUiBQUl9NQ0VfS0lMTF9DTEVBUiAsCmNsZWFyIHRoZSB0aHJlYWQgbWVtb3J5IGNvcnJ1cHRp
b24ga2lsbCBwb2xpY3kgYW5kIHVzZSB0aGUgc3lzdGVtLXdpZGUgZGVmYXVsdC4KKFRoZSBzeXN0
ZW0td2lkZSBkZWZhdWx0IGlzIGRlZmluZWQgYnkKLklSIC9wcm9jL3N5cy92bS9tZW1vcnlfZmFp
bHVyZV9lYXJseV9raWxsIDsKc2VlCi5CUiBwcm9jICg1KS4pCklmCi5JIGFyZzIKaXMKLkJSIFBS
X01DRV9LSUxMX1NFVCAsCnVzZSBhIHRocmVhZC1zcGVjaWZpYyBtZW1vcnkgY29ycnVwdGlvbiBr
aWxsIHBvbGljeS4KSW4gdGhpcyBjYXNlLAouSSBhcmczCmRlZmluZXMgd2hldGhlciB0aGUgcG9s
aWN5IGlzCi5JIGVhcmx5IGtpbGwKLlJCICggUFJfTUNFX0tJTExfRUFSTFkgKSwKLkkgbGF0ZSBr
aWxsCi5SQiAoIFBSX01DRV9LSUxMX0xBVEUgKSwKb3IgdGhlIHN5c3RlbS13aWRlIGRlZmF1bHQK
LlJCICggUFJfTUNFX0tJTExfREVGQVVMVCApLgpFYXJseSBraWxsIG1lYW5zIHRoYXQgdGhlIHRo
cmVhZCByZWNlaXZlcyBhCi5CIFNJR0JVUwpzaWduYWwgYXMgc29vbiBhcyBoYXJkd2FyZSBtZW1v
cnkgY29ycnVwdGlvbiBpcyBkZXRlY3RlZCBpbnNpZGUKaXRzIGFkZHJlc3Mgc3BhY2UuCkluIGxh
dGUga2lsbCBtb2RlLCB0aGUgcHJvY2VzcyBpcyBvbmx5IGtpbGxlZCB3aGVuIGl0IGFjY2Vzc2Vz
IGEgY29ycnVwdGVkIHBhZ2UuClNlZQouQlIgc2lnYWN0aW9uICgyKQpmb3IgbW9yZSBpbmZvcm1h
dGlvbiBvbiB0aGUKLkJSIFNJR0JVUwpzaWduYWwuClRoZSBwb2xpY3kgaXMgaW5oZXJpdGVkIGJ5
IGNoaWxkcmVuLgpUaGUgcmVtYWluaW5nIHVudXNlZAouQlIgcHJjdGwgKCkKYXJndW1lbnRzIG11
c3QgYmUgemVybyBmb3IgZnV0dXJlIGNvbXBhdGliaWxpdHkuCi5UUAouQlIgUFJfTUNFX0tJTExf
R0VUICIgKHNpbmNlIExpbnV4IDIuNi4zMikiClJldHVybiB0aGUgY3VycmVudCBwZXItcHJvY2Vz
cyBtYWNoaW5lIGNoZWNrIGtpbGwgcG9saWN5LgpBbGwgdW51c2VkCi5CUiBwcmN0bCAoKQphcmd1
bWVudHMgbXVzdCBiZSB6ZXJvLgouVFAKLkJSIFBSX1NFVF9NTSAiIChzaW5jZSBMaW51eCAzLjMp
IgpNb2RpZnkgY2VydGFpbiBrZXJuZWwgbWVtb3J5IG1hcCBkZXNjcmlwdG9yIGZpZWxkcwpvZiB0
aGUgY2FsbGluZyBwcm9jZXNzLgpVc3VhbGx5IHRoZXNlIGZpZWxkcyBhcmUgc2V0IGJ5IHRoZSBr
ZXJuZWwgYW5kIGR5bmFtaWMgbG9hZGVyIChzZWUKLkJSIGxkLnNvICg4KQpmb3IgbW9yZSBpbmZv
cm1hdGlvbikgYW5kIGEgcmVndWxhciBhcHBsaWNhdGlvbiBzaG91bGQgbm90IHVzZSB0aGlzIGZl
YXR1cmUuCkhvd2V2ZXIsIHRoZXJlIGFyZSBjYXNlcywgc3VjaCBhcyBzZWxmLW1vZGlmeWluZyBw
cm9ncmFtcywKd2hlcmUgYSBwcm9ncmFtIG1pZ2h0IGZpbmQgaXQgdXNlZnVsIHRvIGNoYW5nZSBp
dHMgb3duIG1lbW9yeSBtYXAuClRoaXMgZmVhdHVyZSBpcyBhdmFpbGFibGUgb25seSBpZiB0aGUg
a2VybmVsIGlzIGJ1aWx0IHdpdGggdGhlIAouQlIgQ09ORklHX0NIRUNLUE9JTlRfUkVTVE9SRQpv
cHRpb24gZW5hYmxlZC4KVGhlIGNhbGxpbmcgcHJvY2VzcyBtdXN0IGhhdmUgdGhlCi5CUiBDQVBf
U1lTX1JFU09VUkNFCmNhcGFiaWxpdHkuClRoZSB2YWx1ZSBpbgouSSBhcmcyCmlzIG9uZSBvZiB0
aGUgb3B0aW9ucyBiZWxvdywgd2hpbGUKLkkgYXJnMwpwcm92aWRlcyBhIG5ldyB2YWx1ZSBmb3Ig
dGhlIG9wdGlvbi4KLlJTCi5UUAouQlIgUFJfU0VUX01NX1NUQVJUX0NPREUKU2V0IHRoZSBhZGRy
ZXNzIGFib3ZlIHdoaWNoIHRoZSBwcm9ncmFtIHRleHQgY2FuIHJ1bi4KVGhlIGNvcnJlc3BvbmRp
bmcgbWVtb3J5IGFyZWEgbXVzdCBiZSByZWFkYWJsZSBhbmQgZXhlY3V0YWJsZSwKYnV0IG5vdCB3
cml0YWJsZSBvciBzaGFyYWJsZSAoc2VlCi5CUiBtcHJvdGVjdCAoMikKYW5kCi5CUiBtbWFwICgy
KQpmb3IgbW9yZSBpbmZvcm1hdGlvbikuCi5UUAouQlIgUFJfU0VUX01NX0VORF9DT0RFClNldCB0
aGUgYWRkcmVzcyBiZWxvdyB3aGljaCB0aGUgcHJvZ3JhbSB0ZXh0IGNhbiBydW4uClRoZSBjb3Jy
ZXNwb25kaW5nIG1lbW9yeSBhcmVhIG11c3QgYmUgcmVhZGFibGUgYW5kIGV4ZWN1dGFibGUsCmJ1
dCBub3Qgd3JpdGFibGUgb3Igc2hhcmFibGUuCi5UUAouQlIgUFJfU0VUX01NX1NUQVJUX0RBVEEK
U2V0IHRoZSBhZGRyZXNzIGFib3ZlIHdoaWNoIGluaXRpYWxpemVkIGFuZAp1bmluaXRpYWxpemVk
IChic3MpIGRhdGEgYXJlIHBsYWNlZC4KVGhlIGNvcnJlc3BvbmRpbmcgbWVtb3J5IGFyZWEgbXVz
dCBiZSByZWFkYWJsZSBhbmQgd3JpdGFibGUsCmJ1dCBub3QgZXhlY3V0YWJsZSBvciBzaGFyYWJs
ZS4KLlRQCi5CIFBSX1NFVF9NTV9FTkRfREFUQQpTZXQgdGhlIGFkZHJlc3MgYmVsb3cgd2hpY2gg
aW5pdGlhbGl6ZWQgYW5kCnVuaW5pdGlhbGl6ZWQgKGJzcykgZGF0YSBhcmUgcGxhY2VkLgpUaGUg
Y29ycmVzcG9uZGluZyBtZW1vcnkgYXJlYSBtdXN0IGJlIHJlYWRhYmxlIGFuZCB3cml0YWJsZSwK
YnV0IG5vdCBleGVjdXRhYmxlIG9yIHNoYXJhYmxlLgouVFAKLkJSIFBSX1NFVF9NTV9TVEFSVF9T
VEFDSwpTZXQgdGhlIHN0YXJ0IGFkZHJlc3Mgb2YgdGhlIHN0YWNrLgpUaGUgY29ycmVzcG9uZGlu
ZyBtZW1vcnkgYXJlYSBtdXN0IGJlIHJlYWRhYmxlIGFuZCB3cml0YWJsZS4KLlRQCi5CUiBQUl9T
RVRfTU1fU1RBUlRfQlJLClNldCB0aGUgYWRkcmVzcyBhYm92ZSB3aGljaCB0aGUgcHJvZ3JhbSBo
ZWFwIGNhbiBiZSBleHBhbmRlZCB3aXRoCi5CUiBicmsgKDIpCmNhbGwuClRoZSBhZGRyZXNzIG11
c3QgYmUgZ3JlYXRlciB0aGFuIHRoZSBlbmRpbmcgYWRkcmVzcyBvZgp0aGUgY3VycmVudCBwcm9n
cmFtIGRhdGEgc2VnbWVudC4KSW4gYWRkaXRpb24sIHRoZSBjb21iaW5lZCBzaXplIG9mIHRoZSBy
ZXN1bHRpbmcgaGVhcCBhbmQKdGhlIHNpemUgb2YgdGhlIGRhdGEgc2VnbWVudCBjYW4ndCBleGNl
ZWQgdGhlCi5CUiBSTElNSVRfREFUQQpyZXNvdXJjZSBsaW1pdCAoc2VlCi5CUiBzZXRybGltaXQg
KDIpKS4KLlRQCi5CUiBQUl9TRVRfTU1fQlJLClNldCB0aGUgY3VycmVudAouQlIgYnJrICgyKQp2
YWx1ZS4KVGhlIHJlcXVpcmVtZW50cyBmb3IgdGhlIGFkZHJlc3MgYXJlIHRoZSBzYW1lIGFzIGZv
ciB0aGUKLkJSIFBSX1NFVF9NTV9TVEFSVF9CUksKb3B0aW9uLgouXCIgRklYTUUgVGhlIGZvbGxv
d2luZyAodW50aWwgPT09PT09PT0pIGlzIG5vdCB5ZXQgaW4gbWFpbmxpbmUga2VybmVsLAouXCIg
c28gY29tbWVudGVkIG91dCBmb3IgdGhlIG1vbWVudC4KLlwiIC5UUAouXCIgLkJSIFBSX1NFVF9N
TV9BUkdfU1RBUlQKLlwiIFNldCB0aGUgYWRkcmVzcyBhYm92ZSB3aGljaCB0aGUgcHJvZ3JhbSBj
b21tYW5kIGxpbmUgaXMgcGxhY2VkLgouXCIgLlRQCi5cIiAuQlIgUFJfU0VUX01NX0FSR19FTkQK
LlwiIFNldCB0aGUgYWRkcmVzcyBiZWxvdyB3aGljaCB0aGUgcHJvZ3JhbSBjb21tYW5kIGxpbmUg
aXMgcGxhY2VkLgouXCIgLlRQCi5cIiAuQlIgUFJfU0VUX01NX0VOVl9TVEFSVAouXCIgU2V0IHRo
ZSBhZGRyZXNzIGFib3ZlIHdoaWNoIHRoZSBwcm9ncmFtIGVudmlyb25tZW50IGlzIHBsYWNlZC4K
LlwiIC5UUAouXCIgLkJSIFBSX1NFVF9NTV9FTlZfRU5ECi5cIiBTZXQgdGhlIGFkZHJlc3MgYmVs
b3cgd2hpY2ggdGhlIHByb2dyYW0gZW52aXJvbm1lbnQgaXMgcGxhY2VkLgouXCIgLklQCi5cIiBU
aGUgYWRkcmVzcyBwYXNzZWQgd2l0aAouXCIgLkJSIFBSX1NFVF9NTV9BUkdfU1RBUlQgLAouXCIg
LkJSIFBSX1NFVF9NTV9BUkdfRU5EICwKLlwiIC5CUiBQUl9TRVRfTU1fRU5WX1NUQVJUICwKLlwi
IGFuZAouXCIgLkJSIFBSX1NFVF9NTV9FTlZfRU5ECi5cIiBzaG91bGQgYmVsb25nIHRvIGEgcHJv
Y2VzcyBzdGFjayBhcmVhLgouXCIgVGh1cywgdGhlIGNvcnJlc3BvbmRpbmcgbWVtb3J5IGFyZWEg
bXVzdCBiZSByZWFkYWJsZSwgd3JpdGFibGUsIGFuZAouXCIgKGRlcGVuZGluZyBvbiB0aGUga2Vy
bmVsIGNvbmZpZ3VyYXRpb24pIGhhdmUgdGhlCi5cIiAuQlIgTUFQX0dST1dTRE9XTgouXCIgYXR0
cmlidXRlIHNldCAoc2VlCi5cIiAuQlIgbW1hcCAoMikpLgouXCIgLlRQCi5cIiAuQlIgUFJfU0VU
X01NX0FVWFYKLlwiIFNldCBhIG5ldyBhdXhpbGlhcnkgdmVjdG9yLgouXCIgVGhlCi5cIiAuSSBh
cmczCi5cIiBhcmd1bWVudCBzaG91bGQgcHJvdmlkZSB0aGUgYWRkcmVzcyBvZiB0aGUgdmVjdG9y
LgouXCIgVGhlCi5cIiAuSSBhcmc0Ci5cIiBpcyB0aGUgc2l6ZSBvZiB0aGUgdmVjdG9yLgouXCIg
LlRQCi5cIiAuQlIgUFJfU0VUX01NX0VYRV9GSUxFCi5cIiBTdXBlcnNlZGUgdGhlCi5cIiAuSVIg
L3Byb2MvcGlkL2V4ZQouXCIgc3ltYm9saWMgbGluayB3aXRoIGEgbmV3IG9uZSBwb2ludGluZyB0
byBhIG5ldyBleGVjdXRhYmxlIGZpbGUKLlwiIGlkZW50aWZpZWQgYnkgdGhlIGZpbGUgZGVzY3Jp
cHRvciBwcm92aWRlZCBpbgouXCIgLkkgYXJnMwouXCIgYXJndW1lbnQuCi5cIiBUaGUgZmlsZSBk
ZXNjcmlwdG9yIHNob3VsZCBiZSBvYnRhaW5lZCB3aXRoIGEgcmVndWxhcgouXCIgLkJSIG9wZW4g
KDIpCi5cIiBjYWxsLgouXCIgLklQCi5cIiBUbyBjaGFuZ2UgdGhlIHN5bWJvbGljIGxpbmssIG9u
ZSBuZWVkcyB0byB1bm1hcCBhbGwgZXhpc3RpbmcKLlwiIGV4ZWN1dGFibGUgbWVtb3J5IGFyZWFz
LCBpbmNsdWRpbmcgdGhvc2UgY3JlYXRlZCBieSB0aGUga2VybmVsIGl0c2VsZgouXCIgKGZvciBl
eGFtcGxlIHRoZSBrZXJuZWwgdXN1YWxseSBjcmVhdGVzIGF0IGxlYXN0IG9uZSBleGVjdXRhYmxl
Ci5cIiBtZW1vcnkgYXJlYSBmb3IgdGhlIEVMRgouXCIgLklSIFwudGV4dAouXCIgc2VjdGlvbiku
Ci5cIiAuSVAKLlwiIFRoZSBzZWNvbmQgbGltaXRhdGlvbiBpcyB0aGF0IHN1Y2ggdHJhbnNpdGlv
bnMgY2FuIGJlIGRvbmUgb25seSBvbmNlCi5cIiBpbiBhIHByb2Nlc3MgbGlmZSB0aW1lLgouXCIg
QW55IGZ1cnRoZXIgYXR0ZW1wdHMgd2lsbCBiZSByZWplY3RlZC4KLlwiIFRoaXMgc2hvdWxkIGhl
bHAgc3lzdGVtIGFkbWluaXN0cmF0b3JzIHRvIG1vbml0b3IgdW51c3VhbAouXCIgc3ltYm9saWMt
bGluayB0cmFuc2l0aW9ucyBvdmVyIGFsbCBwcm9jZXNzIHJ1bm5pbmcgaW4gYSBzeXN0ZW0uCi5c
IiA9PT09PT09PT09IEVORCBGSVhNRQouUkUKLlwiCi5TSCAiUkVUVVJOIFZBTFVFIgpPbiBzdWNj
ZXNzLAouQlIgUFJfR0VUX0RVTVBBQkxFICwKLkJSIFBSX0dFVF9LRUVQQ0FQUyAsCi5CUiBQUl9D
QVBCU0VUX1JFQUQgLAouQlIgUFJfR0VUX1RJTUlORyAsCi5CUiBQUl9HRVRfU0VDVVJFQklUUyAs
Ci5CUiBQUl9NQ0VfS0lMTF9HRVQgLAphbmQgKGlmIGl0IHJldHVybnMpCi5CUiBQUl9HRVRfU0VD
Q09NUApyZXR1cm4gdGhlIG5vbm5lZ2F0aXZlIHZhbHVlcyBkZXNjcmliZWQgYWJvdmUuCkFsbCBv
dGhlcgouSSBvcHRpb24KdmFsdWVzIHJldHVybiAwIG9uIHN1Y2Nlc3MuCk9uIGVycm9yLCBcLTEg
aXMgcmV0dXJuZWQsIGFuZAouSSBlcnJubwppcyBzZXQgYXBwcm9wcmlhdGVseS4KLlNIIEVSUk9S
UwouVFAKLkIgRUZBVUxUCi5JIGFyZzIKaXMgYW4gaW52YWxpZCBhZGRyZXNzLgouVFAKLkIgRUlO
VkFMClRoZSB2YWx1ZSBvZgouSSBvcHRpb24KaXMgbm90IHJlY29nbml6ZWQuCi5UUAouQiBFSU5W
QUwKLkkgb3B0aW9uCmlzCi5CUiBQUl9NQ0VfS0lMTApvcgouQlIgUFJfTUNFX0tJTExfR0VUCm9y
Ci5CUiBQUl9TRVRfTU0gLAphbmQgdW51c2VkCi5CUiBwcmN0bCAoKQphcmd1bWVudHMgd2VyZSBu
b3Qgc3BlY2lmaWVkIGFzIHplcm8uCi5UUAouQiBFSU5WQUwKLkkgYXJnMgppcyBub3QgdmFsaWQg
dmFsdWUgZm9yIHRoaXMKLklSIG9wdGlvbiAuCi5UUAouQiBFSU5WQUwKLkkgb3B0aW9uCmlzCi5C
UiBQUl9TRVRfU0VDQ09NUApvcgouQlIgUFJfU0VUX1NFQ0NPTVAgLAphbmQgdGhlIGtlcm5lbCB3
YXMgbm90IGNvbmZpZ3VyZWQgd2l0aAouQlIgQ09ORklHX1NFQ0NPTVAgLgouVFAKLkIgRUlOVkFM
Ci5JIG9wdGlvbgppcwouQlIgUFJfU0VUX01NICwKYW5kIG9uZSBvZiB0aGUgZm9sbG93aW5nIGlz
IHRydWUKLlJTCi5JUCAqIDMKLkkgYXJnNApvcgouSSBhcmc1CmlzIG5vbnplcm87Ci5JUCAqCi5J
IGFyZzMKaXMgZ3JlYXRlciB0aGFuCi5CIFRBU0tfU0laRQoodGhlIGxpbWl0IG9uIHRoZSBzaXpl
IG9mIHRoZSB1c2VyIGFkZHJlc3Mgc3BhY2UgZm9yIHRoaXMgYXJjaGl0ZWN0dXJlKTsKLklQICoK
LkkgYXJnMgppcwouQlIgUFJfU0VUX01NX1NUQVJUX0NPREUgLAouQlIgUFJfU0VUX01NX0VORF9D
T0RFICwKLkJSIFBSX1NFVF9NTV9TVEFSVF9EQVRBICwKLkJSIFBSX1NFVF9NTV9FTkRfREFUQSAs
Cm9yCi5CUiBQUl9TRVRfTU1fU1RBUlRfU1RBQ0ssCmFuZCB0aGUgcGVybWlzc2lvbnMgb2YgdGhl
IGNvcnJlc3BvbmRpbmcgbWVtb3J5IGFyZWEgYXJlIG5vdCBhcyByZXF1aXJlZDsKLklQICoKLkkg
YXJnMgppcwouQlIgUFJfU0VUX01NX1NUQVJUX0JSSwpvcgouQlIgUFJfU0VUX01NX0JSSyAsCmFu
ZAouSSBhcmczCmlzIGxlc3MgdGhhbiBvciBlcXVhbCB0byB0aGUgZW5kIG9mIHRoZSBkYXRhIHNl
Z21lbnQKb3Igc3BlY2lmaWVzIGEgdmFsdWUgdGhhdCB3b3VsZCBjYXVzZSB0aGUKLkIgUkxJTUlU
X0RBVEEKcmVzb3VyY2UgbGltaXQgdG8gYmUgZXhjZWVkZWQuCi5SRQouVFAKLkIgRVBFUk0KLkkg
b3B0aW9uCmlzCi5CUiBQUl9TRVRfU0VDVVJFQklUUyAsCmFuZCB0aGUgY2FsbGVyIGRvZXMgbm90
IGhhdmUgdGhlCi5CIENBUF9TRVRQQ0FQCmNhcGFiaWxpdHksCm9yIHRyaWVkIHRvIHVuc2V0IGEg
ImxvY2tlZCIgZmxhZywKb3IgdHJpZWQgdG8gc2V0IGEgZmxhZyB3aG9zZSBjb3JyZXNwb25kaW5n
IGxvY2tlZCBmbGFnIHdhcyBzZXQKKHNlZQouQlIgY2FwYWJpbGl0aWVzICg3KSkuCi5UUAouQiBF
UEVSTQouSSBvcHRpb24KaXMKLkJSIFBSX1NFVF9LRUVQQ0FQUyAsCmFuZCB0aGUgY2FsbGVycydz
Ci5CIFNFQ1VSRV9LRUVQX0NBUFNfTE9DS0VECmZsYWcgaXMgc2V0CihzZWUKLkJSIGNhcGFiaWxp
dGllcyAoNykpLgouVFAKLkIgRVBFUk0KLkkgb3B0aW9uCmlzCi5CUiBQUl9DQVBCU0VUX0RST1Ag
LAphbmQgdGhlIGNhbGxlciBkb2VzIG5vdCBoYXZlIHRoZQouQiBDQVBfU0VUUENBUApjYXBhYmls
aXR5LgouVFAKLkIgRVBFUk0KLkkgb3B0aW9uCmlzCi5CUiBQUl9TRVRfTU0gLAphbmQgdGhlIGNh
bGxlciBkb2VzIG5vdCBoYXZlIHRoZQouQiBDQVBfU1lTX1JFU09VUkNFCmNhcGFiaWxpdHkuCi5c
IiBGSVhNRSBUaGUgZm9sbG93aW5nICh1bnRpbCA9PT09PT09PSkgaXMgbm90IHlldCBpbiBtYWlu
bGluZSBrZXJuZWwsCi5cIiBzbyBjb21tZW50ZWQgb3V0IGZvciB0aGUgbW9tZW50LgouXCIgLlRQ
Ci5cIiAuQiBFQUNDRVMKLlwiIC5JIG9wdGlvbgouXCIgaXMKLlwiIC5CUiBQUl9TRVRfTU0gLAou
XCIgYW5kCi5cIiAuSSBhcmczCi5cIiBpcwouXCIgLkJSIFBSX1NFVF9NTV9FWEVfRklMRSAsCi5c
IiB0aGUgZmlsZSBpcyBub3QgZXhlY3V0YWJsZS4KLlwiIC5UUAouXCIgLkIgRUJVU1kKLlwiIC5J
IG9wdGlvbgouXCIgaXMKLlwiIC5CUiBQUl9TRVRfTU0gLAouXCIgLkkgYXJnMwouXCIgaXMKLlwi
IC5CUiBQUl9TRVRfTU1fRVhFX0ZJTEUgLAouXCIgYW5kIHRoaXMgdGhlIHNlY29uZCBhdHRlbXB0
IHRvIGNoYW5nZSB0aGUKLlwiIC5JIC9wcm9jL3BpZC9leGUKLlwiIHN5bWJvbGljIGxpbmssIHdo
aWNoIGlzIHByb2hpYml0ZWQuCi5cIiAuVFAKLlwiIC5CIEVCQURGCi5cIiAuSSBvcHRpb24KLlwi
IGlzCi5cIiAuQlIgUFJfU0VUX01NICwKLlwiIC5JIGFyZzMKLlwiIGlzCi5cIiAuQlIgUFJfU0VU
X01NX0VYRV9GSUxFICwKLlwiIGFuZCB0aGUgZmlsZSBkZXNjcmlwdG9yIHBhc3NlZCBpbgouXCIg
LkkgYXJnNAouXCIgaXMgbm90IHZhbGlkLgouXCIgPT09PT09PT09PSBFTkQgRklYTUUKLlwiIFRo
ZSBmb2xsb3dpbmcgY2FuJ3QgYWN0dWFsbHkgaGFwcGVuLCBiZWNhdXNlIHByY3RsKCkgaW4KLlwi
IHNlY2NvbXAgbW9kZSB3aWxsIGNhdXNlIFNJR0tJTEwuCi5cIiAuVFAKLlwiIC5CIEVQRVJNCi5c
IiAuSSBvcHRpb24KLlwiIGlzCi5cIiAuQlIgUFJfU0VUX1NFQ0NPTVAgLAouXCIgYW5kIHNlY3Vy
ZSBjb21wdXRpbmcgbW9kZSBpcyBhbHJlYWR5IDEuCi5TSCBWRVJTSU9OUwpUaGUKLkJSIHByY3Rs
ICgpCnN5c3RlbSBjYWxsIHdhcyBpbnRyb2R1Y2VkIGluIExpbnV4IDIuMS41Ny4KLlwiIFRoZSBs
aWJyYXJ5IGludGVyZmFjZSB3YXMgYWRkZWQgaW4gZ2xpYmMgMi4wLjYKLlNIICJDT05GT1JNSU5H
IFRPIgpUaGlzIGNhbGwgaXMgTGludXgtc3BlY2lmaWMuCklSSVggaGFzIGEKLkJSIHByY3RsICgp
CnN5c3RlbSBjYWxsIChhbHNvIGludHJvZHVjZWQgaW4gTGludXggMi4xLjQ0CmFzIGlyaXhfcHJj
dGwgb24gdGhlIE1JUFMgYXJjaGl0ZWN0dXJlKSwKd2l0aCBwcm90b3R5cGUKLnNwCi5CSSAicHRy
ZGlmZl90IHByY3RsKGludCAiIG9wdGlvbiAiLCBpbnQgIiBhcmcyICIsIGludCAiIGFyZzMgKTsK
LnNwCmFuZCBvcHRpb25zIHRvIGdldCB0aGUgbWF4aW11bSBudW1iZXIgb2YgcHJvY2Vzc2VzIHBl
ciB1c2VyLApnZXQgdGhlIG1heGltdW0gbnVtYmVyIG9mIHByb2Nlc3NvcnMgdGhlIGNhbGxpbmcg
cHJvY2VzcyBjYW4gdXNlLApmaW5kIG91dCB3aGV0aGVyIGEgc3BlY2lmaWVkIHByb2Nlc3MgaXMg
Y3VycmVudGx5IGJsb2NrZWQsCmdldCBvciBzZXQgdGhlIG1heGltdW0gc3RhY2sgc2l6ZSwgZXRj
LgouU0ggIlNFRSBBTFNPIgouQlIgc2lnbmFsICgyKSwKLkJSIGNvcmUgKDUpCg==
--e89a8f2352f5b0697204bdbf5113--
