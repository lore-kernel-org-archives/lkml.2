Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2LRRge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:36:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37213 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2LRRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:36:31 -0500
Date: Tue, 18 Dec 2012 21:12:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] Add kcmp.2 manpage
Message-ID: <20121218171217.GD7155@moon>
References: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
 <1342995307-884-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkj-=wLEM+SjA_S8GUp0+0o5R4NuDH4fL-8H-pKCKdLryA@mail.gmail.com>
 <20121218170624.GA7148@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218170624.GA7148@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 09:06:24PM +0400, Cyrill Gorcunov wrote:
> On Tue, Dec 18, 2012 at 05:54:49PM +0100, Michael Kerrisk (man-pages) wrote:
> > Hello Cyrill,
> > 
> > On Mon, Jul 23, 2012 at 12:15 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > > NAME
> > >        kcmp - compare if two processes do share a particular kernel resource
> > 
> > Very late follow up on this page, sorry. You didn't provide a
> > copyright or license for this page. Could you please supply that
> > information. See http://www.kernel.org/doc/man-pages/licenses.html .
> 
> Sure, gimme some time to update it...

Something like below?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 1/2] Add kcmp.2 manpage

NAME
       kcmp - compare if two processes do share a particular kernel resource

SYNOPSIS
       #define _GNU_SOURCE         /* See feature_test_macros(7) */
       #include <unistd.h>
       #include <linux/kcmp.h>
       #include <sys/syscall.h>   /* For SYS_xxx definitions */

       int syscall(__NR_kcmp, pid1, pid2, type, idx1, idx2);

DESCRIPTION
       kcmp() allows to find out if two processes identified by pid1 and pid2
       share kernel resources such as virtual memory, file descriptors, file system etc.

       The comparison type is one of the following

       KCMP_FILE determines whether a file descriptor idx1 in the first process
       is the same as another descriptor idx2 in the second process

       KCMP_VM compares whether processes share address space

       KCMP_FILES compares the file descriptor arrays to see whether the processes
       share all files

       KCMP_FS compares whether processes share the file system information (the current
       umask, working directory, namespace root, etc)

       KCMP_SIGHAND compares whether processes share a signal handlers table

       KCMP_IO compares whether processes do share I/O context, used mainly for
       block I/O scheduling

       KCMP_SYSVSEM compares the list of undo operations associated with SYSV semaphores

       Note  the  kcmp() is not protected against false positives which may have
       place if tasks are running.  Which means one should stop tasks being inspected
       with this syscall to obtain meaningful results.

RETURN VALUE
       kcmp was designed to return values suitable for sorting.  This is particularly handy
       when one have to compare a large number of file descriptors.

       The return value is merely a result of simple arithmetic comparison of kernel pointers
       (when kernel compares resources, it uses their memory addresses).

       The  easiest way to explain is to consider an example.  Lets say v1 and v2 are the
       addresses of appropriate resources, then the return value is one of the following

       0 - v1 is equal to v2 , in other words we have a shared resource here
       1 - v1 is less than v2
       2 - v1 is greater than v2
       3 - v1 is not equal to but ordering information is unavailble.

       On error, -1 is returned, and errno is set appropriately.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 man2/kcmp.2 | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)
 create mode 100644 man2/kcmp.2

diff --git a/man2/kcmp.2 b/man2/kcmp.2
new file mode 100644
index 0000000..6c514b6
--- /dev/null
+++ b/man2/kcmp.2
@@ -0,0 +1,134 @@
+.\" Copyright (c) 2012, Cyrill Gorcunov <gorcunov@openvz.org>
+.\"
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of
+.\" this manual under the conditions for verbatim copying, provided that
+.\" the entire resulting derived work is distributed under the terms of
+.\" a permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume.
+.\" no responsibility for errors or omissions, or for damages resulting.
+.\" from the use of the information contained herein.  The author(s) may.
+.\" not have taken the same level of care in the production of this.
+.\" manual, which is licensed free of charge, as they might when working.
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.TH KCMP 2 2012-02-01 "Linux" "Linux Programmer's Manual"
+
+.SH NAME
+kcmp \- compare if two processes do share a particular kernel resource
+
+.SH SYNOPSIS
+.nf
+.BR "#define _GNU_SOURCE" "         /* See feature_test_macros(7) */"
+.B #include <unistd.h>
+.B #include <linux/kcmp.h>
+.BR "#include <sys/syscall.h>   "  "/* For SYS_xxx definitions */"
+
+.BI "int syscall(__NR_kcmp, pid1, pid2, type, idx1, idx2);"
+.fi
+
+.SH DESCRIPTION
+
+.BR kcmp ()
+allows to find out if two processes identified by
+.I pid1
+and
+.I pid2
+share kernel resources such as virtual memory, file descriptors, file system etc.
+
+The comparison
+.I type
+is one of the following
+
+.BR KCMP_FILE
+determines whether a file descriptor
+.I idx1
+in the first process is the same as another descriptor
+.I idx2
+in the second process
+
+.BR KCMP_VM
+compares whether processes share address space
+
+.BR KCMP_FILES
+compares the file descriptor arrays to see whether the processes share all files
+
+.BR KCMP_FS
+compares whether processes share the file system information (the current umask,
+working directory, namespace root, etc)
+
+.BR KCMP_SIGHAND
+compares whether processes share a signal handlers table
+
+.BR KCMP_IO
+compares whether processes do share I/O context,
+used mainly for block I/O scheduling
+
+.BR KCMP_SYSVSEM
+compares the list of undo operations associated with SYSV semaphores
+
+Note the
+.BR kcmp ()
+is not protected against false positives which may have place if tasks are
+running.
+Which means one should stop tasks being inspected with this syscall to obtain
+meaningful results.
+
+.SH "RETURN VALUE"
+.B kcmp
+was designed to return values suitable for sorting.
+This is particularly handy when one have to compare
+a large number of file descriptors.
+
+The return value is merely a result of simple arithmetic comparison
+of kernel pointers (when kernel compares resources, it uses their
+memory addresses).
+
+The easiest way to explain is to consider an example.
+Lets say
+.I v1
+and
+.I v2
+are the addresses of appropriate resources, then the return value
+is one of the following
+
+.B 0
+\-
+.I v1
+is equal to
+.IR v2 ,
+in other words we have a shared resource here
+
+.B 1
+\-
+.I v1
+is less than
+.I v2
+
+.B 2
+\-
+.I v1
+is greater than
+.I v2
+
+.B 3
+\-
+.I v1
+is not equal to
+.IR v2 ,
+but ordering information is unavailable.
+
+On error, \-1 is returned, and errno is set appropriately.
+
+.SH "CONFORMING TO"
+.BR kcmp ()
+is Linux specific and should not be used in programs intended to be portable.
+.SH "SEE ALSO"
+.BR clone (2)
-- 
1.8.0.1

