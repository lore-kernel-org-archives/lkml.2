Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1I2TIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:08:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55050 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1I2TIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:08:22 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 29 Sep 2011 21:08:01 +0200
Message-ID: <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chuck Ebbert <76306.1226@compuserve.com>,
        Blaisorblade <blaisorblade@yahoo.it>,
        Daniel Jacobowitz <dan@debian.org>
Content-Type: multipart/mixed; boundary=0015176f03646b17c304ae193b52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015176f03646b17c304ae193b52
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[CC+=3Dlinux-man + a few other possibly interested individuals]

Hello Denys, (Oleg, Tejun),

On Thu, Jul 21, 2011 at 1:09 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> Hi Michael,
>
> Please apply attached patch which updates ptrace manpage.
> (I'm not sending it inline, google web mail might mangle it. Sorry).

Thanks once again for this nice piece of work. Some comments, and a
revised page below.

> Changes include:
>
> s/parent/tracer/g, s/child/tracee/g - ptrace interface now
> is sufficiently cleaned up to not treat tracing process as parent.

Thanks!

> Deleted several outright false statements:
> - pid 1 can be traced

It looks to me as though this was once true, and I amended the page
accordingly. (Man-pages documents not just current behavior, but
historical behavior too.)

> - tracer is not shown as parent in ps output

Was this true at one time? If yes, then we should document past and
current behavior, and note when the change occurred.

> - PTRACE_ATTACH is not "the same behavior as if tracee had done
> =A0a PTRACE_TRACEME": PTRACE_ATTACH delivers a SIGSTOP.

Okay.

> - SIGSTOP _can_ be injected.

Was this true at one time? If yes, then we should document past and
current behavior, and note when the change occurred.

In the Linux 2.4 sources, I see the following in
arch/i386/kernel/signal.c::do_signal():

                        /* The debugger continued.  Ignore SIGSTOP.  */
                        if (signr =3D=3D SIGSTOP)
                                continue;

Did that code prevent SIGSTOP being injected in the 2.4 series?

> - Removed mentions of SunOS and Solaris as irrelevant.

Okay.

> - Added a few more known bugs.

Thanks.

> Added a large block of text in DESCRIPTION which doesn't focus
> on mechanical description of each flag and operation, but rather
> tries to describe a bigger picture. The targeted audience is
> a person which is reasonably knowledgeable in Unix but did not
> spend years working with ptrace, and thus may be unaware of its quirks.
> This text went through several iterations of review by Oleg Nesterov
> and Tejun Heo.

Thanks. That's a great addition!

> This block of text intentionally uses as little markup as possible,
> otherwise future modifications to it will be very hard to make.

As I noted in an earlier mail, there are many very good reasons to
have the formatting. I've applied suitable formatting, and I can help
with formatting for future revisions to the text.

So, I took your patch, and then did a global edit of the page to fix
various pieces (in the existing text, as well as do some language
clean-ups for the new text). In the process, I found a number of
pieces that are still unclear (some in the old text, some in your new
text). I also made some changes to your text that I'd like you to
check. I've marked each of these with FIXME below. Could you please
take a look at the FIXMEs, and write me a comment for each of these.
(I appreciate that in some cases, especially for the existing text,
you may not have a handy answer Denys, but if you (and others) can
give any help, that would be great.)

Rather than you writing a new patch to this version of the page, I
think it might be easiest if you just replied to the FIXMEs inline
below, then I can revise the page in the light of your comments.

Thanks,

Michael

PS Note that I also added a copyright notice for your changes.

PPS Note also that there's a FIXME at the top of the file for
PTRACE_SEIZE, PTRACE_INTERRUPT, and PTRACE_LISTEN. That's
informational for me, not a request to you (though if someone wants to
write documentation for those three new flags, I am happy receive it).

.\" Hey Emacs! This file is -*- nroff -*- source.
.\"
.\" Copyright (c) 1993 Michael Haardt <michael@moria.de>
.\" Fri Apr  2 11:32:09 MET DST 1993
.\"
.\" and changes Copyright (C) 1999 Mike Coleman (mkc@acm.org)
.\" -- major revision to fully document ptrace semantics per recent Linux
.\"    kernel (2.2.10) and glibc (2.1.2)
.\" Sun Nov  7 03:18:35 CST 1999
.\"
.\" and Copyright (c) 2011, Denys Vlasenko <vda.linux@googlemail.com>
.\"
.\" This is free documentation; you can redistribute it and/or
.\" modify it under the terms of the GNU General Public License as
.\" published by the Free Software Foundation; either version 2 of
.\" the License, or (at your option) any later version.
.\"
.\" The GNU General Public License's references to "object code"
.\" and "executables" are to be interpreted as the output of any
.\" document formatting or typesetting system, including
.\" intermediate and printed output.
.\"
.\" This manual is distributed in the hope that it will be useful,
.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
.\" GNU General Public License for more details.
.\"
.\" You should have received a copy of the GNU General Public
.\" License along with this manual; if not, write to the Free
.\" Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111=
,
.\" USA.
.\"
.\" Modified Fri Jul 23 23:47:18 1993 by Rik Faith <faith@cs.unc.edu>
.\" Modified Fri Jan 31 16:46:30 1997 by Eric S. Raymond <esr@thyrsus.com>
.\" Modified Thu Oct  7 17:28:49 1999 by Andries Brouwer <aeb@cwi.nl>
.\" Modified, 27 May 2004, Michael Kerrisk <mtk.manpages@gmail.com>
.\"     Added notes on capability requirements
.\"
.\" 2006-03-24, Chuck Ebbert <76306.1226@compuserve.com>
.\"    Added    PTRACE_SETOPTIONS, PTRACE_GETEVENTMSG, PTRACE_GETSIGINFO,
.\"        PTRACE_SETSIGINFO, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP
.\"    (Thanks to Blaisorblade, Daniel Jacobowitz and others who helped.)
.\" 2011-09, major update by Denys Vlasenko <vda.linux@googlemail.com>
.\"
.\" FIXME (later): Linux 3.1 adds PTRACE_SEIZE, PTRACE_INTERRUPT, and
PTRACE_LISTEN.
.\"
.TH PTRACE 2 2011-09-26 "Linux" "Linux Programmer's Manual"
.SH NAME
ptrace \- process trace
.SH SYNOPSIS
.nf
.B #include <sys/ptrace.h>
.sp
.BI "long ptrace(enum __ptrace_request " request ", pid_t " pid ", "
.BI "            void *" addr ", void *" data );
.fi
.SH DESCRIPTION
The
.BR ptrace ()
system call provides a means by which one process (the "tracer")
may observe and control the execution of another process (the "tracee"),
and examine and change the tracee's memory and registers.
It is primarily used to implement breakpoint debugging and system
call tracing.
.LP
A tracee first need to be attached to the tracer.
Attachment and subsequent commands are per thread:
in a multithreaded process,
every thread can be individually attached to a
(potentially different) tracer,
or left not attached and thus not debugged.
Therefore, "tracee" always means "(one) thread",
never "a (possibly multithreaded) process".
Ptrace commands are always sent to
a specific tracee using a call of the form

    ptrace(PTRACE_foo, pid, ...)

where
.I pid
is the thread ID of the corresponding Linux thread.
.LP
A process can initiate a trace by calling
.BR fork (2)
and having the resulting child do a
.BR PTRACE_TRACEME ,
followed (typically) by an
.BR execve (2).
Alternatively, one process may commence tracing another process using
.BR PTRACE_ATTACH .
.LP
While being traced, the tracee will stop each time a signal is delivered,
even if the signal is being ignored.
(An exception is
.BR SIGKILL ,
which has its usual effect.)
The tracer will be notified at its next call to
.BR waitpid (2)
(or one of the related "wait" system calls)
and may inspect and modify the tracee while it is stopped.
The tracer then causes the tracee to continue,
optionally ignoring the delivered signal
(or even delivering a different signal instead).
.LP
When the tracer is finished tracing, it can cause the tracee to continue
executing in a normal, untraced mode via
.BR PTRACE_DETACH .
.LP
The value of
.I request
determines the action to be performed:
.TP
.B PTRACE_TRACEME
Indicate that this process is to be traced by its parent.
Any signal (except
.BR SIGKILL )
delivered to this process will cause it to stop and its
parent to be notified via
.BR waitpid (2).
In addition, all subsequent calls to
.BR execve (2)
by the traced process will cause a
.B SIGTRAP
to be sent to it,
giving the parent a chance to gain control before the new program
begins execution.
A process probably shouldn't make this request if its parent
isn't expecting to trace it.
.RI ( pid ,
.IR addr ,
and
.IR data
are ignored.)
.LP
The
.B PTRACE_TRACEME
request is used only by the tracee;
the remaining requests are used only by the tracer.
In the following requests,
.I pid
specifies the thread ID of the tracee to be acted on.
For requests other than
.BR PTRACE_KILL ,
the tracee must be stopped.
.TP
.BR PTRACE_PEEKTEXT ", " PTRACE_PEEKDATA
Read a word at the address
.I addr
in the tracee's memory, returning the word as the result of the
.BR ptrace ()
call.
Linux does not have separate text and data address spaces,
so these two requests are currently equivalent.
.RI ( data
is ignored.)
.TP
.B PTRACE_PEEKUSER
.\" PTRACE_PEEKUSR in kernel source, but glibc uses PTRACE_PEEKUSER,
.\" and that is the name that seems common on other systems.
Read a word at offset
.I addr
in the tracee's USER area,
which holds the registers and other information about the process
(see
.IR <sys/user.h> ).
The word is returned as the result of the
.BR ptrace ()
call.
Typically, the offset must be word-aligned, though this might vary by
architecture.
See NOTES.
.RI ( data
is ignored.)
.TP
.BR PTRACE_POKETEXT ", " PTRACE_POKEDATA
Copy the word
.I data
to the address
.I addr
in the tracee's memory.
As for
.BR PTRACE_PEEKTEXT
and
.BR PTRACE_PEEKDATA ,
these two requests are currently equivalent.
.TP
.B PTRACE_POKEUSER
.\" PTRACE_POKEUSR in kernel source, but glibc uses PTRACE_POKEUSER,
.\" and that is the name that seems common on other systems.
Copy the word
.I data
to offset
.I addr
in the tracee's USER area.
As for
.BR PTRACE_PEEKUSER ,
the offset must typically be word-aligned.
In order to maintain the integrity of the kernel,
some modifications to the USER area are disallowed.
.\" FIXME In the preceding sentence, which modifications are disallowed,
.\" and when they are disallowed, how does userspace discover that fact?
.TP
.BR PTRACE_GETREGS ", " PTRACE_GETFPREGS
Copy the tracee's general purpose or floating-point registers,
respectively, to the address
.I data
in the tracer.
See
.I <sys/user.h>
for information on the format of this data.
.RI ( addr
is ignored.)
.TP
.BR PTRACE_GETSIGINFO " (since Linux 2.3.99-pre6)"
Retrieve information about the signal that caused the stop.
Copy a
.I siginfo_t
structure (see
.BR sigaction (2))
from the tracee to the address
.I data
in the tracer.
.RI ( addr
is ignored.)
.TP
.BR PTRACE_SETREGS ", " PTRACE_SETFPREGS
Copy the tracee's general purpose or floating-point registers,
respectively, from the address
.I data
in the tracer.
As for
.BR PTRACE_POKEUSER ,
some general purpose register modifications may be disallowed.
.\" FIXME In the preceding sentence, which modifications are disallowed,
.\" and when they are disallowed, how does userspace discover that fact?
.RI ( addr
is ignored.)
.TP
.BR PTRACE_SETSIGINFO " (since Linux 2.3.99-pre6)"
Set signal information:
copy a
.I siginfo_t
structure from the address
.I data
in the tracer to the tracee.
This will affect only signals that would normally be delivered to
the tracee and were caught by the tracer.
It may be difficult to tell
these normal signals from synthetic signals generated by
.BR ptrace ()
itself.
.RI ( addr
is ignored.)
.TP
.BR PTRACE_SETOPTIONS " (since Linux 2.4.6; see BUGS for caveats)"
Set ptrace options from
.IR data .
.RI ( addr
is ignored.)
.IR data
is interpreted as a bit mask of options,
which are specified by the following flags:
.RS
.TP
.BR PTRACE_O_TRACESYSGOOD " (since Linux 2.4.6)"
When delivering system call traps, set bit 7 in the signal number
(i.e., deliver
.IR "SIGTRAP|0x80" ).
This makes it easy for the tracer to distinguish
normal traps from those caused by a system call.
.RB ( PTRACE_O_TRACESYSGOOD
may not work on all architectures.)
.\" FIXME Please check. In the following paragraphs, I substituted language
.\" such as:
.\"     Stop tracee at next fork(2) call with SIGTRAP|PTRACE_EVENT_FORK<<8
.\" with:
.\"     Stop tracee at next fork(2) call... A subsequent PTRACE_GETSIGINFO
.\"     on the stopped tracee will return a siginfo_t structure with si_cod=
e
.\"     set to SIGTRAP|PTRACE_EVENT_FORK<<8.
.\"
.\" Is this change correct?
.\"
.TP
.BR PTRACE_O_TRACEFORK " (since Linux 2.5.46)"
Stop the tracee at the next
.BR fork (2)
and automatically start tracing the newly forked process,
which will start with a
.BR SIGSTOP .
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_FORK<<8 .
The PID of the new process can be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACEVFORK " (since Linux 2.5.46)"
Stop the tracee at the next
.BR vfork (2)
and automatically start tracing the newly vforked process,
which will start with a
.BR SIGSTOP .
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_VFORK<<8 .
The PID of the new process can be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACECLONE " (since Linux 2.5.46)"
Stop the tracee at the next
.BR clone (2)
and automatically start tracing the newly cloned process,
which will start with a
.BR SIGSTOP .
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_CLONE<<8 .
The PID of the new process can be retrieved with
.BR PTRACE_GETEVENTMSG .
.IP
This option may not catch
.BR clone (2)
calls in all cases.
If the tracee calls
.BR clone (2)
with the
.B CLONE_VFORK
flag,
.B PTRACE_EVENT_VFORK
will be delivered instead
if
.B PTRACE_O_TRACEVFORK
is set; otherwise if the tracee calls
.BR clone (2)
with the exit signal set to
.BR SIGCHLD ,
.B PTRACE_EVENT_FORK
will be delivered if
.B PTRACE_O_TRACEFORK
is set.
.TP
.BR PTRACE_O_TRACEEXEC " (since Linux 2.5.46)"
Stop the tracee at the next
.BR execve (2).
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_EXEC<<8 .
.TP
.BR PTRACE_O_TRACEVFORKDONE " (since Linux 2.5.60)"
Stop the tracee at the completion of the next
.BR vfork (2).
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_VFORK_DONE<<8 .
The PID of the new process can (since Linux 2.6.18) be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACEEXIT " (since Linux 2.5.60)"
Stop the tracee at exit.
A subsequent
.B PTRACE_GETSIGINFO
on the stopped tracee will return a
.I siginfo_t
structure with
.I si_code
set to
.IR SIGTRAP|PTRACE_EVENT_EXIT<<8 .
The tracee's exit status can be retrieved with
.BR PTRACE_GETEVENTMSG .
.IP
The tracee is stopped early during process exit,
when registers are still available,
allowing the tracer to see where the exit occurred,
whereas the normal exit notification is done after the process
is finished exiting.
Even though context is available,
the tracer cannot prevent the exit from happening at this point.
.RE
.TP
.BR PTRACE_GETEVENTMSG " (since Linux 2.5.46)"
Retrieve a message (as an
.IR "unsigned long" )
about the ptrace event
that just happened, placing it at the address
.I data
in the tracer.
For
.BR PTRACE_EVENT_EXIT ,
this is the tracee's exit status.
For
.BR PTRACE_EVENT_FORK ,
.BR PTRACE_EVENT_VFORK ,
.BR PTRACE_EVENT_VFORK_DONE ,
and
.BR PTRACE_EVENT_CLONE ,
this is the PID of the new process.
.RI (  addr
is ignored.)
.TP
.B PTRACE_CONT
Restart the stopped tracee process.
If
.I data
is nonzero,
it is interpreted as the number of a signal to be delivered to the tracee;
otherwise, no signal is delivered.
Thus, for example, the tracer can control
whether a signal sent to the tracee is delivered or not.
.RI ( addr
is ignored.)
.TP
.BR PTRACE_SYSCALL ", " PTRACE_SINGLESTEP
Restart the stopped tracee as for
.BR PTRACE_CONT ,
but arrange for the tracee to be stopped at
the next entry to or exit from a system call,
or after execution of a single instruction, respectively.
(The tracee will also, as usual, be stopped upon receipt of a signal.)
>From the tracer's perspective, the tracee will appear to have been
stopped by receipt of a
.BR SIGTRAP .
So, for
.BR PTRACE_SYSCALL ,
for example, the idea is to inspect
the arguments to the system call at the first stop,
then do another
.B PTRACE_SYSCALL
and inspect the return value of the system call at the second stop.
The
.I data
argument is treated as for
.BR PTRACE_CONT .
.RI (addr
is ignored.)
.TP
.BR PTRACE_SYSEMU ", " PTRACE_SYSEMU_SINGLESTEP " (since Linux 2.6.14)"
For
.BR PTRACE_SYSEMU ,
continue and stop on entry to the next system call,
which will not be executed.
For
.BR PTRACE_SYSEMU_SINGLESTEP ,
do the same but also singlestep if not a system call.
This call is used by programs like
User Mode Linux that want to emulate all the tracee's system calls.
The
.I data
argument is treated as for
.BR PTRACE_CONT .
.RI ( addr
is ignored;
not supported on all architectures.)
.TP
.B PTRACE_KILL
Send the tracee a
.B SIGKILL
to terminate it.
.RI ( addr
and
.I data
are ignored.)
.IP
.I This operation is deprecated; do not use it!
Instead, send a
.BR SIGKILL
directly using
.BR kill (2)
or
.BR tgkill (2).
The problem with
.B PTRACE_KILL
is that it requires the tracee to be in signal-delivery-stop,
otherwise it may not work
(i.e., may complete successfully but won't kill the tracee).
By contrast, sending a
.B SIGKILL
directly has no such limitation.
.\" mtk: Commented out the following. It doesn't belong in the man page.
.\" .LP
.\" [Note: deprecation suggested by Oleg Nesterov. He prefers to deprecate
.\" it instead of describing (and needing to support) PTRACE_KILL's quirks.=
]
.TP
.B PTRACE_ATTACH
Attach to the process specified in
.IR pid ,
making it a tracee of the calling process.
.\" FIXME So, was the following EVER true? IF it was,
.\"       we should reinstate the text and add mention of
.\"       the kernel version where the behaviour changed.
.\"
.\" Not true: (removed by dv)
.\" ; the behavior of the tracee is as if it had done a
.\" .BR PTRACE_TRACEME .
.\" The calling process actually becomes the parent of the tracee
.\" process for most purposes (e.g., it will receive
.\" notification of tracee events and appears in
.\" .BR ps (1)
.\" output as the tracee's parent), but a
.\" .BR getppid (2)
.\" by the tracee will still return the PID of the original parent.
The tracee is sent a
.BR SIGSTOP ,
but will not necessarily have stopped
by the completion of this call; use
.BR waitpid (2)
to wait for the tracee to stop.
See the "Attaching and detaching" subsection for additional information.
.RI ( addr
and
.I data
are ignored.)
.TP
.B PTRACE_DETACH
Restart the stopped tracee as for
.BR PTRACE_CONT ,
but first detach from it.
Under Linux, a tracee can be detached in this way regardless
of which method was used to initiate tracing.
.RI ( addr
is ignored.)
.\"
.\" In the text below, we decided to avoid prettifying the text with markup=
:
.\" it would make the source nearly impossible to edit, and we _do_ intend
.\" to edit it often, in order to keep it updated:
.\" ptrace API is full of quirks, no need to compound this situation by
.\" making it excruciatingly painful to document them!
.\"
.SS Death under ptrace
When a (possibly multithreaded) process receives a killing signal
(one whose disposition is set to
.B SIG_DFL
and whose default action is to kill the process),
all threads exit.
Tracees report their death to their tracer(s).
Notification of this event is delivered via
.BR waitpid (2).
.LP
Note that the killing signal will first cause signal-delivery-stop
(on one tracee only),
and only after it is injected by the tracer
(or after it was dispatched to a thread which isn't traced),
will death from the signal happen on
.I all
tracees within a multithreaded process.
(The term "signal-delivery-stop" is explained below.)
.LP
.B SIGKILL
operates similarly, with exceptions.
No signal-delivery-stop is generated for
.B SIGKILL
and therefore the tracer can't suppress it.
.B SIGKILL
kills even within system calls
(syscall-exit-stop is not generated prior to death by
.BR SIGKILL ).
The net effect is that
.B SIGKILL
always kills the process (all its threads),
even if some threads of the process are ptraced.
.LP
When the tracee calls
.BR _exit (2),
it reports its death to its tracer.
Other threads are not affected.
.LP
When any thread executes
.BR exit_group (2),
every tracee in its thread group reports its death to its tracer.
.LP
If the
.B PTRACE_O_TRACEEXIT
option is on,
.B PTRACE_EVENT_EXIT
will happen before actual death.
This applies to exits via
.BR exit (2),
.BR exit_group (2),
and signal deaths (except
.BR SIGKILL ),
and when threads are torn down on
.BR execve (2)
in a multithreaded process.
.LP
The tracer cannot assume that the ptrace-stopped tracee exists.
There are many scenarios when the tracee may die while stopped (such as
.BR SIGKILL ).
Therefore, the tracer must be prepared to handle an
.B ESRCH
error on any ptrace operation.
Unfortunately, the same error is returned if the tracee
exists but is not ptrace-stopped
(for commands which require a stopped tracee),
or if it is not traced by the process which issued the ptrace call.
The tracer needs to keep track of the stopped/running state of the tracee,
and interpret
.B ESRCH
as "tracee died unexpectedly" only if it knows that the tracee has
been observed to enter ptrace-stop.
Note that there is no guarantee that
.I waitpid(WNOHANG)
will reliably report the tracee's death status if a
ptrace operation returned
.BR ESRCH .
.I waitpid(WNOHANG)
may return 0 instead.
In other words, the tracee may be "not yet fully dead",
but already refusing ptrace requests.
.LP
The tracer can't assume that the tracee
.I always
ends its life by reporting
.I WIFEXITED(status)
or
.IR WIFSIGNALED(status) .
.LP
.\"     or can it? Do we include such a promise into ptrace API?
.\"
.\" FIXME: The preceding comment seems to be unresolved?
.\"        Do you want to add anything?
.\"
.SS Stopped states
A tracee can be in two states: running or stopped.
.LP
There are many kinds of states when the tracee is stopped, and in ptrace
discussions they are often conflated.
Therefore, it is important to use precise terms.
.LP
In this manual page, any stopped state in which the tracee is ready
to accept ptrace commands from the tracer is called
.IR ptrace-stop .
Ptrace-stops can
be further subdivided into
.IR signal-delivery-stop ,
.IR group-stop ,
.IR syscall-stop ,
and so on.
These stopped states are described in detail below.
.LP
When the running tracee enters ptrace-stop, it notifies its tracer using
.BR waitpid (2)
(or one of the other "wait" system calls).
Most of this manual page assumes that the tracer waits with:
.LP
    pid =3D waitpid(pid_or_minus_1, &status, __WALL);
.LP
Ptrace-stopped tracees are reported as returns with
.I pid
greater than 0 and
.I WIFSTOPPED(status)
true.
.LP
.\" FIXME: mtk: the following comment seems to be unresolved?
.\"        Do you want to add anything?
.\"
.\"     Do we require __WALL usage, or will just using 0 be ok? Are the
.\"     rules different if user wants to use waitid? Will waitid require
.\"     WEXITED?
.\"
.LP
.\" FIXME: Is the following comment "__WALL... implies" true?
The
.B __WALL
flag does not include the
.B WSTOPPED
and
.B WEXITED
flags, but implies their functionality.
.LP
Setting the
.B WCONTINUED
flag when calling
.BR waitpid (2)
is not recommended: the "continued" state is per-process and
consuming it can confuse the real parent of the tracee.
.LP
Use of the
.B WNOHANG
flag may cause
.BR waitpid (2)
to return 0 ("no wait results available yet")
even if the tracer knows there should be a notification.
Example:
.nf

    kill(tracee, SIGKILL);
    waitpid(tracee, &status, __WALL | WNOHANG);
.fi
.\" FIXME: mtk: the following comment seems to be unresolved?
.\"        Do you want to add anything?
.\"
.\"     waitid usage? WNOWAIT?
.\"     describe how wait notifications queue (or not queue)
.LP
The following kinds of ptrace-stops exist: signal-delivery-stops,
group-stop, PTRACE_EVENT stops, syscall-stops
.\"
.\" FIXME: mtk: the following text appears to be incomplete.
.\"        Do you want to add anything?
.\"
[, PTRACE_SINGLESTEP, PTRACE_SYSEMU,
PTRACE_SYSEMU_SINGLESTEP].
They all are reported by
.BR waitpid (2)
with
.I WIFSTOPPED(status)
true.
They may be differentiated by examining the value
.IR status>>8 ,
and if there is ambiguity in that value, by querying
.BR PTRACE_GETSIGINFO .
.\"
.\" FIXME What is the purpose of the following sentence? Is it to warn
.\"       the reader not to use WSTOPSIG()? If so, we should make that
.\"       point more explicitly.
(Note: the
.I WSTOPSIG(status)
macro returns the value
.IR "(status>>8)\ &\ 0xff)" .)
.SS Signal-delivery-stop
When a (possibly multithreaded) process receives any signal except
.BR SIGKILL ,
the kernel selects an arbitrary thread which handles the signal.
(If the signal is generated with
.BR tgkill (2),
the target thread can be explicitly selected by the caller.)
If the selected thread is traced, it enters signal-delivery-stop.
At this point, the signal is not yet delivered to the process,
and can be suppressed by the tracer.
If the tracer doesn't suppress the signal,
.\"
.\" FIXME: I added the word "restart" to the following line. Okay?
it passes the signal to the tracee in the next ptrace restart request.
This second step of signal delivery is called
.I "signal injection"
in this manual page.
Note that if the signal is blocked,
signal-delivery-stop doesn't happen until the signal is unblocked,
with the usual exception that
.B SIGSTOP
can't be blocked.
.LP
Signal-delivery-stop is observed by the tracer as
.BR waitpid (2)
returning with
.I WIFSTOPPED(status)
true, with the stopping signal returned by
.IR WSTOPSIG(status) .
If the stopping signal is
.BR SIGTRAP ,
this may be a different kind of ptrace-stop;
see the "Syscall-stops" and "execve" sections below for details.
If
.I WSTOPSIG(status)
returns a stopping signal, this may be a group-stop; see below.
.SS Signal injection and suppression
After signal-delivery-stop is observed by the tracer,
the tracer should restart the tracee with the call
.LP
    ptrace(PTRACE_restart, pid, 0, sig)
.LP
where
.B PTRACE_restart
is one of the restarting ptrace requests.
If
.I sig
is 0, then a signal is not delivered.
Otherwise, the signal
.I sig
is delivered.
This operation is called
.I "signal injection"
in this manual page, to distinguish it from signal-delivery-stop.
.LP
Note that the
.I sig
value may be different from the
.I WSTOPSIG(status)
value: the tracer can cause a different signal to be injected.
.LP
Note that a suppressed signal still causes system calls to return
prematurely.
Restartable system calls will be restarted (the tracer will
observe the tracee to execute
.BR restart_syscall(2)
if the tracer uses
.BR PTRACE_SYSCALL );
non-restartable system calls may fail with
.B EINTR
even though no observable signal is injected to the tracee.
.LP
Note that restarting ptrace commands issued in ptrace-stops other than
signal-delivery-stop are not guaranteed to inject a signal, even if
.I sig
is nonzero.
No error is reported; a nonzero
.I sig
may simply be ignored.
Ptrace users should not try to "create a new signal" this way: use
.BR tgkill (2)
instead.
.LP
.\"
.\" FIXME: the referrent of "This" in the next line is not clear.
.\"        What does "This" refer to?
This is a cause of confusion among ptrace users.
One typical scenario is that the tracer observes group-stop,
mistakes it for signal-delivery-stop, restarts the tracee with

    ptrace(PTRACE_rest, pid, 0, stopsig)

with the intention of injecting
.IR stopsig ,
but
.I stopsig
gets ignored and the tracee continues to run.
.LP
The
.B SIGCONT
signal has a side effect of waking up (all threads of)
a group-stopped process.
This side effect happens before signal-delivery-stop.
The tracer can't suppress this side-effect (it can
only suppress signal injection, which only causes the
.BR SIGCONT
handler to not be executed in the tracee, if such a handler is installed).
In fact, waking up from group-stop may be followed by
signal-delivery-stop for signal(s)
.I other than
.BR SIGCONT ,
if they were pending when
.B SIGCONT
was delivered.
In other words,
.B SIGCONT
may be not the first signal observed by the tracee after it was sent.
.LP
Stopping signals cause (all threads of) a process to enter group-stop.
This side effect happens after signal injection, and therefore can be
suppressed by the tracer.
.LP
.B PTRACE_GETSIGINFO
can be used to retrieve a
.I siginfo_t
structure which corresponds to the delivered signal.
.B PTRACE_SETSIGINFO
may be used to modify it.
If
.B PTRACE_SETSIGINFO
has been used to alter
.IR siginfo_t ,
the
.I si_signo
field and the
.I sig
parameter in the restarting command must match,
otherwise the result is undefined.
.SS Group-stop
When a (possibly multithreaded) process receives a stopping signal,
all threads stop.
If some threads are traced, they enter a group-stop.
Note that the stopping signal will first cause signal-delivery-stop
(on one tracee only), and only after it is injected by the tracer
(or after it was dispatched to a thread which isn't traced),
will group-stop be initiated on
.I all
tracees within the multithreaded process.
As usual, every tracee reports its group-stop separately
to the corresponding tracer.
.LP
Group-stop is observed by the tracer as
.BR waitpid (2)
returning with
.I WIFSTOPPED(status)
true, with the stopping signal available via
.IR WSTOPSIG(status) .
The same result is returned by some other classes of ptrace-stops,
therefore the recommended practice is to perform the call
.LP
    ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)
