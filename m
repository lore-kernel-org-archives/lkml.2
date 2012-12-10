Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LJLeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:34:24 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:40362 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2LJLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:34:23 -0500
Message-ID: <1355139247.22545.6.camel@hal>
Subject: man page for s390_runtime_instr syscall
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 12:34:07 +0100
Organization: IBM LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12121011-5024-0000-0000-000004A28B52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I've written a man page for the s390_runtime_instr syscall which was merged with 3.7 (e4b8b3f). Now the question is if you would like to include it in the man-pages although it is completely s390 specific and wont be available on any other arch? Or should it go into a different package?

thanks, Jan
--

--- /dev/null	2012-12-04 10:52:46.657720288 +0100
+++ s390_runtime_instr.2	2012-10-09 13:55:39.000000000 +0200
@@ -0,0 +1,73 @@
+.\" Copyright IBM Corp. 2012
+.\" Author: Jan Glauber <jang@linux.vnet.ibm.com>
+.\"
+.TH S390_RUNTIME_INSTR 2 2012-10-09 "Linux Programmer's Manual"
+.SH NAME
+s390_runtime_instr \- enable/disable s390 CPU runtime instrumentation
+.SH SYNOPSIS
+.nf
+.B #include <asm/runtime_instr.h>
+
+.BI "int s390_runtime_instr(int " command ", int " signum ");
+.fi
+
+.SH DESCRIPTION
+The
+.BR s390_runtime_instr ()
+system call starts or stops CPU runtime instrumentation for the current thread.
+
+The
+.IR command
+argument controls whether runtime instumentation is started
+( 1 ) or stopped ( 2 ) for the current thread.
+
+The
+.IR signum
+argument specifies the number of a real-time signal. The
+real-time signal is sent to the thread if the runtime instrumentation
+buffer is full or if the runtime-instrumentation-halted interrupt
+occured.
+
+.SH RETURN VALUE
+On success
+.BR s390_runtime_instr ()
+returns 0 and enables the thread for
+runtime instrumentation by assigning the thread a default runtime
+instrumentation control block. The caller can then read and modify the
+control block and start the runtime instrumentation. On error, -1 is
+returned and
+.IR errno
+is set to one of the error codes listed below.
+
+.SH ERRORS
+.TP
+.B EOPNOTSUPP
+The runtime instrumentation facility is not available.
+.TP
+.B EINVAL
+The value specified in
+.IR command
+is not a valid command or the value specified in
+.IR signum
+is not a real-time signal number.
+.TP
+.B ENOMEM
+Allocating memory for the runtime instrumentation control block
+failed.
+
+.SH VERSIONS
+This system call is available since Linux 3.7.
+
+.SH CONFORMING TO
+This system call
+is only available on the s390 architecture. The runtime instrumentation facility is available
+beginning with System z EC12.
+
+.SH NOTES
+Glibc does not provide a wrapper for this system call, use
+.BR syscall (2)
+to call it.
+
+.SH SEE ALSO
+.BR signal (7),
+.BR syscall (2)

