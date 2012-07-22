Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2GVWPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:15:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39934 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2GVWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:15:12 -0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 1/2] Add kcmp.2 manpage
Date: Mon, 23 Jul 2012 02:15:06 +0400
Message-Id: <1342995307-884-2-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
References: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 man2/kcmp.2 |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 man2/kcmp.2

diff --git a/man2/kcmp.2 b/man2/kcmp.2
new file mode 100644
index 0000000..5d2e9a3
--- /dev/null
+++ b/man2/kcmp.2
@@ -0,0 +1,113 @@
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
1.7.7.6

