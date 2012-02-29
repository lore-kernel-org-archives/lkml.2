Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab2B2MXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:23:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38991 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2B2MX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:23:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.205.136.12 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] Add kcmp.2 manpage
Date: Wed, 29 Feb 2012 16:23:17 +0400
Message-Id: <1330518197-12825-3-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAME
       kcmp - compare if two processes do share a particular kernel resource


SYNOPSIS
       #define  GNU SOURCE         /* See feature test macros(7) */
       #include <unistd.h>
       #include <linux/kcmp.h>
       #include <sys/syscall.h>   /* For SYS xxx definitions */

       int syscall(  NR kcmp, pid1, pid2, type, idx1, idx2);


DESCRIPTION
       kcmp() allows to find out if two processes identified by pid1
       and pid2 do share kernel resources such as virtual memory, file

       The comparison type is one of the following

       KCMP FILE to compare two file descriptors specified by idx1 and idx2

       KCMP VM to compare whether processes do share virtual memory

       KCMP FILES to compare whether processes do share share the file descriptor table

       KCMP FS to compare whether processes do share the file system information

       KCMP SIGHAND to compare whether processes do share a signal handlers table

       KCMP IO to compare whether processes do share I/O context

       KCMP SYSVSEM to compare whether processes do share a single list of System V
       semaphore undo values


RETURN VALUE
       kcmp was designed to return values suitable for sorting.  This is particularly
       handy when one have to compare a large number

       The return value is merely a result of simple arithmetic comparison of kernel
       pointers (when kernel compares resources, it us

       The  easiest way to explain is to consider an example.  Lets say v1 and v2
       are the addresses of appropriate resources, then the return value is one
       of the following

       0 - v1 is equal to v2 , in other words we have a shared resource here

       1 - v1 is greater than v2

       2 - v1 is less than v2

       3 - v1 is not equal to v2 , but ordering information is unavailble.

       On error, -1 is returned, and errno is set appropriately.


CONFORMING TO
       kcmp() is Linux specific and should not be used in programs intended to
       be portable.

SEE ALSO
       clone(2)

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Emelyanov <xemul@parallels.com>
---
 man2/kcmp.2 |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 man2/kcmp.2

diff --git a/man2/kcmp.2 b/man2/kcmp.2
new file mode 100644
index 0000000..de07367
--- /dev/null
+++ b/man2/kcmp.2
@@ -0,0 +1,105 @@
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
+do share kernel resources such as virtual memory, file descriptors,
+file system etc.
+
+The comparison
+.I type
+is one of the following
+
+.BR KCMP_FILE
+to compare two file descriptors specified by
+.I idx1
+and
+.I idx2
+
+.BR KCMP_VM
+to compare whether processes do share virtual memory
+
+.BR KCMP_FILES
+to compare whether processes do share share the file descriptor table
+
+.BR KCMP_FS
+to compare whether processes do share the file system information
+
+.BR KCMP_SIGHAND
+to compare whether processes do share a signal handlers table
+
+.BR KCMP_IO
+to compare whether processes do share I/O context
+
+.BR KCMP_SYSVSEM
+to compare whether processes do share a single list of
+System V semaphore undo values
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
+.I v2
+, in other words we have a shared resource here
+
+.B 1
+\-
+.I v1
+is greater than
+.I v2
+
+.B 2
+\-
+.I v1
+is less than
+.I v2
+
+.B 3
+\-
+.I v1
+is not equal to
+.I v2
+, but ordering information is unavailble.
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

