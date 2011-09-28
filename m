Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1I1RZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:25:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49367 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1I1RZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:25:19 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 28 Sep 2011 19:24:58 +0200
Message-ID: <CAKgNAkhX-SnESaVoux2zUtTEVSY5umw=gPqCtfDEOO+xigtTdg@mail.gmail.com>
Subject: Re: [PATCH 1/2] setns.2: Initial man page [RESEND]
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-man@vger.kernel.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I'm still wanting your input on the edited setns.2 draft below. Please
don't make me chase you round Prague ;-).

Cheers,

Michael

From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, Sep 15, 2011 at 6:13 AM
Subject: Re: [PATCH 1/2] setns.2: Initial man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-man@vger.kernel.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>


Hello Eric,

See below.

On Mon, May 30, 2011 at 5:16 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  man2/setns.2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 88 insertions(+), 0 deletions(-)
>  create mode 100644 man2/setns.2
>
> diff --git a/man2/setns.2 b/man2/setns.2
> new file mode 100644
> index 0000000..8b48e14
> --- /dev/null
> +++ b/man2/setns.2
> @@ -0,0 +1,88 @@
> +.\" Copyright (C) 2011, Eric Biederman <ebiederm@xmission.com>
> +.\" Licensed under the GPLv2
> +.\"
> +.TH SETNS 2 2011-05-28 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +setns \- reassociate parts of the process execution context
> +.SH SYNOPSIS
> +.nf
> +.BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7) */"
> +.B #include <sched.h>
> +.sp
> +.BI "int setns(int " fd ", int " nstype );
> +.fi
> +.SH DESCRIPTION
> +Given a file descriptor referring to a namespace reassociate the
> +current process with that namespace.
> +
> +The
> +.I nstype
> +argument is an enumeration that specifies which type of namespace
> +the current process may be reassociated with.  This argument can
> +have one of the following values:
> +
> +.TP
> +.BR 0
> +Allow any namespace to be joined.
> +.TP
> +.BR CLONE_NEWIPC
> +Only allow joining an ipc namespace.
> +.TP
> +.BR CLONE_NEWNET
> +Only allow joining a network namespace.
> +.TP
> +.BR CLONE_NEWUTS
> +Only allow joining a uts namespace.
> +.PP
> +If
> +.I flags
> +is specified as zero, then
> +.BR setns ()
> +is a no-op;
> +no changes are made to the calling process's execution context.
> +.SH RETURN VALUE
> +On success, zero returned.
> +On failure, \-1 is returned and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.TP
> +.B EBADF
> +A bad file descriptor was passed to setns.
> +
> +.TP
> +.B EINVAL
> +A file descriptor that does not match the specified nstype.
> +
> +Attempting to change the mount namespace and the filesystem
> +is shared between multiple tasks.
> +
> +.TP
> +.B ENOMEM
> +Cannot allocate sufficient memory to change the specified namespace.
> +
> +.TP
> +.B EPERM
> +The calling process did not have the required privileges for this operation.
> +.SH VERSIONS
> +The
> +.BR setns ()
> +system call first appeared in Linux in kernel 3.0
> +.SH CONFORMING TO
> +The
> +.BR setns ()
> +system call is Linux-specific.
> +.SH NOTES
> +Not all of the process attributes that can be shared when
> +a new process is created using
> +.BR clone (2)
> +can be changed using
> +.BR setns ().
> +.SH BUGS
> +The pid namespace and the mount namespace are not currently supported.
> +.SH SEE ALSO
> +.BR clone (2),
> +.BR fork (2),
> +.BR vfork (2),
> +.BR setns(2)
> --
> 1.7.5.1.217.g4e3aa

I made various edits to the page, some after out F2F conversations.
Could you please comment on the new version below?

Note: we talked a couple of times about this piece of text under the
EINVAL error.

      Attempted  to  change  the  mount  namespace, but the filesystem
      is shared between multiple tasks.

As I understand it, this refers to interactions between the mount
namespace and file system namespace. However, as noted in the man
page, setns() does not support CLONE_NEWNS. Furthermore, I can see no
path in the setns() that generates EINVAL and  involves CLONE_NEWNS.
So,I removed that text. Please let me know if that's wrong.

Cheers,

Michael


.\" Copyright (C) 2011, Eric Biederman <ebiederm@xmission.com>
.\" Licensed under the GPLv2
.\"
.TH SETNS 2 2011-09-15 "Linux" "Linux Programmer's Manual"
.SH NAME
setns \- reassociate process with a namespace
.SH SYNOPSIS
.nf
.BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7) */"
.B #include <sched.h>
.sp
.BI "int setns(int " fd ", int " nstype );
.fi
.SH DESCRIPTION
Given a file descriptor referring to a namespace,
reassociate the calling process with that namespace.

The
.I fd
argument is a file descriptor referring to one of the namespace entries in a
.I /proc/[pid]/ns/
directory; see
.BR proc (5)
for further information on
.IR /proc/[pid]/ns/ .
The calling process will be reassociated with the corresponding namespace,
subject to any constraints imposed by the
.I nstype
argument.

The
.I nstype
argument specifies which type of namespace
the calling process may be reassociated with.
This argument can have one of the following values:
.TP
.BR 0
Allow any type of namespace to be joined.
.TP
.BR CLONE_NEWIPC
.I fd
must refer to an IPC namespace.
.TP
.BR CLONE_NEWNET
.I fd
must refer to a network namespace.
.TP
.BR CLONE_NEWUTS
.I fd
must refer to a UTS namespace.
.PP
Specifying
.I nstype
as 0 suffices if the caller knows (or does not care)
what type of namespace is referred to by
.IR fd .
Specifying a nonzero value for
.I nstype
is useful if the caller does not know what type of namespace is referred to by
.IR fd
and wants to ensure that the namespace is of a particular type.
(The caller might not know the type of the namespace referred to by
.IR fd
if the file descriptor was opened by another process and, for example,
passed to the caller via a UNIX domain socket.)
.SH RETURN VALUE
On success,
.IR setns ()
returns 0.
On failure, \-1 is returned and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor.
.TP
.B EINVAL
.I fd
refers to a namespace whose type does not match that specified in
.IR nstype .
.TP
.B ENOMEM
Cannot allocate sufficient memory to change the specified namespace.
.TP
.B EPERM
The calling process did not have the required privilege
.RB ( CAP_SYS_ADMIN )
for this operation.
.SH VERSIONS
The
.BR setns ()
system call first appeared in Linux in kernel 3.0
.SH CONFORMING TO
The
.BR setns ()
system call is Linux-specific.
.SH NOTES
Not all of the process attributes that can be shared when
a new process is created using
.BR clone (2)
can be changed using
.BR setns ().
.SH BUGS
The PID namespace and the mount namespace are not currently supported.
(See the descriptions of
.BR CLONE_NEWPID
and
.BR CLONE_NEWNS
in
.BR clone (2).)
.SH SEE ALSO
.BR clone (2),
.BR fork (2),
.BR vfork (2),
.BR proc (5),
.BR unix (7)
