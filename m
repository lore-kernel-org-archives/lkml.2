Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2LUSYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:24:54 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36839 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LUSYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:24:49 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20121218171217.GD7155@moon>
References: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
 <1342995307-884-2-git-send-email-gorcunov@openvz.org> <CAKgNAkj-=wLEM+SjA_S8GUp0+0o5R4NuDH4fL-8H-pKCKdLryA@mail.gmail.com>
 <20121218170624.GA7148@moon> <20121218171217.GD7155@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 21 Dec 2012 19:24:27 +0100
Message-ID: <CAKgNAkg536wfJy6WjjLANamchZg0XQ3sAHtCtvPtgCkTu_hHMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add kcmp.2 manpage
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 6:12 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Tue, Dec 18, 2012 at 09:06:24PM +0400, Cyrill Gorcunov wrote:
>> On Tue, Dec 18, 2012 at 05:54:49PM +0100, Michael Kerrisk (man-pages) wrote:
>> > Hello Cyrill,
>> >
>> > On Mon, Jul 23, 2012 at 12:15 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> > > NAME
>> > >        kcmp - compare if two processes do share a particular kernel resource
>> >
>> > Very late follow up on this page, sorry. You didn't provide a
>> > copyright or license for this page. Could you please supply that
>> > information. See http://www.kernel.org/doc/man-pages/licenses.html .
>>
>> Sure, gimme some time to update it...
>
> Something like below?

Yep, that's fine. I've done some substantial editing and added several
pieces to the page.  Could you take a careful look at the version to
see that I have not injected any inaccuracies?

Thanks,

Michael


.\" Copyright (C) 2012, Cyrill Gorcunov <gorcunov@openvz.org>
.\" and Copyright (C) 2012, Michael Kerrisk <mtk.manpages@gmail.com>
.\"
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of
.\" this manual under the conditions for verbatim copying, provided that
.\" the entire resulting derived work is distributed under the terms of
.\" a permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume.
.\" no responsibility for errors or omissions, or for damages resulting.
.\" from the use of the information contained herein.  The author(s) may.
.\" not have taken the same level of care in the production of this.
.\" manual, which is licensed free of charge, as they might when working.
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\"
.\" Kernel commit d97b46a64674a267bc41c9e16132ee2a98c3347d
.\"
.TH KCMP 2 2012-12-19 "Linux" "Linux Programmer's Manual"

.SH NAME
kcmp \- compare two processes to determine if they share a kernel resource

.SH SYNOPSIS
.nf
.B #include <linux/kcmp.h>

.BI "int kcmp(pid_t " pid1 ", pid_t " pid2 ", int " type ,
.BI "         unsigned long " idx1 ", unsigned long "  idx2 );

.fi

.IR Note :
There is no glibc wrapper for this system call; see NOTES.

.SH DESCRIPTION
The
.BR kcmp ()
system call can be used to check whether the two processes identified by
.I pid1
and
.I pid2
share a kernel resource such as virtual memory, file descriptors,
and so on.

The
.I type
argument specifies which resource is to be compared in the two processes.
It has one of the following values:

.TP
.BR KCMP_FILE
Check whether a file descriptor
.I idx1
in the process
.I pid1
refers to the same open file description (see
.BR open (2))
as file descriptor
.I idx2
in the process
.IR pid2 .

.TP
.BR KCMP_FILES
Check whether the process share the same set of open file descriptors.
The arguments
.I idx1
and
.I idx2
are ignored.

.TP
.BR KCMP_FS
Check whether the processes share the same file system information
(i.e., file mode creation mask, working directory, and file system root).
The arguments
.I idx1
and
.I idx2
are ignored.

.TP
.BR KCMP_IO
Check whether the processes share I/O context.
The arguments
.I idx1
and
.I idx2
are ignored.

.TP
.BR KCMP_SIGHAND
Check whether the processes share the same table of signal dispositions.
The arguments
.I idx1
and
.I idx2
are ignored.

.TP
.BR KCMP_SYSVSEM
Check whether the processes share the same
list of System V semaphore undo operations.
The arguments
.I idx1
and
.I idx2
are ignored.

.TP
.BR KCMP_VM
Check whether the processes share the same address space.
The arguments
.I idx1
and
.I idx2
are ignored.

.PP
Note the
.BR kcmp ()
is not protected against false positives which may have place if tasks are
running.
Which means one should stop tasks being inspected with this syscall to obtain
meaningful results.

.SH "RETURN VALUE"
The return value of a successful call to
.BR kcmp ()
is simply the result of arithmetic comparison
of kernel pointers (when the kernel compares resources, it uses their
memory addresses).

The easiest way to explain is to consider an example.
Suppose that
.I v1
and
.I v2
are the addresses of appropriate resources, then the return value
is one of the following:

.RS 4
.IP 0 4
.I v1
is equal to
.IR v2 ;
in other words, the two processes share the resource.

.IP 1
.I v1
is less than
.IR v2 .

.IP 2
.I v1
is greater than
.IR v2 .

.IP 3
.I v1
is not equal to
.IR v2 ,
but ordering information is unavailable.
.RE

.PP
On error, \-1 is returned, and
.I errno
is set appropriately.

.B kcmp ()
was designed to return values suitable for sorting.
This is particularly handy if one needs to compare
a large number of file descriptors.

.SH ERRORS

.TP
.B EBADF
.I type
is
.B KCMP_FILE
and
.I fd1
or
.I fd2
is not an open file descriptor.
.TP
.B EINVAL
.I type
is invalid.
.TP
.B EPERM
Insufficient permission to inspect process resources.
The
.B CAP_SYS_PTRACE
capability is required to inspect processes that you do not own.
.TP
.B ESRCH
Process
.I pid1
or
.I pid2
does not exist.

.SH VERSIONS
The
.BR kcmp ()
system call first appeared in Linux 3.5.

.SH "CONFORMING TO"
.BR kcmp ()
is Linux specific and should not be used in programs intended to be portable.

.SH NOTES
Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2).

This system call is available only if the kernel was configured with
.BR CONFIG_CHECKPOINT_RESTORE .
The main use of the system call is for the
checkpoint/restore in user space (CRIU) feature.
The alternative to this system call would have been to expose suitable
process information via the
.BR proc (5)
file system; this was deemed to be unsuitable for security reasons.

See
.BR clone (2)
for some background information on the shared resources
referred to on this page.

.SH "SEE ALSO"
.BR clone (2),
.BR unshare (2)