.LP
The call can be avoided if the signal is not
.BR SIGSTOP ,
.BR SIGTSTP ,
.BR SIGTTIN ,
or
.BR SIGTTOU ;
only these four signals are stopping signals.
If the tracer sees something else, it can't be a group-stop.
Otherwise, the tracer needs to call
.BR PTRACE_GETSIGINFO .
If
.B PTRACE_GETSIGINFO
fails with
.BR EINVAL ,
then it is definitely a group-stop.
(Other failure codes are possible, such as
.B ESRCH
("no such process") if a
.B SIGKILL
killed the tracee.)
.LP
As of kernel 2.6.38,
after the tracer sees the tracee ptrace-stop and until it
restarts or kills it, the tracee will not run,
and will not send notifications (except
.B SIGKILL
death) to the tracer, even if the tracer enters into another
.BR waitpid (2)
call.
.LP
.\"
.\" FIXME ??? referrent of "it" in the next line is unclear
.\"        What does "it" refer to?
Currently, it causes a problem with transparent handling of stopping
signals: if the tracer restarts the tracee after group-stop,
.B SIGSTOP
is effectively ignored: the tracee doesn't remain stopped, it runs.
If the tracer doesn't restart the tracee before entering into the next
.BR waitpid (2),
future
.B SIGCONT
signals will not be reported to the tracer.
This would cause
.B SIGCONT
to have no effect.
.SS PTRACE_EVENT stops
If the tracer sets
.B PTRACE_O_TRACE_*
options, the tracee will enter ptrace-stops called
.B PTRACE_EVENT
stops.
.LP
.B PTRACE_EVENT
stops are observed by the tracer as
.BR waitpid (2)
returning with
.IR WIFSTOPPED(status) ,
and
.I WSTOPSIG(status)
returns
.BR SIGTRAP .
An additional bit is set in the higher byte of the status word:
the value
.I status>>8
will be

    (SIGTRAP | PTRACE_EVENT_foo << 8).

The following events exist:
.TP
.B PTRACE_EVENT_VFORK
Stop before return from
.BR vfork (2)
or
.BR clone (2)
with the
.B CLONE_VFORK
flag.
When the tracee is continued after this stop, it will wait for child to
exit/exec before continuing its execution
(in other words, the usual behavior on
.BR vfork (2)).
.TP
.B PTRACE_EVENT_FORK
Stop before return from
.BR fork (2)
or
.BR clone (2)
with the exit signal set to
.BR SIGCHLD .
.TP
.B PTRACE_EVENT_CLONE
Stop before return from
.BR clone (2)
.TP
.B PTRACE_EVENT_VFORK_DONE
Stop before return from
.BR vfork (2)
or
.BR clone (2)
with the
.B CLONE_VFORK
flag,
but after the child unblocked this tracee by exiting or execing.
.LP
For all four stops described above,
the stop occurs in the parent (i.e., the tracee),
not in the newly created thread.
.BR PTRACE_GETEVENTMSG
can be used to retrieve the new thread's ID.
.TP
.B PTRACE_EVENT_EXEC
Stop before return from
.BR execve (2).
.TP
.B PTRACE_EVENT_EXIT
Stop before exit (including death from
.BR exit_group (2)),
signal death, or exit caused by
.BR execve (2)
in a multithreaded process.
.B PTRACE_GETEVENTMSG
returns the exit status.
Registers can be examined
(unlike when "real" exit happens).
The tracee is still alive; it needs to be
.BR PTRACE_CONT ed
or
.BR PTRACE_DETACH ed
to finish exiting.
.LP
.B PTRACE_GETSIGINFO
on
.B PTRACE_EVENT
stops returns
.B SIGTRAP in
.IR si_signo ,
with
.I si_code
set to
.IR "(event<<8)\ |\ SIGTRAP" .
.SS Syscall-stops
If the tracee was restarted by
.BR PTRACE_SYSCALL ,
the tracee enters
syscall-enter-stop just prior to entering any system call.
If the tracer restarts the tracee with
.BR PTRACE_SYSCALL ,
the tracee enters syscall-exit-stop when the system call is finished,
or if it is interrupted by a signal.
(That is, signal-delivery-stop never happens between syscall-enter-stop
and syscall-exit-stop; it happens
.I after
syscall-exit-stop.)
.LP
Other possibilities are that the tracee may stop in a
.B PTRACE_EVENT
stop, exit (if it entered
.BR _exit (2)
or
.BR exit_group (2)),
be killed by
.BR SIGKILL ,
or die silently (if it is a thread group leader, the
.BR execve (2)
happened in another thread,
and that thread is not traced by the same tracer;
this situation is discussed later).
.LP
Syscall-enter-stop and syscall-exit-stop are observed by the tracer as
.BR waitpid (2)
returning with
.I WIFSTOPPED(status)
true, and
.I WSTOPSIG(status)
giving
.BR SIGTRAP .
If the
.B PTRACE_O_TRACESYSGOOD
option was set by the tracer, then
.I WSTOPSIG(status)
will give the value
.IR "(SIGTRAP\ |\ 0x80)" .
.LP
Syscall-stops can be distinguished from signal-delivery-stop with
.B SIGTRAP
by querying
.BR PTRACE_GETSIGINFO
for the following cases:
.TP
.IR si_code " <=3D 0"
.B SIGTRAP
.\" FIXME: Please confirm this is okay: I changed
.\"        "the usual suspects" to "by a system call". Okay?
.\"        Shouldn't we also add kill(2) here?
was sent by a system call
.RB ( tgkill (2),
.BR sigqueue (3),
etc.)
.TP
.IR si_code " =3D=3D SI_KERNEL (0x80)"
.B SIGTRAP
was sent by the kernel.
.TP
.IR si_code " =3D=3D SIGTRAP or " si_code " =3D=3D (SIGTRAP|0x80)"
This is a syscall-stop.
.LP
However, syscall-stops happen very often (twice per system call),
and performing
.B PTRACE_GETSIGINFO
for every syscall-stop may be somewhat expensive.
.LP
.\"
.\" FIXME referrent of "them" in next line ???
.\"       What does "them" refer to?
Some architectures allow the cases to be distinguished
by examining registers.
For example, on x86,
.I rax
=3D=3D
.RB - ENOSYS
in syscall-enter-stop.
Since
.B SIGTRAP
(like any other signal) always happens
.I after
syscall-exit-stop,
and at this point
.I rax
almost never contains
.RB - ENOSYS ,
the
.B SIGTRAP
looks like "syscall-stop which is not syscall-enter-stop";
in other words, it looks like a
"stray syscall-exit-stop" and can be detected this way.
But such detection is fragile and is best avoided.
.LP
Using the
.B PTRACE_O_TRACESYSGOOD
.\"
.\" FIXME Below: "is the recommended method" for WHAT?
option is the recommended method,
since it is reliable and does not incur a performance penalty.
.LP
Syscall-enter-stop and syscall-exit-stop are
indistinguishable from each other by the tracer.
The tracer needs to keep track of the sequence of
ptrace-stops in order to not misinterpret syscall-enter-stop as
syscall-exit-stop or vice versa.
The rule is that syscall-enter-stop is
always followed by syscall-exit-stop,
.B PTRACE_EVENT
stop or the tracee's death;
no other kinds of ptrace-stop can occur in between.
.LP
If after syscall-enter-stop,
the tracer uses a restarting command other than
.BR PTRACE_SYSCALL ,
syscall-exit-stop is not generated.
.LP
.B PTRACE_GETSIGINFO
on syscall-stops returns
.B SIGTRAP
in
.IR si_signo ,
with
.I si_code
set to
.B SIGTRAP
or
.IR (SIGTRAP|0x80) .
.SS PTRACE_SINGLESTEP, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP stops
.\"
.\" FIXME The following TODO is unresolved
.\"       Do you want to add anything?
.\"
(TODO: document stops occurring with PTRACE_SINGLESTEP, PTRACE_SYSEMU,
PTRACE_SYSEMU_SINGLESTEP)
.SS Informational and restarting ptrace commands
Most ptrace commands (all except
.BR PTRACE_ATTACH ,
.BR PTRACE_TRACEME ,
and
.BR PTRACE_KILL )
require the tracee to be in a ptrace-stop, otherwise they fail with
.BR ESRCH .
.LP
When the tracee is in ptrace-stop,
the tracer can read and write data to
the tracee using informational commands.
These commands leave the tracee in ptrace-stopped state:
.LP
.nf
    ptrace(PTRACE_PEEKTEXT/PEEKDATA/PEEKUSER, pid, addr, 0);
    ptrace(PTRACE_POKETEXT/POKEDATA/POKEUSER, pid, addr, long_val);
    ptrace(PTRACE_GETREGS/GETFPREGS, pid, 0, &struct);
    ptrace(PTRACE_SETREGS/SETFPREGS, pid, 0, &struct);
    ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo);
    ptrace(PTRACE_SETSIGINFO, pid, 0, &siginfo);
    ptrace(PTRACE_GETEVENTMSG, pid, 0, &long_var);
    ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags);
.fi
.LP
Note that some errors are not reported.
For example, setting signal information
.RI ( siginfo )
may have no effect in some ptrace-stops, yet the call may succeed
(return 0 and not set
.IR errno );
querying
.B PTRACE_GETEVENTMSG
may succeed and return some random value if current ptrace-stop
is not documented as returning a meaningful event message.
.LP
The call

    ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags);

affects one tracee.
The tracee's current flags are replaced.
Flags are inherited by new tracees created and "auto-attached" via active
.BR PTRACE_O_TRACEFORK ,
.BR PTRACE_O_TRACEVFORK ,
or
.BR PTRACE_O_TRACECLONE
options.
.LP
Another group of commands makes the ptrace-stopped tracee run.
They have the form:
.LP
    ptrace(PTRACE_cmd, pid, 0, sig);
.LP
where
.I cmd
is
.BR PTRACE_CONT ,
.BR PTRACE_DETACH ,
.BR PTRACE_SYSCALL ,
.BR PTRACE_SINGLESTEP ,
.BR PTRACE_SYSEMU ,
or
.BR PTRACE_SYSEMU_SINGLESTEP.
If the tracee is in signal-delivery-stop,
.I sig
is the signal to be injected (if it is nonzero).
Otherwise,
.I sig
may be ignored.
(Recommended practice is to always pass 0 in these cases.)
.SS Attaching and detaching
A thread can be attached to the tracer using the call

    ptrace(PTRACE_ATTACH, pid, 0, 0);

This also sends
.B SIGSTOP
to this thread.
If the tracer wants this
.B SIGSTOP
to have no effect, it needs to suppress it.
Note that if other signals are concurrently sent to
this thread during attach,
the tracer may see the tracee enter signal-delivery-stop
with other signal(s) first!
The usual practice is to reinject these signals until
.B SIGSTOP
is seen, then suppress
.B SIGSTOP
injection.
.\"
.\" FIXME I significantly rewrote the following sentence to try to make it
.\" clearer. Is the meaning still preserved?
The design bug here is that a ptrace attach and a concurrently delivered
.B SIGSTOP
may race and the concurrent
.B SIGSTOP
may be lost.
.\"
.\" FIXME: mtk: the following comment seems to be unresolved?
.\"	   Do you want to add any text?
.\"
.\"      Describe how to attach to a thread which is already group-stopped.
.LP
Since attaching sends
.B SIGSTOP
and the tracer usually suppresses it, this may cause a stray
.I EINTR
return from the currently executing system call in the tracee,
as described in the "signal injection and suppression" section.
.LP
The request

    ptrace(PTRACE_TRACEME, 0, 0, 0);

