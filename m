Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2LQS4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:56:02 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53486 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LQS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:56:00 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1355746007.3311.6.camel@hal>
References: <1355139247.22545.6.camel@hal> <CAKgNAkimi3joE3u1fGdX-d3kqkEb0ggG=wU=jyKnRPHsc=poMA@mail.gmail.com>
 <1355746007.3311.6.camel@hal>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 17 Dec 2012 19:55:39 +0100
Message-ID: <CAKgNAkgQ3JNYqKbD8XjKN0UKYy6Vv17iXbenuReDd9rDQEAY3g@mail.gmail.com>
Subject: Re: man page for s390_runtime_instr syscall
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

On Mon, Dec 17, 2012 at 1:06 PM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> On Sat, 2012-12-15 at 19:38 +0100, Michael Kerrisk (man-pages) wrote:
>> Thanks for this page. The man-pages package is the right place for it,
>> but a few things need fixing. Could you see below and resubmit please?
>
> I've addressed all of your comments but for the example. We could add
> the example later when the official documentation is released which
> did not yet happen.

Okay. I've applied your patch for man-pages-3.45. Thank you for
sending in this new page.

Cheers,

Michael


> --- /dev/null   2012-12-17 11:58:11.967183723 +0100
> +++ s390_runtime_instr.2        2012-12-17 12:55:20.942872393 +0100
> @@ -0,0 +1,91 @@
> +.\" Copyright IBM Corp. 2012
> +.\" Author: Jan Glauber <jang@linux.vnet.ibm.com>
> +.\" Copyright (c) 2012, IBM Corp.
> +.\"
> +.\" This is free documentation; you can redistribute it and/or
> +.\" modify it under the terms of the GNU General Public License as
> +.\" published by the Free Software Foundation; either version 2 of
> +.\" the License, or (at your option) any later version.
> +.\"
> +.\" The GNU General Public License's references to "object code"
> +.\" and "executables" are to be interpreted as the output of any
> +.\" document formatting or typesetting system, including
> +.\" intermediate and printed output.
> +.\"
> +.\" This manual is distributed in the hope that it will be useful,
> +.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> +.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +.\" GNU General Public License for more details.
> +.\"
> +.\" You should have received a copy of the GNU General Public
> +.\" License along with this manual; if not, see
> +.\" <http://www.gnu.org/licenses/>.
> +.TH S390_RUNTIME_INSTR 2 2012-12-17 "Linux Programmer's Manual"
> +.SH NAME
> +s390_runtime_instr \- enable/disable s390 CPU runtime instrumentation
> +.SH SYNOPSIS
> +.nf
> +.B #include <asm/runtime_instr.h>
> +
> +.BI "int s390_runtime_instr(int " command ", int " signum ");
> +.fi
> +
> +.SH DESCRIPTION
> +The
> +.BR s390_runtime_instr ()
> +system call starts or stops CPU runtime instrumentation for the current thread.
> +
> +The
> +.IR command
> +argument controls whether runtime instrumentation is started
> +( 1 ) or stopped ( 2 ) for the current thread.
> +
> +The
> +.IR signum
> +argument specifies the number of a real-time signal.
> +The real-time signal is sent to the thread if the runtime instrumentation
> +buffer is full or if the runtime-instrumentation-halted interrupt
> +occurred.
> +
> +.SH RETURN VALUE
> +On success
> +.BR s390_runtime_instr ()
> +returns 0 and enables the thread for
> +runtime instrumentation by assigning the thread a default runtime
> +instrumentation control block.
> +The caller can then read and modify the control block and start the runtime
> +instrumentation.
> +On error, -1 is returned and
> +.IR errno
> +is set to one of the error codes listed below.
> +
> +.SH ERRORS
> +.TP
> +.B EOPNOTSUPP
> +The runtime instrumentation facility is not available.
> +.TP
> +.B EINVAL
> +The value specified in
> +.IR command
> +is not a valid command or the value specified in
> +.IR signum
> +is not a real-time signal number.
> +.TP
> +.B ENOMEM
> +Allocating memory for the runtime instrumentation control block failed.
> +
> +.SH VERSIONS
> +This system call is available since Linux 3.7.
> +
> +.SH CONFORMING TO
> +This Linux-specific system call is only available on the s390 architecture.
> +The runtime instrumentation facility is available beginning with System z EC12.
> +
> +.SH NOTES
> +Glibc does not provide a wrapper for this system call, use
> +.BR syscall (2)
> +to call it.
> +
> +.SH SEE ALSO
> +.BR syscall (2),
> +.BR signal (7)
>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
