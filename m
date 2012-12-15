Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2LOSjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 13:39:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37773 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2LOSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 13:39:19 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1355139247.22545.6.camel@hal>
References: <1355139247.22545.6.camel@hal>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 15 Dec 2012 19:38:59 +0100
Message-ID: <CAKgNAkimi3joE3u1fGdX-d3kqkEb0ggG=wU=jyKnRPHsc=poMA@mail.gmail.com>
Subject: Re: man page for s390_runtime_instr syscall
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

On Mon, Dec 10, 2012 at 12:34 PM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> Hi Michael,
>
> I've written a man page for the s390_runtime_instr syscall which was
> merged with 3.7 (e4b8b3f). Now the question is if you would like to
> include it in the man-pages although it is completely s390 specific
and wont be available on any other arch? Or should it go into a
> different package?

Thanks for this page. The man-pages package is the right place for it,
but a few things need fixing. Could you see below and resubmit please?

> --- /dev/null   2012-12-04 10:52:46.657720288 +0100
> +++ s390_runtime_instr.2        2012-10-09 13:55:39.000000000 +0200
> @@ -0,0 +1,73 @@
> +.\" Copyright IBM Corp. 2012
> +.\" Author: Jan Glauber <jang@linux.vnet.ibm.com>

You have provided no license here. Can you please add one. Please see
http://www.kernel.org/doc/man-pages/licenses.html. (My preference is
the "verbatim" license, but others are of course possible.)

> +.\"
> +.TH S390_RUNTIME_INSTR 2 2012-10-09 "Linux Programmer's Manual"

Update the date here.

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
> +argument controls whether runtime instumentation is started

Spelling: instrumentation

> +( 1 ) or stopped ( 2 ) for the current thread.
> +
> +The
> +.IR signum
> +argument specifies the number of a real-time signal. The

Please start new sentences on a new source line.

> +real-time signal is sent to the thread if the runtime instrumentation
> +buffer is full or if the runtime-instrumentation-halted interrupt
> +occured.

Spelling: occurred.

> +
> +.SH RETURN VALUE
> +On success
> +.BR s390_runtime_instr ()
> +returns 0 and enables the thread for
> +runtime instrumentation by assigning the thread a default runtime
> +instrumentation control block. The caller can then read and modify the

Start new sentence on a new source line.

> +control block and start the runtime instrumentation. On error, -1 is

Start new sentence on a new source line.

> +returned and
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
> +Allocating memory for the runtime instrumentation control block
> +failed.
> +
> +.SH VERSIONS
> +This system call is available since Linux 3.7.
> +
> +.SH CONFORMING TO
> +This system call

This Linux-specific system call

> +is only available on the s390 architecture. The runtime instrumentation facility is available

http://www.kernel.org/doc/man-pages/licenses.html

> +beginning with System z EC12.
> +
> +.SH NOTES
> +Glibc does not provide a wrapper for this system call, use
> +.BR syscall (2)
> +to call it.

Somewhere around here it would be nice to have some notes on how one
uses this RI feature. The commit
e4b8b3f33fcaa0ed6e6b5482a606091d8cd20beb has a bit of info. I'd
suggest including that info in the page, with (possibly) an example.

> +
> +.SH SEE ALSO
> +.BR signal (7),
> +.BR syscall (2)

Order entries here by section number.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