turns the calling thread into a tracee.
The thread continues to run (doesn't enter ptrace-stop).
A common practice is to follow the
.B PTRACE_TRACEME
with

    raise(SIGSTOP);

and allow the parent (which is our tracer now) to observe our
signal-delivery-stop.
.LP
If the
.BR PTRACE_O_TRACEFORK ,
.BR PTRACE_O_TRACEVFORK ,
or
.BR PTRACE_O_TRACECLONE
options are in effect, then children created by, respectively,
.BR vfork (2)
or
.BR clone (2)
with the
.B CLONE_VFORK
flag,
.BR fork (2)
or
.BR clone (2)
with the exit signal set to
.BR SIGCHLD ,
and other kinds of
.BR clone (2),
are automatically attached to the same tracer which traced their parent.
.B SIGSTOP
is delivered to the children, causing them to enter
signal-delivery-stop after they exit the system call which created them.
.LP
Detaching of the tracee is performed by:

    ptrace(PTRACE_DETACH, pid, 0, sig);

.B PTRACE_DETACH
is a restarting operation;
therefore it requires the tracee to be in ptrace-stop.
If the tracee is in signal-delivery-stop, a signal can be injected.
Otherwise, the
.I sig
parameter may be silently ignored.
.LP
If the tracee is running when the tracer wants to detach it,
the usual solution is to send
.B SIGSTOP
(using
.BR tgkill (2),
to make sure it goes to the correct thread),
wait for the tracee to stop in signal-delivery-stop for
.B SIGSTOP
and then detach it (suppressing
.B SIGSTOP
injection).
A design bug is that this can race with concurrent
.BR SIGSTOP s.
Another complication is that the tracee may enter other ptrace-stops
and needs to be restarted and waited for again, until
.B SIGSTOP
is seen.
Yet another complication is to be sure that
the tracee is not already ptrace-stopped,
because no signal delivery happens while it is\(emnot even
.BR SIGSTOP .
.\" FIXME: mtk: the following comment seems to be unresolved?
.\"       Do you want to add anything?
.\"
.\"     Describe how to detach from a group-stopped tracee so that it
.\"     doesn't run, but continues to wait for SIGCONT.
.\"
.LP
If the tracer dies, all tracees are automatically detached and restarted,
unless they were in group-stop.
Handling of restart from group-stop is
.\" FIXME: Define currently
currently buggy, but the
.\" FIXME: Planned for when?
"as planned" behavior is to leave tracee stopped and waiting for
.BR SIGCONT .
If the tracee is restarted from signal-delivery-stop,
the pending signal is injected.
.SS execve(2) under ptrace
.\" clone(2) THREAD_CLONE says:
.\"     If  any  of the threads in a thread group performs an execve(2),
.\"     then all threads other than the thread group leader are terminated,
.\"     and the new program is executed in the thread group leader.
.\"
.\" FIXME mtk-addition:  please check: I added the following piece to
.\"       clarify that multithreaded here means clone()+CLONE_THREAD
.\"
When one thread in a multithreaded process
(i.e., a thread group consisting of threads created using the
.BR clone (2)
.B CLONE_THREAD
flag) calls
.\" FIXME end-mtk-addition
.\"
.BR execve (2),
the kernel destroys all other threads in the process,
.\" In kernel 3.1 sources, see fs/exec.c::de_thread()
and resets the thread ID of the execing thread to the
thread group ID (process ID).
.\"
.\" FIXME mtk-addition:  please check: I added the following piece:
(Or, to put things another way, when a multithreaded process does an
.BR execve (2),
the kernel makes it look as though the
.BR execve (2)
occurred in the thread group leader, regardless of which thread did the
.BR execve (2).)
.\" FIXME end-mtk-addition
.\"
This resetting of the thread ID looks very confusing to tracers:
.IP * 3
All other threads stop in
.\" FIXME: mtk: What is "PTRACE_EXIT stop"?
.\"        Should that be "PTRACE_EVENT_EXIT stop"?
.B PTRACE_EXIT
stop,
.\" FIXME: mtk: In the next line, "by active ptrace option" is unclear.
.\"        What does it mean?
if requested by active ptrace option.
Then all other threads except the thread group leader report
death as if they exited via
.BR _exit (2)
with exit code 0.
Then
.B PTRACE_EVENT_EXEC
.\" FIXME: mtk: In the next line, "by active ptrace option" is unclear
.\"        What does it mean?
stop happens, if requested by active ptrace option.
.\" FIXME: mtk: the following comment seems to be unresolved?
.\"       (on which tracee - leader? execve-ing one?)
.\"
.\" FIXME: Please check: at various places in the following,
.\"        I have changed "pid" to "[the tracee's] thead ID"
.\"        Is that okay?
.IP *
The execing tracee changes its thread ID while it is in the
.BR execve (2).
(Remember, under ptrace, the "pid" returned from
.BR waitpid (2),
or fed into ptrace calls, is the tracee's thread ID.)
That is, the tracee's thread ID is reset to be the same as its process ID,
which is the same as the thread group leader's thread ID.
.IP *
If the thread group leader has reported its death by this time,
it appears to the tracer that
the dead thread leader "reappears from nowhere".
If the thread group leader was still alive,
for the tracer this may look as if thread group leader
returns from a different system call than it entered,
or even "returned from a system call even though
it was not in any system call".
If the thread group leader was not traced
(or was traced by a different tracer), then during
.BR execve (2)
it will appear as if it has become a tracee of
the tracer of the execing tracee.
.LP
All of the above effects are the artifacts of
the thread ID change in the tracee.
.LP
The
.B PTRACE_O_TRACEEXEC
option is the recommended tool for dealing with this situation.
It enables
.B PTRACE_EVENT_EXEC
stop, which occurs before
.BR execve (2)
returns.
.\" FIXME Following on from the previous sentences,
.\"       can/should we add a few more words on how
.\"       PTRACE_EVENT_EXEC stop helps us deal with this situation?
.LP
The thread ID change happens before
.B PTRACE_EVENT_EXEC
stop, not after.
.LP
When the tracer receives
.B PTRACE_EVENT_EXEC
stop notification,
it is guaranteed that except this tracee and the thread group leader,
no other threads from the process are alive.
.LP
On receiving the
.B PTRACE_EVENT_EXEC
stop notification,
the tracer should clean up all its internal
data structures describing the threads of this process,
and retain only one data structure\(emone which
describes the single still running tracee, with

    thread ID =3D=3D thread group ID =3D=3D process id.
.LP
Currently, there is no way to retrieve the former
thread ID of the execing tracee.
If the tracer doesn't keep track of its tracees' thread group relations,
it may be unable to know which tracee execed and therefore no longer
exists under the old thread ID due to a thread ID change.
.LP
Example: two threads call
.BR execve (2)
at the same time:
.LP
.nf
*** we get syscall-entry-stop in thread 1: **
PID1 execve("/bin/foo", "foo" <unfinished ...>
*** we issue PTRACE_SYSCALL for thread 1 **
*** we get syscall-entry-stop in thread 2: **
PID2 execve("/bin/bar", "bar" <unfinished ...>
*** we issue PTRACE_SYSCALL for thread 2 **
*** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
*** we get syscall-exit-stop for PID0: **
PID0 <... execve resumed> )             =3D 0
.fi
.LP
In this situation, there is no way to know which
.BR execve (2)
succeeded.
.LP
If the
.B PTRACE_O_TRACEEXEC
option is
.I not
in effect for the execing tracee, the kernel delivers an extra
.B SIGTRAP
to the tracee after
.BR execve (2)
returns.
This is an ordinary signal (similar to one which can be
generated by
.IR "kill -TRAP" ),
not a special kind of ptrace-stop.
Employing
.B PTRACE_GETSIGINFO
for this signal returns
.I si_code
set to 0
.RI ( SI_USER ).
This signal may be blocked by signal mask,
and thus may be delivered (much) later.
.LP
Usually, the tracer (for example,
.BR strace (1))
would not want to show this extra post-execve
.B SIGTRAP
signal to the user, and would suppress its delivery to the tracee (if
.B SIGTRAP
is set to
.BR SIG_DFL ,
it is a killing signal).
However, determining
.I which
.B SIGTRAP
to suppress is not easy.
Setting the
.B PTRACE_O_TRACEEXEC
option and thus suppressing this extra
.B SIGTRAP
is the recommended approach.
.SS Real parent
The ptrace API (ab)uses the standard UNIX parent/child signaling over
.BR waitpid (2).
This used to cause the real parent of the process to stop receiving
several kinds of
.BR waitpid (2)
notifications when the child process is traced by some other process.
.LP
Many of these bugs have been fixed, but as of Linux 2.6.38 several still
exist; see BUGS below.
.LP
As of Linux 2.6.38, the following is believed to work correctly:
.IP * 3
exit/death by signal is reported first to the tracer, then, when the tracer
consumes the
.BR waitpid (2)
result, to the real parent (to the real parent only when the
whole multithreaded process exits).
.\"
.\" FIXME mtk: Please check: In the next line,
.\" I changed "they" to "the tracer and the real parent". Okay?
If the tracer and the real parent are the same process,
the report is sent only once.
.SH "RETURN VALUE"
On success,
.B PTRACE_PEEK*
requests return the requested data,
while other requests return zero.
On error, all requests return \-1, and
.I errno
is set appropriately.
Since the value returned by a successful
.B PTRACE_PEEK*
request may be \-1, the caller must clear
.I errno
before the call, and then check it afterward
to determine whether or not an error occurred.
.SH ERRORS
.TP
.B EBUSY
(i386 only) There was an error with allocating or freeing a debug register.
.TP
.B EFAULT
There was an attempt to read from or write to an invalid area in
the tracer's or the tracee's memory,
probably because the area wasn't mapped or accessible.
Unfortunately, under Linux, different variations of this fault
will return
.B EIO
or
.B EFAULT
more or less arbitrarily.
.TP
.B EINVAL
An attempt was made to set an invalid option.
.TP
.B EIO
.I request
is invalid, or an attempt was made to read from or
write to an invalid area in the tracer's or the tracee's memory,
or there was a word-alignment violation,
or an invalid signal was specified during a restart request.
.TP
.B EPERM
The specified process cannot be traced.
This could be because the
tracer has insufficient privileges (the required capability is
.BR CAP_SYS_PTRACE );
unprivileged processes cannot trace processes that they
cannot send signals to or those running
set-user-ID/set-group-ID programs, for obvious reasons.
.\"
.\" FIXME I reworked the mention of init here to note
.\" when the behavior changed for tracing init(8). Okay?
Alternatively, the process may already be being traced,
or (on kernels before 2.6.26) be
.BR init (8)
(PID 1).
.TP
.B ESRCH
The specified process does not exist, or is not currently being traced
by the caller, or is not stopped
(for requests that require a stopped tracee).
.SH "CONFORMING TO"
SVr4, 4.3BSD.
.SH NOTES
Although arguments to
.BR ptrace ()
are interpreted according to the prototype given,
glibc currently declares
.BR ptrace ()
as a variadic function with only the
.I request
argument fixed.
This means that unneeded trailing arguments may be omitted,
though doing so makes use of undocumented
.BR gcc (1)
behavior.
.\" FIXME Please review. I reinstated the following, noting the
.\" kernel version number where it ceased to be true
.LP
In Linux kernels before 2.6.26,
.\" See commit 00cd5c37afd5f431ac186dd131705048c0a11fdb
.BR init (8),
the process with PID 1, may not be traced.
.LP
The layout of the contents of memory and the USER area are
quite operating-system- and architecture-specific.
The offset supplied, and the data returned,
might not entirely match with the definition of
.IR "struct user" .
.\" See http://lkml.org/lkml/2008/5/8/375
.LP
The size of a "word" is determined by the operating-system variant
(e.g., for 32-bit Linux it is 32 bits, etc.).
.\" FIXME So, can we just remove the following text?
.\"
.\" Covered in more details above: (removed by dv)
.\" .LP
.\" Tracing causes a few subtle differences in the semantics of
.\" traced processes.
.\" For example, if a process is attached to with
.\" .BR PTRACE_ATTACH ,
.\" its original parent can no longer receive notification via
.\" .BR waitpid (2)
.\" when it stops, and there is no way for the new parent to
.\" effectively simulate this notification.
.\" .LP
.\" When the parent receives an event with
.\" .B PTRACE_EVENT_*
.\" set,
.\" the tracee is not in the normal signal delivery path.
.\" This means the parent cannot do
.\" .BR ptrace (PTRACE_CONT)
.\" with a signal or
.\" .BR ptrace (PTRACE_KILL).
.\" .BR kill (2)
.\" with a
.\" .B SIGKILL
.\" signal can be used instead to kill the tracee
.\" after receiving one of these messages.
.\" .LP
This page documents the way the
.BR ptrace ()
call works currently in Linux.
Its behavior differs noticeably on other flavors of UNIX.
In any case, use of
.BR ptrace ()
is highly specific to the operating system and architecture.
.SH BUGS
On hosts with 2.6 kernel headers,
.B PTRACE_SETOPTIONS
is declared with a different value than the one for 2.4.
This leads to applications compiled with 2.6 kernel
headers failing when run on 2.4 kernels.
This can be worked around by redefining
.B PTRACE_SETOPTIONS
to
.BR PTRACE_OLDSETOPTIONS ,
if that is defined.
.LP
Group-stop notifications are sent to the tracer, but not to real parent.
Last confirmed on 2.6.38.6.
.LP
.\"
.\" FIXME Does "exits" in the following mean
.\" just "_exit(2)" or or both "_exit(2) and exit_group(2)"?
If a thread group leader is traced and exits by calling
.BR _exit (2),
a
.B PTRACE_EVENT_EXIT
stop will happen for it (if requested), but the subsequent
.B WIFEXITED
notification will not be delivered until all other threads exit.
As explained above, if one of other threads calls
.BR execve (2),
the death of the thread group leader will
.I never
be reported.
If the execed thread is not traced by this tracer,
the tracer will never know that
.BR execve (2)
happened.
One possible workaround is to
.B PTRACE_DETACH
the thread group leader instead of restarting it in this case.
Last confirmed on 2.6.38.6.
.\"        ^^^ need to test/verify this scenario
.\" FIXME: mtk: the preceding comment seems to be unresolved?
.\"        Do you want to add anything?
.LP
A
.B SIGKILL
signal may still cause a
.B PTRACE_EVENT_EXIT
stop before actual signal death.
This may be changed in the future;
.B SIGKILL
is meant to always immediately kill tasks even under ptrace.
Last confirmed on 2.6.38.6.
.SH "SEE ALSO"
.BR gdb (1),
.BR strace (1),
.BR clone (2),
.BR execve (2),
.BR fork (2),
.BR gettid (2),
.BR sigaction (2),
.BR tgkill (2),
.BR vfork (2),
.BR waitpid (2),
.BR exec (3),
.BR capabilities (7),
.BR signal (7)


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/

--0015176f03646b17c304ae193b52
Content-Type: application/octet-stream; name="ptrace.2"
Content-Disposition: attachment; filename="ptrace.2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt59rj1v1

LlwiIEhleSBFbWFjcyEgVGhpcyBmaWxlIGlzIC0qLSBucm9mZiAtKi0gc291cmNlLgouXCIKLlwi
IENvcHlyaWdodCAoYykgMTk5MyBNaWNoYWVsIEhhYXJkdCA8bWljaGFlbEBtb3JpYS5kZT4KLlwi
IEZyaSBBcHIgIDIgMTE6MzI6MDkgTUVUIERTVCAxOTkzCi5cIiBhbmQgQ29weXJpZ2h0IChjKSAy
MDExLCBEZW55cyBWbGFzZW5rbyA8dmRhLmxpbnV4QGdvb2dsZW1haWwuY29tPgouXCIKLlwiIGNo
YW5nZXMgQ29weXJpZ2h0IDE5OTkgTWlrZSBDb2xlbWFuIChta2NAYWNtLm9yZykKLlwiIC0tIG1h
am9yIHJldmlzaW9uIHRvIGZ1bGx5IGRvY3VtZW50IHB0cmFjZSBzZW1hbnRpY3MgcGVyIHJlY2Vu
dCBMaW51eAouXCIgICAga2VybmVsICgyLjIuMTApIGFuZCBnbGliYyAoMi4xLjIpCi5cIiBTdW4g
Tm92ICA3IDAzOjE4OjM1IENTVCAxOTk5Ci5cIgouXCIgVGhpcyBpcyBmcmVlIGRvY3VtZW50YXRp
b247IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgouXCIgbW9kaWZ5IGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMKLlwiIHB1Ymxpc2hl
ZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mCi5c
IiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KLlwi
Ci5cIiBUaGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UncyByZWZlcmVuY2VzIHRvICJvYmpl
Y3QgY29kZSIKLlwiIGFuZCAiZXhlY3V0YWJsZXMiIGFyZSB0byBiZSBpbnRlcnByZXRlZCBhcyB0
aGUgb3V0cHV0IG9mIGFueQouXCIgZG9jdW1lbnQgZm9ybWF0dGluZyBvciB0eXBlc2V0dGluZyBz
eXN0ZW0sIGluY2x1ZGluZwouXCIgaW50ZXJtZWRpYXRlIGFuZCBwcmludGVkIG91dHB1dC4KLlwi
Ci5cIiBUaGlzIG1hbnVhbCBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwg
YmUgdXNlZnVsLAouXCIgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhl
IGltcGxpZWQgd2FycmFudHkgb2YKLlwiIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBB
IFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKLlwiIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlIGZvciBtb3JlIGRldGFpbHMuCi5cIgouXCIgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEg
Y29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljCi5cIiBMaWNlbnNlIGFsb25nIHdpdGggdGhp
cyBtYW51YWw7IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUKLlwiIFNvZnR3YXJlIEZvdW5kYXRp
b24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLAou
XCIgVVNBLgouXCIKLlwiIE1vZGlmaWVkIEZyaSBKdWwgMjMgMjM6NDc6MTggMTk5MyBieSBSaWsg
RmFpdGggPGZhaXRoQGNzLnVuYy5lZHU+Ci5cIiBNb2RpZmllZCBGcmkgSmFuIDMxIDE2OjQ2OjMw
IDE5OTcgYnkgRXJpYyBTLiBSYXltb25kIDxlc3JAdGh5cnN1cy5jb20+Ci5cIiBNb2RpZmllZCBU
aHUgT2N0ICA3IDE3OjI4OjQ5IDE5OTkgYnkgQW5kcmllcyBCcm91d2VyIDxhZWJAY3dpLm5sPgou
XCIgTW9kaWZpZWQsIDI3IE1heSAyMDA0LCBNaWNoYWVsIEtlcnJpc2sgPG10ay5tYW5wYWdlc0Bn
bWFpbC5jb20+Ci5cIiAgICAgQWRkZWQgbm90ZXMgb24gY2FwYWJpbGl0eSByZXF1aXJlbWVudHMK
LlwiCi5cIiAyMDA2LTAzLTI0LCBDaHVjayBFYmJlcnQgPDc2MzA2LjEyMjZAY29tcHVzZXJ2ZS5j
b20+Ci5cIiAgICBBZGRlZCAgICBQVFJBQ0VfU0VUT1BUSU9OUywgUFRSQUNFX0dFVEVWRU5UTVNH
LCBQVFJBQ0VfR0VUU0lHSU5GTywKLlwiICAgICAgICBQVFJBQ0VfU0VUU0lHSU5GTywgUFRSQUNF
X1NZU0VNVSwgUFRSQUNFX1NZU0VNVV9TSU5HTEVTVEVQCi5cIiAgICAoVGhhbmtzIHRvIEJsYWlz
b3JibGFkZSwgRGFuaWVsIEphY29ib3dpdHogYW5kIG90aGVycyB3aG8gaGVscGVkLikKLlwiIDIw
MTEtMDksIG1ham9yIHVwZGF0ZSBieSBEZW55cyBWbGFzZW5rbyA8dmRhLmxpbnV4QGdvb2dsZW1h
aWwuY29tPgouXCIKLlwiIEZJWE1FIChsYXRlcik6IExpbnV4IDMuMSBhZGRzIFBUUkFDRV9TRUla
RSwgUFRSQUNFX0lOVEVSUlVQVCwgYW5kIFBUUkFDRV9MSVNURU4uCi5cIgouVEggUFRSQUNFIDIg
MjAxMS0wOS0yNiAiTGludXgiICJMaW51eCBQcm9ncmFtbWVyJ3MgTWFudWFsIgouU0ggTkFNRQpw
dHJhY2UgXC0gcHJvY2VzcyB0cmFjZQouU0ggU1lOT1BTSVMKLm5mCi5CICNpbmNsdWRlIDxzeXMv
cHRyYWNlLmg+Ci5zcAouQkkgImxvbmcgcHRyYWNlKGVudW0gX19wdHJhY2VfcmVxdWVzdCAiIHJl
cXVlc3QgIiwgcGlkX3QgIiBwaWQgIiwgIgouQkkgIiAgICAgICAgICAgIHZvaWQgKiIgYWRkciAi
LCB2b2lkICoiIGRhdGEgKTsKLmZpCi5TSCBERVNDUklQVElPTgpUaGUKLkJSIHB0cmFjZSAoKQpz
eXN0ZW0gY2FsbCBwcm92aWRlcyBhIG1lYW5zIGJ5IHdoaWNoIG9uZSBwcm9jZXNzICh0aGUgInRy
YWNlciIpCm1heSBvYnNlcnZlIGFuZCBjb250cm9sIHRoZSBleGVjdXRpb24gb2YgYW5vdGhlciBw
cm9jZXNzICh0aGUgInRyYWNlZSIpLAphbmQgZXhhbWluZSBhbmQgY2hhbmdlIHRoZSB0cmFjZWUn
cyBtZW1vcnkgYW5kIHJlZ2lzdGVycy4KSXQgaXMgcHJpbWFyaWx5IHVzZWQgdG8gaW1wbGVtZW50
IGJyZWFrcG9pbnQgZGVidWdnaW5nIGFuZCBzeXN0ZW0KY2FsbCB0cmFjaW5nLgouTFAKQSB0cmFj
ZWUgZmlyc3QgbmVlZCB0byBiZSBhdHRhY2hlZCB0byB0aGUgdHJhY2VyLgpBdHRhY2htZW50IGFu
ZCBzdWJzZXF1ZW50IGNvbW1hbmRzIGFyZSBwZXIgdGhyZWFkOgppbiBhIG11bHRpdGhyZWFkZWQg
cHJvY2VzcywKZXZlcnkgdGhyZWFkIGNhbiBiZSBpbmRpdmlkdWFsbHkgYXR0YWNoZWQgdG8gYQoo
cG90ZW50aWFsbHkgZGlmZmVyZW50KSB0cmFjZXIsCm9yIGxlZnQgbm90IGF0dGFjaGVkIGFuZCB0
aHVzIG5vdCBkZWJ1Z2dlZC4KVGhlcmVmb3JlLCAidHJhY2VlIiBhbHdheXMgbWVhbnMgIihvbmUp
IHRocmVhZCIsCm5ldmVyICJhIChwb3NzaWJseSBtdWx0aXRocmVhZGVkKSBwcm9jZXNzIi4KUHRy
YWNlIGNvbW1hbmRzIGFyZSBhbHdheXMgc2VudCB0bwphIHNwZWNpZmljIHRyYWNlZSB1c2luZyBh
IGNhbGwgb2YgdGhlIGZvcm0KCiAgICBwdHJhY2UoUFRSQUNFX2ZvbywgcGlkLCAuLi4pCgp3aGVy
ZQouSSBwaWQKaXMgdGhlIHRocmVhZCBJRCBvZiB0aGUgY29ycmVzcG9uZGluZyBMaW51eCB0aHJl
YWQuCi5MUApBIHByb2Nlc3MgY2FuIGluaXRpYXRlIGEgdHJhY2UgYnkgY2FsbGluZwouQlIgZm9y
ayAoMikKYW5kIGhhdmluZyB0aGUgcmVzdWx0aW5nIGNoaWxkIGRvIGEKLkJSIFBUUkFDRV9UUkFD
RU1FICwKZm9sbG93ZWQgKHR5cGljYWxseSkgYnkgYW4KLkJSIGV4ZWN2ZSAoMikuCkFsdGVybmF0
aXZlbHksIG9uZSBwcm9jZXNzIG1heSBjb21tZW5jZSB0cmFjaW5nIGFub3RoZXIgcHJvY2VzcyB1
c2luZwouQlIgUFRSQUNFX0FUVEFDSCAuCi5MUApXaGlsZSBiZWluZyB0cmFjZWQsIHRoZSB0cmFj
ZWUgd2lsbCBzdG9wIGVhY2ggdGltZSBhIHNpZ25hbCBpcyBkZWxpdmVyZWQsCmV2ZW4gaWYgdGhl
IHNpZ25hbCBpcyBiZWluZyBpZ25vcmVkLgooQW4gZXhjZXB0aW9uIGlzCi5CUiBTSUdLSUxMICwK
d2hpY2ggaGFzIGl0cyB1c3VhbCBlZmZlY3QuKQpUaGUgdHJhY2VyIHdpbGwgYmUgbm90aWZpZWQg
YXQgaXRzIG5leHQgY2FsbCB0bwouQlIgd2FpdHBpZCAoMikKKG9yIG9uZSBvZiB0aGUgcmVsYXRl
ZCAid2FpdCIgc3lzdGVtIGNhbGxzKQphbmQgbWF5IGluc3BlY3QgYW5kIG1vZGlmeSB0aGUgdHJh
Y2VlIHdoaWxlIGl0IGlzIHN0b3BwZWQuClRoZSB0cmFjZXIgdGhlbiBjYXVzZXMgdGhlIHRyYWNl
ZSB0byBjb250aW51ZSwKb3B0aW9uYWxseSBpZ25vcmluZyB0aGUgZGVsaXZlcmVkIHNpZ25hbAoo
b3IgZXZlbiBkZWxpdmVyaW5nIGEgZGlmZmVyZW50IHNpZ25hbCBpbnN0ZWFkKS4KLkxQCldoZW4g
dGhlIHRyYWNlciBpcyBmaW5pc2hlZCB0cmFjaW5nLCBpdCBjYW4gY2F1c2UgdGhlIHRyYWNlZSB0
byBjb250aW51ZQpleGVjdXRpbmcgaW4gYSBub3JtYWwsIHVudHJhY2VkIG1vZGUgdmlhCi5CUiBQ
VFJBQ0VfREVUQUNIIC4KLkxQClRoZSB2YWx1ZSBvZgouSSByZXF1ZXN0CmRldGVybWluZXMgdGhl
IGFjdGlvbiB0byBiZSBwZXJmb3JtZWQ6Ci5UUAouQiBQVFJBQ0VfVFJBQ0VNRQpJbmRpY2F0ZSB0
aGF0IHRoaXMgcHJvY2VzcyBpcyB0byBiZSB0cmFjZWQgYnkgaXRzIHBhcmVudC4KQW55IHNpZ25h
bCAoZXhjZXB0Ci5CUiBTSUdLSUxMICkKZGVsaXZlcmVkIHRvIHRoaXMgcHJvY2VzcyB3aWxsIGNh
dXNlIGl0IHRvIHN0b3AgYW5kIGl0cwpwYXJlbnQgdG8gYmUgbm90aWZpZWQgdmlhCi5CUiB3YWl0
cGlkICgyKS4KSW4gYWRkaXRpb24sIGFsbCBzdWJzZXF1ZW50IGNhbGxzIHRvCi5CUiBleGVjdmUg
KDIpCmJ5IHRoZSB0cmFjZWQgcHJvY2VzcyB3aWxsIGNhdXNlIGEKLkIgU0lHVFJBUAp0byBiZSBz
ZW50IHRvIGl0LApnaXZpbmcgdGhlIHBhcmVudCBhIGNoYW5jZSB0byBnYWluIGNvbnRyb2wgYmVm
b3JlIHRoZSBuZXcgcHJvZ3JhbQpiZWdpbnMgZXhlY3V0aW9uLgpBIHByb2Nlc3MgcHJvYmFibHkg
c2hvdWxkbid0IG1ha2UgdGhpcyByZXF1ZXN0IGlmIGl0cyBwYXJlbnQKaXNuJ3QgZXhwZWN0aW5n
IHRvIHRyYWNlIGl0LgouUkkgKCBwaWQgLAouSVIgYWRkciAsCmFuZAouSVIgZGF0YQphcmUgaWdu
b3JlZC4pCi5MUApUaGUKLkIgUFRSQUNFX1RSQUNFTUUKcmVxdWVzdCBpcyB1c2VkIG9ubHkgYnkg
dGhlIHRyYWNlZTsKdGhlIHJlbWFpbmluZyByZXF1ZXN0cyBhcmUgdXNlZCBvbmx5IGJ5IHRoZSB0
cmFjZXIuCkluIHRoZSBmb2xsb3dpbmcgcmVxdWVzdHMsCi5JIHBpZApzcGVjaWZpZXMgdGhlIHRo
cmVhZCBJRCBvZiB0aGUgdHJhY2VlIHRvIGJlIGFjdGVkIG9uLgpGb3IgcmVxdWVzdHMgb3RoZXIg
dGhhbgouQlIgUFRSQUNFX0tJTEwgLAp0aGUgdHJhY2VlIG11c3QgYmUgc3RvcHBlZC4KLlRQCi5C
UiBQVFJBQ0VfUEVFS1RFWFQgIiwgIiBQVFJBQ0VfUEVFS0RBVEEKUmVhZCBhIHdvcmQgYXQgdGhl
IGFkZHJlc3MKLkkgYWRkcgppbiB0aGUgdHJhY2VlJ3MgbWVtb3J5LCByZXR1cm5pbmcgdGhlIHdv
cmQgYXMgdGhlIHJlc3VsdCBvZiB0aGUKLkJSIHB0cmFjZSAoKQpjYWxsLgpMaW51eCBkb2VzIG5v
dCBoYXZlIHNlcGFyYXRlIHRleHQgYW5kIGRhdGEgYWRkcmVzcyBzcGFjZXMsCnNvIHRoZXNlIHR3
byByZXF1ZXN0cyBhcmUgY3VycmVudGx5IGVxdWl2YWxlbnQuCi5SSSAoIGRhdGEKaXMgaWdub3Jl
ZC4pCi5UUAouQiBQVFJBQ0VfUEVFS1VTRVIKLlwiIFBUUkFDRV9QRUVLVVNSIGluIGtlcm5lbCBz
b3VyY2UsIGJ1dCBnbGliYyB1c2VzIFBUUkFDRV9QRUVLVVNFUiwKLlwiIGFuZCB0aGF0IGlzIHRo
ZSBuYW1lIHRoYXQgc2VlbXMgY29tbW9uIG9uIG90aGVyIHN5c3RlbXMuClJlYWQgYSB3b3JkIGF0
IG9mZnNldAouSSBhZGRyCmluIHRoZSB0cmFjZWUncyBVU0VSIGFyZWEsCndoaWNoIGhvbGRzIHRo
ZSByZWdpc3RlcnMgYW5kIG90aGVyIGluZm9ybWF0aW9uIGFib3V0IHRoZSBwcm9jZXNzCihzZWUK
LklSIDxzeXMvdXNlci5oPiApLgpUaGUgd29yZCBpcyByZXR1cm5lZCBhcyB0aGUgcmVzdWx0IG9m
IHRoZQouQlIgcHRyYWNlICgpCmNhbGwuClR5cGljYWxseSwgdGhlIG9mZnNldCBtdXN0IGJlIHdv
cmQtYWxpZ25lZCwgdGhvdWdoIHRoaXMgbWlnaHQgdmFyeSBieQphcmNoaXRlY3R1cmUuClNlZSBO
T1RFUy4KLlJJICggZGF0YQppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfUE9LRVRFWFQgIiwg
IiBQVFJBQ0VfUE9LRURBVEEKQ29weSB0aGUgd29yZAouSSBkYXRhCnRvIHRoZSBhZGRyZXNzCi5J
IGFkZHIKaW4gdGhlIHRyYWNlZSdzIG1lbW9yeS4KQXMgZm9yCi5CUiBQVFJBQ0VfUEVFS1RFWFQg
CmFuZAouQlIgUFRSQUNFX1BFRUtEQVRBICwKdGhlc2UgdHdvIHJlcXVlc3RzIGFyZSBjdXJyZW50
bHkgZXF1aXZhbGVudC4KLlRQCi5CIFBUUkFDRV9QT0tFVVNFUgouXCIgUFRSQUNFX1BPS0VVU1Ig
aW4ga2VybmVsIHNvdXJjZSwgYnV0IGdsaWJjIHVzZXMgUFRSQUNFX1BPS0VVU0VSLAouXCIgYW5k
IHRoYXQgaXMgdGhlIG5hbWUgdGhhdCBzZWVtcyBjb21tb24gb24gb3RoZXIgc3lzdGVtcy4KQ29w
eSB0aGUgd29yZAouSSBkYXRhCnRvIG9mZnNldAouSSBhZGRyCmluIHRoZSB0cmFjZWUncyBVU0VS
IGFyZWEuCkFzIGZvcgouQlIgUFRSQUNFX1BFRUtVU0VSICwKdGhlIG9mZnNldCBtdXN0IHR5cGlj
YWxseSBiZSB3b3JkLWFsaWduZWQuCkluIG9yZGVyIHRvIG1haW50YWluIHRoZSBpbnRlZ3JpdHkg
b2YgdGhlIGtlcm5lbCwKc29tZSBtb2RpZmljYXRpb25zIHRvIHRoZSBVU0VSIGFyZWEgYXJlIGRp
c2FsbG93ZWQuCi5cIiBGSVhNRSBJbiB0aGUgcHJlY2VkaW5nIHNlbnRlbmNlLCB3aGljaCBtb2Rp
ZmljYXRpb25zIGFyZSBkaXNhbGxvd2VkLAouXCIgYW5kIHdoZW4gdGhleSBhcmUgZGlzYWxsb3dl
ZCwgaG93IGRvZXMgdXNlcnNwYWNlIGRpc2NvdmVyIHRoYXQgZmFjdD8KLlRQCi5CUiBQVFJBQ0Vf
R0VUUkVHUyAiLCAiIFBUUkFDRV9HRVRGUFJFR1MKQ29weSB0aGUgdHJhY2VlJ3MgZ2VuZXJhbCBw
dXJwb3NlIG9yIGZsb2F0aW5nLXBvaW50IHJlZ2lzdGVycywKcmVzcGVjdGl2ZWx5LCB0byB0aGUg
YWRkcmVzcwouSSBkYXRhCmluIHRoZSB0cmFjZXIuClNlZQouSSA8c3lzL3VzZXIuaD4KZm9yIGlu
Zm9ybWF0aW9uIG9uIHRoZSBmb3JtYXQgb2YgdGhpcyBkYXRhLgouUkkgKCBhZGRyCmlzIGlnbm9y
ZWQuKQouVFAKLkJSIFBUUkFDRV9HRVRTSUdJTkZPICIgKHNpbmNlIExpbnV4IDIuMy45OS1wcmU2
KSIKUmV0cmlldmUgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHNpZ25hbCB0aGF0IGNhdXNlZCB0aGUg
c3RvcC4KQ29weSBhCi5JIHNpZ2luZm9fdApzdHJ1Y3R1cmUgKHNlZQouQlIgc2lnYWN0aW9uICgy
KSkKZnJvbSB0aGUgdHJhY2VlIHRvIHRoZSBhZGRyZXNzCi5JIGRhdGEKaW4gdGhlIHRyYWNlci4K
LlJJICggYWRkcgppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfU0VUUkVHUyAiLCAiIFBUUkFD
RV9TRVRGUFJFR1MKQ29weSB0aGUgdHJhY2VlJ3MgZ2VuZXJhbCBwdXJwb3NlIG9yIGZsb2F0aW5n
LXBvaW50IHJlZ2lzdGVycywKcmVzcGVjdGl2ZWx5LCBmcm9tIHRoZSBhZGRyZXNzCi5JIGRhdGEK
aW4gdGhlIHRyYWNlci4KQXMgZm9yCi5CUiBQVFJBQ0VfUE9LRVVTRVIgLApzb21lIGdlbmVyYWwg
cHVycG9zZSByZWdpc3RlciBtb2RpZmljYXRpb25zIG1heSBiZSBkaXNhbGxvd2VkLgouXCIgRklY
TUUgSW4gdGhlIHByZWNlZGluZyBzZW50ZW5jZSwgd2hpY2ggbW9kaWZpY2F0aW9ucyBhcmUgZGlz
YWxsb3dlZCwKLlwiIGFuZCB3aGVuIHRoZXkgYXJlIGRpc2FsbG93ZWQsIGhvdyBkb2VzIHVzZXJz
cGFjZSBkaXNjb3ZlciB0aGF0IGZhY3Q/Ci5SSSAoIGFkZHIKaXMgaWdub3JlZC4pCi5UUAouQlIg
UFRSQUNFX1NFVFNJR0lORk8gIiAoc2luY2UgTGludXggMi4zLjk5LXByZTYpIgpTZXQgc2lnbmFs
IGluZm9ybWF0aW9uOgpjb3B5IGEKLkkgc2lnaW5mb190CnN0cnVjdHVyZSBmcm9tIHRoZSBhZGRy
ZXNzCi5JIGRhdGEKaW4gdGhlIHRyYWNlciB0byB0aGUgdHJhY2VlLgpUaGlzIHdpbGwgYWZmZWN0
IG9ubHkgc2lnbmFscyB0aGF0IHdvdWxkIG5vcm1hbGx5IGJlIGRlbGl2ZXJlZCB0bwp0aGUgdHJh
Y2VlIGFuZCB3ZXJlIGNhdWdodCBieSB0aGUgdHJhY2VyLgpJdCBtYXkgYmUgZGlmZmljdWx0IHRv
IHRlbGwKdGhlc2Ugbm9ybWFsIHNpZ25hbHMgZnJvbSBzeW50aGV0aWMgc2lnbmFscyBnZW5lcmF0
ZWQgYnkKLkJSIHB0cmFjZSAoKQppdHNlbGYuCi5SSSAoIGFkZHIKaXMgaWdub3JlZC4pCi5UUAou
QlIgUFRSQUNFX1NFVE9QVElPTlMgIiAoc2luY2UgTGludXggMi40LjY7IHNlZSBCVUdTIGZvciBj
YXZlYXRzKSIKU2V0IHB0cmFjZSBvcHRpb25zIGZyb20KLklSIGRhdGEgLgouUkkgKCBhZGRyCmlz
IGlnbm9yZWQuKQouSVIgZGF0YQppcyBpbnRlcnByZXRlZCBhcyBhIGJpdCBtYXNrIG9mIG9wdGlv
bnMsCndoaWNoIGFyZSBzcGVjaWZpZWQgYnkgdGhlIGZvbGxvd2luZyBmbGFnczoKLlJTCi5UUAou
QlIgUFRSQUNFX09fVFJBQ0VTWVNHT09EICIgKHNpbmNlIExpbnV4IDIuNC42KSIKV2hlbiBkZWxp
dmVyaW5nIHN5c3RlbSBjYWxsIHRyYXBzLCBzZXQgYml0IDcgaW4gdGhlIHNpZ25hbCBudW1iZXIK
KGkuZS4sIGRlbGl2ZXIKLklSICJTSUdUUkFQfDB4ODAiICkuClRoaXMgbWFrZXMgaXQgZWFzeSBm
b3IgdGhlIHRyYWNlciB0byBkaXN0aW5ndWlzaApub3JtYWwgdHJhcHMgZnJvbSB0aG9zZSBjYXVz
ZWQgYnkgYSBzeXN0ZW0gY2FsbC4KLlJCICggUFRSQUNFX09fVFJBQ0VTWVNHT09ECm1heSBub3Qg
d29yayBvbiBhbGwgYXJjaGl0ZWN0dXJlcy4pCi5cIiBGSVhNRSBQbGVhc2UgY2hlY2suIEluIHRo
ZSBmb2xsb3dpbmcgcGFyYWdyYXBocywgSSBzdWJzdGl0dXRlZCBsYW5ndWFnZQouXCIgc3VjaCBh
czoKLlwiICAgICBTdG9wIHRyYWNlZSBhdCBuZXh0IGZvcmsoMikgY2FsbCB3aXRoIFNJR1RSQVB8
UFRSQUNFX0VWRU5UX0ZPUks8PDgKLlwiIHdpdGg6Ci5cIiAgICAgU3RvcCB0cmFjZWUgYXQgbmV4
dCBmb3JrKDIpIGNhbGwuLi4gQSBzdWJzZXF1ZW50IFBUUkFDRV9HRVRTSUdJTkZPCi5cIiAgICAg
b24gdGhlIHN0b3BwZWQgdHJhY2VlIHdpbGwgcmV0dXJuIGEgc2lnaW5mb190IHN0cnVjdHVyZSB3
aXRoIHNpX2NvZGUKLlwiICAgICBzZXQgdG8gU0lHVFJBUHxQVFJBQ0VfRVZFTlRfRk9SSzw8OC4K
LlwiCi5cIiBJcyB0aGlzIGNoYW5nZSBjb3JyZWN0PwouXCIKLlRQCi5CUiBQVFJBQ0VfT19UUkFD
RUZPUksgIiAoc2luY2UgTGludXggMi41LjQ2KSIKU3RvcCB0aGUgdHJhY2VlIGF0IHRoZSBuZXh0
Ci5CUiBmb3JrICgyKQphbmQgYXV0b21hdGljYWxseSBzdGFydCB0cmFjaW5nIHRoZSBuZXdseSBm
b3JrZWQgcHJvY2VzcywKd2hpY2ggd2lsbCBzdGFydCB3aXRoIGEKLkJSIFNJR1NUT1AgLgpBIHN1
YnNlcXVlbnQKLkIgUFRSQUNFX0dFVFNJR0lORk8Kb24gdGhlIHN0b3BwZWQgdHJhY2VlIHdpbGwg
cmV0dXJuIGEKLkkgc2lnaW5mb190CnN0cnVjdHVyZSB3aXRoCi5JIHNpX2NvZGUKc2V0IHRvCi5J
UiBTSUdUUkFQfFBUUkFDRV9FVkVOVF9GT1JLPDw4IC4KVGhlIFBJRCBvZiB0aGUgbmV3IHByb2Nl
c3MgY2FuIGJlIHJldHJpZXZlZCB3aXRoCi5CUiBQVFJBQ0VfR0VURVZFTlRNU0cgLgouVFAKLkJS
IFBUUkFDRV9PX1RSQUNFVkZPUksgIiAoc2luY2UgTGludXggMi41LjQ2KSIKU3RvcCB0aGUgdHJh
Y2VlIGF0IHRoZSBuZXh0Ci5CUiB2Zm9yayAoMikKYW5kIGF1dG9tYXRpY2FsbHkgc3RhcnQgdHJh
Y2luZyB0aGUgbmV3bHkgdmZvcmtlZCBwcm9jZXNzLAp3aGljaCB3aWxsIHN0YXJ0IHdpdGggYQou
QlIgU0lHU1RPUCAuCkEgc3Vic2VxdWVudAouQiBQVFJBQ0VfR0VUU0lHSU5GTwpvbiB0aGUgc3Rv
cHBlZCB0cmFjZWUgd2lsbCByZXR1cm4gYQouSSBzaWdpbmZvX3QKc3RydWN0dXJlIHdpdGgKLkkg
c2lfY29kZQpzZXQgdG8KLklSIFNJR1RSQVB8UFRSQUNFX0VWRU5UX1ZGT1JLPDw4IC4KVGhlIFBJ
RCBvZiB0aGUgbmV3IHByb2Nlc3MgY2FuIGJlIHJldHJpZXZlZCB3aXRoCi5CUiBQVFJBQ0VfR0VU
RVZFTlRNU0cgLgouVFAKLkJSIFBUUkFDRV9PX1RSQUNFQ0xPTkUgIiAoc2luY2UgTGludXggMi41
LjQ2KSIKU3RvcCB0aGUgdHJhY2VlIGF0IHRoZSBuZXh0Ci5CUiBjbG9uZSAoMikKYW5kIGF1dG9t
YXRpY2FsbHkgc3RhcnQgdHJhY2luZyB0aGUgbmV3bHkgY2xvbmVkIHByb2Nlc3MsCndoaWNoIHdp
bGwgc3RhcnQgd2l0aCBhCi5CUiBTSUdTVE9QIC4KQSBzdWJzZXF1ZW50Ci5CIFBUUkFDRV9HRVRT
SUdJTkZPCm9uIHRoZSBzdG9wcGVkIHRyYWNlZSB3aWxsIHJldHVybiBhCi5JIHNpZ2luZm9fdApz
dHJ1Y3R1cmUgd2l0aAouSSBzaV9jb2RlCnNldCB0bwouSVIgU0lHVFJBUHxQVFJBQ0VfRVZFTlRf
Q0xPTkU8PDggLgpUaGUgUElEIG9mIHRoZSBuZXcgcHJvY2VzcyBjYW4gYmUgcmV0cmlldmVkIHdp
dGgKLkJSIFBUUkFDRV9HRVRFVkVOVE1TRyAuCi5JUApUaGlzIG9wdGlvbiBtYXkgbm90IGNhdGNo
Ci5CUiBjbG9uZSAoMikKY2FsbHMgaW4gYWxsIGNhc2VzLgpJZiB0aGUgdHJhY2VlIGNhbGxzCi5C
UiBjbG9uZSAoMikKd2l0aCB0aGUKLkIgQ0xPTkVfVkZPUksKZmxhZywKLkIgUFRSQUNFX0VWRU5U
X1ZGT1JLCndpbGwgYmUgZGVsaXZlcmVkIGluc3RlYWQKaWYKLkIgUFRSQUNFX09fVFJBQ0VWRk9S
SwppcyBzZXQ7IG90aGVyd2lzZSBpZiB0aGUgdHJhY2VlIGNhbGxzCi5CUiBjbG9uZSAoMikKd2l0
aCB0aGUgZXhpdCBzaWduYWwgc2V0IHRvCi5CUiBTSUdDSExEICwKLkIgUFRSQUNFX0VWRU5UX0ZP
UksKd2lsbCBiZSBkZWxpdmVyZWQgaWYKLkIgUFRSQUNFX09fVFJBQ0VGT1JLCmlzIHNldC4KLlRQ
Ci5CUiBQVFJBQ0VfT19UUkFDRUVYRUMgIiAoc2luY2UgTGludXggMi41LjQ2KSIKU3RvcCB0aGUg
dHJhY2VlIGF0IHRoZSBuZXh0Ci5CUiBleGVjdmUgKDIpLgpBIHN1YnNlcXVlbnQKLkIgUFRSQUNF
X0dFVFNJR0lORk8Kb24gdGhlIHN0b3BwZWQgdHJhY2VlIHdpbGwgcmV0dXJuIGEKLkkgc2lnaW5m
b190CnN0cnVjdHVyZSB3aXRoCi5JIHNpX2NvZGUKc2V0IHRvCi5JUiBTSUdUUkFQfFBUUkFDRV9F
VkVOVF9FWEVDPDw4IC4KLlRQCi5CUiBQVFJBQ0VfT19UUkFDRVZGT1JLRE9ORSAiIChzaW5jZSBM
aW51eCAyLjUuNjApIgpTdG9wIHRoZSB0cmFjZWUgYXQgdGhlIGNvbXBsZXRpb24gb2YgdGhlIG5l
eHQKLkJSIHZmb3JrICgyKS4KQSBzdWJzZXF1ZW50Ci5CIFBUUkFDRV9HRVRTSUdJTkZPCm9uIHRo
ZSBzdG9wcGVkIHRyYWNlZSB3aWxsIHJldHVybiBhCi5JIHNpZ2luZm9fdApzdHJ1Y3R1cmUgd2l0
aAouSSBzaV9jb2RlCnNldCB0bwouSVIgU0lHVFJBUHxQVFJBQ0VfRVZFTlRfVkZPUktfRE9ORTw8
OCAuClRoZSBQSUQgb2YgdGhlIG5ldyBwcm9jZXNzIGNhbiAoc2luY2UgTGludXggMi42LjE4KSBi
ZSByZXRyaWV2ZWQgd2l0aAouQlIgUFRSQUNFX0dFVEVWRU5UTVNHIC4KLlRQCi5CUiBQVFJBQ0Vf
T19UUkFDRUVYSVQgIiAoc2luY2UgTGludXggMi41LjYwKSIKU3RvcCB0aGUgdHJhY2VlIGF0IGV4
aXQuCkEgc3Vic2VxdWVudAouQiBQVFJBQ0VfR0VUU0lHSU5GTwpvbiB0aGUgc3RvcHBlZCB0cmFj
ZWUgd2lsbCByZXR1cm4gYQouSSBzaWdpbmZvX3QKc3RydWN0dXJlIHdpdGgKLkkgc2lfY29kZQpz
ZXQgdG8KLklSIFNJR1RSQVB8UFRSQUNFX0VWRU5UX0VYSVQ8PDggLgpUaGUgdHJhY2VlJ3MgZXhp
dCBzdGF0dXMgY2FuIGJlIHJldHJpZXZlZCB3aXRoCi5CUiBQVFJBQ0VfR0VURVZFTlRNU0cgLgou
SVAKVGhlIHRyYWNlZSBpcyBzdG9wcGVkIGVhcmx5IGR1cmluZyBwcm9jZXNzIGV4aXQsCndoZW4g
cmVnaXN0ZXJzIGFyZSBzdGlsbCBhdmFpbGFibGUsCmFsbG93aW5nIHRoZSB0cmFjZXIgdG8gc2Vl
IHdoZXJlIHRoZSBleGl0IG9jY3VycmVkLAp3aGVyZWFzIHRoZSBub3JtYWwgZXhpdCBub3RpZmlj
YXRpb24gaXMgZG9uZSBhZnRlciB0aGUgcHJvY2VzcwppcyBmaW5pc2hlZCBleGl0aW5nLgpFdmVu
IHRob3VnaCBjb250ZXh0IGlzIGF2YWlsYWJsZSwKdGhlIHRyYWNlciBjYW5ub3QgcHJldmVudCB0
aGUgZXhpdCBmcm9tIGhhcHBlbmluZyBhdCB0aGlzIHBvaW50LgouUkUKLlRQCi5CUiBQVFJBQ0Vf
R0VURVZFTlRNU0cgIiAoc2luY2UgTGludXggMi41LjQ2KSIKUmV0cmlldmUgYSBtZXNzYWdlIChh
cyBhbgouSVIgInVuc2lnbmVkIGxvbmciICkKYWJvdXQgdGhlIHB0cmFjZSBldmVudAp0aGF0IGp1
c3QgaGFwcGVuZWQsIHBsYWNpbmcgaXQgYXQgdGhlIGFkZHJlc3MKLkkgZGF0YQppbiB0aGUgdHJh
Y2VyLgpGb3IKLkJSIFBUUkFDRV9FVkVOVF9FWElUICwKdGhpcyBpcyB0aGUgdHJhY2VlJ3MgZXhp
dCBzdGF0dXMuCkZvcgouQlIgUFRSQUNFX0VWRU5UX0ZPUksgLAouQlIgUFRSQUNFX0VWRU5UX1ZG
T1JLICwKLkJSIFBUUkFDRV9FVkVOVF9WRk9SS19ET05FICwKYW5kCi5CUiBQVFJBQ0VfRVZFTlRf
Q0xPTkUgLAp0aGlzIGlzIHRoZSBQSUQgb2YgdGhlIG5ldyBwcm9jZXNzLgouUkkgKCAgYWRkcgpp
cyBpZ25vcmVkLikKLlRQCi5CIFBUUkFDRV9DT05UClJlc3RhcnQgdGhlIHN0b3BwZWQgdHJhY2Vl
IHByb2Nlc3MuCklmCi5JIGRhdGEKaXMgbm9uemVybywKaXQgaXMgaW50ZXJwcmV0ZWQgYXMgdGhl
IG51bWJlciBvZiBhIHNpZ25hbCB0byBiZSBkZWxpdmVyZWQgdG8gdGhlIHRyYWNlZTsKb3RoZXJ3
aXNlLCBubyBzaWduYWwgaXMgZGVsaXZlcmVkLgpUaHVzLCBmb3IgZXhhbXBsZSwgdGhlIHRyYWNl
ciBjYW4gY29udHJvbAp3aGV0aGVyIGEgc2lnbmFsIHNlbnQgdG8gdGhlIHRyYWNlZSBpcyBkZWxp
dmVyZWQgb3Igbm90LgouUkkgKCBhZGRyCmlzIGlnbm9yZWQuKQouVFAKLkJSIFBUUkFDRV9TWVND
QUxMICIsICIgUFRSQUNFX1NJTkdMRVNURVAKUmVzdGFydCB0aGUgc3RvcHBlZCB0cmFjZWUgYXMg
Zm9yCi5CUiBQVFJBQ0VfQ09OVCAsCmJ1dCBhcnJhbmdlIGZvciB0aGUgdHJhY2VlIHRvIGJlIHN0
b3BwZWQgYXQKdGhlIG5leHQgZW50cnkgdG8gb3IgZXhpdCBmcm9tIGEgc3lzdGVtIGNhbGwsCm9y
IGFmdGVyIGV4ZWN1dGlvbiBvZiBhIHNpbmdsZSBpbnN0cnVjdGlvbiwgcmVzcGVjdGl2ZWx5Lgoo
VGhlIHRyYWNlZSB3aWxsIGFsc28sIGFzIHVzdWFsLCBiZSBzdG9wcGVkIHVwb24gcmVjZWlwdCBv
ZiBhIHNpZ25hbC4pCkZyb20gdGhlIHRyYWNlcidzIHBlcnNwZWN0aXZlLCB0aGUgdHJhY2VlIHdp
bGwgYXBwZWFyIHRvIGhhdmUgYmVlbgpzdG9wcGVkIGJ5IHJlY2VpcHQgb2YgYQouQlIgU0lHVFJB
UCAuClNvLCBmb3IKLkJSIFBUUkFDRV9TWVNDQUxMICwKZm9yIGV4YW1wbGUsIHRoZSBpZGVhIGlz
IHRvIGluc3BlY3QKdGhlIGFyZ3VtZW50cyB0byB0aGUgc3lzdGVtIGNhbGwgYXQgdGhlIGZpcnN0
IHN0b3AsCnRoZW4gZG8gYW5vdGhlcgouQiBQVFJBQ0VfU1lTQ0FMTAphbmQgaW5zcGVjdCB0aGUg
cmV0dXJuIHZhbHVlIG9mIHRoZSBzeXN0ZW0gY2FsbCBhdCB0aGUgc2Vjb25kIHN0b3AuClRoZQou
SSBkYXRhCmFyZ3VtZW50IGlzIHRyZWF0ZWQgYXMgZm9yCi5CUiBQVFJBQ0VfQ09OVCAuCi5SSSAo
YWRkcgppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfU1lTRU1VICIsICIgUFRSQUNFX1NZU0VN
VV9TSU5HTEVTVEVQICIgKHNpbmNlIExpbnV4IDIuNi4xNCkiCkZvcgouQlIgUFRSQUNFX1NZU0VN
VSAsCmNvbnRpbnVlIGFuZCBzdG9wIG9uIGVudHJ5IHRvIHRoZSBuZXh0IHN5c3RlbSBjYWxsLAp3
aGljaCB3aWxsIG5vdCBiZSBleGVjdXRlZC4KRm9yCi5CUiBQVFJBQ0VfU1lTRU1VX1NJTkdMRVNU
RVAgLApkbyB0aGUgc2FtZSBidXQgYWxzbyBzaW5nbGVzdGVwIGlmIG5vdCBhIHN5c3RlbSBjYWxs
LgpUaGlzIGNhbGwgaXMgdXNlZCBieSBwcm9ncmFtcyBsaWtlClVzZXIgTW9kZSBMaW51eCB0aGF0
IHdhbnQgdG8gZW11bGF0ZSBhbGwgdGhlIHRyYWNlZSdzIHN5c3RlbSBjYWxscy4KVGhlCi5JIGRh
dGEKYXJndW1lbnQgaXMgdHJlYXRlZCBhcyBmb3IKLkJSIFBUUkFDRV9DT05UIC4KLlJJICggYWRk
cgppcyBpZ25vcmVkOwpub3Qgc3VwcG9ydGVkIG9uIGFsbCBhcmNoaXRlY3R1cmVzLikKLlRQCi5C
IFBUUkFDRV9LSUxMClNlbmQgdGhlIHRyYWNlZSBhCi5CIFNJR0tJTEwKdG8gdGVybWluYXRlIGl0
LgouUkkgKCBhZGRyCmFuZAouSSBkYXRhCmFyZSBpZ25vcmVkLikKLklQCi5JIFRoaXMgb3BlcmF0
aW9uIGlzIGRlcHJlY2F0ZWQ7IGRvIG5vdCB1c2UgaXQhCkluc3RlYWQsIHNlbmQgYQouQlIgU0lH
S0lMTApkaXJlY3RseSB1c2luZwouQlIga2lsbCAoMikKb3IKLkJSIHRna2lsbCAoMikuClRoZSBw
cm9ibGVtIHdpdGgKLkIgUFRSQUNFX0tJTEwKaXMgdGhhdCBpdCByZXF1aXJlcyB0aGUgdHJhY2Vl
IHRvIGJlIGluIHNpZ25hbC1kZWxpdmVyeS1zdG9wLApvdGhlcndpc2UgaXQgbWF5IG5vdCB3b3Jr
CihpLmUuLCBtYXkgY29tcGxldGUgc3VjY2Vzc2Z1bGx5IGJ1dCB3b24ndCBraWxsIHRoZSB0cmFj
ZWUpLgpCeSBjb250cmFzdCwgc2VuZGluZyBhCi5CIFNJR0tJTEwKZGlyZWN0bHkgaGFzIG5vIHN1
Y2ggbGltaXRhdGlvbi4KLlwiIG10azogQ29tbWVudGVkIG91dCB0aGUgZm9sbG93aW5nLiBJdCBk
b2Vzbid0IGJlbG9uZyBpbiB0aGUgbWFuIHBhZ2UuCi5cIiAuTFAKLlwiIFtOb3RlOiBkZXByZWNh
dGlvbiBzdWdnZXN0ZWQgYnkgT2xlZyBOZXN0ZXJvdi4gSGUgcHJlZmVycyB0byBkZXByZWNhdGUK
LlwiIGl0IGluc3RlYWQgb2YgZGVzY3JpYmluZyAoYW5kIG5lZWRpbmcgdG8gc3VwcG9ydCkgUFRS
QUNFX0tJTEwncyBxdWlya3MuXQouVFAKLkIgUFRSQUNFX0FUVEFDSApBdHRhY2ggdG8gdGhlIHBy
b2Nlc3Mgc3BlY2lmaWVkIGluCi5JUiBwaWQgLAptYWtpbmcgaXQgYSB0cmFjZWUgb2YgdGhlIGNh
bGxpbmcgcHJvY2Vzcy4KLlwiIEZJWE1FIFNvLCB3YXMgdGhlIGZvbGxvd2luZyBFVkVSIHRydWU/
IElGIGl0IHdhcywKLlwiICAgICAgIHdlIHNob3VsZCByZWluc3RhdGUgdGhlIHRleHQgYW5kIGFk
ZCBtZW50aW9uIG9mCi5cIiAgICAgICB0aGUga2VybmVsIHZlcnNpb24gd2hlcmUgdGhlIGJlaGF2
aW91ciBjaGFuZ2VkLgouXCIKLlwiIE5vdCB0cnVlOiAocmVtb3ZlZCBieSBkdikKLlwiIDsgdGhl
IGJlaGF2aW9yIG9mIHRoZSB0cmFjZWUgaXMgYXMgaWYgaXQgaGFkIGRvbmUgYQouXCIgLkJSIFBU
UkFDRV9UUkFDRU1FIC4KLlwiIFRoZSBjYWxsaW5nIHByb2Nlc3MgYWN0dWFsbHkgYmVjb21lcyB0
aGUgcGFyZW50IG9mIHRoZSB0cmFjZWUKLlwiIHByb2Nlc3MgZm9yIG1vc3QgcHVycG9zZXMgKGUu
Zy4sIGl0IHdpbGwgcmVjZWl2ZQouXCIgbm90aWZpY2F0aW9uIG9mIHRyYWNlZSBldmVudHMgYW5k
IGFwcGVhcnMgaW4KLlwiIC5CUiBwcyAoMSkKLlwiIG91dHB1dCBhcyB0aGUgdHJhY2VlJ3MgcGFy
ZW50KSwgYnV0IGEKLlwiIC5CUiBnZXRwcGlkICgyKQouXCIgYnkgdGhlIHRyYWNlZSB3aWxsIHN0
aWxsIHJldHVybiB0aGUgUElEIG9mIHRoZSBvcmlnaW5hbCBwYXJlbnQuClRoZSB0cmFjZWUgaXMg
c2VudCBhCi5CUiBTSUdTVE9QICwKYnV0IHdpbGwgbm90IG5lY2Vzc2FyaWx5IGhhdmUgc3RvcHBl
ZApieSB0aGUgY29tcGxldGlvbiBvZiB0aGlzIGNhbGw7IHVzZQouQlIgd2FpdHBpZCAoMikKdG8g
d2FpdCBmb3IgdGhlIHRyYWNlZSB0byBzdG9wLgpTZWUgdGhlICJBdHRhY2hpbmcgYW5kIGRldGFj
aGluZyIgc3Vic2VjdGlvbiBmb3IgYWRkaXRpb25hbCBpbmZvcm1hdGlvbi4KLlJJICggYWRkcgph
bmQKLkkgZGF0YQphcmUgaWdub3JlZC4pCi5UUAouQiBQVFJBQ0VfREVUQUNIClJlc3RhcnQgdGhl
IHN0b3BwZWQgdHJhY2VlIGFzIGZvcgouQlIgUFRSQUNFX0NPTlQgLApidXQgZmlyc3QgZGV0YWNo
IGZyb20gaXQuClVuZGVyIExpbnV4LCBhIHRyYWNlZSBjYW4gYmUgZGV0YWNoZWQgaW4gdGhpcyB3
YXkgcmVnYXJkbGVzcwpvZiB3aGljaCBtZXRob2Qgd2FzIHVzZWQgdG8gaW5pdGlhdGUgdHJhY2lu
Zy4KLlJJICggYWRkcgppcyBpZ25vcmVkLikKLlwiCi5cIiBJbiB0aGUgdGV4dCBiZWxvdywgd2Ug
ZGVjaWRlZCB0byBhdm9pZCBwcmV0dGlmeWluZyB0aGUgdGV4dCB3aXRoIG1hcmt1cDoKLlwiIGl0
IHdvdWxkIG1ha2UgdGhlIHNvdXJjZSBuZWFybHkgaW1wb3NzaWJsZSB0byBlZGl0LCBhbmQgd2Ug
X2RvXyBpbnRlbmQKLlwiIHRvIGVkaXQgaXQgb2Z0ZW4sIGluIG9yZGVyIHRvIGtlZXAgaXQgdXBk
YXRlZDoKLlwiIHB0cmFjZSBBUEkgaXMgZnVsbCBvZiBxdWlya3MsIG5vIG5lZWQgdG8gY29tcG91
bmQgdGhpcyBzaXR1YXRpb24gYnkKLlwiIG1ha2luZyBpdCBleGNydWNpYXRpbmdseSBwYWluZnVs
IHRvIGRvY3VtZW50IHRoZW0hCi5cIgouU1MgRGVhdGggdW5kZXIgcHRyYWNlCldoZW4gYSAocG9z
c2libHkgbXVsdGl0aHJlYWRlZCkgcHJvY2VzcyByZWNlaXZlcyBhIGtpbGxpbmcgc2lnbmFsCihv
bmUgd2hvc2UgZGlzcG9zaXRpb24gaXMgc2V0IHRvCi5CIFNJR19ERkwKYW5kIHdob3NlIGRlZmF1
bHQgYWN0aW9uIGlzIHRvIGtpbGwgdGhlIHByb2Nlc3MpLAphbGwgdGhyZWFkcyBleGl0LgpUcmFj
ZWVzIHJlcG9ydCB0aGVpciBkZWF0aCB0byB0aGVpciB0cmFjZXIocykuCk5vdGlmaWNhdGlvbiBv
ZiB0aGlzIGV2ZW50IGlzIGRlbGl2ZXJlZCB2aWEKLkJSIHdhaXRwaWQgKDIpLgouTFAKTm90ZSB0
aGF0IHRoZSBraWxsaW5nIHNpZ25hbCB3aWxsIGZpcnN0IGNhdXNlIHNpZ25hbC1kZWxpdmVyeS1z
dG9wCihvbiBvbmUgdHJhY2VlIG9ubHkpLAphbmQgb25seSBhZnRlciBpdCBpcyBpbmplY3RlZCBi
eSB0aGUgdHJhY2VyCihvciBhZnRlciBpdCB3YXMgZGlzcGF0Y2hlZCB0byBhIHRocmVhZCB3aGlj
aCBpc24ndCB0cmFjZWQpLAp3aWxsIGRlYXRoIGZyb20gdGhlIHNpZ25hbCBoYXBwZW4gb24KLkkg
YWxsCnRyYWNlZXMgd2l0aGluIGEgbXVsdGl0aHJlYWRlZCBwcm9jZXNzLgooVGhlIHRlcm0gInNp
Z25hbC1kZWxpdmVyeS1zdG9wIiBpcyBleHBsYWluZWQgYmVsb3cuKQouTFAKLkIgU0lHS0lMTApv
cGVyYXRlcyBzaW1pbGFybHksIHdpdGggZXhjZXB0aW9ucy4KTm8gc2lnbmFsLWRlbGl2ZXJ5LXN0
b3AgaXMgZ2VuZXJhdGVkIGZvcgouQiBTSUdLSUxMCmFuZCB0aGVyZWZvcmUgdGhlIHRyYWNlciBj
YW4ndCBzdXBwcmVzcyBpdC4KLkIgU0lHS0lMTApraWxscyBldmVuIHdpdGhpbiBzeXN0ZW0gY2Fs
bHMKKHN5c2NhbGwtZXhpdC1zdG9wIGlzIG5vdCBnZW5lcmF0ZWQgcHJpb3IgdG8gZGVhdGggYnkK
LkJSIFNJR0tJTEwgKS4KVGhlIG5ldCBlZmZlY3QgaXMgdGhhdAouQiBTSUdLSUxMCmFsd2F5cyBr
aWxscyB0aGUgcHJvY2VzcyAoYWxsIGl0cyB0aHJlYWRzKSwKZXZlbiBpZiBzb21lIHRocmVhZHMg
b2YgdGhlIHByb2Nlc3MgYXJlIHB0cmFjZWQuCi5MUApXaGVuIHRoZSB0cmFjZWUgY2FsbHMKLkJS
IF9leGl0ICgyKSwKaXQgcmVwb3J0cyBpdHMgZGVhdGggdG8gaXRzIHRyYWNlci4KT3RoZXIgdGhy
ZWFkcyBhcmUgbm90IGFmZmVjdGVkLgouTFAKV2hlbiBhbnkgdGhyZWFkIGV4ZWN1dGVzCi5CUiBl
eGl0X2dyb3VwICgyKSwKZXZlcnkgdHJhY2VlIGluIGl0cyB0aHJlYWQgZ3JvdXAgcmVwb3J0cyBp
dHMgZGVhdGggdG8gaXRzIHRyYWNlci4KLkxQCklmIHRoZQouQiBQVFJBQ0VfT19UUkFDRUVYSVQK
b3B0aW9uIGlzIG9uLAouQiBQVFJBQ0VfRVZFTlRfRVhJVAp3aWxsIGhhcHBlbiBiZWZvcmUgYWN0
dWFsIGRlYXRoLgpUaGlzIGFwcGxpZXMgdG8gZXhpdHMgdmlhCi5CUiBleGl0ICgyKSwKLkJSIGV4
aXRfZ3JvdXAgKDIpLAphbmQgc2lnbmFsIGRlYXRocyAoZXhjZXB0Ci5CUiBTSUdLSUxMICksCmFu
ZCB3aGVuIHRocmVhZHMgYXJlIHRvcm4gZG93biBvbgouQlIgZXhlY3ZlICgyKQppbiBhIG11bHRp
dGhyZWFkZWQgcHJvY2Vzcy4KLkxQClRoZSB0cmFjZXIgY2Fubm90IGFzc3VtZSB0aGF0IHRoZSBw
dHJhY2Utc3RvcHBlZCB0cmFjZWUgZXhpc3RzLgpUaGVyZSBhcmUgbWFueSBzY2VuYXJpb3Mgd2hl
biB0aGUgdHJhY2VlIG1heSBkaWUgd2hpbGUgc3RvcHBlZCAoc3VjaCBhcwouQlIgU0lHS0lMTCAp
LgpUaGVyZWZvcmUsIHRoZSB0cmFjZXIgbXVzdCBiZSBwcmVwYXJlZCB0byBoYW5kbGUgYW4gCi5C
IEVTUkNICmVycm9yIG9uIGFueSBwdHJhY2Ugb3BlcmF0aW9uLgpVbmZvcnR1bmF0ZWx5LCB0aGUg
c2FtZSBlcnJvciBpcyByZXR1cm5lZCBpZiB0aGUgdHJhY2VlCmV4aXN0cyBidXQgaXMgbm90IHB0
cmFjZS1zdG9wcGVkCihmb3IgY29tbWFuZHMgd2hpY2ggcmVxdWlyZSBhIHN0b3BwZWQgdHJhY2Vl
KSwKb3IgaWYgaXQgaXMgbm90IHRyYWNlZCBieSB0aGUgcHJvY2VzcyB3aGljaCBpc3N1ZWQgdGhl
IHB0cmFjZSBjYWxsLgpUaGUgdHJhY2VyIG5lZWRzIHRvIGtlZXAgdHJhY2sgb2YgdGhlIHN0b3Bw
ZWQvcnVubmluZyBzdGF0ZSBvZiB0aGUgdHJhY2VlLAphbmQgaW50ZXJwcmV0Ci5CIEVTUkNICmFz
ICJ0cmFjZWUgZGllZCB1bmV4cGVjdGVkbHkiIG9ubHkgaWYgaXQga25vd3MgdGhhdCB0aGUgdHJh
Y2VlIGhhcwpiZWVuIG9ic2VydmVkIHRvIGVudGVyIHB0cmFjZS1zdG9wLgpOb3RlIHRoYXQgdGhl
cmUgaXMgbm8gZ3VhcmFudGVlIHRoYXQKLkkgd2FpdHBpZChXTk9IQU5HKQp3aWxsIHJlbGlhYmx5
IHJlcG9ydCB0aGUgdHJhY2VlJ3MgZGVhdGggc3RhdHVzIGlmIGEKcHRyYWNlIG9wZXJhdGlvbiBy
ZXR1cm5lZAouQlIgRVNSQ0ggLgouSSB3YWl0cGlkKFdOT0hBTkcpCm1heSByZXR1cm4gMCBpbnN0
ZWFkLgpJbiBvdGhlciB3b3JkcywgdGhlIHRyYWNlZSBtYXkgYmUgIm5vdCB5ZXQgZnVsbHkgZGVh
ZCIsCmJ1dCBhbHJlYWR5IHJlZnVzaW5nIHB0cmFjZSByZXF1ZXN0cy4KLkxQClRoZSB0cmFjZXIg
Y2FuJ3QgYXNzdW1lIHRoYXQgdGhlIHRyYWNlZQouSSBhbHdheXMKZW5kcyBpdHMgbGlmZSBieSBy
ZXBvcnRpbmcKLkkgV0lGRVhJVEVEKHN0YXR1cykKb3IKLklSIFdJRlNJR05BTEVEKHN0YXR1cykg
LgouTFAKLlwiICAgICBvciBjYW4gaXQ/IERvIHdlIGluY2x1ZGUgc3VjaCBhIHByb21pc2UgaW50
byBwdHJhY2UgQVBJPwouXCIKLlwiIEZJWE1FOiBUaGUgcHJlY2VkaW5nIGNvbW1lbnQgc2VlbXMg
dG8gYmUgdW5yZXNvbHZlZD8KLlwiICAgICAgICBEbyB5b3Ugd2FudCB0byBhZGQgYW55dGhpbmc/
Ci5cIgouU1MgU3RvcHBlZCBzdGF0ZXMKQSB0cmFjZWUgY2FuIGJlIGluIHR3byBzdGF0ZXM6IHJ1
bm5pbmcgb3Igc3RvcHBlZC4KLkxQClRoZXJlIGFyZSBtYW55IGtpbmRzIG9mIHN0YXRlcyB3aGVu
IHRoZSB0cmFjZWUgaXMgc3RvcHBlZCwgYW5kIGluIHB0cmFjZQpkaXNjdXNzaW9ucyB0aGV5IGFy
ZSBvZnRlbiBjb25mbGF0ZWQuClRoZXJlZm9yZSwgaXQgaXMgaW1wb3J0YW50IHRvIHVzZSBwcmVj
aXNlIHRlcm1zLgouTFAKSW4gdGhpcyBtYW51YWwgcGFnZSwgYW55IHN0b3BwZWQgc3RhdGUgaW4g
d2hpY2ggdGhlIHRyYWNlZSBpcyByZWFkeQp0byBhY2NlcHQgcHRyYWNlIGNvbW1hbmRzIGZyb20g
dGhlIHRyYWNlciBpcyBjYWxsZWQKLklSIHB0cmFjZS1zdG9wIC4KUHRyYWNlLXN0b3BzIGNhbgpi
ZSBmdXJ0aGVyIHN1YmRpdmlkZWQgaW50bwouSVIgc2lnbmFsLWRlbGl2ZXJ5LXN0b3AgLAouSVIg
Z3JvdXAtc3RvcCAsCi5JUiBzeXNjYWxsLXN0b3AgLAphbmQgc28gb24uClRoZXNlIHN0b3BwZWQg
c3RhdGVzIGFyZSBkZXNjcmliZWQgaW4gZGV0YWlsIGJlbG93LgouTFAKV2hlbiB0aGUgcnVubmlu
ZyB0cmFjZWUgZW50ZXJzIHB0cmFjZS1zdG9wLCBpdCBub3RpZmllcyBpdHMgdHJhY2VyIHVzaW5n
Ci5CUiB3YWl0cGlkICgyKQoob3Igb25lIG9mIHRoZSBvdGhlciAid2FpdCIgc3lzdGVtIGNhbGxz
KS4KTW9zdCBvZiB0aGlzIG1hbnVhbCBwYWdlIGFzc3VtZXMgdGhhdCB0aGUgdHJhY2VyIHdhaXRz
IHdpdGg6Ci5MUAogICAgcGlkID0gd2FpdHBpZChwaWRfb3JfbWludXNfMSwgJnN0YXR1cywgX19X
QUxMKTsKLkxQClB0cmFjZS1zdG9wcGVkIHRyYWNlZXMgYXJlIHJlcG9ydGVkIGFzIHJldHVybnMg
d2l0aAouSSBwaWQKZ3JlYXRlciB0aGFuIDAgYW5kCi5JIFdJRlNUT1BQRUQoc3RhdHVzKQp0cnVl
LgouTFAKLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dpbmcgY29tbWVudCBzZWVtcyB0byBiZSB1
bnJlc29sdmVkPwouXCIgICAgICAgIERvIHlvdSB3YW50IHRvIGFkZCBhbnl0aGluZz8KLlwiCi5c
IiAgICAgRG8gd2UgcmVxdWlyZSBfX1dBTEwgdXNhZ2UsIG9yIHdpbGwganVzdCB1c2luZyAwIGJl
IG9rPyBBcmUgdGhlCi5cIiAgICAgcnVsZXMgZGlmZmVyZW50IGlmIHVzZXIgd2FudHMgdG8gdXNl
IHdhaXRpZD8gV2lsbCB3YWl0aWQgcmVxdWlyZQouXCIgICAgIFdFWElURUQ/Ci5cIgouTFAKLlwi
IEZJWE1FOiBJcyB0aGUgZm9sbG93aW5nIGNvbW1lbnQgIl9fV0FMTC4uLiBpbXBsaWVzIiB0cnVl
PwpUaGUKLkIgX19XQUxMCmZsYWcgZG9lcyBub3QgaW5jbHVkZSB0aGUKLkIgV1NUT1BQRUQKYW5k
Ci5CIFdFWElURUQKZmxhZ3MsIGJ1dCBpbXBsaWVzIHRoZWlyIGZ1bmN0aW9uYWxpdHkuCi5MUApT
ZXR0aW5nIHRoZQouQiBXQ09OVElOVUVECmZsYWcgd2hlbiBjYWxsaW5nCi5CUiB3YWl0cGlkICgy
KQppcyBub3QgcmVjb21tZW5kZWQ6IHRoZSAiY29udGludWVkIiBzdGF0ZSBpcyBwZXItcHJvY2Vz
cyBhbmQKY29uc3VtaW5nIGl0IGNhbiBjb25mdXNlIHRoZSByZWFsIHBhcmVudCBvZiB0aGUgdHJh
Y2VlLgouTFAKVXNlIG9mIHRoZQouQiBXTk9IQU5HCmZsYWcgbWF5IGNhdXNlCi5CUiB3YWl0cGlk
ICgyKQp0byByZXR1cm4gMCAoIm5vIHdhaXQgcmVzdWx0cyBhdmFpbGFibGUgeWV0IikKZXZlbiBp
ZiB0aGUgdHJhY2VyIGtub3dzIHRoZXJlIHNob3VsZCBiZSBhIG5vdGlmaWNhdGlvbi4KRXhhbXBs
ZToKLm5mCgogICAga2lsbCh0cmFjZWUsIFNJR0tJTEwpOwogICAgd2FpdHBpZCh0cmFjZWUsICZz
dGF0dXMsIF9fV0FMTCB8IFdOT0hBTkcpOwouZmkKLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dp
bmcgY29tbWVudCBzZWVtcyB0byBiZSB1bnJlc29sdmVkPwouXCIgICAgICAgIERvIHlvdSB3YW50
IHRvIGFkZCBhbnl0aGluZz8KLlwiCi5cIiAgICAgd2FpdGlkIHVzYWdlPyBXTk9XQUlUPwouXCIg
ICAgIGRlc2NyaWJlIGhvdyB3YWl0IG5vdGlmaWNhdGlvbnMgcXVldWUgKG9yIG5vdCBxdWV1ZSkK
LkxQClRoZSBmb2xsb3dpbmcga2luZHMgb2YgcHRyYWNlLXN0b3BzIGV4aXN0OiBzaWduYWwtZGVs
aXZlcnktc3RvcHMsCmdyb3VwLXN0b3AsIFBUUkFDRV9FVkVOVCBzdG9wcywgc3lzY2FsbC1zdG9w
cwouXCIKLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dpbmcgdGV4dCBhcHBlYXJzIHRvIGJlIGlu
Y29tcGxldGUuCi5cIiAgICAgICAgRG8geW91IHdhbnQgdG8gYWRkIGFueXRoaW5nPwouXCIKWywg
UFRSQUNFX1NJTkdMRVNURVAsIFBUUkFDRV9TWVNFTVUsClBUUkFDRV9TWVNFTVVfU0lOR0xFU1RF
UF0uClRoZXkgYWxsIGFyZSByZXBvcnRlZCBieQouQlIgd2FpdHBpZCAoMikKd2l0aAouSSBXSUZT
VE9QUEVEKHN0YXR1cykKdHJ1ZS4KVGhleSBtYXkgYmUgZGlmZmVyZW50aWF0ZWQgYnkgZXhhbWlu
aW5nIHRoZSB2YWx1ZQouSVIgc3RhdHVzPj44ICwKYW5kIGlmIHRoZXJlIGlzIGFtYmlndWl0eSBp
biB0aGF0IHZhbHVlLCBieSBxdWVyeWluZwouQlIgUFRSQUNFX0dFVFNJR0lORk8gLgouXCIKLlwi
IEZJWE1FIFdoYXQgaXMgdGhlIHB1cnBvc2Ugb2YgdGhlIGZvbGxvd2luZyBzZW50ZW5jZT8gSXMg
aXQgdG8gd2FybgouXCIgICAgICAgdGhlIHJlYWRlciBub3QgdG8gdXNlIFdTVE9QU0lHKCk/IElm
IHNvLCB3ZSBzaG91bGQgbWFrZSB0aGF0Ci5cIiAgICAgICBwb2ludCBtb3JlIGV4cGxpY2l0bHku
CihOb3RlOiB0aGUKLkkgV1NUT1BTSUcoc3RhdHVzKQptYWNybyByZXR1cm5zIHRoZSB2YWx1ZQou
SVIgIihzdGF0dXM+PjgpXCAmXCAweGZmKSIgLikKLlNTIFNpZ25hbC1kZWxpdmVyeS1zdG9wCldo
ZW4gYSAocG9zc2libHkgbXVsdGl0aHJlYWRlZCkgcHJvY2VzcyByZWNlaXZlcyBhbnkgc2lnbmFs
IGV4Y2VwdAouQlIgU0lHS0lMTCAsCnRoZSBrZXJuZWwgc2VsZWN0cyBhbiBhcmJpdHJhcnkgdGhy
ZWFkIHdoaWNoIGhhbmRsZXMgdGhlIHNpZ25hbC4KKElmIHRoZSBzaWduYWwgaXMgZ2VuZXJhdGVk
IHdpdGgKLkJSIHRna2lsbCAoMiksCnRoZSB0YXJnZXQgdGhyZWFkIGNhbiBiZSBleHBsaWNpdGx5
IHNlbGVjdGVkIGJ5IHRoZSBjYWxsZXIuKQpJZiB0aGUgc2VsZWN0ZWQgdGhyZWFkIGlzIHRyYWNl
ZCwgaXQgZW50ZXJzIHNpZ25hbC1kZWxpdmVyeS1zdG9wLgpBdCB0aGlzIHBvaW50LCB0aGUgc2ln
bmFsIGlzIG5vdCB5ZXQgZGVsaXZlcmVkIHRvIHRoZSBwcm9jZXNzLAphbmQgY2FuIGJlIHN1cHBy
ZXNzZWQgYnkgdGhlIHRyYWNlci4KSWYgdGhlIHRyYWNlciBkb2Vzbid0IHN1cHByZXNzIHRoZSBz
aWduYWwsCi5cIgouXCIgRklYTUU6IEkgYWRkZWQgdGhlIHdvcmQgInJlc3RhcnQiIHRvIHRoZSBm
b2xsb3dpbmcgbGluZS4gT2theT8KaXQgcGFzc2VzIHRoZSBzaWduYWwgdG8gdGhlIHRyYWNlZSBp
biB0aGUgbmV4dCBwdHJhY2UgcmVzdGFydCByZXF1ZXN0LgpUaGlzIHNlY29uZCBzdGVwIG9mIHNp
Z25hbCBkZWxpdmVyeSBpcyBjYWxsZWQKLkkgInNpZ25hbCBpbmplY3Rpb24iCmluIHRoaXMgbWFu
dWFsIHBhZ2UuCk5vdGUgdGhhdCBpZiB0aGUgc2lnbmFsIGlzIGJsb2NrZWQsCnNpZ25hbC1kZWxp
dmVyeS1zdG9wIGRvZXNuJ3QgaGFwcGVuIHVudGlsIHRoZSBzaWduYWwgaXMgdW5ibG9ja2VkLAp3
aXRoIHRoZSB1c3VhbCBleGNlcHRpb24gdGhhdAouQiBTSUdTVE9QCmNhbid0IGJlIGJsb2NrZWQu
Ci5MUApTaWduYWwtZGVsaXZlcnktc3RvcCBpcyBvYnNlcnZlZCBieSB0aGUgdHJhY2VyIGFzCi5C
UiB3YWl0cGlkICgyKQpyZXR1cm5pbmcgd2l0aAouSSBXSUZTVE9QUEVEKHN0YXR1cykKdHJ1ZSwg
d2l0aCB0aGUgc3RvcHBpbmcgc2lnbmFsIHJldHVybmVkIGJ5Ci5JUiBXU1RPUFNJRyhzdGF0dXMp
IC4KSWYgdGhlIHN0b3BwaW5nIHNpZ25hbCBpcwouQlIgU0lHVFJBUCAsCnRoaXMgbWF5IGJlIGEg
ZGlmZmVyZW50IGtpbmQgb2YgcHRyYWNlLXN0b3A7CnNlZSB0aGUgIlN5c2NhbGwtc3RvcHMiIGFu
ZCAiZXhlY3ZlIiBzZWN0aW9ucyBiZWxvdyBmb3IgZGV0YWlscy4KSWYKLkkgV1NUT1BTSUcoc3Rh
dHVzKQpyZXR1cm5zIGEgc3RvcHBpbmcgc2lnbmFsLCB0aGlzIG1heSBiZSBhIGdyb3VwLXN0b3A7
IHNlZSBiZWxvdy4KLlNTIFNpZ25hbCBpbmplY3Rpb24gYW5kIHN1cHByZXNzaW9uCkFmdGVyIHNp
Z25hbC1kZWxpdmVyeS1zdG9wIGlzIG9ic2VydmVkIGJ5IHRoZSB0cmFjZXIsCnRoZSB0cmFjZXIg
c2hvdWxkIHJlc3RhcnQgdGhlIHRyYWNlZSB3aXRoIHRoZSBjYWxsCi5MUAogICAgcHRyYWNlKFBU
UkFDRV9yZXN0YXJ0LCBwaWQsIDAsIHNpZykKLkxQCndoZXJlCi5CIFBUUkFDRV9yZXN0YXJ0Cmlz
IG9uZSBvZiB0aGUgcmVzdGFydGluZyBwdHJhY2UgcmVxdWVzdHMuCklmCi5JIHNpZwppcyAwLCB0
aGVuIGEgc2lnbmFsIGlzIG5vdCBkZWxpdmVyZWQuCk90aGVyd2lzZSwgdGhlIHNpZ25hbAouSSBz
aWcKaXMgZGVsaXZlcmVkLgpUaGlzIG9wZXJhdGlvbiBpcyBjYWxsZWQKLkkgInNpZ25hbCBpbmpl
Y3Rpb24iCmluIHRoaXMgbWFudWFsIHBhZ2UsIHRvIGRpc3Rpbmd1aXNoIGl0IGZyb20gc2lnbmFs
LWRlbGl2ZXJ5LXN0b3AuCi5MUApOb3RlIHRoYXQgdGhlCi5JIHNpZwp2YWx1ZSBtYXkgYmUgZGlm
ZmVyZW50IGZyb20gdGhlCi5JIFdTVE9QU0lHKHN0YXR1cykKdmFsdWU6IHRoZSB0cmFjZXIgY2Fu
IGNhdXNlIGEgZGlmZmVyZW50IHNpZ25hbCB0byBiZSBpbmplY3RlZC4KLkxQCk5vdGUgdGhhdCBh
IHN1cHByZXNzZWQgc2lnbmFsIHN0aWxsIGNhdXNlcyBzeXN0ZW0gY2FsbHMgdG8gcmV0dXJuCnBy
ZW1hdHVyZWx5LgpSZXN0YXJ0YWJsZSBzeXN0ZW0gY2FsbHMgd2lsbCBiZSByZXN0YXJ0ZWQgKHRo
ZSB0cmFjZXIgd2lsbApvYnNlcnZlIHRoZSB0cmFjZWUgdG8gZXhlY3V0ZQouQlIgcmVzdGFydF9z
eXNjYWxsKDIpCmlmIHRoZSB0cmFjZXIgdXNlcwouQlIgUFRSQUNFX1NZU0NBTEwgKTsKbm9uLXJl
c3RhcnRhYmxlIHN5c3RlbSBjYWxscyBtYXkgZmFpbCB3aXRoCi5CIEVJTlRSCmV2ZW4gdGhvdWdo
IG5vIG9ic2VydmFibGUgc2lnbmFsIGlzIGluamVjdGVkIHRvIHRoZSB0cmFjZWUuCi5MUApOb3Rl
IHRoYXQgcmVzdGFydGluZyBwdHJhY2UgY29tbWFuZHMgaXNzdWVkIGluIHB0cmFjZS1zdG9wcyBv
dGhlciB0aGFuCnNpZ25hbC1kZWxpdmVyeS1zdG9wIGFyZSBub3QgZ3VhcmFudGVlZCB0byBpbmpl
Y3QgYSBzaWduYWwsIGV2ZW4gaWYKLkkgc2lnCmlzIG5vbnplcm8uCk5vIGVycm9yIGlzIHJlcG9y
dGVkOyBhIG5vbnplcm8KLkkgc2lnCm1heSBzaW1wbHkgYmUgaWdub3JlZC4KUHRyYWNlIHVzZXJz
IHNob3VsZCBub3QgdHJ5IHRvICJjcmVhdGUgYSBuZXcgc2lnbmFsIiB0aGlzIHdheTogdXNlCi5C
UiB0Z2tpbGwgKDIpCmluc3RlYWQuCi5MUAouXCIKLlwiIEZJWE1FOiB0aGUgcmVmZXJyZW50IG9m
ICJUaGlzIiBpbiB0aGUgbmV4dCBsaW5lIGlzIG5vdCBjbGVhci4KLlwiICAgICAgICBXaGF0IGRv
ZXMgIlRoaXMiIHJlZmVyIHRvPwpUaGlzIGlzIGEgY2F1c2Ugb2YgY29uZnVzaW9uIGFtb25nIHB0
cmFjZSB1c2Vycy4KT25lIHR5cGljYWwgc2NlbmFyaW8gaXMgdGhhdCB0aGUgdHJhY2VyIG9ic2Vy
dmVzIGdyb3VwLXN0b3AsCm1pc3Rha2VzIGl0IGZvciBzaWduYWwtZGVsaXZlcnktc3RvcCwgcmVz
dGFydHMgdGhlIHRyYWNlZSB3aXRoCgogICAgcHRyYWNlKFBUUkFDRV9yZXN0LCBwaWQsIDAsIHN0
b3BzaWcpCgp3aXRoIHRoZSBpbnRlbnRpb24gb2YgaW5qZWN0aW5nCi5JUiBzdG9wc2lnICwKYnV0
Ci5JIHN0b3BzaWcKZ2V0cyBpZ25vcmVkIGFuZCB0aGUgdHJhY2VlIGNvbnRpbnVlcyB0byBydW4u
Ci5MUApUaGUKLkIgU0lHQ09OVApzaWduYWwgaGFzIGEgc2lkZSBlZmZlY3Qgb2Ygd2FraW5nIHVw
IChhbGwgdGhyZWFkcyBvZikKYSBncm91cC1zdG9wcGVkIHByb2Nlc3MuClRoaXMgc2lkZSBlZmZl
Y3QgaGFwcGVucyBiZWZvcmUgc2lnbmFsLWRlbGl2ZXJ5LXN0b3AuClRoZSB0cmFjZXIgY2FuJ3Qg
c3VwcHJlc3MgdGhpcyBzaWRlLWVmZmVjdCAoaXQgY2FuCm9ubHkgc3VwcHJlc3Mgc2lnbmFsIGlu
amVjdGlvbiwgd2hpY2ggb25seSBjYXVzZXMgdGhlCi5CUiBTSUdDT05UCmhhbmRsZXIgdG8gbm90
IGJlIGV4ZWN1dGVkIGluIHRoZSB0cmFjZWUsIGlmIHN1Y2ggYSBoYW5kbGVyIGlzIGluc3RhbGxl
ZCkuCkluIGZhY3QsIHdha2luZyB1cCBmcm9tIGdyb3VwLXN0b3AgbWF5IGJlIGZvbGxvd2VkIGJ5
CnNpZ25hbC1kZWxpdmVyeS1zdG9wIGZvciBzaWduYWwocykKLkkgb3RoZXIgdGhhbgouQlIgU0lH
Q09OVCAsCmlmIHRoZXkgd2VyZSBwZW5kaW5nIHdoZW4KLkIgU0lHQ09OVAp3YXMgZGVsaXZlcmVk
LgpJbiBvdGhlciB3b3JkcywKLkIgU0lHQ09OVAptYXkgYmUgbm90IHRoZSBmaXJzdCBzaWduYWwg
b2JzZXJ2ZWQgYnkgdGhlIHRyYWNlZSBhZnRlciBpdCB3YXMgc2VudC4KLkxQClN0b3BwaW5nIHNp
Z25hbHMgY2F1c2UgKGFsbCB0aHJlYWRzIG9mKSBhIHByb2Nlc3MgdG8gZW50ZXIgZ3JvdXAtc3Rv
cC4KVGhpcyBzaWRlIGVmZmVjdCBoYXBwZW5zIGFmdGVyIHNpZ25hbCBpbmplY3Rpb24sIGFuZCB0
aGVyZWZvcmUgY2FuIGJlCnN1cHByZXNzZWQgYnkgdGhlIHRyYWNlci4KLkxQCi5CIFBUUkFDRV9H
RVRTSUdJTkZPCmNhbiBiZSB1c2VkIHRvIHJldHJpZXZlIGEKLkkgc2lnaW5mb190CnN0cnVjdHVy
ZSB3aGljaCBjb3JyZXNwb25kcyB0byB0aGUgZGVsaXZlcmVkIHNpZ25hbC4KLkIgUFRSQUNFX1NF
VFNJR0lORk8KbWF5IGJlIHVzZWQgdG8gbW9kaWZ5IGl0LgpJZgouQiBQVFJBQ0VfU0VUU0lHSU5G
TwpoYXMgYmVlbiB1c2VkIHRvIGFsdGVyCi5JUiBzaWdpbmZvX3QgLAp0aGUKLkkgc2lfc2lnbm8K
ZmllbGQgYW5kIHRoZQouSSBzaWcKcGFyYW1ldGVyIGluIHRoZSByZXN0YXJ0aW5nIGNvbW1hbmQg
bXVzdCBtYXRjaCwKb3RoZXJ3aXNlIHRoZSByZXN1bHQgaXMgdW5kZWZpbmVkLgouU1MgR3JvdXAt
c3RvcApXaGVuIGEgKHBvc3NpYmx5IG11bHRpdGhyZWFkZWQpIHByb2Nlc3MgcmVjZWl2ZXMgYSBz
dG9wcGluZyBzaWduYWwsCmFsbCB0aHJlYWRzIHN0b3AuCklmIHNvbWUgdGhyZWFkcyBhcmUgdHJh
Y2VkLCB0aGV5IGVudGVyIGEgZ3JvdXAtc3RvcC4KTm90ZSB0aGF0IHRoZSBzdG9wcGluZyBzaWdu
YWwgd2lsbCBmaXJzdCBjYXVzZSBzaWduYWwtZGVsaXZlcnktc3RvcAoob24gb25lIHRyYWNlZSBv
bmx5KSwgYW5kIG9ubHkgYWZ0ZXIgaXQgaXMgaW5qZWN0ZWQgYnkgdGhlIHRyYWNlcgoob3IgYWZ0
ZXIgaXQgd2FzIGRpc3BhdGNoZWQgdG8gYSB0aHJlYWQgd2hpY2ggaXNuJ3QgdHJhY2VkKSwKd2ls
bCBncm91cC1zdG9wIGJlIGluaXRpYXRlZCBvbgouSSBhbGwKdHJhY2VlcyB3aXRoaW4gdGhlIG11
bHRpdGhyZWFkZWQgcHJvY2Vzcy4KQXMgdXN1YWwsIGV2ZXJ5IHRyYWNlZSByZXBvcnRzIGl0cyBn
cm91cC1zdG9wIHNlcGFyYXRlbHkKdG8gdGhlIGNvcnJlc3BvbmRpbmcgdHJhY2VyLgouTFAKR3Jv
dXAtc3RvcCBpcyBvYnNlcnZlZCBieSB0aGUgdHJhY2VyIGFzCi5CUiB3YWl0cGlkICgyKQpyZXR1
cm5pbmcgd2l0aAouSSBXSUZTVE9QUEVEKHN0YXR1cykKdHJ1ZSwgd2l0aCB0aGUgc3RvcHBpbmcg
c2lnbmFsIGF2YWlsYWJsZSB2aWEKLklSIFdTVE9QU0lHKHN0YXR1cykgLgpUaGUgc2FtZSByZXN1
bHQgaXMgcmV0dXJuZWQgYnkgc29tZSBvdGhlciBjbGFzc2VzIG9mIHB0cmFjZS1zdG9wcywKdGhl
cmVmb3JlIHRoZSByZWNvbW1lbmRlZCBwcmFjdGljZSBpcyB0byBwZXJmb3JtIHRoZSBjYWxsCi5M
UAogICAgcHRyYWNlKFBUUkFDRV9HRVRTSUdJTkZPLCBwaWQsIDAsICZzaWdpbmZvKQouTFAKVGhl
IGNhbGwgY2FuIGJlIGF2b2lkZWQgaWYgdGhlIHNpZ25hbCBpcyBub3QKLkJSIFNJR1NUT1AgLAou
QlIgU0lHVFNUUCAsCi5CUiBTSUdUVElOICwKb3IKLkJSIFNJR1RUT1UgOwpvbmx5IHRoZXNlIGZv
dXIgc2lnbmFscyBhcmUgc3RvcHBpbmcgc2lnbmFscy4KSWYgdGhlIHRyYWNlciBzZWVzIHNvbWV0
aGluZyBlbHNlLCBpdCBjYW4ndCBiZSBhIGdyb3VwLXN0b3AuCk90aGVyd2lzZSwgdGhlIHRyYWNl
ciBuZWVkcyB0byBjYWxsCi5CUiBQVFJBQ0VfR0VUU0lHSU5GTyAuCklmCi5CIFBUUkFDRV9HRVRT
SUdJTkZPCmZhaWxzIHdpdGgKLkJSIEVJTlZBTCAsCnRoZW4gaXQgaXMgZGVmaW5pdGVseSBhIGdy
b3VwLXN0b3AuCihPdGhlciBmYWlsdXJlIGNvZGVzIGFyZSBwb3NzaWJsZSwgc3VjaCBhcwouQiBF
U1JDSAooIm5vIHN1Y2ggcHJvY2VzcyIpIGlmIGEKLkIgU0lHS0lMTApraWxsZWQgdGhlIHRyYWNl
ZS4pCi5MUApBcyBvZiBrZXJuZWwgMi42LjM4LAphZnRlciB0aGUgdHJhY2VyIHNlZXMgdGhlIHRy
YWNlZSBwdHJhY2Utc3RvcCBhbmQgdW50aWwgaXQKcmVzdGFydHMgb3Iga2lsbHMgaXQsIHRoZSB0
cmFjZWUgd2lsbCBub3QgcnVuLAphbmQgd2lsbCBub3Qgc2VuZCBub3RpZmljYXRpb25zIChleGNl
cHQKLkIgU0lHS0lMTApkZWF0aCkgdG8gdGhlIHRyYWNlciwgZXZlbiBpZiB0aGUgdHJhY2VyIGVu
dGVycyBpbnRvIGFub3RoZXIKLkJSIHdhaXRwaWQgKDIpCmNhbGwuCi5MUAouXCIKLlwiIEZJWE1F
ID8/PyByZWZlcnJlbnQgb2YgIml0IiBpbiB0aGUgbmV4dCBsaW5lIGlzIHVuY2xlYXIKLlwiICAg
ICAgICBXaGF0IGRvZXMgIml0IiByZWZlciB0bz8KQ3VycmVudGx5LCBpdCBjYXVzZXMgYSBwcm9i
bGVtIHdpdGggdHJhbnNwYXJlbnQgaGFuZGxpbmcgb2Ygc3RvcHBpbmcKc2lnbmFsczogaWYgdGhl
IHRyYWNlciByZXN0YXJ0cyB0aGUgdHJhY2VlIGFmdGVyIGdyb3VwLXN0b3AsCi5CIFNJR1NUT1AK
aXMgZWZmZWN0aXZlbHkgaWdub3JlZDogdGhlIHRyYWNlZSBkb2Vzbid0IHJlbWFpbiBzdG9wcGVk
LCBpdCBydW5zLgpJZiB0aGUgdHJhY2VyIGRvZXNuJ3QgcmVzdGFydCB0aGUgdHJhY2VlIGJlZm9y
ZSBlbnRlcmluZyBpbnRvIHRoZSBuZXh0Ci5CUiB3YWl0cGlkICgyKSwKZnV0dXJlCi5CIFNJR0NP
TlQKc2lnbmFscyB3aWxsIG5vdCBiZSByZXBvcnRlZCB0byB0aGUgdHJhY2VyLgpUaGlzIHdvdWxk
IGNhdXNlCi5CIFNJR0NPTlQKdG8gaGF2ZSBubyBlZmZlY3QuCi5TUyBQVFJBQ0VfRVZFTlQgc3Rv
cHMKSWYgdGhlIHRyYWNlciBzZXRzCi5CIFBUUkFDRV9PX1RSQUNFXyoKb3B0aW9ucywgdGhlIHRy
YWNlZSB3aWxsIGVudGVyIHB0cmFjZS1zdG9wcyBjYWxsZWQKLkIgUFRSQUNFX0VWRU5UCnN0b3Bz
LgouTFAKLkIgUFRSQUNFX0VWRU5UCnN0b3BzIGFyZSBvYnNlcnZlZCBieSB0aGUgdHJhY2VyIGFz
Ci5CUiB3YWl0cGlkICgyKQpyZXR1cm5pbmcgd2l0aAouSVIgV0lGU1RPUFBFRChzdGF0dXMpICwK
YW5kCi5JIFdTVE9QU0lHKHN0YXR1cykKcmV0dXJucwouQlIgU0lHVFJBUCAuCkFuIGFkZGl0aW9u
YWwgYml0IGlzIHNldCBpbiB0aGUgaGlnaGVyIGJ5dGUgb2YgdGhlIHN0YXR1cyB3b3JkOgp0aGUg
dmFsdWUKLkkgc3RhdHVzPj44CndpbGwgYmUKCiAgICAoU0lHVFJBUCB8IFBUUkFDRV9FVkVOVF9m
b28gPDwgOCkuCgpUaGUgZm9sbG93aW5nIGV2ZW50cyBleGlzdDoKLlRQCi5CIFBUUkFDRV9FVkVO
VF9WRk9SSwpTdG9wIGJlZm9yZSByZXR1cm4gZnJvbQouQlIgdmZvcmsgKDIpCm9yCi5CUiBjbG9u
ZSAoMikKd2l0aCB0aGUKLkIgQ0xPTkVfVkZPUksKZmxhZy4KV2hlbiB0aGUgdHJhY2VlIGlzIGNv
bnRpbnVlZCBhZnRlciB0aGlzIHN0b3AsIGl0IHdpbGwgd2FpdCBmb3IgY2hpbGQgdG8KZXhpdC9l
eGVjIGJlZm9yZSBjb250aW51aW5nIGl0cyBleGVjdXRpb24KKGluIG90aGVyIHdvcmRzLCB0aGUg
dXN1YWwgYmVoYXZpb3Igb24KLkJSIHZmb3JrICgyKSkuCi5UUAouQiBQVFJBQ0VfRVZFTlRfRk9S
SwpTdG9wIGJlZm9yZSByZXR1cm4gZnJvbQouQlIgZm9yayAoMikKb3IKLkJSIGNsb25lICgyKQp3
aXRoIHRoZSBleGl0IHNpZ25hbCBzZXQgdG8KLkJSIFNJR0NITEQgLgouVFAKLkIgUFRSQUNFX0VW
RU5UX0NMT05FClN0b3AgYmVmb3JlIHJldHVybiBmcm9tCi5CUiBjbG9uZSAoMikKLlRQCi5CIFBU
UkFDRV9FVkVOVF9WRk9SS19ET05FClN0b3AgYmVmb3JlIHJldHVybiBmcm9tCi5CUiB2Zm9yayAo
MikKb3IKLkJSIGNsb25lICgyKQp3aXRoIHRoZQouQiBDTE9ORV9WRk9SSwpmbGFnLApidXQgYWZ0
ZXIgdGhlIGNoaWxkIHVuYmxvY2tlZCB0aGlzIHRyYWNlZSBieSBleGl0aW5nIG9yIGV4ZWNpbmcu
Ci5MUApGb3IgYWxsIGZvdXIgc3RvcHMgZGVzY3JpYmVkIGFib3ZlLAp0aGUgc3RvcCBvY2N1cnMg
aW4gdGhlIHBhcmVudCAoaS5lLiwgdGhlIHRyYWNlZSksCm5vdCBpbiB0aGUgbmV3bHkgY3JlYXRl
ZCB0aHJlYWQuCi5CUiBQVFJBQ0VfR0VURVZFTlRNU0cKY2FuIGJlIHVzZWQgdG8gcmV0cmlldmUg
dGhlIG5ldyB0aHJlYWQncyBJRC4KLlRQCi5CIFBUUkFDRV9FVkVOVF9FWEVDClN0b3AgYmVmb3Jl
IHJldHVybiBmcm9tCi5CUiBleGVjdmUgKDIpLgouVFAKLkIgUFRSQUNFX0VWRU5UX0VYSVQKU3Rv
cCBiZWZvcmUgZXhpdCAoaW5jbHVkaW5nIGRlYXRoIGZyb20KLkJSIGV4aXRfZ3JvdXAgKDIpKSwK
c2lnbmFsIGRlYXRoLCBvciBleGl0IGNhdXNlZCBieQouQlIgZXhlY3ZlICgyKQppbiBhIG11bHRp
dGhyZWFkZWQgcHJvY2Vzcy4KLkIgUFRSQUNFX0dFVEVWRU5UTVNHCnJldHVybnMgdGhlIGV4aXQg
c3RhdHVzLgpSZWdpc3RlcnMgY2FuIGJlIGV4YW1pbmVkCih1bmxpa2Ugd2hlbiAicmVhbCIgZXhp
dCBoYXBwZW5zKS4KVGhlIHRyYWNlZSBpcyBzdGlsbCBhbGl2ZTsgaXQgbmVlZHMgdG8gYmUKLkJS
IFBUUkFDRV9DT05UIGVkCm9yCi5CUiBQVFJBQ0VfREVUQUNIIGVkCnRvIGZpbmlzaCBleGl0aW5n
LgouTFAKLkIgUFRSQUNFX0dFVFNJR0lORk8Kb24KLkIgUFRSQUNFX0VWRU5UCnN0b3BzIHJldHVy
bnMKLkIgU0lHVFJBUCBpbgouSVIgc2lfc2lnbm8gLAp3aXRoCi5JIHNpX2NvZGUKc2V0IHRvCi5J
UiAiKGV2ZW50PDw4KVwgfFwgU0lHVFJBUCIgLgouU1MgU3lzY2FsbC1zdG9wcwpJZiB0aGUgdHJh
Y2VlIHdhcyByZXN0YXJ0ZWQgYnkKLkJSIFBUUkFDRV9TWVNDQUxMICwKdGhlIHRyYWNlZSBlbnRl
cnMKc3lzY2FsbC1lbnRlci1zdG9wIGp1c3QgcHJpb3IgdG8gZW50ZXJpbmcgYW55IHN5c3RlbSBj
YWxsLgpJZiB0aGUgdHJhY2VyIHJlc3RhcnRzIHRoZSB0cmFjZWUgd2l0aAouQlIgUFRSQUNFX1NZ
U0NBTEwgLAp0aGUgdHJhY2VlIGVudGVycyBzeXNjYWxsLWV4aXQtc3RvcCB3aGVuIHRoZSBzeXN0
ZW0gY2FsbCBpcyBmaW5pc2hlZCwKb3IgaWYgaXQgaXMgaW50ZXJydXB0ZWQgYnkgYSBzaWduYWwu
CihUaGF0IGlzLCBzaWduYWwtZGVsaXZlcnktc3RvcCBuZXZlciBoYXBwZW5zIGJldHdlZW4gc3lz
Y2FsbC1lbnRlci1zdG9wCmFuZCBzeXNjYWxsLWV4aXQtc3RvcDsgaXQgaGFwcGVucwouSSBhZnRl
cgpzeXNjYWxsLWV4aXQtc3RvcC4pCi5MUApPdGhlciBwb3NzaWJpbGl0aWVzIGFyZSB0aGF0IHRo
ZSB0cmFjZWUgbWF5IHN0b3AgaW4gYQouQiBQVFJBQ0VfRVZFTlQKc3RvcCwgZXhpdCAoaWYgaXQg
ZW50ZXJlZAouQlIgX2V4aXQgKDIpCm9yCi5CUiBleGl0X2dyb3VwICgyKSksCmJlIGtpbGxlZCBi
eQouQlIgU0lHS0lMTCAsCm9yIGRpZSBzaWxlbnRseSAoaWYgaXQgaXMgYSB0aHJlYWQgZ3JvdXAg
bGVhZGVyLCB0aGUKLkJSIGV4ZWN2ZSAoMikKaGFwcGVuZWQgaW4gYW5vdGhlciB0aHJlYWQsCmFu
ZCB0aGF0IHRocmVhZCBpcyBub3QgdHJhY2VkIGJ5IHRoZSBzYW1lIHRyYWNlcjsKdGhpcyBzaXR1
YXRpb24gaXMgZGlzY3Vzc2VkIGxhdGVyKS4KLkxQClN5c2NhbGwtZW50ZXItc3RvcCBhbmQgc3lz
Y2FsbC1leGl0LXN0b3AgYXJlIG9ic2VydmVkIGJ5IHRoZSB0cmFjZXIgYXMKLkJSIHdhaXRwaWQg
KDIpCnJldHVybmluZyB3aXRoCi5JIFdJRlNUT1BQRUQoc3RhdHVzKQp0cnVlLCBhbmQKLkkgV1NU
T1BTSUcoc3RhdHVzKQpnaXZpbmcKLkJSIFNJR1RSQVAgLgpJZiB0aGUKLkIgUFRSQUNFX09fVFJB
Q0VTWVNHT09ECm9wdGlvbiB3YXMgc2V0IGJ5IHRoZSB0cmFjZXIsIHRoZW4KLkkgV1NUT1BTSUco
c3RhdHVzKQp3aWxsIGdpdmUgdGhlIHZhbHVlCi5JUiAiKFNJR1RSQVBcIHxcIDB4ODApIiAuCi5M
UApTeXNjYWxsLXN0b3BzIGNhbiBiZSBkaXN0aW5ndWlzaGVkIGZyb20gc2lnbmFsLWRlbGl2ZXJ5
LXN0b3Agd2l0aAouQiBTSUdUUkFQCmJ5IHF1ZXJ5aW5nCi5CUiBQVFJBQ0VfR0VUU0lHSU5GTwpm
b3IgdGhlIGZvbGxvd2luZyBjYXNlczoKLlRQCi5JUiBzaV9jb2RlICIgPD0gMCIKLkIgU0lHVFJB
UAouXCIgRklYTUU6IFBsZWFzZSBjb25maXJtIHRoaXMgaXMgb2theTogSSBjaGFuZ2VkCi5cIiAg
ICAgICAgInRoZSB1c3VhbCBzdXNwZWN0cyIgdG8gImJ5IGEgc3lzdGVtIGNhbGwiLiBPa2F5Pwou
XCIgICAgICAgIFNob3VsZG4ndCB3ZSBhbHNvIGFkZCBraWxsKDIpIGhlcmU/CndhcyBzZW50IGJ5
IGEgc3lzdGVtIGNhbGwKLlJCICggdGdraWxsICgyKSwKLkJSIHNpZ3F1ZXVlICgzKSwKZXRjLikK
LlRQCi5JUiBzaV9jb2RlICIgPT0gU0lfS0VSTkVMICgweDgwKSIKLkIgU0lHVFJBUAp3YXMgc2Vu
dCBieSB0aGUga2VybmVsLgouVFAKLklSIHNpX2NvZGUgIiA9PSBTSUdUUkFQIG9yICIgc2lfY29k
ZSAiID09IChTSUdUUkFQfDB4ODApIgpUaGlzIGlzIGEgc3lzY2FsbC1zdG9wLgouTFAKSG93ZXZl
ciwgc3lzY2FsbC1zdG9wcyBoYXBwZW4gdmVyeSBvZnRlbiAodHdpY2UgcGVyIHN5c3RlbSBjYWxs
KSwKYW5kIHBlcmZvcm1pbmcKLkIgUFRSQUNFX0dFVFNJR0lORk8KZm9yIGV2ZXJ5IHN5c2NhbGwt
c3RvcCBtYXkgYmUgc29tZXdoYXQgZXhwZW5zaXZlLgouTFAKLlwiCi5cIiBGSVhNRSByZWZlcnJl
bnQgb2YgInRoZW0iIGluIG5leHQgbGluZSA/Pz8KLlwiICAgICAgIFdoYXQgZG9lcyAidGhlbSIg
cmVmZXIgdG8/ClNvbWUgYXJjaGl0ZWN0dXJlcyBhbGxvdyB0aGUgY2FzZXMgdG8gYmUgZGlzdGlu
Z3Vpc2hlZApieSBleGFtaW5pbmcgcmVnaXN0ZXJzLgpGb3IgZXhhbXBsZSwgb24geDg2LAouSSBy
YXgKPT0KLlJCIC0gRU5PU1lTCmluIHN5c2NhbGwtZW50ZXItc3RvcC4KU2luY2UKLkIgU0lHVFJB
UAoobGlrZSBhbnkgb3RoZXIgc2lnbmFsKSBhbHdheXMgaGFwcGVucwouSSBhZnRlcgpzeXNjYWxs
LWV4aXQtc3RvcCwKYW5kIGF0IHRoaXMgcG9pbnQKLkkgcmF4CmFsbW9zdCBuZXZlciBjb250YWlu
cwouUkIgLSBFTk9TWVMgLAp0aGUKLkIgU0lHVFJBUApsb29rcyBsaWtlICJzeXNjYWxsLXN0b3Ag
d2hpY2ggaXMgbm90IHN5c2NhbGwtZW50ZXItc3RvcCI7CmluIG90aGVyIHdvcmRzLCBpdCBsb29r
cyBsaWtlIGEKInN0cmF5IHN5c2NhbGwtZXhpdC1zdG9wIiBhbmQgY2FuIGJlIGRldGVjdGVkIHRo
aXMgd2F5LgpCdXQgc3VjaCBkZXRlY3Rpb24gaXMgZnJhZ2lsZSBhbmQgaXMgYmVzdCBhdm9pZGVk
LgouTFAKVXNpbmcgdGhlCi5CIFBUUkFDRV9PX1RSQUNFU1lTR09PRAouXCIKLlwiIEZJWE1FIEJl
bG93OiAiaXMgdGhlIHJlY29tbWVuZGVkIG1ldGhvZCIgZm9yIFdIQVQ/Cm9wdGlvbiBpcyB0aGUg
cmVjb21tZW5kZWQgbWV0aG9kLApzaW5jZSBpdCBpcyByZWxpYWJsZSBhbmQgZG9lcyBub3QgaW5j
dXIgYSBwZXJmb3JtYW5jZSBwZW5hbHR5LgouTFAKU3lzY2FsbC1lbnRlci1zdG9wIGFuZCBzeXNj
YWxsLWV4aXQtc3RvcCBhcmUKaW5kaXN0aW5ndWlzaGFibGUgZnJvbSBlYWNoIG90aGVyIGJ5IHRo
ZSB0cmFjZXIuClRoZSB0cmFjZXIgbmVlZHMgdG8ga2VlcCB0cmFjayBvZiB0aGUgc2VxdWVuY2Ug
b2YKcHRyYWNlLXN0b3BzIGluIG9yZGVyIHRvIG5vdCBtaXNpbnRlcnByZXQgc3lzY2FsbC1lbnRl
ci1zdG9wIGFzCnN5c2NhbGwtZXhpdC1zdG9wIG9yIHZpY2UgdmVyc2EuClRoZSBydWxlIGlzIHRo
YXQgc3lzY2FsbC1lbnRlci1zdG9wIGlzCmFsd2F5cyBmb2xsb3dlZCBieSBzeXNjYWxsLWV4aXQt
c3RvcCwKLkIgUFRSQUNFX0VWRU5UCnN0b3Agb3IgdGhlIHRyYWNlZSdzIGRlYXRoOwpubyBvdGhl
ciBraW5kcyBvZiBwdHJhY2Utc3RvcCBjYW4gb2NjdXIgaW4gYmV0d2Vlbi4KLkxQCklmIGFmdGVy
IHN5c2NhbGwtZW50ZXItc3RvcCwKdGhlIHRyYWNlciB1c2VzIGEgcmVzdGFydGluZyBjb21tYW5k
IG90aGVyIHRoYW4KLkJSIFBUUkFDRV9TWVNDQUxMICwKc3lzY2FsbC1leGl0LXN0b3AgaXMgbm90
IGdlbmVyYXRlZC4KLkxQCi5CIFBUUkFDRV9HRVRTSUdJTkZPCm9uIHN5c2NhbGwtc3RvcHMgcmV0
dXJucwouQiBTSUdUUkFQCmluCi5JUiBzaV9zaWdubyAsCndpdGgKLkkgc2lfY29kZQpzZXQgdG8K
LkIgU0lHVFJBUApvcgouSVIgKFNJR1RSQVB8MHg4MCkgLgouU1MgUFRSQUNFX1NJTkdMRVNURVAs
IFBUUkFDRV9TWVNFTVUsIFBUUkFDRV9TWVNFTVVfU0lOR0xFU1RFUCBzdG9wcwouXCIKLlwiIEZJ
WE1FIFRoZSBmb2xsb3dpbmcgVE9ETyBpcyB1bnJlc29sdmVkCi5cIiAgICAgICBEbyB5b3Ugd2Fu
dCB0byBhZGQgYW55dGhpbmc/Ci5cIgooVE9ETzogZG9jdW1lbnQgc3RvcHMgb2NjdXJyaW5nIHdp
dGggUFRSQUNFX1NJTkdMRVNURVAsIFBUUkFDRV9TWVNFTVUsClBUUkFDRV9TWVNFTVVfU0lOR0xF
U1RFUCkKLlNTIEluZm9ybWF0aW9uYWwgYW5kIHJlc3RhcnRpbmcgcHRyYWNlIGNvbW1hbmRzCk1v
c3QgcHRyYWNlIGNvbW1hbmRzIChhbGwgZXhjZXB0Ci5CUiBQVFJBQ0VfQVRUQUNIICwKLkJSIFBU
UkFDRV9UUkFDRU1FICwKYW5kCi5CUiBQVFJBQ0VfS0lMTCApCnJlcXVpcmUgdGhlIHRyYWNlZSB0
byBiZSBpbiBhIHB0cmFjZS1zdG9wLCBvdGhlcndpc2UgdGhleSBmYWlsIHdpdGgKLkJSIEVTUkNI
IC4KLkxQCldoZW4gdGhlIHRyYWNlZSBpcyBpbiBwdHJhY2Utc3RvcCwKdGhlIHRyYWNlciBjYW4g
cmVhZCBhbmQgd3JpdGUgZGF0YSB0bwp0aGUgdHJhY2VlIHVzaW5nIGluZm9ybWF0aW9uYWwgY29t
bWFuZHMuClRoZXNlIGNvbW1hbmRzIGxlYXZlIHRoZSB0cmFjZWUgaW4gcHRyYWNlLXN0b3BwZWQg
c3RhdGU6Ci5MUAoubmYKICAgIHB0cmFjZShQVFJBQ0VfUEVFS1RFWFQvUEVFS0RBVEEvUEVFS1VT
RVIsIHBpZCwgYWRkciwgMCk7CiAgICBwdHJhY2UoUFRSQUNFX1BPS0VURVhUL1BPS0VEQVRBL1BP
S0VVU0VSLCBwaWQsIGFkZHIsIGxvbmdfdmFsKTsKICAgIHB0cmFjZShQVFJBQ0VfR0VUUkVHUy9H
RVRGUFJFR1MsIHBpZCwgMCwgJnN0cnVjdCk7CiAgICBwdHJhY2UoUFRSQUNFX1NFVFJFR1MvU0VU
RlBSRUdTLCBwaWQsIDAsICZzdHJ1Y3QpOwogICAgcHRyYWNlKFBUUkFDRV9HRVRTSUdJTkZPLCBw
aWQsIDAsICZzaWdpbmZvKTsKICAgIHB0cmFjZShQVFJBQ0VfU0VUU0lHSU5GTywgcGlkLCAwLCAm
c2lnaW5mbyk7CiAgICBwdHJhY2UoUFRSQUNFX0dFVEVWRU5UTVNHLCBwaWQsIDAsICZsb25nX3Zh
cik7CiAgICBwdHJhY2UoUFRSQUNFX1NFVE9QVElPTlMsIHBpZCwgMCwgUFRSQUNFX09fZmxhZ3Mp
OwouZmkKLkxQCk5vdGUgdGhhdCBzb21lIGVycm9ycyBhcmUgbm90IHJlcG9ydGVkLgpGb3IgZXhh
bXBsZSwgc2V0dGluZyBzaWduYWwgaW5mb3JtYXRpb24KLlJJICggc2lnaW5mbyApCm1heSBoYXZl
IG5vIGVmZmVjdCBpbiBzb21lIHB0cmFjZS1zdG9wcywgeWV0IHRoZSBjYWxsIG1heSBzdWNjZWVk
CihyZXR1cm4gMCBhbmQgbm90IHNldAouSVIgZXJybm8gKTsKcXVlcnlpbmcKLkIgUFRSQUNFX0dF
VEVWRU5UTVNHCm1heSBzdWNjZWVkIGFuZCByZXR1cm4gc29tZSByYW5kb20gdmFsdWUgaWYgY3Vy
cmVudCBwdHJhY2Utc3RvcAppcyBub3QgZG9jdW1lbnRlZCBhcyByZXR1cm5pbmcgYSBtZWFuaW5n
ZnVsIGV2ZW50IG1lc3NhZ2UuCi5MUApUaGUgY2FsbAoKICAgIHB0cmFjZShQVFJBQ0VfU0VUT1BU
SU9OUywgcGlkLCAwLCBQVFJBQ0VfT19mbGFncyk7CiAgICAKYWZmZWN0cyBvbmUgdHJhY2VlLgpU
aGUgdHJhY2VlJ3MgY3VycmVudCBmbGFncyBhcmUgcmVwbGFjZWQuCkZsYWdzIGFyZSBpbmhlcml0
ZWQgYnkgbmV3IHRyYWNlZXMgY3JlYXRlZCBhbmQgImF1dG8tYXR0YWNoZWQiIHZpYSBhY3RpdmUK
LkJSIFBUUkFDRV9PX1RSQUNFRk9SSyAsCi5CUiBQVFJBQ0VfT19UUkFDRVZGT1JLICwKb3IKLkJS
IFBUUkFDRV9PX1RSQUNFQ0xPTkUKb3B0aW9ucy4KLkxQCkFub3RoZXIgZ3JvdXAgb2YgY29tbWFu
ZHMgbWFrZXMgdGhlIHB0cmFjZS1zdG9wcGVkIHRyYWNlZSBydW4uClRoZXkgaGF2ZSB0aGUgZm9y
bToKLkxQCiAgICBwdHJhY2UoUFRSQUNFX2NtZCwgcGlkLCAwLCBzaWcpOwouTFAKd2hlcmUKLkkg
Y21kCmlzCi5CUiBQVFJBQ0VfQ09OVCAsCi5CUiBQVFJBQ0VfREVUQUNIICwKLkJSIFBUUkFDRV9T
WVNDQUxMICwKLkJSIFBUUkFDRV9TSU5HTEVTVEVQICwKLkJSIFBUUkFDRV9TWVNFTVUgLApvcgou
QlIgUFRSQUNFX1NZU0VNVV9TSU5HTEVTVEVQLgpJZiB0aGUgdHJhY2VlIGlzIGluIHNpZ25hbC1k
ZWxpdmVyeS1zdG9wLAouSSBzaWcKaXMgdGhlIHNpZ25hbCB0byBiZSBpbmplY3RlZCAoaWYgaXQg
aXMgbm9uemVybykuCk90aGVyd2lzZSwKLkkgc2lnCm1heSBiZSBpZ25vcmVkLgooUmVjb21tZW5k
ZWQgcHJhY3RpY2UgaXMgdG8gYWx3YXlzIHBhc3MgMCBpbiB0aGVzZSBjYXNlcy4pCi5TUyBBdHRh
Y2hpbmcgYW5kIGRldGFjaGluZwpBIHRocmVhZCBjYW4gYmUgYXR0YWNoZWQgdG8gdGhlIHRyYWNl
ciB1c2luZyB0aGUgY2FsbAoKICAgIHB0cmFjZShQVFJBQ0VfQVRUQUNILCBwaWQsIDAsIDApOwoK
VGhpcyBhbHNvIHNlbmRzCi5CIFNJR1NUT1AKdG8gdGhpcyB0aHJlYWQuCklmIHRoZSB0cmFjZXIg
d2FudHMgdGhpcwouQiBTSUdTVE9QCnRvIGhhdmUgbm8gZWZmZWN0LCBpdCBuZWVkcyB0byBzdXBw
cmVzcyBpdC4KTm90ZSB0aGF0IGlmIG90aGVyIHNpZ25hbHMgYXJlIGNvbmN1cnJlbnRseSBzZW50
IHRvCnRoaXMgdGhyZWFkIGR1cmluZyBhdHRhY2gsCnRoZSB0cmFjZXIgbWF5IHNlZSB0aGUgdHJh
Y2VlIGVudGVyIHNpZ25hbC1kZWxpdmVyeS1zdG9wCndpdGggb3RoZXIgc2lnbmFsKHMpIGZpcnN0
IQpUaGUgdXN1YWwgcHJhY3RpY2UgaXMgdG8gcmVpbmplY3QgdGhlc2Ugc2lnbmFscyB1bnRpbAou
QiBTSUdTVE9QCmlzIHNlZW4sIHRoZW4gc3VwcHJlc3MKLkIgU0lHU1RPUAppbmplY3Rpb24uCi5c
IgouXCIgRklYTUUgSSBzaWduaWZpY2FudGx5IHJld3JvdGUgdGhlIGZvbGxvd2luZyBzZW50ZW5j
ZSB0byB0cnkgdG8gbWFrZSBpdAouXCIgY2xlYXJlci4gSXMgdGhlIG1lYW5pbmcgc3RpbGwgcHJl
c2VydmVkPwpUaGUgZGVzaWduIGJ1ZyBoZXJlIGlzIHRoYXQgYSBwdHJhY2UgYXR0YWNoIGFuZCBh
IGNvbmN1cnJlbnRseSBkZWxpdmVyZWQKLkIgU0lHU1RPUAptYXkgcmFjZSBhbmQgdGhlIGNvbmN1
cnJlbnQKLkIgU0lHU1RPUAptYXkgYmUgbG9zdC4KLlwiCi5cIiBGSVhNRTogbXRrOiB0aGUgZm9s
bG93aW5nIGNvbW1lbnQgc2VlbXMgdG8gYmUgdW5yZXNvbHZlZD8KLlwiCSAgIERvIHlvdSB3YW50
IHRvIGFkZCBhbnkgdGV4dD8KLlwiCi5cIiAgICAgIERlc2NyaWJlIGhvdyB0byBhdHRhY2ggdG8g
YSB0aHJlYWQgd2hpY2ggaXMgYWxyZWFkeSBncm91cC1zdG9wcGVkLgouTFAKU2luY2UgYXR0YWNo
aW5nIHNlbmRzCi5CIFNJR1NUT1AKYW5kIHRoZSB0cmFjZXIgdXN1YWxseSBzdXBwcmVzc2VzIGl0
LCB0aGlzIG1heSBjYXVzZSBhIHN0cmF5Ci5JIEVJTlRSCnJldHVybiBmcm9tIHRoZSBjdXJyZW50
bHkgZXhlY3V0aW5nIHN5c3RlbSBjYWxsIGluIHRoZSB0cmFjZWUsCmFzIGRlc2NyaWJlZCBpbiB0
aGUgInNpZ25hbCBpbmplY3Rpb24gYW5kIHN1cHByZXNzaW9uIiBzZWN0aW9uLgouTFAKVGhlIHJl
cXVlc3QKCiAgICBwdHJhY2UoUFRSQUNFX1RSQUNFTUUsIDAsIDAsIDApOwoKdHVybnMgdGhlIGNh
bGxpbmcgdGhyZWFkIGludG8gYSB0cmFjZWUuClRoZSB0aHJlYWQgY29udGludWVzIHRvIHJ1biAo
ZG9lc24ndCBlbnRlciBwdHJhY2Utc3RvcCkuCkEgY29tbW9uIHByYWN0aWNlIGlzIHRvIGZvbGxv
dyB0aGUKLkIgUFRSQUNFX1RSQUNFTUUKd2l0aAoKICAgIHJhaXNlKFNJR1NUT1ApOwoKYW5kIGFs
bG93IHRoZSBwYXJlbnQgKHdoaWNoIGlzIG91ciB0cmFjZXIgbm93KSB0byBvYnNlcnZlIG91cgpz
aWduYWwtZGVsaXZlcnktc3RvcC4KLkxQCklmIHRoZSAKLkJSIFBUUkFDRV9PX1RSQUNFRk9SSyAs
Ci5CUiBQVFJBQ0VfT19UUkFDRVZGT1JLICwKb3IKLkJSIFBUUkFDRV9PX1RSQUNFQ0xPTkUKb3B0
aW9ucyBhcmUgaW4gZWZmZWN0LCB0aGVuIGNoaWxkcmVuIGNyZWF0ZWQgYnksIHJlc3BlY3RpdmVs
eSwKLkJSIHZmb3JrICgyKQpvcgouQlIgY2xvbmUgKDIpCndpdGggdGhlCi5CIENMT05FX1ZGT1JL
CmZsYWcsCi5CUiBmb3JrICgyKQpvcgouQlIgY2xvbmUgKDIpCndpdGggdGhlIGV4aXQgc2lnbmFs
IHNldCB0bwouQlIgU0lHQ0hMRCAsCmFuZCBvdGhlciBraW5kcyBvZgouQlIgY2xvbmUgKDIpLAph
cmUgYXV0b21hdGljYWxseSBhdHRhY2hlZCB0byB0aGUgc2FtZSB0cmFjZXIgd2hpY2ggdHJhY2Vk
IHRoZWlyIHBhcmVudC4KLkIgU0lHU1RPUAppcyBkZWxpdmVyZWQgdG8gdGhlIGNoaWxkcmVuLCBj
YXVzaW5nIHRoZW0gdG8gZW50ZXIKc2lnbmFsLWRlbGl2ZXJ5LXN0b3AgYWZ0ZXIgdGhleSBleGl0
IHRoZSBzeXN0ZW0gY2FsbCB3aGljaCBjcmVhdGVkIHRoZW0uCi5MUApEZXRhY2hpbmcgb2YgdGhl
IHRyYWNlZSBpcyBwZXJmb3JtZWQgYnk6CgogICAgcHRyYWNlKFBUUkFDRV9ERVRBQ0gsIHBpZCwg
MCwgc2lnKTsKCi5CIFBUUkFDRV9ERVRBQ0gKaXMgYSByZXN0YXJ0aW5nIG9wZXJhdGlvbjsKdGhl
cmVmb3JlIGl0IHJlcXVpcmVzIHRoZSB0cmFjZWUgdG8gYmUgaW4gcHRyYWNlLXN0b3AuCklmIHRo
ZSB0cmFjZWUgaXMgaW4gc2lnbmFsLWRlbGl2ZXJ5LXN0b3AsIGEgc2lnbmFsIGNhbiBiZSBpbmpl
Y3RlZC4KT3RoZXJ3aXNlLCB0aGUKLkkgc2lnCnBhcmFtZXRlciBtYXkgYmUgc2lsZW50bHkgaWdu
b3JlZC4KLkxQCklmIHRoZSB0cmFjZWUgaXMgcnVubmluZyB3aGVuIHRoZSB0cmFjZXIgd2FudHMg
dG8gZGV0YWNoIGl0LAp0aGUgdXN1YWwgc29sdXRpb24gaXMgdG8gc2VuZAouQiBTSUdTVE9QCih1
c2luZwouQlIgdGdraWxsICgyKSwKdG8gbWFrZSBzdXJlIGl0IGdvZXMgdG8gdGhlIGNvcnJlY3Qg
dGhyZWFkKSwKd2FpdCBmb3IgdGhlIHRyYWNlZSB0byBzdG9wIGluIHNpZ25hbC1kZWxpdmVyeS1z
dG9wIGZvcgouQiBTSUdTVE9QCmFuZCB0aGVuIGRldGFjaCBpdCAoc3VwcHJlc3NpbmcKLkIgU0lH
U1RPUAppbmplY3Rpb24pLgpBIGRlc2lnbiBidWcgaXMgdGhhdCB0aGlzIGNhbiByYWNlIHdpdGgg
Y29uY3VycmVudAouQlIgU0lHU1RPUCBzLgpBbm90aGVyIGNvbXBsaWNhdGlvbiBpcyB0aGF0IHRo
ZSB0cmFjZWUgbWF5IGVudGVyIG90aGVyIHB0cmFjZS1zdG9wcwphbmQgbmVlZHMgdG8gYmUgcmVz
dGFydGVkIGFuZCB3YWl0ZWQgZm9yIGFnYWluLCB1bnRpbAouQiBTSUdTVE9QCmlzIHNlZW4uClll
dCBhbm90aGVyIGNvbXBsaWNhdGlvbiBpcyB0byBiZSBzdXJlIHRoYXQKdGhlIHRyYWNlZSBpcyBu
b3QgYWxyZWFkeSBwdHJhY2Utc3RvcHBlZCwKYmVjYXVzZSBubyBzaWduYWwgZGVsaXZlcnkgaGFw
cGVucyB3aGlsZSBpdCBpc1woZW1ub3QgZXZlbgouQlIgU0lHU1RPUCAuCi5cIiBGSVhNRTogbXRr
OiB0aGUgZm9sbG93aW5nIGNvbW1lbnQgc2VlbXMgdG8gYmUgdW5yZXNvbHZlZD8KLlwiICAgICAg
IERvIHlvdSB3YW50IHRvIGFkZCBhbnl0aGluZz8KLlwiCi5cIiAgICAgRGVzY3JpYmUgaG93IHRv
IGRldGFjaCBmcm9tIGEgZ3JvdXAtc3RvcHBlZCB0cmFjZWUgc28gdGhhdCBpdAouXCIgICAgIGRv
ZXNuJ3QgcnVuLCBidXQgY29udGludWVzIHRvIHdhaXQgZm9yIFNJR0NPTlQuCi5cIgouTFAKSWYg
dGhlIHRyYWNlciBkaWVzLCBhbGwgdHJhY2VlcyBhcmUgYXV0b21hdGljYWxseSBkZXRhY2hlZCBh
bmQgcmVzdGFydGVkLAp1bmxlc3MgdGhleSB3ZXJlIGluIGdyb3VwLXN0b3AuCkhhbmRsaW5nIG9m
IHJlc3RhcnQgZnJvbSBncm91cC1zdG9wIGlzCi5cIiBGSVhNRTogRGVmaW5lIGN1cnJlbnRseQpj
dXJyZW50bHkgYnVnZ3ksIGJ1dCB0aGUKLlwiIEZJWE1FOiBQbGFubmVkIGZvciB3aGVuPwoiYXMg
cGxhbm5lZCIgYmVoYXZpb3IgaXMgdG8gbGVhdmUgdHJhY2VlIHN0b3BwZWQgYW5kIHdhaXRpbmcg
Zm9yCi5CUiBTSUdDT05UIC4KSWYgdGhlIHRyYWNlZSBpcyByZXN0YXJ0ZWQgZnJvbSBzaWduYWwt
ZGVsaXZlcnktc3RvcCwKdGhlIHBlbmRpbmcgc2lnbmFsIGlzIGluamVjdGVkLgouU1MgZXhlY3Zl
KDIpIHVuZGVyIHB0cmFjZQouXCIgY2xvbmUoMikgVEhSRUFEX0NMT05FIHNheXM6Ci5cIiAgICAg
SWYgIGFueSAgb2YgdGhlIHRocmVhZHMgaW4gYSB0aHJlYWQgZ3JvdXAgcGVyZm9ybXMgYW4gZXhl
Y3ZlKDIpLAouXCIgICAgIHRoZW4gYWxsIHRocmVhZHMgb3RoZXIgdGhhbiB0aGUgdGhyZWFkIGdy
b3VwIGxlYWRlciBhcmUgdGVybWluYXRlZCwKLlwiICAgICBhbmQgdGhlIG5ldyBwcm9ncmFtIGlz
IGV4ZWN1dGVkIGluIHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyLiAgCi5cIgouXCIgRklYTUUgbXRr
LWFkZGl0aW9uOiAgcGxlYXNlIGNoZWNrOiBJIGFkZGVkIHRoZSBmb2xsb3dpbmcgcGllY2UgdG8K
LlwiICAgICAgIGNsYXJpZnkgdGhhdCBtdWx0aXRocmVhZGVkIGhlcmUgbWVhbnMgY2xvbmUoKStD
TE9ORV9USFJFQUQKLlwiCldoZW4gb25lIHRocmVhZCBpbiBhIG11bHRpdGhyZWFkZWQgcHJvY2Vz
cwooaS5lLiwgYSB0aHJlYWQgZ3JvdXAgY29uc2lzdGluZyBvZiB0aHJlYWRzIGNyZWF0ZWQgdXNp
bmcgdGhlCi5CUiBjbG9uZSAoMikKLkIgQ0xPTkVfVEhSRUFECmZsYWcpIGNhbGxzCi5cIiBGSVhN
RSBlbmQtbXRrLWFkZGl0aW9uCi5cIgouQlIgZXhlY3ZlICgyKSwKdGhlIGtlcm5lbCBkZXN0cm95
cyBhbGwgb3RoZXIgdGhyZWFkcyBpbiB0aGUgcHJvY2VzcywKLlwiIEluIGtlcm5lbCAzLjEgc291
cmNlcywgc2VlIGZzL2V4ZWMuYzo6ZGVfdGhyZWFkKCkKYW5kIHJlc2V0cyB0aGUgdGhyZWFkIElE
IG9mIHRoZSBleGVjaW5nIHRocmVhZCB0byB0aGUKdGhyZWFkIGdyb3VwIElEIChwcm9jZXNzIElE
KS4KLlwiCi5cIiBGSVhNRSBtdGstYWRkaXRpb246ICBwbGVhc2UgY2hlY2s6IEkgYWRkZWQgdGhl
IGZvbGxvd2luZyBwaWVjZToKKE9yLCB0byBwdXQgdGhpbmdzIGFub3RoZXIgd2F5LCB3aGVuIGEg
bXVsdGl0aHJlYWRlZCBwcm9jZXNzIGRvZXMgYW4KLkJSIGV4ZWN2ZSAoMiksCnRoZSBrZXJuZWwg
bWFrZXMgaXQgbG9vayBhcyB0aG91Z2ggdGhlCi5CUiBleGVjdmUgKDIpCm9jY3VycmVkIGluIHRo
ZSB0aHJlYWQgZ3JvdXAgbGVhZGVyLCByZWdhcmRsZXNzIG9mIHdoaWNoIHRocmVhZCBkaWQgdGhl
Ci5CUiBleGVjdmUgKDIpLikKLlwiIEZJWE1FIGVuZC1tdGstYWRkaXRpb24KLlwiClRoaXMgcmVz
ZXR0aW5nIG9mIHRoZSB0aHJlYWQgSUQgbG9va3MgdmVyeSBjb25mdXNpbmcgdG8gdHJhY2VyczoK
LklQICogMwpBbGwgb3RoZXIgdGhyZWFkcyBzdG9wIGluCi5cIiBGSVhNRTogbXRrOiBXaGF0IGlz
ICJQVFJBQ0VfRVhJVCBzdG9wIj8KLlwiICAgICAgICBTaG91bGQgdGhhdCBiZSAiUFRSQUNFX0VW
RU5UX0VYSVQgc3RvcCI/Ci5CIFBUUkFDRV9FWElUCnN0b3AsCi5cIiBGSVhNRTogbXRrOiBJbiB0
aGUgbmV4dCBsaW5lLCAiYnkgYWN0aXZlIHB0cmFjZSBvcHRpb24iIGlzIHVuY2xlYXIuCi5cIiAg
ICAgICAgV2hhdCBkb2VzIGl0IG1lYW4/CmlmIHJlcXVlc3RlZCBieSBhY3RpdmUgcHRyYWNlIG9w
dGlvbi4KVGhlbiBhbGwgb3RoZXIgdGhyZWFkcyBleGNlcHQgdGhlIHRocmVhZCBncm91cCBsZWFk
ZXIgcmVwb3J0CmRlYXRoIGFzIGlmIHRoZXkgZXhpdGVkIHZpYQouQlIgX2V4aXQgKDIpCndpdGgg
ZXhpdCBjb2RlIDAuClRoZW4KLkIgUFRSQUNFX0VWRU5UX0VYRUMKLlwiIEZJWE1FOiBtdGs6IElu
IHRoZSBuZXh0IGxpbmUsICJieSBhY3RpdmUgcHRyYWNlIG9wdGlvbiIgaXMgdW5jbGVhcgouXCIg
ICAgICAgIFdoYXQgZG9lcyBpdCBtZWFuPwpzdG9wIGhhcHBlbnMsIGlmIHJlcXVlc3RlZCBieSBh
Y3RpdmUgcHRyYWNlIG9wdGlvbi4KLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dpbmcgY29tbWVu
dCBzZWVtcyB0byBiZSB1bnJlc29sdmVkPwouXCIgICAgICAgKG9uIHdoaWNoIHRyYWNlZSAtIGxl
YWRlcj8gZXhlY3ZlLWluZyBvbmU/KQouXCIgCi5cIiBGSVhNRTogUGxlYXNlIGNoZWNrOiBhdCB2
YXJpb3VzIHBsYWNlcyBpbiB0aGUgZm9sbG93aW5nLAouXCIgICAgICAgIEkgaGF2ZSBjaGFuZ2Vk
ICJwaWQiIHRvICJbdGhlIHRyYWNlZSdzXSB0aGVhZCBJRCIKLlwiICAgICAgICBJcyB0aGF0IG9r
YXk/Ci5JUCAqClRoZSBleGVjaW5nIHRyYWNlZSBjaGFuZ2VzIGl0cyB0aHJlYWQgSUQgd2hpbGUg
aXQgaXMgaW4gdGhlCi5CUiBleGVjdmUgKDIpLgooUmVtZW1iZXIsIHVuZGVyIHB0cmFjZSwgdGhl
ICJwaWQiIHJldHVybmVkIGZyb20KLkJSIHdhaXRwaWQgKDIpLApvciBmZWQgaW50byBwdHJhY2Ug
Y2FsbHMsIGlzIHRoZSB0cmFjZWUncyB0aHJlYWQgSUQuKQpUaGF0IGlzLCB0aGUgdHJhY2VlJ3Mg
dGhyZWFkIElEIGlzIHJlc2V0IHRvIGJlIHRoZSBzYW1lIGFzIGl0cyBwcm9jZXNzIElELAp3aGlj
aCBpcyB0aGUgc2FtZSBhcyB0aGUgdGhyZWFkIGdyb3VwIGxlYWRlcidzIHRocmVhZCBJRC4KLklQ
ICoKSWYgdGhlIHRocmVhZCBncm91cCBsZWFkZXIgaGFzIHJlcG9ydGVkIGl0cyBkZWF0aCBieSB0
aGlzIHRpbWUsCml0IGFwcGVhcnMgdG8gdGhlIHRyYWNlciB0aGF0CnRoZSBkZWFkIHRocmVhZCBs
ZWFkZXIgInJlYXBwZWFycyBmcm9tIG5vd2hlcmUiLgpJZiB0aGUgdGhyZWFkIGdyb3VwIGxlYWRl
ciB3YXMgc3RpbGwgYWxpdmUsCmZvciB0aGUgdHJhY2VyIHRoaXMgbWF5IGxvb2sgYXMgaWYgdGhy
ZWFkIGdyb3VwIGxlYWRlcgpyZXR1cm5zIGZyb20gYSBkaWZmZXJlbnQgc3lzdGVtIGNhbGwgdGhh
biBpdCBlbnRlcmVkLApvciBldmVuICJyZXR1cm5lZCBmcm9tIGEgc3lzdGVtIGNhbGwgZXZlbiB0
aG91Z2gKaXQgd2FzIG5vdCBpbiBhbnkgc3lzdGVtIGNhbGwiLgpJZiB0aGUgdGhyZWFkIGdyb3Vw
IGxlYWRlciB3YXMgbm90IHRyYWNlZAoob3Igd2FzIHRyYWNlZCBieSBhIGRpZmZlcmVudCB0cmFj
ZXIpLCB0aGVuIGR1cmluZwouQlIgZXhlY3ZlICgyKQppdCB3aWxsIGFwcGVhciBhcyBpZiBpdCBo
YXMgYmVjb21lIGEgdHJhY2VlIG9mCnRoZSB0cmFjZXIgb2YgdGhlIGV4ZWNpbmcgdHJhY2VlLgou
TFAKQWxsIG9mIHRoZSBhYm92ZSBlZmZlY3RzIGFyZSB0aGUgYXJ0aWZhY3RzIG9mCnRoZSB0aHJl
YWQgSUQgY2hhbmdlIGluIHRoZSB0cmFjZWUuCi5MUApUaGUKLkIgUFRSQUNFX09fVFJBQ0VFWEVD
Cm9wdGlvbiBpcyB0aGUgcmVjb21tZW5kZWQgdG9vbCBmb3IgZGVhbGluZyB3aXRoIHRoaXMgc2l0
dWF0aW9uLgpJdCBlbmFibGVzCi5CIFBUUkFDRV9FVkVOVF9FWEVDCnN0b3AsIHdoaWNoIG9jY3Vy
cyBiZWZvcmUKLkJSIGV4ZWN2ZSAoMikKcmV0dXJucy4KLlwiIEZJWE1FIEZvbGxvd2luZyBvbiBm
cm9tIHRoZSBwcmV2aW91cyBzZW50ZW5jZXMsCi5cIiAgICAgICBjYW4vc2hvdWxkIHdlIGFkZCBh
IGZldyBtb3JlIHdvcmRzIG9uIGhvdwouXCIgICAgICAgUFRSQUNFX0VWRU5UX0VYRUMgc3RvcCBo
ZWxwcyB1cyBkZWFsIHdpdGggdGhpcyBzaXR1YXRpb24/Ci5MUApUaGUgdGhyZWFkIElEIGNoYW5n
ZSBoYXBwZW5zIGJlZm9yZQouQiBQVFJBQ0VfRVZFTlRfRVhFQwpzdG9wLCBub3QgYWZ0ZXIuCi5M
UApXaGVuIHRoZSB0cmFjZXIgcmVjZWl2ZXMKLkIgUFRSQUNFX0VWRU5UX0VYRUMKc3RvcCBub3Rp
ZmljYXRpb24sCml0IGlzIGd1YXJhbnRlZWQgdGhhdCBleGNlcHQgdGhpcyB0cmFjZWUgYW5kIHRo
ZSB0aHJlYWQgZ3JvdXAgbGVhZGVyLApubyBvdGhlciB0aHJlYWRzIGZyb20gdGhlIHByb2Nlc3Mg
YXJlIGFsaXZlLgouTFAKT24gcmVjZWl2aW5nIHRoZQouQiBQVFJBQ0VfRVZFTlRfRVhFQwpzdG9w
IG5vdGlmaWNhdGlvbiwKdGhlIHRyYWNlciBzaG91bGQgY2xlYW4gdXAgYWxsIGl0cyBpbnRlcm5h
bApkYXRhIHN0cnVjdHVyZXMgZGVzY3JpYmluZyB0aGUgdGhyZWFkcyBvZiB0aGlzIHByb2Nlc3Ms
CmFuZCByZXRhaW4gb25seSBvbmUgZGF0YSBzdHJ1Y3R1cmVcKGVtb25lIHdoaWNoCmRlc2NyaWJl
cyB0aGUgc2luZ2xlIHN0aWxsIHJ1bm5pbmcgdHJhY2VlLCB3aXRoCgogICAgdGhyZWFkIElEID09
IHRocmVhZCBncm91cCBJRCA9PSBwcm9jZXNzIGlkLgouTFAKQ3VycmVudGx5LCB0aGVyZSBpcyBu
byB3YXkgdG8gcmV0cmlldmUgdGhlIGZvcm1lcgp0aHJlYWQgSUQgb2YgdGhlIGV4ZWNpbmcgdHJh
Y2VlLgpJZiB0aGUgdHJhY2VyIGRvZXNuJ3Qga2VlcCB0cmFjayBvZiBpdHMgdHJhY2VlcycgdGhy
ZWFkIGdyb3VwIHJlbGF0aW9ucywKaXQgbWF5IGJlIHVuYWJsZSB0byBrbm93IHdoaWNoIHRyYWNl
ZSBleGVjZWQgYW5kIHRoZXJlZm9yZSBubyBsb25nZXIKZXhpc3RzIHVuZGVyIHRoZSBvbGQgdGhy
ZWFkIElEIGR1ZSB0byBhIHRocmVhZCBJRCBjaGFuZ2UuCi5MUApFeGFtcGxlOiB0d28gdGhyZWFk
cyBjYWxsCi5CUiBleGVjdmUgKDIpCmF0IHRoZSBzYW1lIHRpbWU6Ci5MUAoubmYKKioqIHdlIGdl
dCBzeXNjYWxsLWVudHJ5LXN0b3AgaW4gdGhyZWFkIDE6ICoqClBJRDEgZXhlY3ZlKCIvYmluL2Zv
byIsICJmb28iIDx1bmZpbmlzaGVkIC4uLj4KKioqIHdlIGlzc3VlIFBUUkFDRV9TWVNDQUxMIGZv
ciB0aHJlYWQgMSAqKgoqKiogd2UgZ2V0IHN5c2NhbGwtZW50cnktc3RvcCBpbiB0aHJlYWQgMjog
KioKUElEMiBleGVjdmUoIi9iaW4vYmFyIiwgImJhciIgPHVuZmluaXNoZWQgLi4uPgoqKiogd2Ug
aXNzdWUgUFRSQUNFX1NZU0NBTEwgZm9yIHRocmVhZCAyICoqCioqKiB3ZSBnZXQgUFRSQUNFX0VW
RU5UX0VYRUMgZm9yIFBJRDAsIHdlIGlzc3VlIFBUUkFDRV9TWVNDQUxMICoqCioqKiB3ZSBnZXQg
c3lzY2FsbC1leGl0LXN0b3AgZm9yIFBJRDA6ICoqClBJRDAgPC4uLiBleGVjdmUgcmVzdW1lZD4g
KSAgICAgICAgICAgICA9IDAKLmZpCi5MUApJbiB0aGlzIHNpdHVhdGlvbiwgdGhlcmUgaXMgbm8g
d2F5IHRvIGtub3cgd2hpY2gKLkJSIGV4ZWN2ZSAoMikKc3VjY2VlZGVkLgouTFAKSWYgdGhlCi5C
IFBUUkFDRV9PX1RSQUNFRVhFQwpvcHRpb24gaXMKLkkgbm90CmluIGVmZmVjdCBmb3IgdGhlIGV4
ZWNpbmcgdHJhY2VlLCB0aGUga2VybmVsIGRlbGl2ZXJzIGFuIGV4dHJhCi5CIFNJR1RSQVAKdG8g
dGhlIHRyYWNlZSBhZnRlcgouQlIgZXhlY3ZlICgyKQpyZXR1cm5zLgpUaGlzIGlzIGFuIG9yZGlu
YXJ5IHNpZ25hbCAoc2ltaWxhciB0byBvbmUgd2hpY2ggY2FuIGJlCmdlbmVyYXRlZCBieQouSVIg
ImtpbGwgLVRSQVAiICksCm5vdCBhIHNwZWNpYWwga2luZCBvZiBwdHJhY2Utc3RvcC4KRW1wbG95
aW5nCi5CIFBUUkFDRV9HRVRTSUdJTkZPCmZvciB0aGlzIHNpZ25hbCByZXR1cm5zCi5JIHNpX2Nv
ZGUKc2V0IHRvIDAKLlJJICggU0lfVVNFUiApLgpUaGlzIHNpZ25hbCBtYXkgYmUgYmxvY2tlZCBi
eSBzaWduYWwgbWFzaywKYW5kIHRodXMgbWF5IGJlIGRlbGl2ZXJlZCAobXVjaCkgbGF0ZXIuCi5M
UApVc3VhbGx5LCB0aGUgdHJhY2VyIChmb3IgZXhhbXBsZSwKLkJSIHN0cmFjZSAoMSkpCndvdWxk
IG5vdCB3YW50IHRvIHNob3cgdGhpcyBleHRyYSBwb3N0LWV4ZWN2ZQouQiBTSUdUUkFQCnNpZ25h
bCB0byB0aGUgdXNlciwgYW5kIHdvdWxkIHN1cHByZXNzIGl0cyBkZWxpdmVyeSB0byB0aGUgdHJh
Y2VlIChpZgouQiBTSUdUUkFQCmlzIHNldCB0bwouQlIgU0lHX0RGTCAsCml0IGlzIGEga2lsbGlu
ZyBzaWduYWwpLgpIb3dldmVyLCBkZXRlcm1pbmluZyAKLkkgd2hpY2gKLkIgU0lHVFJBUAp0byBz
dXBwcmVzcyBpcyBub3QgZWFzeS4KU2V0dGluZyB0aGUKLkIgUFRSQUNFX09fVFJBQ0VFWEVDCm9w
dGlvbiBhbmQgdGh1cyBzdXBwcmVzc2luZyB0aGlzIGV4dHJhCi5CIFNJR1RSQVAKaXMgdGhlIHJl
Y29tbWVuZGVkIGFwcHJvYWNoLgouU1MgUmVhbCBwYXJlbnQKVGhlIHB0cmFjZSBBUEkgKGFiKXVz
ZXMgdGhlIHN0YW5kYXJkIFVOSVggcGFyZW50L2NoaWxkIHNpZ25hbGluZyBvdmVyCi5CUiB3YWl0
cGlkICgyKS4KVGhpcyB1c2VkIHRvIGNhdXNlIHRoZSByZWFsIHBhcmVudCBvZiB0aGUgcHJvY2Vz
cyB0byBzdG9wIHJlY2VpdmluZwpzZXZlcmFsIGtpbmRzIG9mCi5CUiB3YWl0cGlkICgyKQpub3Rp
ZmljYXRpb25zIHdoZW4gdGhlIGNoaWxkIHByb2Nlc3MgaXMgdHJhY2VkIGJ5IHNvbWUgb3RoZXIg
cHJvY2Vzcy4KLkxQCk1hbnkgb2YgdGhlc2UgYnVncyBoYXZlIGJlZW4gZml4ZWQsIGJ1dCBhcyBv
ZiBMaW51eCAyLjYuMzggc2V2ZXJhbCBzdGlsbApleGlzdDsgc2VlIEJVR1MgYmVsb3cuCi5MUApB
cyBvZiBMaW51eCAyLjYuMzgsIHRoZSBmb2xsb3dpbmcgaXMgYmVsaWV2ZWQgdG8gd29yayBjb3Jy
ZWN0bHk6Ci5JUCAqIDMKZXhpdC9kZWF0aCBieSBzaWduYWwgaXMgcmVwb3J0ZWQgZmlyc3QgdG8g
dGhlIHRyYWNlciwgdGhlbiwgd2hlbiB0aGUgdHJhY2VyCmNvbnN1bWVzIHRoZQouQlIgd2FpdHBp
ZCAoMikKcmVzdWx0LCB0byB0aGUgcmVhbCBwYXJlbnQgKHRvIHRoZSByZWFsIHBhcmVudCBvbmx5
IHdoZW4gdGhlCndob2xlIG11bHRpdGhyZWFkZWQgcHJvY2VzcyBleGl0cykuCi5cIgouXCIgRklY
TUUgbXRrOiBQbGVhc2UgY2hlY2s6IEluIHRoZSBuZXh0IGxpbmUsIAouXCIgSSBjaGFuZ2VkICJ0
aGV5IiB0byAidGhlIHRyYWNlciBhbmQgdGhlIHJlYWwgcGFyZW50Ii4gT2theT8KSWYgdGhlIHRy
YWNlciBhbmQgdGhlIHJlYWwgcGFyZW50IGFyZSB0aGUgc2FtZSBwcm9jZXNzLAp0aGUgcmVwb3J0
IGlzIHNlbnQgb25seSBvbmNlLgouU0ggIlJFVFVSTiBWQUxVRSIKT24gc3VjY2VzcywKLkIgUFRS
QUNFX1BFRUsqCnJlcXVlc3RzIHJldHVybiB0aGUgcmVxdWVzdGVkIGRhdGEsCndoaWxlIG90aGVy
IHJlcXVlc3RzIHJldHVybiB6ZXJvLgpPbiBlcnJvciwgYWxsIHJlcXVlc3RzIHJldHVybiBcLTEs
IGFuZAouSSBlcnJubwppcyBzZXQgYXBwcm9wcmlhdGVseS4KU2luY2UgdGhlIHZhbHVlIHJldHVy
bmVkIGJ5IGEgc3VjY2Vzc2Z1bAouQiBQVFJBQ0VfUEVFSyoKcmVxdWVzdCBtYXkgYmUgXC0xLCB0
aGUgY2FsbGVyIG11c3QgY2xlYXIKLkkgZXJybm8KYmVmb3JlIHRoZSBjYWxsLCBhbmQgdGhlbiBj
aGVjayBpdCBhZnRlcndhcmQKdG8gZGV0ZXJtaW5lIHdoZXRoZXIgb3Igbm90IGFuIGVycm9yIG9j
Y3VycmVkLgouU0ggRVJST1JTCi5UUAouQiBFQlVTWQooaTM4NiBvbmx5KSBUaGVyZSB3YXMgYW4g
ZXJyb3Igd2l0aCBhbGxvY2F0aW5nIG9yIGZyZWVpbmcgYSBkZWJ1ZyByZWdpc3Rlci4KLlRQCi5C
IEVGQVVMVApUaGVyZSB3YXMgYW4gYXR0ZW1wdCB0byByZWFkIGZyb20gb3Igd3JpdGUgdG8gYW4g
aW52YWxpZCBhcmVhIGluCnRoZSB0cmFjZXIncyBvciB0aGUgdHJhY2VlJ3MgbWVtb3J5LApwcm9i
YWJseSBiZWNhdXNlIHRoZSBhcmVhIHdhc24ndCBtYXBwZWQgb3IgYWNjZXNzaWJsZS4KVW5mb3J0
dW5hdGVseSwgdW5kZXIgTGludXgsIGRpZmZlcmVudCB2YXJpYXRpb25zIG9mIHRoaXMgZmF1bHQK
d2lsbCByZXR1cm4KLkIgRUlPCm9yCi5CIEVGQVVMVAptb3JlIG9yIGxlc3MgYXJiaXRyYXJpbHku
Ci5UUAouQiBFSU5WQUwKQW4gYXR0ZW1wdCB3YXMgbWFkZSB0byBzZXQgYW4gaW52YWxpZCBvcHRp
b24uCi5UUAouQiBFSU8KLkkgcmVxdWVzdAppcyBpbnZhbGlkLCBvciBhbiBhdHRlbXB0IHdhcyBt
YWRlIHRvIHJlYWQgZnJvbSBvcgp3cml0ZSB0byBhbiBpbnZhbGlkIGFyZWEgaW4gdGhlIHRyYWNl
cidzIG9yIHRoZSB0cmFjZWUncyBtZW1vcnksCm9yIHRoZXJlIHdhcyBhIHdvcmQtYWxpZ25tZW50
IHZpb2xhdGlvbiwKb3IgYW4gaW52YWxpZCBzaWduYWwgd2FzIHNwZWNpZmllZCBkdXJpbmcgYSBy
ZXN0YXJ0IHJlcXVlc3QuCi5UUAouQiBFUEVSTQpUaGUgc3BlY2lmaWVkIHByb2Nlc3MgY2Fubm90
IGJlIHRyYWNlZC4KVGhpcyBjb3VsZCBiZSBiZWNhdXNlIHRoZQp0cmFjZXIgaGFzIGluc3VmZmlj
aWVudCBwcml2aWxlZ2VzICh0aGUgcmVxdWlyZWQgY2FwYWJpbGl0eSBpcwouQlIgQ0FQX1NZU19Q
VFJBQ0UgKTsKdW5wcml2aWxlZ2VkIHByb2Nlc3NlcyBjYW5ub3QgdHJhY2UgcHJvY2Vzc2VzIHRo
YXQgdGhleQpjYW5ub3Qgc2VuZCBzaWduYWxzIHRvIG9yIHRob3NlIHJ1bm5pbmcKc2V0LXVzZXIt
SUQvc2V0LWdyb3VwLUlEIHByb2dyYW1zLCBmb3Igb2J2aW91cyByZWFzb25zLgouXCIgCi5cIiBG
SVhNRSBJIHJld29ya2VkIHRoZSBtZW50aW9uIG9mIGluaXQgaGVyZSB0byBub3RlCi5cIiB3aGVu
IHRoZSBiZWhhdmlvciBjaGFuZ2VkIGZvciB0cmFjaW5nIGluaXQoOCkuIE9rYXk/CkFsdGVybmF0
aXZlbHksIHRoZSBwcm9jZXNzIG1heSBhbHJlYWR5IGJlIGJlaW5nIHRyYWNlZCwKb3IgKG9uIGtl
cm5lbHMgYmVmb3JlIDIuNi4yNikgYmUKLkJSIGluaXQgKDgpCihQSUQgMSkuCi5UUAouQiBFU1JD
SApUaGUgc3BlY2lmaWVkIHByb2Nlc3MgZG9lcyBub3QgZXhpc3QsIG9yIGlzIG5vdCBjdXJyZW50
bHkgYmVpbmcgdHJhY2VkCmJ5IHRoZSBjYWxsZXIsIG9yIGlzIG5vdCBzdG9wcGVkCihmb3IgcmVx
dWVzdHMgdGhhdCByZXF1aXJlIGEgc3RvcHBlZCB0cmFjZWUpLgouU0ggIkNPTkZPUk1JTkcgVE8i
ClNWcjQsIDQuM0JTRC4KLlNIIE5PVEVTCkFsdGhvdWdoIGFyZ3VtZW50cyB0bwouQlIgcHRyYWNl
ICgpCmFyZSBpbnRlcnByZXRlZCBhY2NvcmRpbmcgdG8gdGhlIHByb3RvdHlwZSBnaXZlbiwKZ2xp
YmMgY3VycmVudGx5IGRlY2xhcmVzCi5CUiBwdHJhY2UgKCkKYXMgYSB2YXJpYWRpYyBmdW5jdGlv
biB3aXRoIG9ubHkgdGhlCi5JIHJlcXVlc3QKYXJndW1lbnQgZml4ZWQuClRoaXMgbWVhbnMgdGhh
dCB1bm5lZWRlZCB0cmFpbGluZyBhcmd1bWVudHMgbWF5IGJlIG9taXR0ZWQsCnRob3VnaCBkb2lu
ZyBzbyBtYWtlcyB1c2Ugb2YgdW5kb2N1bWVudGVkCi5CUiBnY2MgKDEpCmJlaGF2aW9yLgouXCIg
RklYTUUgUGxlYXNlIHJldmlldy4gSSByZWluc3RhdGVkIHRoZSBmb2xsb3dpbmcsIG5vdGluZyB0
aGUKLlwiIGtlcm5lbCB2ZXJzaW9uIG51bWJlciB3aGVyZSBpdCBjZWFzZWQgdG8gYmUgdHJ1ZQou
TFAKSW4gTGludXgga2VybmVscyBiZWZvcmUgMi42LjI2LAouXCIgU2VlIGNvbW1pdCAwMGNkNWMz
N2FmZDVmNDMxYWMxODZkZDEzMTcwNTA0OGMwYTExZmRiCi5CUiBpbml0ICg4KSwKdGhlIHByb2Nl
c3Mgd2l0aCBQSUQgMSwgbWF5IG5vdCBiZSB0cmFjZWQuCi5MUApUaGUgbGF5b3V0IG9mIHRoZSBj
b250ZW50cyBvZiBtZW1vcnkgYW5kIHRoZSBVU0VSIGFyZWEgYXJlCnF1aXRlIG9wZXJhdGluZy1z
eXN0ZW0tIGFuZCBhcmNoaXRlY3R1cmUtc3BlY2lmaWMuClRoZSBvZmZzZXQgc3VwcGxpZWQsIGFu
ZCB0aGUgZGF0YSByZXR1cm5lZCwKbWlnaHQgbm90IGVudGlyZWx5IG1hdGNoIHdpdGggdGhlIGRl
ZmluaXRpb24gb2YKLklSICJzdHJ1Y3QgdXNlciIgLgouXCIgU2VlIGh0dHA6Ly9sa21sLm9yZy9s
a21sLzIwMDgvNS84LzM3NQouTFAKVGhlIHNpemUgb2YgYSAid29yZCIgaXMgZGV0ZXJtaW5lZCBi
eSB0aGUgb3BlcmF0aW5nLXN5c3RlbSB2YXJpYW50CihlLmcuLCBmb3IgMzItYml0IExpbnV4IGl0
IGlzIDMyIGJpdHMsIGV0Yy4pLgouXCIgRklYTUUgU28sIGNhbiB3ZSBqdXN0IHJlbW92ZSB0aGUg
Zm9sbG93aW5nIHRleHQ/Ci5cIgouXCIgQ292ZXJlZCBpbiBtb3JlIGRldGFpbHMgYWJvdmU6IChy
ZW1vdmVkIGJ5IGR2KQouXCIgLkxQCi5cIiBUcmFjaW5nIGNhdXNlcyBhIGZldyBzdWJ0bGUgZGlm
ZmVyZW5jZXMgaW4gdGhlIHNlbWFudGljcyBvZgouXCIgdHJhY2VkIHByb2Nlc3Nlcy4KLlwiIEZv
ciBleGFtcGxlLCBpZiBhIHByb2Nlc3MgaXMgYXR0YWNoZWQgdG8gd2l0aAouXCIgLkJSIFBUUkFD
RV9BVFRBQ0ggLAouXCIgaXRzIG9yaWdpbmFsIHBhcmVudCBjYW4gbm8gbG9uZ2VyIHJlY2VpdmUg
bm90aWZpY2F0aW9uIHZpYQouXCIgLkJSIHdhaXRwaWQgKDIpCi5cIiB3aGVuIGl0IHN0b3BzLCBh
bmQgdGhlcmUgaXMgbm8gd2F5IGZvciB0aGUgbmV3IHBhcmVudCB0bwouXCIgZWZmZWN0aXZlbHkg
c2ltdWxhdGUgdGhpcyBub3RpZmljYXRpb24uCi5cIiAuTFAKLlwiIFdoZW4gdGhlIHBhcmVudCBy
ZWNlaXZlcyBhbiBldmVudCB3aXRoCi5cIiAuQiBQVFJBQ0VfRVZFTlRfKgouXCIgc2V0LAouXCIg
dGhlIHRyYWNlZSBpcyBub3QgaW4gdGhlIG5vcm1hbCBzaWduYWwgZGVsaXZlcnkgcGF0aC4KLlwi
IFRoaXMgbWVhbnMgdGhlIHBhcmVudCBjYW5ub3QgZG8KLlwiIC5CUiBwdHJhY2UgKFBUUkFDRV9D
T05UKQouXCIgd2l0aCBhIHNpZ25hbCBvcgouXCIgLkJSIHB0cmFjZSAoUFRSQUNFX0tJTEwpLgou
XCIgLkJSIGtpbGwgKDIpCi5cIiB3aXRoIGEKLlwiIC5CIFNJR0tJTEwKLlwiIHNpZ25hbCBjYW4g
YmUgdXNlZCBpbnN0ZWFkIHRvIGtpbGwgdGhlIHRyYWNlZQouXCIgYWZ0ZXIgcmVjZWl2aW5nIG9u
ZSBvZiB0aGVzZSBtZXNzYWdlcy4KLlwiIC5MUApUaGlzIHBhZ2UgZG9jdW1lbnRzIHRoZSB3YXkg
dGhlCi5CUiBwdHJhY2UgKCkKY2FsbCB3b3JrcyBjdXJyZW50bHkgaW4gTGludXguCkl0cyBiZWhh
dmlvciBkaWZmZXJzIG5vdGljZWFibHkgb24gb3RoZXIgZmxhdm9ycyBvZiBVTklYLgpJbiBhbnkg
Y2FzZSwgdXNlIG9mCi5CUiBwdHJhY2UgKCkKaXMgaGlnaGx5IHNwZWNpZmljIHRvIHRoZSBvcGVy
YXRpbmcgc3lzdGVtIGFuZCBhcmNoaXRlY3R1cmUuCi5TSCBCVUdTCk9uIGhvc3RzIHdpdGggMi42
IGtlcm5lbCBoZWFkZXJzLAouQiBQVFJBQ0VfU0VUT1BUSU9OUwppcyBkZWNsYXJlZCB3aXRoIGEg
ZGlmZmVyZW50IHZhbHVlIHRoYW4gdGhlIG9uZSBmb3IgMi40LgpUaGlzIGxlYWRzIHRvIGFwcGxp
Y2F0aW9ucyBjb21waWxlZCB3aXRoIDIuNiBrZXJuZWwKaGVhZGVycyBmYWlsaW5nIHdoZW4gcnVu
IG9uIDIuNCBrZXJuZWxzLgpUaGlzIGNhbiBiZSB3b3JrZWQgYXJvdW5kIGJ5IHJlZGVmaW5pbmcK
LkIgUFRSQUNFX1NFVE9QVElPTlMKdG8KLkJSIFBUUkFDRV9PTERTRVRPUFRJT05TICwKaWYgdGhh
dCBpcyBkZWZpbmVkLgouTFAKR3JvdXAtc3RvcCBub3RpZmljYXRpb25zIGFyZSBzZW50IHRvIHRo
ZSB0cmFjZXIsIGJ1dCBub3QgdG8gcmVhbCBwYXJlbnQuCkxhc3QgY29uZmlybWVkIG9uIDIuNi4z
OC42LgouTFAKLlwiIAouXCIgRklYTUUgRG9lcyAiZXhpdHMiIGluIHRoZSBmb2xsb3dpbmcgbWVh
bgouXCIganVzdCAiX2V4aXQoMikiIG9yIG9yIGJvdGggIl9leGl0KDIpIGFuZCBleGl0X2dyb3Vw
KDIpIj8KSWYgYSB0aHJlYWQgZ3JvdXAgbGVhZGVyIGlzIHRyYWNlZCBhbmQgZXhpdHMgYnkgY2Fs
bGluZwouQlIgX2V4aXQgKDIpLAphCi5CIFBUUkFDRV9FVkVOVF9FWElUCnN0b3Agd2lsbCBoYXBw
ZW4gZm9yIGl0IChpZiByZXF1ZXN0ZWQpLCBidXQgdGhlIHN1YnNlcXVlbnQKLkIgV0lGRVhJVEVE
Cm5vdGlmaWNhdGlvbiB3aWxsIG5vdCBiZSBkZWxpdmVyZWQgdW50aWwgYWxsIG90aGVyIHRocmVh
ZHMgZXhpdC4KQXMgZXhwbGFpbmVkIGFib3ZlLCBpZiBvbmUgb2Ygb3RoZXIgdGhyZWFkcyBjYWxs
cwouQlIgZXhlY3ZlICgyKSwKdGhlIGRlYXRoIG9mIHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyIHdp
bGwKLkkgbmV2ZXIKYmUgcmVwb3J0ZWQuCklmIHRoZSBleGVjZWQgdGhyZWFkIGlzIG5vdCB0cmFj
ZWQgYnkgdGhpcyB0cmFjZXIsCnRoZSB0cmFjZXIgd2lsbCBuZXZlciBrbm93IHRoYXQKLkJSIGV4
ZWN2ZSAoMikKaGFwcGVuZWQuCk9uZSBwb3NzaWJsZSB3b3JrYXJvdW5kIGlzIHRvCi5CIFBUUkFD
RV9ERVRBQ0gKdGhlIHRocmVhZCBncm91cCBsZWFkZXIgaW5zdGVhZCBvZiByZXN0YXJ0aW5nIGl0
IGluIHRoaXMgY2FzZS4KTGFzdCBjb25maXJtZWQgb24gMi42LjM4LjYuCi5cIiAgICAgICAgXl5e
IG5lZWQgdG8gdGVzdC92ZXJpZnkgdGhpcyBzY2VuYXJpbwouXCIgRklYTUU6IG10azogdGhlIHBy
ZWNlZGluZyBjb21tZW50IHNlZW1zIHRvIGJlIHVucmVzb2x2ZWQ/Ci5cIiAgICAgICAgRG8geW91
IHdhbnQgdG8gYWRkIGFueXRoaW5nPwouTFAKQQouQiBTSUdLSUxMCnNpZ25hbCBtYXkgc3RpbGwg
Y2F1c2UgYQouQiBQVFJBQ0VfRVZFTlRfRVhJVApzdG9wIGJlZm9yZSBhY3R1YWwgc2lnbmFsIGRl
YXRoLgpUaGlzIG1heSBiZSBjaGFuZ2VkIGluIHRoZSBmdXR1cmU7Ci5CIFNJR0tJTEwKaXMgbWVh
bnQgdG8gYWx3YXlzIGltbWVkaWF0ZWx5IGtpbGwgdGFza3MgZXZlbiB1bmRlciBwdHJhY2UuCkxh
c3QgY29uZmlybWVkIG9uIDIuNi4zOC42LgouU0ggIlNFRSBBTFNPIgouQlIgZ2RiICgxKSwKLkJS
IHN0cmFjZSAoMSksCi5CUiBjbG9uZSAoMiksCi5CUiBleGVjdmUgKDIpLAouQlIgZm9yayAoMiks
Ci5CUiBnZXR0aWQgKDIpLAouQlIgc2lnYWN0aW9uICgyKSwKLkJSIHRna2lsbCAoMiksCi5CUiB2
Zm9yayAoMiksCi5CUiB3YWl0cGlkICgyKSwKLkJSIGV4ZWMgKDMpLAouQlIgY2FwYWJpbGl0aWVz
ICg3KSwKLkJSIHNpZ25hbCAoNykK
--0015176f03646b17c304ae193b52--
