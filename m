Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2BZSnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 13:43:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2BZSnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 13:43:09 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkiyR7v=q0WTr+sQEsYE57z_j-C3+3n3ABZT+5HjJoc9fw@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
 <CAK1hOcNEBFOd1MR6L+Fdj0paAGacmrepbyPmpT_J9wBQ7bxx=Q@mail.gmail.com>
 <CAKgNAkj8tjBk1mXO6WhwUyeZDrRC5ECzHXLzPQ0PCpbr34D4_A@mail.gmail.com>
 <CAK1hOcMEWnCysL1HRe+Z3Qfxg9+=tcY6YKWor7_bymNkPVSL+A@mail.gmail.com> <CAKgNAkiyR7v=q0WTr+sQEsYE57z_j-C3+3n3ABZT+5HjJoc9fw@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 27 Feb 2012 07:42:47 +1300
Message-ID: <CAKgNAkhZT=cGfAvenQpc7zLSzk6SPrKN_8FDLahK2QkKv3uhrA@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Blaisorblade <blaisorblade@yahoo.it>,
        Daniel Jacobowitz <dan@debian.org>
Content-Type: multipart/mixed; boundary=e89a8f50320c72af9704b9e25dc7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f50320c72af9704b9e25dc7
Content-Type: text/plain; charset=ISO-8859-1

Hello Denys,

Below is another iteration of the ptrace.2 page with your new
material. Could you please take a look at the page in general, and the
FIXMEs in particular? (I'd like to get specific input from you on all
of the FIXMEs, if possible.)

Thanks,

Michael

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
.\" Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111,
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
.\" FIXME (later): Linux 3.1 adds PTRACE_SEIZE, PTRACE_INTERRUPT,
.\"                and PTRACE_LISTEN.
.\"
.TH PTRACE 2 2012-02-27 "Linux" "Linux Programmer's Manual"
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
A tracee first needs to be attached to the tracer.
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
(Note that in this page, a "multithreaded process"
means a thread group consisting of threads created using the
.BR clone (2)
.B CLONE_THREAD
flag.)
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
(or one of the related "wait" system calls); that call will return a
.I status
value containing information that indicates
the cause of the stop in the tracee.
While the tracee is stopped,
the tracer can use various ptrace requests to inspect and modify the tracee.
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
.TP
.BR PTRACE_O_TRACEFORK " (since Linux 2.5.46)"
Stop the tracee at the next
.BR fork (2)
and automatically start tracing the newly forked process,
which will start with a
.BR SIGSTOP .
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_FORK<<8))
.fi

The PID of the new process can be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACEVFORK " (since Linux 2.5.46)"
Stop the tracee at the next
.BR vfork (2)
and automatically start tracing the newly vforked process,
which will start with a
.BR SIGSTOP .
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_VFORK<<8))
.fi

The PID of the new process can be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACECLONE " (since Linux 2.5.46)"
Stop the tracee at the next
.BR clone (2)
and automatically start tracing the newly cloned process,
which will start with a
.BR SIGSTOP .
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_CLONE<<8))
.fi

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
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_EXEC<<8))
.fi

.TP
.BR PTRACE_O_TRACEVFORKDONE " (since Linux 2.5.60)"
Stop the tracee at the completion of the next
.BR vfork (2).
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_VFORK_DONE<<8))
.fi

The PID of the new process can (since Linux 2.6.18) be retrieved with
.BR PTRACE_GETEVENTMSG .
.TP
.BR PTRACE_O_TRACEEXIT " (since Linux 2.5.60)"
Stop the tracee at exit.
A
.BR waitpid (2)
by the tracer will return a
.I status
value such that

.nf
  status>>8 == (SIGTRAP | (PTRACE_EVENT_EXIT<<8))
.fi

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
.\" [Note from Denys Vlasenko:
.\"     deprecation suggested by Oleg Nesterov. He prefers to deprecate it
.\"     instead of describing (and needing to support) PTRACE_KILL's quirks.]
.TP
.B PTRACE_ATTACH
Attach to the process specified in
.IR pid ,
making it a tracee of the calling process.
.\" No longer true (removed by Denys Vlasenko, 2011, who remarks:
.\"        "I think it isn't true in non-ancient 2.4 and in 2.6/3.x.
.\"         Basically, it's not true for any Linux in practical use.
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
.\" In the text below, we decided to avoid prettifying the text with markup:
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
.IR WIFSIGNALED(status) ;
there are cases where this does not occur.
For example, if a thread other than thread group leader does an
.BR execve (2),
it disappears;
its PID will never be seen again,
and any subsequent ptrace stops will be reported under
the thread group leader's PID.
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
    pid = waitpid(pid_or_minus_1, &status, __WALL);
.LP
Ptrace-stopped tracees are reported as returns with
.I pid
greater than 0 and
.I WIFSTOPPED(status)
true.
.\" Denys Vlasenko:
.\"     Do we require __WALL usage, or will just using 0 be ok? (With 0,
.\"     I am not 100% sure there aren't ugly corner cases.) Are the
.\"     rules different if user wants to use waitid? Will waitid require
.\"     WEXITED?
.\"
.LP
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
.\" FIXME: mtk: the following text ("[, PTRACE_SINGLESTEP...") is incomplete.
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
(Note: the
.I WSTOPSIG(status)
macro can't be used to perform this examination,
because it returns the value
(\fIstatus\>>8)\ \fB&\ 0xff\fP\fP.)
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
The
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
Restarting ptrace commands issued in ptrace-stops other than
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
The fact that signal injection requests may be ignored
when restarting the tracee after
ptrace stops that are not signal-delivery-stops
is a cause of confusion among ptrace users.
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
In Linux 2.4 and earlier, the
.B SIGSTOP
signal can't be injected.
.\" In the Linux 2.4 sources, in arch/i386/kernel/signal.c::do_signal(),
.\" there is:
.\"
.\"             /* The debugger continued.  Ignore SIGSTOP.  */
.\"             if (signr == SIGSTOP)
.\"                     continue;
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
.\" FIXME It is unclear what "this kernel behavior" refers to.
.\" Can show me exactly which piece of text above or below is
.\" referred to when you say "this kernel behavior"?
Currently, this kernel behavior
causes a problem with transparent handling of stopping signals:
if the tracer restarts the tracee after group-stop,
the stopping signal
is effectively ignored\(emthe tracee doesn't remain stopped, it runs.
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
.IR si_code " <= 0"
.B SIGTRAP
was delivered as a result of a userspace action,
for example, a system call
.RB ( tgkill (2),
.BR kill (2),
.BR sigqueue (3),
etc.),
expiration of a POSIX timer,
change of state on a POSIX message queue,
or completion of an asynchronous I/O request.
.TP
.IR si_code " == SI_KERNEL (0x80)"
.B SIGTRAP
was sent by the kernel.
.TP
.IR si_code " == SIGTRAP or " si_code " == (SIGTRAP|0x80)"
This is a syscall-stop.
.LP
However, syscall-stops happen very often (twice per system call),
and performing
.B PTRACE_GETSIGINFO
for every syscall-stop may be somewhat expensive.
.LP
Some architectures allow the cases to be distinguished
by examining registers.
For example, on x86,
.I rax
==
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
.\"       Do you want to add anything, or (less good) do we just
.\"       convert this into a comment in the source indicating
.\"       that these points still need to be documented?
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
    ptrace(cmd, pid, 0, sig);
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
(When restarting a tracee from a ptrace-stop other than signal-delivery-stop,
recommended practice is to always pass 0 in
.I sig .)
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
.\" FIXME: Planned for when? And should applications be designed
.\" in some way so as to allow for this future change?
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
When one thread in a multithreaded process calls
.BR execve (2),
the kernel destroys all other threads in the process,
.\" In kernel 3.1 sources, see fs/exec.c::de_thread()
and resets the thread ID of the execing thread to the
thread group ID (process ID).
(Or, to put things another way, when a multithreaded process does an
.BR execve (2),
at completion of the call, it appears as though the
.BR execve (2)
occurred in the thread group leader, regardless of which thread did the
.BR execve (2).)
This resetting of the thread ID looks very confusing to tracers:
.IP * 3
All other threads stop in
.B PTRACE_EVENT_EXIT
stop,
if the
.BR PTRACE_O_TRACEEXIT
option was turned on.
Then all other threads except the thread group leader report
death as if they exited via
.BR _exit (2)
with exit code 0.
Then a
.B PTRACE_EVENT_EXEC
stop happens, if the
.BR PTRACE_O_TRACEEXEC
option was turned on.
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

    thread ID == thread group ID == process id.
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
PID0 <... execve resumed> )             = 0
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
exit/death by signal is reported first to the tracer, then,
when the tracer consumes the
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
.\" FIXME I reworked the discussion of init below to note
.\" the kernel version (2.6.26) when the behavior changed for
.\" tracing init(8). Okay?
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
.\" FIXME So, can we just remove the following text (rather than
.\" just commenting it out)?
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
If a thread group leader is traced and exits by calling
.BR _exit (2),
.\" Note from Denys Vlasenko:
.\"     Here "exits" means any kind of death - _exit, exit_group,
.\"     signal death. Signal death and exit_group cases are trivial,
.\"     though: since signal death and exit_group kill all other threads
.\"     too, "until all other threads exit" thing happens rather soon
.\"     in these cases. Therefore, only _exit presents observably
.\"     puzzling behavior to ptrace users: thread leader _exit's,
.\"     but WIFEXITED isn't reported! We are trying to explain here
.\"     why it is so.
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

--e89a8f50320c72af9704b9e25dc7
Content-Type: application/octet-stream; name="ptrace.2"
Content-Disposition: attachment; filename="ptrace.2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gz4feayt0

LlwiIEhleSBFbWFjcyEgVGhpcyBmaWxlIGlzIC0qLSBucm9mZiAtKi0gc291cmNlLgouXCIKLlwi
IENvcHlyaWdodCAoYykgMTk5MyBNaWNoYWVsIEhhYXJkdCA8bWljaGFlbEBtb3JpYS5kZT4KLlwi
IEZyaSBBcHIgIDIgMTE6MzI6MDkgTUVUIERTVCAxOTkzCi5cIgouXCIgYW5kIGNoYW5nZXMgQ29w
eXJpZ2h0IChDKSAxOTk5IE1pa2UgQ29sZW1hbiAobWtjQGFjbS5vcmcpCi5cIiAtLSBtYWpvciBy
ZXZpc2lvbiB0byBmdWxseSBkb2N1bWVudCBwdHJhY2Ugc2VtYW50aWNzIHBlciByZWNlbnQgTGlu
dXgKLlwiICAgIGtlcm5lbCAoMi4yLjEwKSBhbmQgZ2xpYmMgKDIuMS4yKQouXCIgU3VuIE5vdiAg
NyAwMzoxODozNSBDU1QgMTk5OQouXCIKLlwiIGFuZCBDb3B5cmlnaHQgKGMpIDIwMTEsIERlbnlz
IFZsYXNlbmtvIDx2ZGEubGludXhAZ29vZ2xlbWFpbC5jb20+Ci5cIgouXCIgVGhpcyBpcyBmcmVl
IGRvY3VtZW50YXRpb247IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgouXCIgbW9kaWZ5
IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMK
LlwiIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVy
c2lvbiAyIG9mCi5cIiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIg
dmVyc2lvbi4KLlwiCi5cIiBUaGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UncyByZWZlcmVu
Y2VzIHRvICJvYmplY3QgY29kZSIKLlwiIGFuZCAiZXhlY3V0YWJsZXMiIGFyZSB0byBiZSBpbnRl
cnByZXRlZCBhcyB0aGUgb3V0cHV0IG9mIGFueQouXCIgZG9jdW1lbnQgZm9ybWF0dGluZyBvciB0
eXBlc2V0dGluZyBzeXN0ZW0sIGluY2x1ZGluZwouXCIgaW50ZXJtZWRpYXRlIGFuZCBwcmludGVk
IG91dHB1dC4KLlwiCi5cIiBUaGlzIG1hbnVhbCBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0
aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAouXCIgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRo
b3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKLlwiIE1FUkNIQU5UQUJJTElUWSBvciBG
SVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKLlwiIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCi5cIgouXCIgWW91IHNob3VsZCBoYXZl
IHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljCi5cIiBMaWNlbnNlIGFs
b25nIHdpdGggdGhpcyBtYW51YWw7IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUKLlwiIFNvZnR3
YXJlIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24s
IE1BIDAyMTExLAouXCIgVVNBLgouXCIKLlwiIE1vZGlmaWVkIEZyaSBKdWwgMjMgMjM6NDc6MTgg
MTk5MyBieSBSaWsgRmFpdGggPGZhaXRoQGNzLnVuYy5lZHU+Ci5cIiBNb2RpZmllZCBGcmkgSmFu
IDMxIDE2OjQ2OjMwIDE5OTcgYnkgRXJpYyBTLiBSYXltb25kIDxlc3JAdGh5cnN1cy5jb20+Ci5c
IiBNb2RpZmllZCBUaHUgT2N0ICA3IDE3OjI4OjQ5IDE5OTkgYnkgQW5kcmllcyBCcm91d2VyIDxh
ZWJAY3dpLm5sPgouXCIgTW9kaWZpZWQsIDI3IE1heSAyMDA0LCBNaWNoYWVsIEtlcnJpc2sgPG10
ay5tYW5wYWdlc0BnbWFpbC5jb20+Ci5cIiAgICAgQWRkZWQgbm90ZXMgb24gY2FwYWJpbGl0eSBy
ZXF1aXJlbWVudHMKLlwiCi5cIiAyMDA2LTAzLTI0LCBDaHVjayBFYmJlcnQgPDc2MzA2LjEyMjZA
Y29tcHVzZXJ2ZS5jb20+Ci5cIiAgICBBZGRlZCAgICBQVFJBQ0VfU0VUT1BUSU9OUywgUFRSQUNF
X0dFVEVWRU5UTVNHLCBQVFJBQ0VfR0VUU0lHSU5GTywKLlwiICAgICAgICBQVFJBQ0VfU0VUU0lH
SU5GTywgUFRSQUNFX1NZU0VNVSwgUFRSQUNFX1NZU0VNVV9TSU5HTEVTVEVQCi5cIiAgICAoVGhh
bmtzIHRvIEJsYWlzb3JibGFkZSwgRGFuaWVsIEphY29ib3dpdHogYW5kIG90aGVycyB3aG8gaGVs
cGVkLikKLlwiIDIwMTEtMDksIG1ham9yIHVwZGF0ZSBieSBEZW55cyBWbGFzZW5rbyA8dmRhLmxp
bnV4QGdvb2dsZW1haWwuY29tPgouXCIKLlwiIEZJWE1FIChsYXRlcik6IExpbnV4IDMuMSBhZGRz
IFBUUkFDRV9TRUlaRSwgUFRSQUNFX0lOVEVSUlVQVCwKLlwiICAgICAgICAgICAgICAgIGFuZCBQ
VFJBQ0VfTElTVEVOLgouXCIKLlRIIFBUUkFDRSAyIDIwMTItMDItMjcgIkxpbnV4IiAiTGludXgg
UHJvZ3JhbW1lcidzIE1hbnVhbCIKLlNIIE5BTUUKcHRyYWNlIFwtIHByb2Nlc3MgdHJhY2UKLlNI
IFNZTk9QU0lTCi5uZgouQiAjaW5jbHVkZSA8c3lzL3B0cmFjZS5oPgouc3AKLkJJICJsb25nIHB0
cmFjZShlbnVtIF9fcHRyYWNlX3JlcXVlc3QgIiByZXF1ZXN0ICIsIHBpZF90ICIgcGlkICIsICIK
LkJJICIgICAgICAgICAgICB2b2lkICoiIGFkZHIgIiwgdm9pZCAqIiBkYXRhICk7Ci5maQouU0gg
REVTQ1JJUFRJT04KVGhlCi5CUiBwdHJhY2UgKCkKc3lzdGVtIGNhbGwgcHJvdmlkZXMgYSBtZWFu
cyBieSB3aGljaCBvbmUgcHJvY2VzcyAodGhlICJ0cmFjZXIiKQptYXkgb2JzZXJ2ZSBhbmQgY29u
dHJvbCB0aGUgZXhlY3V0aW9uIG9mIGFub3RoZXIgcHJvY2VzcyAodGhlICJ0cmFjZWUiKSwKYW5k
IGV4YW1pbmUgYW5kIGNoYW5nZSB0aGUgdHJhY2VlJ3MgbWVtb3J5IGFuZCByZWdpc3RlcnMuCkl0
IGlzIHByaW1hcmlseSB1c2VkIHRvIGltcGxlbWVudCBicmVha3BvaW50IGRlYnVnZ2luZyBhbmQg
c3lzdGVtCmNhbGwgdHJhY2luZy4KLkxQCkEgdHJhY2VlIGZpcnN0IG5lZWRzIHRvIGJlIGF0dGFj
aGVkIHRvIHRoZSB0cmFjZXIuCkF0dGFjaG1lbnQgYW5kIHN1YnNlcXVlbnQgY29tbWFuZHMgYXJl
IHBlciB0aHJlYWQ6CmluIGEgbXVsdGl0aHJlYWRlZCBwcm9jZXNzLApldmVyeSB0aHJlYWQgY2Fu
IGJlIGluZGl2aWR1YWxseSBhdHRhY2hlZCB0byBhCihwb3RlbnRpYWxseSBkaWZmZXJlbnQpIHRy
YWNlciwKb3IgbGVmdCBub3QgYXR0YWNoZWQgYW5kIHRodXMgbm90IGRlYnVnZ2VkLgpUaGVyZWZv
cmUsICJ0cmFjZWUiIGFsd2F5cyBtZWFucyAiKG9uZSkgdGhyZWFkIiwKbmV2ZXIgImEgKHBvc3Np
Ymx5IG11bHRpdGhyZWFkZWQpIHByb2Nlc3MiLgpQdHJhY2UgY29tbWFuZHMgYXJlIGFsd2F5cyBz
ZW50IHRvCmEgc3BlY2lmaWMgdHJhY2VlIHVzaW5nIGEgY2FsbCBvZiB0aGUgZm9ybQoKICAgIHB0
cmFjZShQVFJBQ0VfZm9vLCBwaWQsIC4uLikKCndoZXJlCi5JIHBpZAppcyB0aGUgdGhyZWFkIElE
IG9mIHRoZSBjb3JyZXNwb25kaW5nIExpbnV4IHRocmVhZC4KLkxQCihOb3RlIHRoYXQgaW4gdGhp
cyBwYWdlLCBhICJtdWx0aXRocmVhZGVkIHByb2Nlc3MiCm1lYW5zIGEgdGhyZWFkIGdyb3VwIGNv
bnNpc3Rpbmcgb2YgdGhyZWFkcyBjcmVhdGVkIHVzaW5nIHRoZQouQlIgY2xvbmUgKDIpCi5CIENM
T05FX1RIUkVBRApmbGFnLikKLkxQCkEgcHJvY2VzcyBjYW4gaW5pdGlhdGUgYSB0cmFjZSBieSBj
YWxsaW5nCi5CUiBmb3JrICgyKQphbmQgaGF2aW5nIHRoZSByZXN1bHRpbmcgY2hpbGQgZG8gYQou
QlIgUFRSQUNFX1RSQUNFTUUgLApmb2xsb3dlZCAodHlwaWNhbGx5KSBieSBhbgouQlIgZXhlY3Zl
ICgyKS4KQWx0ZXJuYXRpdmVseSwgb25lIHByb2Nlc3MgbWF5IGNvbW1lbmNlIHRyYWNpbmcgYW5v
dGhlciBwcm9jZXNzIHVzaW5nCi5CUiBQVFJBQ0VfQVRUQUNIIC4KLkxQCldoaWxlIGJlaW5nIHRy
YWNlZCwgdGhlIHRyYWNlZSB3aWxsIHN0b3AgZWFjaCB0aW1lIGEgc2lnbmFsIGlzIGRlbGl2ZXJl
ZCwKZXZlbiBpZiB0aGUgc2lnbmFsIGlzIGJlaW5nIGlnbm9yZWQuCihBbiBleGNlcHRpb24gaXMK
LkJSIFNJR0tJTEwgLAp3aGljaCBoYXMgaXRzIHVzdWFsIGVmZmVjdC4pClRoZSB0cmFjZXIgd2ls
bCBiZSBub3RpZmllZCBhdCBpdHMgbmV4dCBjYWxsIHRvCi5CUiB3YWl0cGlkICgyKQoob3Igb25l
IG9mIHRoZSByZWxhdGVkICJ3YWl0IiBzeXN0ZW0gY2FsbHMpOyB0aGF0IGNhbGwgd2lsbCByZXR1
cm4gYQouSSBzdGF0dXMKdmFsdWUgY29udGFpbmluZyBpbmZvcm1hdGlvbiB0aGF0IGluZGljYXRl
cwp0aGUgY2F1c2Ugb2YgdGhlIHN0b3AgaW4gdGhlIHRyYWNlZS4KV2hpbGUgdGhlIHRyYWNlZSBp
cyBzdG9wcGVkLAp0aGUgdHJhY2VyIGNhbiB1c2UgdmFyaW91cyBwdHJhY2UgcmVxdWVzdHMgdG8g
aW5zcGVjdCBhbmQgbW9kaWZ5IHRoZSB0cmFjZWUuClRoZSB0cmFjZXIgdGhlbiBjYXVzZXMgdGhl
IHRyYWNlZSB0byBjb250aW51ZSwKb3B0aW9uYWxseSBpZ25vcmluZyB0aGUgZGVsaXZlcmVkIHNp
Z25hbAoob3IgZXZlbiBkZWxpdmVyaW5nIGEgZGlmZmVyZW50IHNpZ25hbCBpbnN0ZWFkKS4KLkxQ
CldoZW4gdGhlIHRyYWNlciBpcyBmaW5pc2hlZCB0cmFjaW5nLCBpdCBjYW4gY2F1c2UgdGhlIHRy
YWNlZSB0byBjb250aW51ZQpleGVjdXRpbmcgaW4gYSBub3JtYWwsIHVudHJhY2VkIG1vZGUgdmlh
Ci5CUiBQVFJBQ0VfREVUQUNIIC4KLkxQClRoZSB2YWx1ZSBvZgouSSByZXF1ZXN0CmRldGVybWlu
ZXMgdGhlIGFjdGlvbiB0byBiZSBwZXJmb3JtZWQ6Ci5UUAouQiBQVFJBQ0VfVFJBQ0VNRQpJbmRp
Y2F0ZSB0aGF0IHRoaXMgcHJvY2VzcyBpcyB0byBiZSB0cmFjZWQgYnkgaXRzIHBhcmVudC4KQW55
IHNpZ25hbCAoZXhjZXB0Ci5CUiBTSUdLSUxMICkKZGVsaXZlcmVkIHRvIHRoaXMgcHJvY2VzcyB3
aWxsIGNhdXNlIGl0IHRvIHN0b3AgYW5kIGl0cwpwYXJlbnQgdG8gYmUgbm90aWZpZWQgdmlhCi5C
UiB3YWl0cGlkICgyKS4KSW4gYWRkaXRpb24sIGFsbCBzdWJzZXF1ZW50IGNhbGxzIHRvCi5CUiBl
eGVjdmUgKDIpCmJ5IHRoZSB0cmFjZWQgcHJvY2VzcyB3aWxsIGNhdXNlIGEKLkIgU0lHVFJBUAp0
byBiZSBzZW50IHRvIGl0LApnaXZpbmcgdGhlIHBhcmVudCBhIGNoYW5jZSB0byBnYWluIGNvbnRy
b2wgYmVmb3JlIHRoZSBuZXcgcHJvZ3JhbQpiZWdpbnMgZXhlY3V0aW9uLgpBIHByb2Nlc3MgcHJv
YmFibHkgc2hvdWxkbid0IG1ha2UgdGhpcyByZXF1ZXN0IGlmIGl0cyBwYXJlbnQKaXNuJ3QgZXhw
ZWN0aW5nIHRvIHRyYWNlIGl0LgouUkkgKCBwaWQgLAouSVIgYWRkciAsCmFuZAouSVIgZGF0YQph
cmUgaWdub3JlZC4pCi5MUApUaGUKLkIgUFRSQUNFX1RSQUNFTUUKcmVxdWVzdCBpcyB1c2VkIG9u
bHkgYnkgdGhlIHRyYWNlZTsKdGhlIHJlbWFpbmluZyByZXF1ZXN0cyBhcmUgdXNlZCBvbmx5IGJ5
IHRoZSB0cmFjZXIuCkluIHRoZSBmb2xsb3dpbmcgcmVxdWVzdHMsCi5JIHBpZApzcGVjaWZpZXMg
dGhlIHRocmVhZCBJRCBvZiB0aGUgdHJhY2VlIHRvIGJlIGFjdGVkIG9uLgpGb3IgcmVxdWVzdHMg
b3RoZXIgdGhhbgouQlIgUFRSQUNFX0tJTEwgLAp0aGUgdHJhY2VlIG11c3QgYmUgc3RvcHBlZC4K
LlRQCi5CUiBQVFJBQ0VfUEVFS1RFWFQgIiwgIiBQVFJBQ0VfUEVFS0RBVEEKUmVhZCBhIHdvcmQg
YXQgdGhlIGFkZHJlc3MKLkkgYWRkcgppbiB0aGUgdHJhY2VlJ3MgbWVtb3J5LCByZXR1cm5pbmcg
dGhlIHdvcmQgYXMgdGhlIHJlc3VsdCBvZiB0aGUKLkJSIHB0cmFjZSAoKQpjYWxsLgpMaW51eCBk
b2VzIG5vdCBoYXZlIHNlcGFyYXRlIHRleHQgYW5kIGRhdGEgYWRkcmVzcyBzcGFjZXMsCnNvIHRo
ZXNlIHR3byByZXF1ZXN0cyBhcmUgY3VycmVudGx5IGVxdWl2YWxlbnQuCi5SSSAoIGRhdGEKaXMg
aWdub3JlZC4pCi5UUAouQiBQVFJBQ0VfUEVFS1VTRVIKLlwiIFBUUkFDRV9QRUVLVVNSIGluIGtl
cm5lbCBzb3VyY2UsIGJ1dCBnbGliYyB1c2VzIFBUUkFDRV9QRUVLVVNFUiwKLlwiIGFuZCB0aGF0
IGlzIHRoZSBuYW1lIHRoYXQgc2VlbXMgY29tbW9uIG9uIG90aGVyIHN5c3RlbXMuClJlYWQgYSB3
b3JkIGF0IG9mZnNldAouSSBhZGRyCmluIHRoZSB0cmFjZWUncyBVU0VSIGFyZWEsCndoaWNoIGhv
bGRzIHRoZSByZWdpc3RlcnMgYW5kIG90aGVyIGluZm9ybWF0aW9uIGFib3V0IHRoZSBwcm9jZXNz
CihzZWUKLklSIDxzeXMvdXNlci5oPiApLgpUaGUgd29yZCBpcyByZXR1cm5lZCBhcyB0aGUgcmVz
dWx0IG9mIHRoZQouQlIgcHRyYWNlICgpCmNhbGwuClR5cGljYWxseSwgdGhlIG9mZnNldCBtdXN0
IGJlIHdvcmQtYWxpZ25lZCwgdGhvdWdoIHRoaXMgbWlnaHQgdmFyeSBieQphcmNoaXRlY3R1cmUu
ClNlZSBOT1RFUy4KLlJJICggZGF0YQppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfUE9LRVRF
WFQgIiwgIiBQVFJBQ0VfUE9LRURBVEEKQ29weSB0aGUgd29yZAouSSBkYXRhCnRvIHRoZSBhZGRy
ZXNzCi5JIGFkZHIKaW4gdGhlIHRyYWNlZSdzIG1lbW9yeS4KQXMgZm9yCi5CUiBQVFJBQ0VfUEVF
S1RFWFQgCmFuZAouQlIgUFRSQUNFX1BFRUtEQVRBICwKdGhlc2UgdHdvIHJlcXVlc3RzIGFyZSBj
dXJyZW50bHkgZXF1aXZhbGVudC4KLlRQCi5CIFBUUkFDRV9QT0tFVVNFUgouXCIgUFRSQUNFX1BP
S0VVU1IgaW4ga2VybmVsIHNvdXJjZSwgYnV0IGdsaWJjIHVzZXMgUFRSQUNFX1BPS0VVU0VSLAou
XCIgYW5kIHRoYXQgaXMgdGhlIG5hbWUgdGhhdCBzZWVtcyBjb21tb24gb24gb3RoZXIgc3lzdGVt
cy4KQ29weSB0aGUgd29yZAouSSBkYXRhCnRvIG9mZnNldAouSSBhZGRyCmluIHRoZSB0cmFjZWUn
cyBVU0VSIGFyZWEuCkFzIGZvcgouQlIgUFRSQUNFX1BFRUtVU0VSICwKdGhlIG9mZnNldCBtdXN0
IHR5cGljYWxseSBiZSB3b3JkLWFsaWduZWQuCkluIG9yZGVyIHRvIG1haW50YWluIHRoZSBpbnRl
Z3JpdHkgb2YgdGhlIGtlcm5lbCwKc29tZSBtb2RpZmljYXRpb25zIHRvIHRoZSBVU0VSIGFyZWEg
YXJlIGRpc2FsbG93ZWQuCi5cIiBGSVhNRSBJbiB0aGUgcHJlY2VkaW5nIHNlbnRlbmNlLCB3aGlj
aCBtb2RpZmljYXRpb25zIGFyZSBkaXNhbGxvd2VkLAouXCIgYW5kIHdoZW4gdGhleSBhcmUgZGlz
YWxsb3dlZCwgaG93IGRvZXMgdXNlcnNwYWNlIGRpc2NvdmVyIHRoYXQgZmFjdD8KLlRQCi5CUiBQ
VFJBQ0VfR0VUUkVHUyAiLCAiIFBUUkFDRV9HRVRGUFJFR1MKQ29weSB0aGUgdHJhY2VlJ3MgZ2Vu
ZXJhbCBwdXJwb3NlIG9yIGZsb2F0aW5nLXBvaW50IHJlZ2lzdGVycywKcmVzcGVjdGl2ZWx5LCB0
byB0aGUgYWRkcmVzcwouSSBkYXRhCmluIHRoZSB0cmFjZXIuClNlZQouSSA8c3lzL3VzZXIuaD4K
Zm9yIGluZm9ybWF0aW9uIG9uIHRoZSBmb3JtYXQgb2YgdGhpcyBkYXRhLgouUkkgKCBhZGRyCmlz
IGlnbm9yZWQuKQouVFAKLkJSIFBUUkFDRV9HRVRTSUdJTkZPICIgKHNpbmNlIExpbnV4IDIuMy45
OS1wcmU2KSIKUmV0cmlldmUgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHNpZ25hbCB0aGF0IGNhdXNl
ZCB0aGUgc3RvcC4KQ29weSBhCi5JIHNpZ2luZm9fdApzdHJ1Y3R1cmUgKHNlZQouQlIgc2lnYWN0
aW9uICgyKSkKZnJvbSB0aGUgdHJhY2VlIHRvIHRoZSBhZGRyZXNzCi5JIGRhdGEKaW4gdGhlIHRy
YWNlci4KLlJJICggYWRkcgppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfU0VUUkVHUyAiLCAi
IFBUUkFDRV9TRVRGUFJFR1MKQ29weSB0aGUgdHJhY2VlJ3MgZ2VuZXJhbCBwdXJwb3NlIG9yIGZs
b2F0aW5nLXBvaW50IHJlZ2lzdGVycywKcmVzcGVjdGl2ZWx5LCBmcm9tIHRoZSBhZGRyZXNzCi5J
IGRhdGEKaW4gdGhlIHRyYWNlci4KQXMgZm9yCi5CUiBQVFJBQ0VfUE9LRVVTRVIgLApzb21lIGdl
bmVyYWwgcHVycG9zZSByZWdpc3RlciBtb2RpZmljYXRpb25zIG1heSBiZSBkaXNhbGxvd2VkLgou
XCIgRklYTUUgSW4gdGhlIHByZWNlZGluZyBzZW50ZW5jZSwgd2hpY2ggbW9kaWZpY2F0aW9ucyBh
cmUgZGlzYWxsb3dlZCwKLlwiIGFuZCB3aGVuIHRoZXkgYXJlIGRpc2FsbG93ZWQsIGhvdyBkb2Vz
IHVzZXJzcGFjZSBkaXNjb3ZlciB0aGF0IGZhY3Q/Ci5SSSAoIGFkZHIKaXMgaWdub3JlZC4pCi5U
UAouQlIgUFRSQUNFX1NFVFNJR0lORk8gIiAoc2luY2UgTGludXggMi4zLjk5LXByZTYpIgpTZXQg
c2lnbmFsIGluZm9ybWF0aW9uOgpjb3B5IGEKLkkgc2lnaW5mb190CnN0cnVjdHVyZSBmcm9tIHRo
ZSBhZGRyZXNzCi5JIGRhdGEKaW4gdGhlIHRyYWNlciB0byB0aGUgdHJhY2VlLgpUaGlzIHdpbGwg
YWZmZWN0IG9ubHkgc2lnbmFscyB0aGF0IHdvdWxkIG5vcm1hbGx5IGJlIGRlbGl2ZXJlZCB0bwp0
aGUgdHJhY2VlIGFuZCB3ZXJlIGNhdWdodCBieSB0aGUgdHJhY2VyLgpJdCBtYXkgYmUgZGlmZmlj
dWx0IHRvIHRlbGwKdGhlc2Ugbm9ybWFsIHNpZ25hbHMgZnJvbSBzeW50aGV0aWMgc2lnbmFscyBn
ZW5lcmF0ZWQgYnkKLkJSIHB0cmFjZSAoKQppdHNlbGYuCi5SSSAoIGFkZHIKaXMgaWdub3JlZC4p
Ci5UUAouQlIgUFRSQUNFX1NFVE9QVElPTlMgIiAoc2luY2UgTGludXggMi40LjY7IHNlZSBCVUdT
IGZvciBjYXZlYXRzKSIKU2V0IHB0cmFjZSBvcHRpb25zIGZyb20KLklSIGRhdGEgLgouUkkgKCBh
ZGRyCmlzIGlnbm9yZWQuKQouSVIgZGF0YQppcyBpbnRlcnByZXRlZCBhcyBhIGJpdCBtYXNrIG9m
IG9wdGlvbnMsCndoaWNoIGFyZSBzcGVjaWZpZWQgYnkgdGhlIGZvbGxvd2luZyBmbGFnczoKLlJT
Ci5UUAouQlIgUFRSQUNFX09fVFJBQ0VTWVNHT09EICIgKHNpbmNlIExpbnV4IDIuNC42KSIKV2hl
biBkZWxpdmVyaW5nIHN5c3RlbSBjYWxsIHRyYXBzLCBzZXQgYml0IDcgaW4gdGhlIHNpZ25hbCBu
dW1iZXIKKGkuZS4sIGRlbGl2ZXIKLklSICJTSUdUUkFQfDB4ODAiICkuClRoaXMgbWFrZXMgaXQg
ZWFzeSBmb3IgdGhlIHRyYWNlciB0byBkaXN0aW5ndWlzaApub3JtYWwgdHJhcHMgZnJvbSB0aG9z
ZSBjYXVzZWQgYnkgYSBzeXN0ZW0gY2FsbC4KLlJCICggUFRSQUNFX09fVFJBQ0VTWVNHT09ECm1h
eSBub3Qgd29yayBvbiBhbGwgYXJjaGl0ZWN0dXJlcy4pCi5UUAouQlIgUFRSQUNFX09fVFJBQ0VG
T1JLICIgKHNpbmNlIExpbnV4IDIuNS40NikiClN0b3AgdGhlIHRyYWNlZSBhdCB0aGUgbmV4dAou
QlIgZm9yayAoMikKYW5kIGF1dG9tYXRpY2FsbHkgc3RhcnQgdHJhY2luZyB0aGUgbmV3bHkgZm9y
a2VkIHByb2Nlc3MsCndoaWNoIHdpbGwgc3RhcnQgd2l0aCBhCi5CUiBTSUdTVE9QIC4KQQouQlIg
d2FpdHBpZCAoMikKYnkgdGhlIHRyYWNlciB3aWxsIHJldHVybiBhCi5JIHN0YXR1cwp2YWx1ZSBz
dWNoIHRoYXQKCi5uZgogIHN0YXR1cz4+OCA9PSAoU0lHVFJBUCB8IChQVFJBQ0VfRVZFTlRfRk9S
Szw8OCkpCi5maQoKVGhlIFBJRCBvZiB0aGUgbmV3IHByb2Nlc3MgY2FuIGJlIHJldHJpZXZlZCB3
aXRoCi5CUiBQVFJBQ0VfR0VURVZFTlRNU0cgLgouVFAKLkJSIFBUUkFDRV9PX1RSQUNFVkZPUksg
IiAoc2luY2UgTGludXggMi41LjQ2KSIKU3RvcCB0aGUgdHJhY2VlIGF0IHRoZSBuZXh0Ci5CUiB2
Zm9yayAoMikKYW5kIGF1dG9tYXRpY2FsbHkgc3RhcnQgdHJhY2luZyB0aGUgbmV3bHkgdmZvcmtl
ZCBwcm9jZXNzLAp3aGljaCB3aWxsIHN0YXJ0IHdpdGggYQouQlIgU0lHU1RPUCAuCkEKLkJSIHdh
aXRwaWQgKDIpCmJ5IHRoZSB0cmFjZXIgd2lsbCByZXR1cm4gYQouSSBzdGF0dXMKdmFsdWUgc3Vj
aCB0aGF0CgoubmYKICBzdGF0dXM+PjggPT0gKFNJR1RSQVAgfCAoUFRSQUNFX0VWRU5UX1ZGT1JL
PDw4KSkKLmZpCgpUaGUgUElEIG9mIHRoZSBuZXcgcHJvY2VzcyBjYW4gYmUgcmV0cmlldmVkIHdp
dGgKLkJSIFBUUkFDRV9HRVRFVkVOVE1TRyAuCi5UUAouQlIgUFRSQUNFX09fVFJBQ0VDTE9ORSAi
IChzaW5jZSBMaW51eCAyLjUuNDYpIgpTdG9wIHRoZSB0cmFjZWUgYXQgdGhlIG5leHQKLkJSIGNs
b25lICgyKQphbmQgYXV0b21hdGljYWxseSBzdGFydCB0cmFjaW5nIHRoZSBuZXdseSBjbG9uZWQg
cHJvY2VzcywKd2hpY2ggd2lsbCBzdGFydCB3aXRoIGEKLkJSIFNJR1NUT1AgLgpBCi5CUiB3YWl0
cGlkICgyKQpieSB0aGUgdHJhY2VyIHdpbGwgcmV0dXJuIGEKLkkgc3RhdHVzCnZhbHVlIHN1Y2gg
dGhhdAoKLm5mCiAgc3RhdHVzPj44ID09IChTSUdUUkFQIHwgKFBUUkFDRV9FVkVOVF9DTE9ORTw8
OCkpCi5maQoKVGhlIFBJRCBvZiB0aGUgbmV3IHByb2Nlc3MgY2FuIGJlIHJldHJpZXZlZCB3aXRo
Ci5CUiBQVFJBQ0VfR0VURVZFTlRNU0cgLgouSVAKVGhpcyBvcHRpb24gbWF5IG5vdCBjYXRjaAou
QlIgY2xvbmUgKDIpCmNhbGxzIGluIGFsbCBjYXNlcy4KSWYgdGhlIHRyYWNlZSBjYWxscwouQlIg
Y2xvbmUgKDIpCndpdGggdGhlCi5CIENMT05FX1ZGT1JLCmZsYWcsCi5CIFBUUkFDRV9FVkVOVF9W
Rk9SSwp3aWxsIGJlIGRlbGl2ZXJlZCBpbnN0ZWFkCmlmCi5CIFBUUkFDRV9PX1RSQUNFVkZPUksK
aXMgc2V0OyBvdGhlcndpc2UgaWYgdGhlIHRyYWNlZSBjYWxscwouQlIgY2xvbmUgKDIpCndpdGgg
dGhlIGV4aXQgc2lnbmFsIHNldCB0bwouQlIgU0lHQ0hMRCAsCi5CIFBUUkFDRV9FVkVOVF9GT1JL
CndpbGwgYmUgZGVsaXZlcmVkIGlmCi5CIFBUUkFDRV9PX1RSQUNFRk9SSwppcyBzZXQuCi5UUAou
QlIgUFRSQUNFX09fVFJBQ0VFWEVDICIgKHNpbmNlIExpbnV4IDIuNS40NikiClN0b3AgdGhlIHRy
YWNlZSBhdCB0aGUgbmV4dAouQlIgZXhlY3ZlICgyKS4KQQouQlIgd2FpdHBpZCAoMikKYnkgdGhl
IHRyYWNlciB3aWxsIHJldHVybiBhCi5JIHN0YXR1cwp2YWx1ZSBzdWNoIHRoYXQKCi5uZgogIHN0
YXR1cz4+OCA9PSAoU0lHVFJBUCB8IChQVFJBQ0VfRVZFTlRfRVhFQzw8OCkpCi5maQoKLlRQCi5C
UiBQVFJBQ0VfT19UUkFDRVZGT1JLRE9ORSAiIChzaW5jZSBMaW51eCAyLjUuNjApIgpTdG9wIHRo
ZSB0cmFjZWUgYXQgdGhlIGNvbXBsZXRpb24gb2YgdGhlIG5leHQKLkJSIHZmb3JrICgyKS4KQQou
QlIgd2FpdHBpZCAoMikKYnkgdGhlIHRyYWNlciB3aWxsIHJldHVybiBhCi5JIHN0YXR1cwp2YWx1
ZSBzdWNoIHRoYXQKCi5uZgogIHN0YXR1cz4+OCA9PSAoU0lHVFJBUCB8IChQVFJBQ0VfRVZFTlRf
VkZPUktfRE9ORTw8OCkpCi5maQoKVGhlIFBJRCBvZiB0aGUgbmV3IHByb2Nlc3MgY2FuIChzaW5j
ZSBMaW51eCAyLjYuMTgpIGJlIHJldHJpZXZlZCB3aXRoCi5CUiBQVFJBQ0VfR0VURVZFTlRNU0cg
LgouVFAKLkJSIFBUUkFDRV9PX1RSQUNFRVhJVCAiIChzaW5jZSBMaW51eCAyLjUuNjApIgpTdG9w
IHRoZSB0cmFjZWUgYXQgZXhpdC4KQQouQlIgd2FpdHBpZCAoMikKYnkgdGhlIHRyYWNlciB3aWxs
IHJldHVybiBhCi5JIHN0YXR1cwp2YWx1ZSBzdWNoIHRoYXQKCi5uZgogIHN0YXR1cz4+OCA9PSAo
U0lHVFJBUCB8IChQVFJBQ0VfRVZFTlRfRVhJVDw8OCkpCi5maQoKVGhlIHRyYWNlZSdzIGV4aXQg
c3RhdHVzIGNhbiBiZSByZXRyaWV2ZWQgd2l0aAouQlIgUFRSQUNFX0dFVEVWRU5UTVNHIC4KLklQ
ClRoZSB0cmFjZWUgaXMgc3RvcHBlZCBlYXJseSBkdXJpbmcgcHJvY2VzcyBleGl0LAp3aGVuIHJl
Z2lzdGVycyBhcmUgc3RpbGwgYXZhaWxhYmxlLAphbGxvd2luZyB0aGUgdHJhY2VyIHRvIHNlZSB3
aGVyZSB0aGUgZXhpdCBvY2N1cnJlZCwKd2hlcmVhcyB0aGUgbm9ybWFsIGV4aXQgbm90aWZpY2F0
aW9uIGlzIGRvbmUgYWZ0ZXIgdGhlIHByb2Nlc3MKaXMgZmluaXNoZWQgZXhpdGluZy4KRXZlbiB0
aG91Z2ggY29udGV4dCBpcyBhdmFpbGFibGUsCnRoZSB0cmFjZXIgY2Fubm90IHByZXZlbnQgdGhl
IGV4aXQgZnJvbSBoYXBwZW5pbmcgYXQgdGhpcyBwb2ludC4KLlJFCi5UUAouQlIgUFRSQUNFX0dF
VEVWRU5UTVNHICIgKHNpbmNlIExpbnV4IDIuNS40NikiClJldHJpZXZlIGEgbWVzc2FnZSAoYXMg
YW4KLklSICJ1bnNpZ25lZCBsb25nIiApCmFib3V0IHRoZSBwdHJhY2UgZXZlbnQKdGhhdCBqdXN0
IGhhcHBlbmVkLCBwbGFjaW5nIGl0IGF0IHRoZSBhZGRyZXNzCi5JIGRhdGEKaW4gdGhlIHRyYWNl
ci4KRm9yCi5CUiBQVFJBQ0VfRVZFTlRfRVhJVCAsCnRoaXMgaXMgdGhlIHRyYWNlZSdzIGV4aXQg
c3RhdHVzLgpGb3IKLkJSIFBUUkFDRV9FVkVOVF9GT1JLICwKLkJSIFBUUkFDRV9FVkVOVF9WRk9S
SyAsCi5CUiBQVFJBQ0VfRVZFTlRfVkZPUktfRE9ORSAsCmFuZAouQlIgUFRSQUNFX0VWRU5UX0NM
T05FICwKdGhpcyBpcyB0aGUgUElEIG9mIHRoZSBuZXcgcHJvY2Vzcy4KLlJJICggIGFkZHIKaXMg
aWdub3JlZC4pCi5UUAouQiBQVFJBQ0VfQ09OVApSZXN0YXJ0IHRoZSBzdG9wcGVkIHRyYWNlZSBw
cm9jZXNzLgpJZgouSSBkYXRhCmlzIG5vbnplcm8sCml0IGlzIGludGVycHJldGVkIGFzIHRoZSBu
dW1iZXIgb2YgYSBzaWduYWwgdG8gYmUgZGVsaXZlcmVkIHRvIHRoZSB0cmFjZWU7Cm90aGVyd2lz
ZSwgbm8gc2lnbmFsIGlzIGRlbGl2ZXJlZC4KVGh1cywgZm9yIGV4YW1wbGUsIHRoZSB0cmFjZXIg
Y2FuIGNvbnRyb2wKd2hldGhlciBhIHNpZ25hbCBzZW50IHRvIHRoZSB0cmFjZWUgaXMgZGVsaXZl
cmVkIG9yIG5vdC4KLlJJICggYWRkcgppcyBpZ25vcmVkLikKLlRQCi5CUiBQVFJBQ0VfU1lTQ0FM
TCAiLCAiIFBUUkFDRV9TSU5HTEVTVEVQClJlc3RhcnQgdGhlIHN0b3BwZWQgdHJhY2VlIGFzIGZv
cgouQlIgUFRSQUNFX0NPTlQgLApidXQgYXJyYW5nZSBmb3IgdGhlIHRyYWNlZSB0byBiZSBzdG9w
cGVkIGF0CnRoZSBuZXh0IGVudHJ5IHRvIG9yIGV4aXQgZnJvbSBhIHN5c3RlbSBjYWxsLApvciBh
ZnRlciBleGVjdXRpb24gb2YgYSBzaW5nbGUgaW5zdHJ1Y3Rpb24sIHJlc3BlY3RpdmVseS4KKFRo
ZSB0cmFjZWUgd2lsbCBhbHNvLCBhcyB1c3VhbCwgYmUgc3RvcHBlZCB1cG9uIHJlY2VpcHQgb2Yg
YSBzaWduYWwuKQpGcm9tIHRoZSB0cmFjZXIncyBwZXJzcGVjdGl2ZSwgdGhlIHRyYWNlZSB3aWxs
IGFwcGVhciB0byBoYXZlIGJlZW4Kc3RvcHBlZCBieSByZWNlaXB0IG9mIGEKLkJSIFNJR1RSQVAg
LgpTbywgZm9yCi5CUiBQVFJBQ0VfU1lTQ0FMTCAsCmZvciBleGFtcGxlLCB0aGUgaWRlYSBpcyB0
byBpbnNwZWN0CnRoZSBhcmd1bWVudHMgdG8gdGhlIHN5c3RlbSBjYWxsIGF0IHRoZSBmaXJzdCBz
dG9wLAp0aGVuIGRvIGFub3RoZXIKLkIgUFRSQUNFX1NZU0NBTEwKYW5kIGluc3BlY3QgdGhlIHJl
dHVybiB2YWx1ZSBvZiB0aGUgc3lzdGVtIGNhbGwgYXQgdGhlIHNlY29uZCBzdG9wLgpUaGUKLkkg
ZGF0YQphcmd1bWVudCBpcyB0cmVhdGVkIGFzIGZvcgouQlIgUFRSQUNFX0NPTlQgLgouUkkgKGFk
ZHIKaXMgaWdub3JlZC4pCi5UUAouQlIgUFRSQUNFX1NZU0VNVSAiLCAiIFBUUkFDRV9TWVNFTVVf
U0lOR0xFU1RFUCAiIChzaW5jZSBMaW51eCAyLjYuMTQpIgpGb3IKLkJSIFBUUkFDRV9TWVNFTVUg
LApjb250aW51ZSBhbmQgc3RvcCBvbiBlbnRyeSB0byB0aGUgbmV4dCBzeXN0ZW0gY2FsbCwKd2hp
Y2ggd2lsbCBub3QgYmUgZXhlY3V0ZWQuCkZvcgouQlIgUFRSQUNFX1NZU0VNVV9TSU5HTEVTVEVQ
ICwKZG8gdGhlIHNhbWUgYnV0IGFsc28gc2luZ2xlc3RlcCBpZiBub3QgYSBzeXN0ZW0gY2FsbC4K
VGhpcyBjYWxsIGlzIHVzZWQgYnkgcHJvZ3JhbXMgbGlrZQpVc2VyIE1vZGUgTGludXggdGhhdCB3
YW50IHRvIGVtdWxhdGUgYWxsIHRoZSB0cmFjZWUncyBzeXN0ZW0gY2FsbHMuClRoZQouSSBkYXRh
CmFyZ3VtZW50IGlzIHRyZWF0ZWQgYXMgZm9yCi5CUiBQVFJBQ0VfQ09OVCAuCi5SSSAoIGFkZHIK
aXMgaWdub3JlZDsKbm90IHN1cHBvcnRlZCBvbiBhbGwgYXJjaGl0ZWN0dXJlcy4pCi5UUAouQiBQ
VFJBQ0VfS0lMTApTZW5kIHRoZSB0cmFjZWUgYQouQiBTSUdLSUxMCnRvIHRlcm1pbmF0ZSBpdC4K
LlJJICggYWRkcgphbmQKLkkgZGF0YQphcmUgaWdub3JlZC4pCi5JUAouSSBUaGlzIG9wZXJhdGlv
biBpcyBkZXByZWNhdGVkOyBkbyBub3QgdXNlIGl0IQpJbnN0ZWFkLCBzZW5kIGEKLkJSIFNJR0tJ
TEwKZGlyZWN0bHkgdXNpbmcKLkJSIGtpbGwgKDIpCm9yCi5CUiB0Z2tpbGwgKDIpLgpUaGUgcHJv
YmxlbSB3aXRoCi5CIFBUUkFDRV9LSUxMCmlzIHRoYXQgaXQgcmVxdWlyZXMgdGhlIHRyYWNlZSB0
byBiZSBpbiBzaWduYWwtZGVsaXZlcnktc3RvcCwKb3RoZXJ3aXNlIGl0IG1heSBub3Qgd29yawoo
aS5lLiwgbWF5IGNvbXBsZXRlIHN1Y2Nlc3NmdWxseSBidXQgd29uJ3Qga2lsbCB0aGUgdHJhY2Vl
KS4KQnkgY29udHJhc3QsIHNlbmRpbmcgYQouQiBTSUdLSUxMCmRpcmVjdGx5IGhhcyBubyBzdWNo
IGxpbWl0YXRpb24uCi5cIiBbTm90ZSBmcm9tIERlbnlzIFZsYXNlbmtvOgouXCIgICAgIGRlcHJl
Y2F0aW9uIHN1Z2dlc3RlZCBieSBPbGVnIE5lc3Rlcm92LiBIZSBwcmVmZXJzIHRvIGRlcHJlY2F0
ZSBpdAouXCIgICAgIGluc3RlYWQgb2YgZGVzY3JpYmluZyAoYW5kIG5lZWRpbmcgdG8gc3VwcG9y
dCkgUFRSQUNFX0tJTEwncyBxdWlya3MuXQouVFAKLkIgUFRSQUNFX0FUVEFDSApBdHRhY2ggdG8g
dGhlIHByb2Nlc3Mgc3BlY2lmaWVkIGluCi5JUiBwaWQgLAptYWtpbmcgaXQgYSB0cmFjZWUgb2Yg
dGhlIGNhbGxpbmcgcHJvY2Vzcy4KLlwiIE5vIGxvbmdlciB0cnVlIChyZW1vdmVkIGJ5IERlbnlz
IFZsYXNlbmtvLCAyMDExLCB3aG8gcmVtYXJrczoKLlwiICAgICAgICAiSSB0aGluayBpdCBpc24n
dCB0cnVlIGluIG5vbi1hbmNpZW50IDIuNCBhbmQgaW4gMi42LzMueC4KLlwiICAgICAgICAgQmFz
aWNhbGx5LCBpdCdzIG5vdCB0cnVlIGZvciBhbnkgTGludXggaW4gcHJhY3RpY2FsIHVzZS4KLlwi
IDsgdGhlIGJlaGF2aW9yIG9mIHRoZSB0cmFjZWUgaXMgYXMgaWYgaXQgaGFkIGRvbmUgYQouXCIg
LkJSIFBUUkFDRV9UUkFDRU1FIC4KLlwiIFRoZSBjYWxsaW5nIHByb2Nlc3MgYWN0dWFsbHkgYmVj
b21lcyB0aGUgcGFyZW50IG9mIHRoZSB0cmFjZWUKLlwiIHByb2Nlc3MgZm9yIG1vc3QgcHVycG9z
ZXMgKGUuZy4sIGl0IHdpbGwgcmVjZWl2ZQouXCIgbm90aWZpY2F0aW9uIG9mIHRyYWNlZSBldmVu
dHMgYW5kIGFwcGVhcnMgaW4KLlwiIC5CUiBwcyAoMSkKLlwiIG91dHB1dCBhcyB0aGUgdHJhY2Vl
J3MgcGFyZW50KSwgYnV0IGEKLlwiIC5CUiBnZXRwcGlkICgyKQouXCIgYnkgdGhlIHRyYWNlZSB3
aWxsIHN0aWxsIHJldHVybiB0aGUgUElEIG9mIHRoZSBvcmlnaW5hbCBwYXJlbnQuClRoZSB0cmFj
ZWUgaXMgc2VudCBhCi5CUiBTSUdTVE9QICwKYnV0IHdpbGwgbm90IG5lY2Vzc2FyaWx5IGhhdmUg
c3RvcHBlZApieSB0aGUgY29tcGxldGlvbiBvZiB0aGlzIGNhbGw7IHVzZQouQlIgd2FpdHBpZCAo
MikKdG8gd2FpdCBmb3IgdGhlIHRyYWNlZSB0byBzdG9wLgpTZWUgdGhlICJBdHRhY2hpbmcgYW5k
IGRldGFjaGluZyIgc3Vic2VjdGlvbiBmb3IgYWRkaXRpb25hbCBpbmZvcm1hdGlvbi4KLlJJICgg
YWRkcgphbmQKLkkgZGF0YQphcmUgaWdub3JlZC4pCi5UUAouQiBQVFJBQ0VfREVUQUNIClJlc3Rh
cnQgdGhlIHN0b3BwZWQgdHJhY2VlIGFzIGZvcgouQlIgUFRSQUNFX0NPTlQgLApidXQgZmlyc3Qg
ZGV0YWNoIGZyb20gaXQuClVuZGVyIExpbnV4LCBhIHRyYWNlZSBjYW4gYmUgZGV0YWNoZWQgaW4g
dGhpcyB3YXkgcmVnYXJkbGVzcwpvZiB3aGljaCBtZXRob2Qgd2FzIHVzZWQgdG8gaW5pdGlhdGUg
dHJhY2luZy4KLlJJICggYWRkcgppcyBpZ25vcmVkLikKLlwiCi5cIiBJbiB0aGUgdGV4dCBiZWxv
dywgd2UgZGVjaWRlZCB0byBhdm9pZCBwcmV0dGlmeWluZyB0aGUgdGV4dCB3aXRoIG1hcmt1cDoK
LlwiIGl0IHdvdWxkIG1ha2UgdGhlIHNvdXJjZSBuZWFybHkgaW1wb3NzaWJsZSB0byBlZGl0LCBh
bmQgd2UgX2RvXyBpbnRlbmQKLlwiIHRvIGVkaXQgaXQgb2Z0ZW4sIGluIG9yZGVyIHRvIGtlZXAg
aXQgdXBkYXRlZDoKLlwiIHB0cmFjZSBBUEkgaXMgZnVsbCBvZiBxdWlya3MsIG5vIG5lZWQgdG8g
Y29tcG91bmQgdGhpcyBzaXR1YXRpb24gYnkKLlwiIG1ha2luZyBpdCBleGNydWNpYXRpbmdseSBw
YWluZnVsIHRvIGRvY3VtZW50IHRoZW0hCi5cIgouU1MgRGVhdGggdW5kZXIgcHRyYWNlCldoZW4g
YSAocG9zc2libHkgbXVsdGl0aHJlYWRlZCkgcHJvY2VzcyByZWNlaXZlcyBhIGtpbGxpbmcgc2ln
bmFsCihvbmUgd2hvc2UgZGlzcG9zaXRpb24gaXMgc2V0IHRvCi5CIFNJR19ERkwKYW5kIHdob3Nl
IGRlZmF1bHQgYWN0aW9uIGlzIHRvIGtpbGwgdGhlIHByb2Nlc3MpLAphbGwgdGhyZWFkcyBleGl0
LgpUcmFjZWVzIHJlcG9ydCB0aGVpciBkZWF0aCB0byB0aGVpciB0cmFjZXIocykuCk5vdGlmaWNh
dGlvbiBvZiB0aGlzIGV2ZW50IGlzIGRlbGl2ZXJlZCB2aWEKLkJSIHdhaXRwaWQgKDIpLgouTFAK
Tm90ZSB0aGF0IHRoZSBraWxsaW5nIHNpZ25hbCB3aWxsIGZpcnN0IGNhdXNlIHNpZ25hbC1kZWxp
dmVyeS1zdG9wCihvbiBvbmUgdHJhY2VlIG9ubHkpLAphbmQgb25seSBhZnRlciBpdCBpcyBpbmpl
Y3RlZCBieSB0aGUgdHJhY2VyCihvciBhZnRlciBpdCB3YXMgZGlzcGF0Y2hlZCB0byBhIHRocmVh
ZCB3aGljaCBpc24ndCB0cmFjZWQpLAp3aWxsIGRlYXRoIGZyb20gdGhlIHNpZ25hbCBoYXBwZW4g
b24KLkkgYWxsCnRyYWNlZXMgd2l0aGluIGEgbXVsdGl0aHJlYWRlZCBwcm9jZXNzLgooVGhlIHRl
cm0gInNpZ25hbC1kZWxpdmVyeS1zdG9wIiBpcyBleHBsYWluZWQgYmVsb3cuKQouTFAKLkIgU0lH
S0lMTApvcGVyYXRlcyBzaW1pbGFybHksIHdpdGggZXhjZXB0aW9ucy4KTm8gc2lnbmFsLWRlbGl2
ZXJ5LXN0b3AgaXMgZ2VuZXJhdGVkIGZvcgouQiBTSUdLSUxMCmFuZCB0aGVyZWZvcmUgdGhlIHRy
YWNlciBjYW4ndCBzdXBwcmVzcyBpdC4KLkIgU0lHS0lMTApraWxscyBldmVuIHdpdGhpbiBzeXN0
ZW0gY2FsbHMKKHN5c2NhbGwtZXhpdC1zdG9wIGlzIG5vdCBnZW5lcmF0ZWQgcHJpb3IgdG8gZGVh
dGggYnkKLkJSIFNJR0tJTEwgKS4KVGhlIG5ldCBlZmZlY3QgaXMgdGhhdAouQiBTSUdLSUxMCmFs
d2F5cyBraWxscyB0aGUgcHJvY2VzcyAoYWxsIGl0cyB0aHJlYWRzKSwKZXZlbiBpZiBzb21lIHRo
cmVhZHMgb2YgdGhlIHByb2Nlc3MgYXJlIHB0cmFjZWQuCi5MUApXaGVuIHRoZSB0cmFjZWUgY2Fs
bHMKLkJSIF9leGl0ICgyKSwKaXQgcmVwb3J0cyBpdHMgZGVhdGggdG8gaXRzIHRyYWNlci4KT3Ro
ZXIgdGhyZWFkcyBhcmUgbm90IGFmZmVjdGVkLgouTFAKV2hlbiBhbnkgdGhyZWFkIGV4ZWN1dGVz
Ci5CUiBleGl0X2dyb3VwICgyKSwKZXZlcnkgdHJhY2VlIGluIGl0cyB0aHJlYWQgZ3JvdXAgcmVw
b3J0cyBpdHMgZGVhdGggdG8gaXRzIHRyYWNlci4KLkxQCklmIHRoZQouQiBQVFJBQ0VfT19UUkFD
RUVYSVQKb3B0aW9uIGlzIG9uLAouQiBQVFJBQ0VfRVZFTlRfRVhJVAp3aWxsIGhhcHBlbiBiZWZv
cmUgYWN0dWFsIGRlYXRoLgpUaGlzIGFwcGxpZXMgdG8gZXhpdHMgdmlhCi5CUiBleGl0ICgyKSwK
LkJSIGV4aXRfZ3JvdXAgKDIpLAphbmQgc2lnbmFsIGRlYXRocyAoZXhjZXB0Ci5CUiBTSUdLSUxM
ICksCmFuZCB3aGVuIHRocmVhZHMgYXJlIHRvcm4gZG93biBvbgouQlIgZXhlY3ZlICgyKQppbiBh
IG11bHRpdGhyZWFkZWQgcHJvY2Vzcy4KLkxQClRoZSB0cmFjZXIgY2Fubm90IGFzc3VtZSB0aGF0
IHRoZSBwdHJhY2Utc3RvcHBlZCB0cmFjZWUgZXhpc3RzLgpUaGVyZSBhcmUgbWFueSBzY2VuYXJp
b3Mgd2hlbiB0aGUgdHJhY2VlIG1heSBkaWUgd2hpbGUgc3RvcHBlZCAoc3VjaCBhcwouQlIgU0lH
S0lMTCApLgpUaGVyZWZvcmUsIHRoZSB0cmFjZXIgbXVzdCBiZSBwcmVwYXJlZCB0byBoYW5kbGUg
YW4gCi5CIEVTUkNICmVycm9yIG9uIGFueSBwdHJhY2Ugb3BlcmF0aW9uLgpVbmZvcnR1bmF0ZWx5
LCB0aGUgc2FtZSBlcnJvciBpcyByZXR1cm5lZCBpZiB0aGUgdHJhY2VlCmV4aXN0cyBidXQgaXMg
bm90IHB0cmFjZS1zdG9wcGVkCihmb3IgY29tbWFuZHMgd2hpY2ggcmVxdWlyZSBhIHN0b3BwZWQg
dHJhY2VlKSwKb3IgaWYgaXQgaXMgbm90IHRyYWNlZCBieSB0aGUgcHJvY2VzcyB3aGljaCBpc3N1
ZWQgdGhlIHB0cmFjZSBjYWxsLgpUaGUgdHJhY2VyIG5lZWRzIHRvIGtlZXAgdHJhY2sgb2YgdGhl
IHN0b3BwZWQvcnVubmluZyBzdGF0ZSBvZiB0aGUgdHJhY2VlLAphbmQgaW50ZXJwcmV0Ci5CIEVT
UkNICmFzICJ0cmFjZWUgZGllZCB1bmV4cGVjdGVkbHkiIG9ubHkgaWYgaXQga25vd3MgdGhhdCB0
aGUgdHJhY2VlIGhhcwpiZWVuIG9ic2VydmVkIHRvIGVudGVyIHB0cmFjZS1zdG9wLgpOb3RlIHRo
YXQgdGhlcmUgaXMgbm8gZ3VhcmFudGVlIHRoYXQKLkkgd2FpdHBpZChXTk9IQU5HKQp3aWxsIHJl
bGlhYmx5IHJlcG9ydCB0aGUgdHJhY2VlJ3MgZGVhdGggc3RhdHVzIGlmIGEKcHRyYWNlIG9wZXJh
dGlvbiByZXR1cm5lZAouQlIgRVNSQ0ggLgouSSB3YWl0cGlkKFdOT0hBTkcpCm1heSByZXR1cm4g
MCBpbnN0ZWFkLgpJbiBvdGhlciB3b3JkcywgdGhlIHRyYWNlZSBtYXkgYmUgIm5vdCB5ZXQgZnVs
bHkgZGVhZCIsCmJ1dCBhbHJlYWR5IHJlZnVzaW5nIHB0cmFjZSByZXF1ZXN0cy4KLkxQClRoZSB0
cmFjZXIgY2FuJ3QgYXNzdW1lIHRoYXQgdGhlIHRyYWNlZQouSSBhbHdheXMKZW5kcyBpdHMgbGlm
ZSBieSByZXBvcnRpbmcKLkkgV0lGRVhJVEVEKHN0YXR1cykKb3IKLklSIFdJRlNJR05BTEVEKHN0
YXR1cykgOwp0aGVyZSBhcmUgY2FzZXMgd2hlcmUgdGhpcyBkb2VzIG5vdCBvY2N1ci4KRm9yIGV4
YW1wbGUsIGlmIGEgdGhyZWFkIG90aGVyIHRoYW4gdGhyZWFkIGdyb3VwIGxlYWRlciBkb2VzIGFu
Ci5CUiBleGVjdmUgKDIpLAppdCBkaXNhcHBlYXJzOwppdHMgUElEIHdpbGwgbmV2ZXIgYmUgc2Vl
biBhZ2FpbiwKYW5kIGFueSBzdWJzZXF1ZW50IHB0cmFjZSBzdG9wcyB3aWxsIGJlIHJlcG9ydGVk
IHVuZGVyCnRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyJ3MgUElELgouU1MgU3RvcHBlZCBzdGF0ZXMK
QSB0cmFjZWUgY2FuIGJlIGluIHR3byBzdGF0ZXM6IHJ1bm5pbmcgb3Igc3RvcHBlZC4KLkxQClRo
ZXJlIGFyZSBtYW55IGtpbmRzIG9mIHN0YXRlcyB3aGVuIHRoZSB0cmFjZWUgaXMgc3RvcHBlZCwg
YW5kIGluIHB0cmFjZQpkaXNjdXNzaW9ucyB0aGV5IGFyZSBvZnRlbiBjb25mbGF0ZWQuClRoZXJl
Zm9yZSwgaXQgaXMgaW1wb3J0YW50IHRvIHVzZSBwcmVjaXNlIHRlcm1zLgouTFAKSW4gdGhpcyBt
YW51YWwgcGFnZSwgYW55IHN0b3BwZWQgc3RhdGUgaW4gd2hpY2ggdGhlIHRyYWNlZSBpcyByZWFk
eQp0byBhY2NlcHQgcHRyYWNlIGNvbW1hbmRzIGZyb20gdGhlIHRyYWNlciBpcyBjYWxsZWQKLklS
IHB0cmFjZS1zdG9wIC4KUHRyYWNlLXN0b3BzIGNhbgpiZSBmdXJ0aGVyIHN1YmRpdmlkZWQgaW50
bwouSVIgc2lnbmFsLWRlbGl2ZXJ5LXN0b3AgLAouSVIgZ3JvdXAtc3RvcCAsCi5JUiBzeXNjYWxs
LXN0b3AgLAphbmQgc28gb24uClRoZXNlIHN0b3BwZWQgc3RhdGVzIGFyZSBkZXNjcmliZWQgaW4g
ZGV0YWlsIGJlbG93LgouTFAKV2hlbiB0aGUgcnVubmluZyB0cmFjZWUgZW50ZXJzIHB0cmFjZS1z
dG9wLCBpdCBub3RpZmllcyBpdHMgdHJhY2VyIHVzaW5nCi5CUiB3YWl0cGlkICgyKQoob3Igb25l
IG9mIHRoZSBvdGhlciAid2FpdCIgc3lzdGVtIGNhbGxzKS4KTW9zdCBvZiB0aGlzIG1hbnVhbCBw
YWdlIGFzc3VtZXMgdGhhdCB0aGUgdHJhY2VyIHdhaXRzIHdpdGg6Ci5MUAogICAgcGlkID0gd2Fp
dHBpZChwaWRfb3JfbWludXNfMSwgJnN0YXR1cywgX19XQUxMKTsKLkxQClB0cmFjZS1zdG9wcGVk
IHRyYWNlZXMgYXJlIHJlcG9ydGVkIGFzIHJldHVybnMgd2l0aAouSSBwaWQKZ3JlYXRlciB0aGFu
IDAgYW5kCi5JIFdJRlNUT1BQRUQoc3RhdHVzKQp0cnVlLgouXCIgRGVueXMgVmxhc2Vua286Ci5c
IiAgICAgRG8gd2UgcmVxdWlyZSBfX1dBTEwgdXNhZ2UsIG9yIHdpbGwganVzdCB1c2luZyAwIGJl
IG9rPyAoV2l0aCAwLAouXCIgICAgIEkgYW0gbm90IDEwMCUgc3VyZSB0aGVyZSBhcmVuJ3QgdWds
eSBjb3JuZXIgY2FzZXMuKSBBcmUgdGhlCi5cIiAgICAgcnVsZXMgZGlmZmVyZW50IGlmIHVzZXIg
d2FudHMgdG8gdXNlIHdhaXRpZD8gV2lsbCB3YWl0aWQgcmVxdWlyZQouXCIgICAgIFdFWElURUQ/
Ci5cIgouTFAKVGhlCi5CIF9fV0FMTApmbGFnIGRvZXMgbm90IGluY2x1ZGUgdGhlCi5CIFdTVE9Q
UEVECmFuZAouQiBXRVhJVEVECmZsYWdzLCBidXQgaW1wbGllcyB0aGVpciBmdW5jdGlvbmFsaXR5
LgouTFAKU2V0dGluZyB0aGUKLkIgV0NPTlRJTlVFRApmbGFnIHdoZW4gY2FsbGluZwouQlIgd2Fp
dHBpZCAoMikKaXMgbm90IHJlY29tbWVuZGVkOiB0aGUgImNvbnRpbnVlZCIgc3RhdGUgaXMgcGVy
LXByb2Nlc3MgYW5kCmNvbnN1bWluZyBpdCBjYW4gY29uZnVzZSB0aGUgcmVhbCBwYXJlbnQgb2Yg
dGhlIHRyYWNlZS4KLkxQClVzZSBvZiB0aGUKLkIgV05PSEFORwpmbGFnIG1heSBjYXVzZQouQlIg
d2FpdHBpZCAoMikKdG8gcmV0dXJuIDAgKCJubyB3YWl0IHJlc3VsdHMgYXZhaWxhYmxlIHlldCIp
CmV2ZW4gaWYgdGhlIHRyYWNlciBrbm93cyB0aGVyZSBzaG91bGQgYmUgYSBub3RpZmljYXRpb24u
CkV4YW1wbGU6Ci5uZgoKICAgIGtpbGwodHJhY2VlLCBTSUdLSUxMKTsKICAgIHdhaXRwaWQodHJh
Y2VlLCAmc3RhdHVzLCBfX1dBTEwgfCBXTk9IQU5HKTsKLmZpCi5cIiBGSVhNRTogbXRrOiB0aGUg
Zm9sbG93aW5nIGNvbW1lbnQgc2VlbXMgdG8gYmUgdW5yZXNvbHZlZD8KLlwiICAgICAgICBEbyB5
b3Ugd2FudCB0byBhZGQgYW55dGhpbmc/Ci5cIgouXCIgICAgIHdhaXRpZCB1c2FnZT8gV05PV0FJ
VD8KLlwiICAgICBkZXNjcmliZSBob3cgd2FpdCBub3RpZmljYXRpb25zIHF1ZXVlIChvciBub3Qg
cXVldWUpCi5MUApUaGUgZm9sbG93aW5nIGtpbmRzIG9mIHB0cmFjZS1zdG9wcyBleGlzdDogc2ln
bmFsLWRlbGl2ZXJ5LXN0b3BzLApncm91cC1zdG9wLCBQVFJBQ0VfRVZFTlQgc3RvcHMsIHN5c2Nh
bGwtc3RvcHMKLlwiCi5cIiBGSVhNRTogbXRrOiB0aGUgZm9sbG93aW5nIHRleHQgKCJbLCBQVFJB
Q0VfU0lOR0xFU1RFUC4uLiIpIGlzIGluY29tcGxldGUuCi5cIiAgICAgICAgRG8geW91IHdhbnQg
dG8gYWRkIGFueXRoaW5nPwouXCIKWywgUFRSQUNFX1NJTkdMRVNURVAsIFBUUkFDRV9TWVNFTVUs
ClBUUkFDRV9TWVNFTVVfU0lOR0xFU1RFUF0uClRoZXkgYWxsIGFyZSByZXBvcnRlZCBieQouQlIg
d2FpdHBpZCAoMikKd2l0aAouSSBXSUZTVE9QUEVEKHN0YXR1cykKdHJ1ZS4KVGhleSBtYXkgYmUg
ZGlmZmVyZW50aWF0ZWQgYnkgZXhhbWluaW5nIHRoZSB2YWx1ZQouSVIgc3RhdHVzPj44ICwKYW5k
IGlmIHRoZXJlIGlzIGFtYmlndWl0eSBpbiB0aGF0IHZhbHVlLCBieSBxdWVyeWluZwouQlIgUFRS
QUNFX0dFVFNJR0lORk8gLgooTm90ZTogdGhlCi5JIFdTVE9QU0lHKHN0YXR1cykKbWFjcm8gY2Fu
J3QgYmUgdXNlZCB0byBwZXJmb3JtIHRoaXMgZXhhbWluYXRpb24sCmJlY2F1c2UgaXQgcmV0dXJu
cyB0aGUgdmFsdWUKKFxmSXN0YXR1c1w+PjgpXCBcZkImXCAweGZmXGZQXGZQLikKLlNTIFNpZ25h
bC1kZWxpdmVyeS1zdG9wCldoZW4gYSAocG9zc2libHkgbXVsdGl0aHJlYWRlZCkgcHJvY2VzcyBy
ZWNlaXZlcyBhbnkgc2lnbmFsIGV4Y2VwdAouQlIgU0lHS0lMTCAsCnRoZSBrZXJuZWwgc2VsZWN0
cyBhbiBhcmJpdHJhcnkgdGhyZWFkIHdoaWNoIGhhbmRsZXMgdGhlIHNpZ25hbC4KKElmIHRoZSBz
aWduYWwgaXMgZ2VuZXJhdGVkIHdpdGgKLkJSIHRna2lsbCAoMiksCnRoZSB0YXJnZXQgdGhyZWFk
IGNhbiBiZSBleHBsaWNpdGx5IHNlbGVjdGVkIGJ5IHRoZSBjYWxsZXIuKQpJZiB0aGUgc2VsZWN0
ZWQgdGhyZWFkIGlzIHRyYWNlZCwgaXQgZW50ZXJzIHNpZ25hbC1kZWxpdmVyeS1zdG9wLgpBdCB0
aGlzIHBvaW50LCB0aGUgc2lnbmFsIGlzIG5vdCB5ZXQgZGVsaXZlcmVkIHRvIHRoZSBwcm9jZXNz
LAphbmQgY2FuIGJlIHN1cHByZXNzZWQgYnkgdGhlIHRyYWNlci4KSWYgdGhlIHRyYWNlciBkb2Vz
bid0IHN1cHByZXNzIHRoZSBzaWduYWwsCml0IHBhc3NlcyB0aGUgc2lnbmFsIHRvIHRoZSB0cmFj
ZWUgaW4gdGhlIG5leHQgcHRyYWNlIHJlc3RhcnQgcmVxdWVzdC4KVGhpcyBzZWNvbmQgc3RlcCBv
ZiBzaWduYWwgZGVsaXZlcnkgaXMgY2FsbGVkCi5JICJzaWduYWwgaW5qZWN0aW9uIgppbiB0aGlz
IG1hbnVhbCBwYWdlLgpOb3RlIHRoYXQgaWYgdGhlIHNpZ25hbCBpcyBibG9ja2VkLApzaWduYWwt
ZGVsaXZlcnktc3RvcCBkb2Vzbid0IGhhcHBlbiB1bnRpbCB0aGUgc2lnbmFsIGlzIHVuYmxvY2tl
ZCwKd2l0aCB0aGUgdXN1YWwgZXhjZXB0aW9uIHRoYXQKLkIgU0lHU1RPUApjYW4ndCBiZSBibG9j
a2VkLgouTFAKU2lnbmFsLWRlbGl2ZXJ5LXN0b3AgaXMgb2JzZXJ2ZWQgYnkgdGhlIHRyYWNlciBh
cwouQlIgd2FpdHBpZCAoMikKcmV0dXJuaW5nIHdpdGgKLkkgV0lGU1RPUFBFRChzdGF0dXMpCnRy
dWUsIHdpdGggdGhlIHN0b3BwaW5nIHNpZ25hbCByZXR1cm5lZCBieQouSVIgV1NUT1BTSUcoc3Rh
dHVzKSAuCklmIHRoZSBzdG9wcGluZyBzaWduYWwgaXMKLkJSIFNJR1RSQVAgLAp0aGlzIG1heSBi
ZSBhIGRpZmZlcmVudCBraW5kIG9mIHB0cmFjZS1zdG9wOwpzZWUgdGhlICJTeXNjYWxsLXN0b3Bz
IiBhbmQgImV4ZWN2ZSIgc2VjdGlvbnMgYmVsb3cgZm9yIGRldGFpbHMuCklmCi5JIFdTVE9QU0lH
KHN0YXR1cykKcmV0dXJucyBhIHN0b3BwaW5nIHNpZ25hbCwgdGhpcyBtYXkgYmUgYSBncm91cC1z
dG9wOyBzZWUgYmVsb3cuCi5TUyBTaWduYWwgaW5qZWN0aW9uIGFuZCBzdXBwcmVzc2lvbgpBZnRl
ciBzaWduYWwtZGVsaXZlcnktc3RvcCBpcyBvYnNlcnZlZCBieSB0aGUgdHJhY2VyLAp0aGUgdHJh
Y2VyIHNob3VsZCByZXN0YXJ0IHRoZSB0cmFjZWUgd2l0aCB0aGUgY2FsbAouTFAKICAgIHB0cmFj
ZShQVFJBQ0VfcmVzdGFydCwgcGlkLCAwLCBzaWcpCi5MUAp3aGVyZQouQiBQVFJBQ0VfcmVzdGFy
dAppcyBvbmUgb2YgdGhlIHJlc3RhcnRpbmcgcHRyYWNlIHJlcXVlc3RzLgpJZgouSSBzaWcKaXMg
MCwgdGhlbiBhIHNpZ25hbCBpcyBub3QgZGVsaXZlcmVkLgpPdGhlcndpc2UsIHRoZSBzaWduYWwK
Lkkgc2lnCmlzIGRlbGl2ZXJlZC4KVGhpcyBvcGVyYXRpb24gaXMgY2FsbGVkCi5JICJzaWduYWwg
aW5qZWN0aW9uIgppbiB0aGlzIG1hbnVhbCBwYWdlLCB0byBkaXN0aW5ndWlzaCBpdCBmcm9tIHNp
Z25hbC1kZWxpdmVyeS1zdG9wLgouTFAKVGhlCi5JIHNpZwp2YWx1ZSBtYXkgYmUgZGlmZmVyZW50
IGZyb20gdGhlCi5JIFdTVE9QU0lHKHN0YXR1cykKdmFsdWU6IHRoZSB0cmFjZXIgY2FuIGNhdXNl
IGEgZGlmZmVyZW50IHNpZ25hbCB0byBiZSBpbmplY3RlZC4KLkxQCk5vdGUgdGhhdCBhIHN1cHBy
ZXNzZWQgc2lnbmFsIHN0aWxsIGNhdXNlcyBzeXN0ZW0gY2FsbHMgdG8gcmV0dXJuCnByZW1hdHVy
ZWx5LgpSZXN0YXJ0YWJsZSBzeXN0ZW0gY2FsbHMgd2lsbCBiZSByZXN0YXJ0ZWQgKHRoZSB0cmFj
ZXIgd2lsbApvYnNlcnZlIHRoZSB0cmFjZWUgdG8gZXhlY3V0ZQouQlIgcmVzdGFydF9zeXNjYWxs
KDIpCmlmIHRoZSB0cmFjZXIgdXNlcwouQlIgUFRSQUNFX1NZU0NBTEwgKTsKbm9uLXJlc3RhcnRh
YmxlIHN5c3RlbSBjYWxscyBtYXkgZmFpbCB3aXRoCi5CIEVJTlRSCmV2ZW4gdGhvdWdoIG5vIG9i
c2VydmFibGUgc2lnbmFsIGlzIGluamVjdGVkIHRvIHRoZSB0cmFjZWUuCi5MUApSZXN0YXJ0aW5n
IHB0cmFjZSBjb21tYW5kcyBpc3N1ZWQgaW4gcHRyYWNlLXN0b3BzIG90aGVyIHRoYW4Kc2lnbmFs
LWRlbGl2ZXJ5LXN0b3AgYXJlIG5vdCBndWFyYW50ZWVkIHRvIGluamVjdCBhIHNpZ25hbCwgZXZl
biBpZgouSSBzaWcKaXMgbm9uemVyby4KTm8gZXJyb3IgaXMgcmVwb3J0ZWQ7IGEgbm9uemVybwou
SSBzaWcKbWF5IHNpbXBseSBiZSBpZ25vcmVkLgpQdHJhY2UgdXNlcnMgc2hvdWxkIG5vdCB0cnkg
dG8gImNyZWF0ZSBhIG5ldyBzaWduYWwiIHRoaXMgd2F5OiB1c2UKLkJSIHRna2lsbCAoMikKaW5z
dGVhZC4KLkxQClRoZSBmYWN0IHRoYXQgc2lnbmFsIGluamVjdGlvbiByZXF1ZXN0cyBtYXkgYmUg
aWdub3JlZAp3aGVuIHJlc3RhcnRpbmcgdGhlIHRyYWNlZSBhZnRlcgpwdHJhY2Ugc3RvcHMgdGhh
dCBhcmUgbm90IHNpZ25hbC1kZWxpdmVyeS1zdG9wcwppcyBhIGNhdXNlIG9mIGNvbmZ1c2lvbiBh
bW9uZyBwdHJhY2UgdXNlcnMuCk9uZSB0eXBpY2FsIHNjZW5hcmlvIGlzIHRoYXQgdGhlIHRyYWNl
ciBvYnNlcnZlcyBncm91cC1zdG9wLAptaXN0YWtlcyBpdCBmb3Igc2lnbmFsLWRlbGl2ZXJ5LXN0
b3AsIHJlc3RhcnRzIHRoZSB0cmFjZWUgd2l0aAoKICAgIHB0cmFjZShQVFJBQ0VfcmVzdCwgcGlk
LCAwLCBzdG9wc2lnKQoKd2l0aCB0aGUgaW50ZW50aW9uIG9mIGluamVjdGluZwouSVIgc3RvcHNp
ZyAsCmJ1dAouSSBzdG9wc2lnCmdldHMgaWdub3JlZCBhbmQgdGhlIHRyYWNlZSBjb250aW51ZXMg
dG8gcnVuLgouTFAKVGhlCi5CIFNJR0NPTlQKc2lnbmFsIGhhcyBhIHNpZGUgZWZmZWN0IG9mIHdh
a2luZyB1cCAoYWxsIHRocmVhZHMgb2YpCmEgZ3JvdXAtc3RvcHBlZCBwcm9jZXNzLgpUaGlzIHNp
ZGUgZWZmZWN0IGhhcHBlbnMgYmVmb3JlIHNpZ25hbC1kZWxpdmVyeS1zdG9wLgpUaGUgdHJhY2Vy
IGNhbid0IHN1cHByZXNzIHRoaXMgc2lkZS1lZmZlY3QgKGl0IGNhbgpvbmx5IHN1cHByZXNzIHNp
Z25hbCBpbmplY3Rpb24sIHdoaWNoIG9ubHkgY2F1c2VzIHRoZQouQlIgU0lHQ09OVApoYW5kbGVy
IHRvIG5vdCBiZSBleGVjdXRlZCBpbiB0aGUgdHJhY2VlLCBpZiBzdWNoIGEgaGFuZGxlciBpcyBp
bnN0YWxsZWQpLgpJbiBmYWN0LCB3YWtpbmcgdXAgZnJvbSBncm91cC1zdG9wIG1heSBiZSBmb2xs
b3dlZCBieQpzaWduYWwtZGVsaXZlcnktc3RvcCBmb3Igc2lnbmFsKHMpCi5JIG90aGVyIHRoYW4K
LkJSIFNJR0NPTlQgLAppZiB0aGV5IHdlcmUgcGVuZGluZyB3aGVuCi5CIFNJR0NPTlQKd2FzIGRl
bGl2ZXJlZC4KSW4gb3RoZXIgd29yZHMsCi5CIFNJR0NPTlQKbWF5IGJlIG5vdCB0aGUgZmlyc3Qg
c2lnbmFsIG9ic2VydmVkIGJ5IHRoZSB0cmFjZWUgYWZ0ZXIgaXQgd2FzIHNlbnQuCi5MUApTdG9w
cGluZyBzaWduYWxzIGNhdXNlIChhbGwgdGhyZWFkcyBvZikgYSBwcm9jZXNzIHRvIGVudGVyIGdy
b3VwLXN0b3AuClRoaXMgc2lkZSBlZmZlY3QgaGFwcGVucyBhZnRlciBzaWduYWwgaW5qZWN0aW9u
LCBhbmQgdGhlcmVmb3JlIGNhbiBiZQpzdXBwcmVzc2VkIGJ5IHRoZSB0cmFjZXIuCi5MUApJbiBM
aW51eCAyLjQgYW5kIGVhcmxpZXIsIHRoZQouQiBTSUdTVE9QCnNpZ25hbCBjYW4ndCBiZSBpbmpl
Y3RlZC4KLlwiIEluIHRoZSBMaW51eCAyLjQgc291cmNlcywgaW4gYXJjaC9pMzg2L2tlcm5lbC9z
aWduYWwuYzo6ZG9fc2lnbmFsKCksCi5cIiB0aGVyZSBpczoKLlwiIAouXCIgICAgICAgICAgICAg
LyogVGhlIGRlYnVnZ2VyIGNvbnRpbnVlZC4gIElnbm9yZSBTSUdTVE9QLiAgKi8KLlwiICAgICAg
ICAgICAgIGlmIChzaWduciA9PSBTSUdTVE9QKQouXCIgICAgICAgICAgICAgICAgICAgICBjb250
aW51ZTsKLkxQCi5CIFBUUkFDRV9HRVRTSUdJTkZPCmNhbiBiZSB1c2VkIHRvIHJldHJpZXZlIGEK
Lkkgc2lnaW5mb190CnN0cnVjdHVyZSB3aGljaCBjb3JyZXNwb25kcyB0byB0aGUgZGVsaXZlcmVk
IHNpZ25hbC4KLkIgUFRSQUNFX1NFVFNJR0lORk8KbWF5IGJlIHVzZWQgdG8gbW9kaWZ5IGl0LgpJ
ZgouQiBQVFJBQ0VfU0VUU0lHSU5GTwpoYXMgYmVlbiB1c2VkIHRvIGFsdGVyCi5JUiBzaWdpbmZv
X3QgLAp0aGUKLkkgc2lfc2lnbm8KZmllbGQgYW5kIHRoZQouSSBzaWcKcGFyYW1ldGVyIGluIHRo
ZSByZXN0YXJ0aW5nIGNvbW1hbmQgbXVzdCBtYXRjaCwKb3RoZXJ3aXNlIHRoZSByZXN1bHQgaXMg
dW5kZWZpbmVkLgouU1MgR3JvdXAtc3RvcApXaGVuIGEgKHBvc3NpYmx5IG11bHRpdGhyZWFkZWQp
IHByb2Nlc3MgcmVjZWl2ZXMgYSBzdG9wcGluZyBzaWduYWwsCmFsbCB0aHJlYWRzIHN0b3AuCklm
IHNvbWUgdGhyZWFkcyBhcmUgdHJhY2VkLCB0aGV5IGVudGVyIGEgZ3JvdXAtc3RvcC4KTm90ZSB0
aGF0IHRoZSBzdG9wcGluZyBzaWduYWwgd2lsbCBmaXJzdCBjYXVzZSBzaWduYWwtZGVsaXZlcnkt
c3RvcAoob24gb25lIHRyYWNlZSBvbmx5KSwgYW5kIG9ubHkgYWZ0ZXIgaXQgaXMgaW5qZWN0ZWQg
YnkgdGhlIHRyYWNlcgoob3IgYWZ0ZXIgaXQgd2FzIGRpc3BhdGNoZWQgdG8gYSB0aHJlYWQgd2hp
Y2ggaXNuJ3QgdHJhY2VkKSwKd2lsbCBncm91cC1zdG9wIGJlIGluaXRpYXRlZCBvbgouSSBhbGwK
dHJhY2VlcyB3aXRoaW4gdGhlIG11bHRpdGhyZWFkZWQgcHJvY2Vzcy4KQXMgdXN1YWwsIGV2ZXJ5
IHRyYWNlZSByZXBvcnRzIGl0cyBncm91cC1zdG9wIHNlcGFyYXRlbHkKdG8gdGhlIGNvcnJlc3Bv
bmRpbmcgdHJhY2VyLgouTFAKR3JvdXAtc3RvcCBpcyBvYnNlcnZlZCBieSB0aGUgdHJhY2VyIGFz
Ci5CUiB3YWl0cGlkICgyKQpyZXR1cm5pbmcgd2l0aAouSSBXSUZTVE9QUEVEKHN0YXR1cykKdHJ1
ZSwgd2l0aCB0aGUgc3RvcHBpbmcgc2lnbmFsIGF2YWlsYWJsZSB2aWEKLklSIFdTVE9QU0lHKHN0
YXR1cykgLgpUaGUgc2FtZSByZXN1bHQgaXMgcmV0dXJuZWQgYnkgc29tZSBvdGhlciBjbGFzc2Vz
IG9mIHB0cmFjZS1zdG9wcywKdGhlcmVmb3JlIHRoZSByZWNvbW1lbmRlZCBwcmFjdGljZSBpcyB0
byBwZXJmb3JtIHRoZSBjYWxsCi5MUAogICAgcHRyYWNlKFBUUkFDRV9HRVRTSUdJTkZPLCBwaWQs
IDAsICZzaWdpbmZvKQouTFAKVGhlIGNhbGwgY2FuIGJlIGF2b2lkZWQgaWYgdGhlIHNpZ25hbCBp
cyBub3QKLkJSIFNJR1NUT1AgLAouQlIgU0lHVFNUUCAsCi5CUiBTSUdUVElOICwKb3IKLkJSIFNJ
R1RUT1UgOwpvbmx5IHRoZXNlIGZvdXIgc2lnbmFscyBhcmUgc3RvcHBpbmcgc2lnbmFscy4KSWYg
dGhlIHRyYWNlciBzZWVzIHNvbWV0aGluZyBlbHNlLCBpdCBjYW4ndCBiZSBhIGdyb3VwLXN0b3Au
Ck90aGVyd2lzZSwgdGhlIHRyYWNlciBuZWVkcyB0byBjYWxsCi5CUiBQVFJBQ0VfR0VUU0lHSU5G
TyAuCklmCi5CIFBUUkFDRV9HRVRTSUdJTkZPCmZhaWxzIHdpdGgKLkJSIEVJTlZBTCAsCnRoZW4g
aXQgaXMgZGVmaW5pdGVseSBhIGdyb3VwLXN0b3AuCihPdGhlciBmYWlsdXJlIGNvZGVzIGFyZSBw
b3NzaWJsZSwgc3VjaCBhcwouQiBFU1JDSAooIm5vIHN1Y2ggcHJvY2VzcyIpIGlmIGEKLkIgU0lH
S0lMTApraWxsZWQgdGhlIHRyYWNlZS4pCi5MUApBcyBvZiBrZXJuZWwgMi42LjM4LAphZnRlciB0
aGUgdHJhY2VyIHNlZXMgdGhlIHRyYWNlZSBwdHJhY2Utc3RvcCBhbmQgdW50aWwgaXQKcmVzdGFy
dHMgb3Iga2lsbHMgaXQsIHRoZSB0cmFjZWUgd2lsbCBub3QgcnVuLAphbmQgd2lsbCBub3Qgc2Vu
ZCBub3RpZmljYXRpb25zIChleGNlcHQKLkIgU0lHS0lMTApkZWF0aCkgdG8gdGhlIHRyYWNlciwg
ZXZlbiBpZiB0aGUgdHJhY2VyIGVudGVycyBpbnRvIGFub3RoZXIKLkJSIHdhaXRwaWQgKDIpCmNh
bGwuCi5MUAouXCIgRklYTUUgSXQgaXMgdW5jbGVhciB3aGF0ICJ0aGlzIGtlcm5lbCBiZWhhdmlv
ciIgcmVmZXJzIHRvLgouXCIgQ2FuIHNob3cgbWUgZXhhY3RseSB3aGljaCBwaWVjZSBvZiB0ZXh0
IGFib3ZlIG9yIGJlbG93IGlzCi5cIiByZWZlcnJlZCB0byB3aGVuIHlvdSBzYXkgInRoaXMga2Vy
bmVsIGJlaGF2aW9yIj8KQ3VycmVudGx5LCB0aGlzIGtlcm5lbCBiZWhhdmlvcgpjYXVzZXMgYSBw
cm9ibGVtIHdpdGggdHJhbnNwYXJlbnQgaGFuZGxpbmcgb2Ygc3RvcHBpbmcgc2lnbmFsczoKaWYg
dGhlIHRyYWNlciByZXN0YXJ0cyB0aGUgdHJhY2VlIGFmdGVyIGdyb3VwLXN0b3AsCnRoZSBzdG9w
cGluZyBzaWduYWwKaXMgZWZmZWN0aXZlbHkgaWdub3JlZFwoZW10aGUgdHJhY2VlIGRvZXNuJ3Qg
cmVtYWluIHN0b3BwZWQsIGl0IHJ1bnMuCklmIHRoZSB0cmFjZXIgZG9lc24ndCByZXN0YXJ0IHRo
ZSB0cmFjZWUgYmVmb3JlIGVudGVyaW5nIGludG8gdGhlIG5leHQKLkJSIHdhaXRwaWQgKDIpLApm
dXR1cmUKLkIgU0lHQ09OVApzaWduYWxzIHdpbGwgbm90IGJlIHJlcG9ydGVkIHRvIHRoZSB0cmFj
ZXIuClRoaXMgd291bGQgY2F1c2UKLkIgU0lHQ09OVAp0byBoYXZlIG5vIGVmZmVjdC4KLlNTIFBU
UkFDRV9FVkVOVCBzdG9wcwpJZiB0aGUgdHJhY2VyIHNldHMKLkIgUFRSQUNFX09fVFJBQ0VfKgpv
cHRpb25zLCB0aGUgdHJhY2VlIHdpbGwgZW50ZXIgcHRyYWNlLXN0b3BzIGNhbGxlZAouQiBQVFJB
Q0VfRVZFTlQKc3RvcHMuCi5MUAouQiBQVFJBQ0VfRVZFTlQKc3RvcHMgYXJlIG9ic2VydmVkIGJ5
IHRoZSB0cmFjZXIgYXMKLkJSIHdhaXRwaWQgKDIpCnJldHVybmluZyB3aXRoCi5JUiBXSUZTVE9Q
UEVEKHN0YXR1cykgLAphbmQKLkkgV1NUT1BTSUcoc3RhdHVzKQpyZXR1cm5zCi5CUiBTSUdUUkFQ
IC4KQW4gYWRkaXRpb25hbCBiaXQgaXMgc2V0IGluIHRoZSBoaWdoZXIgYnl0ZSBvZiB0aGUgc3Rh
dHVzIHdvcmQ6CnRoZSB2YWx1ZQouSSBzdGF0dXM+PjgKd2lsbCBiZQoKICAgIChTSUdUUkFQIHwg
UFRSQUNFX0VWRU5UX2ZvbyA8PCA4KS4KClRoZSBmb2xsb3dpbmcgZXZlbnRzIGV4aXN0OgouVFAK
LkIgUFRSQUNFX0VWRU5UX1ZGT1JLClN0b3AgYmVmb3JlIHJldHVybiBmcm9tCi5CUiB2Zm9yayAo
MikKb3IKLkJSIGNsb25lICgyKQp3aXRoIHRoZQouQiBDTE9ORV9WRk9SSwpmbGFnLgpXaGVuIHRo
ZSB0cmFjZWUgaXMgY29udGludWVkIGFmdGVyIHRoaXMgc3RvcCwgaXQgd2lsbCB3YWl0IGZvciBj
aGlsZCB0bwpleGl0L2V4ZWMgYmVmb3JlIGNvbnRpbnVpbmcgaXRzIGV4ZWN1dGlvbgooaW4gb3Ro
ZXIgd29yZHMsIHRoZSB1c3VhbCBiZWhhdmlvciBvbgouQlIgdmZvcmsgKDIpKS4KLlRQCi5CIFBU
UkFDRV9FVkVOVF9GT1JLClN0b3AgYmVmb3JlIHJldHVybiBmcm9tCi5CUiBmb3JrICgyKQpvcgou
QlIgY2xvbmUgKDIpCndpdGggdGhlIGV4aXQgc2lnbmFsIHNldCB0bwouQlIgU0lHQ0hMRCAuCi5U
UAouQiBQVFJBQ0VfRVZFTlRfQ0xPTkUKU3RvcCBiZWZvcmUgcmV0dXJuIGZyb20KLkJSIGNsb25l
ICgyKQouVFAKLkIgUFRSQUNFX0VWRU5UX1ZGT1JLX0RPTkUKU3RvcCBiZWZvcmUgcmV0dXJuIGZy
b20KLkJSIHZmb3JrICgyKQpvcgouQlIgY2xvbmUgKDIpCndpdGggdGhlCi5CIENMT05FX1ZGT1JL
CmZsYWcsCmJ1dCBhZnRlciB0aGUgY2hpbGQgdW5ibG9ja2VkIHRoaXMgdHJhY2VlIGJ5IGV4aXRp
bmcgb3IgZXhlY2luZy4KLkxQCkZvciBhbGwgZm91ciBzdG9wcyBkZXNjcmliZWQgYWJvdmUsCnRo
ZSBzdG9wIG9jY3VycyBpbiB0aGUgcGFyZW50IChpLmUuLCB0aGUgdHJhY2VlKSwKbm90IGluIHRo
ZSBuZXdseSBjcmVhdGVkIHRocmVhZC4KLkJSIFBUUkFDRV9HRVRFVkVOVE1TRwpjYW4gYmUgdXNl
ZCB0byByZXRyaWV2ZSB0aGUgbmV3IHRocmVhZCdzIElELgouVFAKLkIgUFRSQUNFX0VWRU5UX0VY
RUMKU3RvcCBiZWZvcmUgcmV0dXJuIGZyb20KLkJSIGV4ZWN2ZSAoMikuCi5UUAouQiBQVFJBQ0Vf
RVZFTlRfRVhJVApTdG9wIGJlZm9yZSBleGl0IChpbmNsdWRpbmcgZGVhdGggZnJvbQouQlIgZXhp
dF9ncm91cCAoMikpLApzaWduYWwgZGVhdGgsIG9yIGV4aXQgY2F1c2VkIGJ5Ci5CUiBleGVjdmUg
KDIpCmluIGEgbXVsdGl0aHJlYWRlZCBwcm9jZXNzLgouQiBQVFJBQ0VfR0VURVZFTlRNU0cKcmV0
dXJucyB0aGUgZXhpdCBzdGF0dXMuClJlZ2lzdGVycyBjYW4gYmUgZXhhbWluZWQKKHVubGlrZSB3
aGVuICJyZWFsIiBleGl0IGhhcHBlbnMpLgpUaGUgdHJhY2VlIGlzIHN0aWxsIGFsaXZlOyBpdCBu
ZWVkcyB0byBiZQouQlIgUFRSQUNFX0NPTlQgZWQKb3IKLkJSIFBUUkFDRV9ERVRBQ0ggZWQKdG8g
ZmluaXNoIGV4aXRpbmcuCi5MUAouQiBQVFJBQ0VfR0VUU0lHSU5GTwpvbgouQiBQVFJBQ0VfRVZF
TlQKc3RvcHMgcmV0dXJucwouQiBTSUdUUkFQIGluCi5JUiBzaV9zaWdubyAsCndpdGgKLkkgc2lf
Y29kZQpzZXQgdG8KLklSICIoZXZlbnQ8PDgpXCB8XCBTSUdUUkFQIiAuCi5TUyBTeXNjYWxsLXN0
b3BzCklmIHRoZSB0cmFjZWUgd2FzIHJlc3RhcnRlZCBieQouQlIgUFRSQUNFX1NZU0NBTEwgLAp0
aGUgdHJhY2VlIGVudGVycwpzeXNjYWxsLWVudGVyLXN0b3AganVzdCBwcmlvciB0byBlbnRlcmlu
ZyBhbnkgc3lzdGVtIGNhbGwuCklmIHRoZSB0cmFjZXIgcmVzdGFydHMgdGhlIHRyYWNlZSB3aXRo
Ci5CUiBQVFJBQ0VfU1lTQ0FMTCAsCnRoZSB0cmFjZWUgZW50ZXJzIHN5c2NhbGwtZXhpdC1zdG9w
IHdoZW4gdGhlIHN5c3RlbSBjYWxsIGlzIGZpbmlzaGVkLApvciBpZiBpdCBpcyBpbnRlcnJ1cHRl
ZCBieSBhIHNpZ25hbC4KKFRoYXQgaXMsIHNpZ25hbC1kZWxpdmVyeS1zdG9wIG5ldmVyIGhhcHBl
bnMgYmV0d2VlbiBzeXNjYWxsLWVudGVyLXN0b3AKYW5kIHN5c2NhbGwtZXhpdC1zdG9wOyBpdCBo
YXBwZW5zCi5JIGFmdGVyCnN5c2NhbGwtZXhpdC1zdG9wLikKLkxQCk90aGVyIHBvc3NpYmlsaXRp
ZXMgYXJlIHRoYXQgdGhlIHRyYWNlZSBtYXkgc3RvcCBpbiBhCi5CIFBUUkFDRV9FVkVOVApzdG9w
LCBleGl0IChpZiBpdCBlbnRlcmVkCi5CUiBfZXhpdCAoMikKb3IKLkJSIGV4aXRfZ3JvdXAgKDIp
KSwKYmUga2lsbGVkIGJ5Ci5CUiBTSUdLSUxMICwKb3IgZGllIHNpbGVudGx5IChpZiBpdCBpcyBh
IHRocmVhZCBncm91cCBsZWFkZXIsIHRoZQouQlIgZXhlY3ZlICgyKQpoYXBwZW5lZCBpbiBhbm90
aGVyIHRocmVhZCwKYW5kIHRoYXQgdGhyZWFkIGlzIG5vdCB0cmFjZWQgYnkgdGhlIHNhbWUgdHJh
Y2VyOwp0aGlzIHNpdHVhdGlvbiBpcyBkaXNjdXNzZWQgbGF0ZXIpLgouTFAKU3lzY2FsbC1lbnRl
ci1zdG9wIGFuZCBzeXNjYWxsLWV4aXQtc3RvcCBhcmUgb2JzZXJ2ZWQgYnkgdGhlIHRyYWNlciBh
cwouQlIgd2FpdHBpZCAoMikKcmV0dXJuaW5nIHdpdGgKLkkgV0lGU1RPUFBFRChzdGF0dXMpCnRy
dWUsIGFuZAouSSBXU1RPUFNJRyhzdGF0dXMpCmdpdmluZwouQlIgU0lHVFJBUCAuCklmIHRoZQou
QiBQVFJBQ0VfT19UUkFDRVNZU0dPT0QKb3B0aW9uIHdhcyBzZXQgYnkgdGhlIHRyYWNlciwgdGhl
bgouSSBXU1RPUFNJRyhzdGF0dXMpCndpbGwgZ2l2ZSB0aGUgdmFsdWUKLklSICIoU0lHVFJBUFwg
fFwgMHg4MCkiIC4KLkxQClN5c2NhbGwtc3RvcHMgY2FuIGJlIGRpc3Rpbmd1aXNoZWQgZnJvbSBz
aWduYWwtZGVsaXZlcnktc3RvcCB3aXRoCi5CIFNJR1RSQVAKYnkgcXVlcnlpbmcKLkJSIFBUUkFD
RV9HRVRTSUdJTkZPCmZvciB0aGUgZm9sbG93aW5nIGNhc2VzOgouVFAKLklSIHNpX2NvZGUgIiA8
PSAwIgouQiBTSUdUUkFQCndhcyBkZWxpdmVyZWQgYXMgYSByZXN1bHQgb2YgYSB1c2Vyc3BhY2Ug
YWN0aW9uLApmb3IgZXhhbXBsZSwgYSBzeXN0ZW0gY2FsbAouUkIgKCB0Z2tpbGwgKDIpLAouQlIg
a2lsbCAoMiksCi5CUiBzaWdxdWV1ZSAoMyksCmV0Yy4pLApleHBpcmF0aW9uIG9mIGEgUE9TSVgg
dGltZXIsCmNoYW5nZSBvZiBzdGF0ZSBvbiBhIFBPU0lYIG1lc3NhZ2UgcXVldWUsCm9yIGNvbXBs
ZXRpb24gb2YgYW4gYXN5bmNocm9ub3VzIEkvTyByZXF1ZXN0LgouVFAKLklSIHNpX2NvZGUgIiA9
PSBTSV9LRVJORUwgKDB4ODApIgouQiBTSUdUUkFQCndhcyBzZW50IGJ5IHRoZSBrZXJuZWwuCi5U
UAouSVIgc2lfY29kZSAiID09IFNJR1RSQVAgb3IgIiBzaV9jb2RlICIgPT0gKFNJR1RSQVB8MHg4
MCkiClRoaXMgaXMgYSBzeXNjYWxsLXN0b3AuCi5MUApIb3dldmVyLCBzeXNjYWxsLXN0b3BzIGhh
cHBlbiB2ZXJ5IG9mdGVuICh0d2ljZSBwZXIgc3lzdGVtIGNhbGwpLAphbmQgcGVyZm9ybWluZwou
QiBQVFJBQ0VfR0VUU0lHSU5GTwpmb3IgZXZlcnkgc3lzY2FsbC1zdG9wIG1heSBiZSBzb21ld2hh
dCBleHBlbnNpdmUuCi5MUApTb21lIGFyY2hpdGVjdHVyZXMgYWxsb3cgdGhlIGNhc2VzIHRvIGJl
IGRpc3Rpbmd1aXNoZWQKYnkgZXhhbWluaW5nIHJlZ2lzdGVycy4KRm9yIGV4YW1wbGUsIG9uIHg4
NiwKLkkgcmF4Cj09Ci5SQiAtIEVOT1NZUwppbiBzeXNjYWxsLWVudGVyLXN0b3AuClNpbmNlCi5C
IFNJR1RSQVAKKGxpa2UgYW55IG90aGVyIHNpZ25hbCkgYWx3YXlzIGhhcHBlbnMKLkkgYWZ0ZXIK
c3lzY2FsbC1leGl0LXN0b3AsCmFuZCBhdCB0aGlzIHBvaW50Ci5JIHJheAphbG1vc3QgbmV2ZXIg
Y29udGFpbnMKLlJCIC0gRU5PU1lTICwKdGhlCi5CIFNJR1RSQVAKbG9va3MgbGlrZSAic3lzY2Fs
bC1zdG9wIHdoaWNoIGlzIG5vdCBzeXNjYWxsLWVudGVyLXN0b3AiOwppbiBvdGhlciB3b3Jkcywg
aXQgbG9va3MgbGlrZSBhCiJzdHJheSBzeXNjYWxsLWV4aXQtc3RvcCIgYW5kIGNhbiBiZSBkZXRl
Y3RlZCB0aGlzIHdheS4KQnV0IHN1Y2ggZGV0ZWN0aW9uIGlzIGZyYWdpbGUgYW5kIGlzIGJlc3Qg
YXZvaWRlZC4KLkxQClVzaW5nIHRoZQouQiBQVFJBQ0VfT19UUkFDRVNZU0dPT0QKLlwiCi5cIiBG
SVhNRSBCZWxvdzogImlzIHRoZSByZWNvbW1lbmRlZCBtZXRob2QiIGZvciBXSEFUPwpvcHRpb24g
aXMgdGhlIHJlY29tbWVuZGVkIG1ldGhvZCwKc2luY2UgaXQgaXMgcmVsaWFibGUgYW5kIGRvZXMg
bm90IGluY3VyIGEgcGVyZm9ybWFuY2UgcGVuYWx0eS4KLkxQClN5c2NhbGwtZW50ZXItc3RvcCBh
bmQgc3lzY2FsbC1leGl0LXN0b3AgYXJlCmluZGlzdGluZ3Vpc2hhYmxlIGZyb20gZWFjaCBvdGhl
ciBieSB0aGUgdHJhY2VyLgpUaGUgdHJhY2VyIG5lZWRzIHRvIGtlZXAgdHJhY2sgb2YgdGhlIHNl
cXVlbmNlIG9mCnB0cmFjZS1zdG9wcyBpbiBvcmRlciB0byBub3QgbWlzaW50ZXJwcmV0IHN5c2Nh
bGwtZW50ZXItc3RvcCBhcwpzeXNjYWxsLWV4aXQtc3RvcCBvciB2aWNlIHZlcnNhLgpUaGUgcnVs
ZSBpcyB0aGF0IHN5c2NhbGwtZW50ZXItc3RvcCBpcwphbHdheXMgZm9sbG93ZWQgYnkgc3lzY2Fs
bC1leGl0LXN0b3AsCi5CIFBUUkFDRV9FVkVOVApzdG9wIG9yIHRoZSB0cmFjZWUncyBkZWF0aDsK
bm8gb3RoZXIga2luZHMgb2YgcHRyYWNlLXN0b3AgY2FuIG9jY3VyIGluIGJldHdlZW4uCi5MUApJ
ZiBhZnRlciBzeXNjYWxsLWVudGVyLXN0b3AsCnRoZSB0cmFjZXIgdXNlcyBhIHJlc3RhcnRpbmcg
Y29tbWFuZCBvdGhlciB0aGFuCi5CUiBQVFJBQ0VfU1lTQ0FMTCAsCnN5c2NhbGwtZXhpdC1zdG9w
IGlzIG5vdCBnZW5lcmF0ZWQuCi5MUAouQiBQVFJBQ0VfR0VUU0lHSU5GTwpvbiBzeXNjYWxsLXN0
b3BzIHJldHVybnMKLkIgU0lHVFJBUAppbgouSVIgc2lfc2lnbm8gLAp3aXRoCi5JIHNpX2NvZGUK
c2V0IHRvCi5CIFNJR1RSQVAKb3IKLklSIChTSUdUUkFQfDB4ODApIC4KLlNTIFBUUkFDRV9TSU5H
TEVTVEVQLCBQVFJBQ0VfU1lTRU1VLCBQVFJBQ0VfU1lTRU1VX1NJTkdMRVNURVAgc3RvcHMKLlwi
Ci5cIiBGSVhNRSBUaGUgZm9sbG93aW5nIFRPRE8gaXMgdW5yZXNvbHZlZAouXCIgICAgICAgRG8g
eW91IHdhbnQgdG8gYWRkIGFueXRoaW5nLCBvciAobGVzcyBnb29kKSBkbyB3ZSBqdXN0Ci5cIiAg
ICAgICBjb252ZXJ0IHRoaXMgaW50byBhIGNvbW1lbnQgaW4gdGhlIHNvdXJjZSBpbmRpY2F0aW5n
Ci5cIiAgICAgICB0aGF0IHRoZXNlIHBvaW50cyBzdGlsbCBuZWVkIHRvIGJlIGRvY3VtZW50ZWQ/
Ci5cIgooVE9ETzogZG9jdW1lbnQgc3RvcHMgb2NjdXJyaW5nIHdpdGggUFRSQUNFX1NJTkdMRVNU
RVAsIFBUUkFDRV9TWVNFTVUsClBUUkFDRV9TWVNFTVVfU0lOR0xFU1RFUCkKLlNTIEluZm9ybWF0
aW9uYWwgYW5kIHJlc3RhcnRpbmcgcHRyYWNlIGNvbW1hbmRzCk1vc3QgcHRyYWNlIGNvbW1hbmRz
IChhbGwgZXhjZXB0Ci5CUiBQVFJBQ0VfQVRUQUNIICwKLkJSIFBUUkFDRV9UUkFDRU1FICwKYW5k
Ci5CUiBQVFJBQ0VfS0lMTCApCnJlcXVpcmUgdGhlIHRyYWNlZSB0byBiZSBpbiBhIHB0cmFjZS1z
dG9wLCBvdGhlcndpc2UgdGhleSBmYWlsIHdpdGgKLkJSIEVTUkNIIC4KLkxQCldoZW4gdGhlIHRy
YWNlZSBpcyBpbiBwdHJhY2Utc3RvcCwKdGhlIHRyYWNlciBjYW4gcmVhZCBhbmQgd3JpdGUgZGF0
YSB0bwp0aGUgdHJhY2VlIHVzaW5nIGluZm9ybWF0aW9uYWwgY29tbWFuZHMuClRoZXNlIGNvbW1h
bmRzIGxlYXZlIHRoZSB0cmFjZWUgaW4gcHRyYWNlLXN0b3BwZWQgc3RhdGU6Ci5MUAoubmYKICAg
IHB0cmFjZShQVFJBQ0VfUEVFS1RFWFQvUEVFS0RBVEEvUEVFS1VTRVIsIHBpZCwgYWRkciwgMCk7
CiAgICBwdHJhY2UoUFRSQUNFX1BPS0VURVhUL1BPS0VEQVRBL1BPS0VVU0VSLCBwaWQsIGFkZHIs
IGxvbmdfdmFsKTsKICAgIHB0cmFjZShQVFJBQ0VfR0VUUkVHUy9HRVRGUFJFR1MsIHBpZCwgMCwg
JnN0cnVjdCk7CiAgICBwdHJhY2UoUFRSQUNFX1NFVFJFR1MvU0VURlBSRUdTLCBwaWQsIDAsICZz
dHJ1Y3QpOwogICAgcHRyYWNlKFBUUkFDRV9HRVRTSUdJTkZPLCBwaWQsIDAsICZzaWdpbmZvKTsK
ICAgIHB0cmFjZShQVFJBQ0VfU0VUU0lHSU5GTywgcGlkLCAwLCAmc2lnaW5mbyk7CiAgICBwdHJh
Y2UoUFRSQUNFX0dFVEVWRU5UTVNHLCBwaWQsIDAsICZsb25nX3Zhcik7CiAgICBwdHJhY2UoUFRS
QUNFX1NFVE9QVElPTlMsIHBpZCwgMCwgUFRSQUNFX09fZmxhZ3MpOwouZmkKLkxQCk5vdGUgdGhh
dCBzb21lIGVycm9ycyBhcmUgbm90IHJlcG9ydGVkLgpGb3IgZXhhbXBsZSwgc2V0dGluZyBzaWdu
YWwgaW5mb3JtYXRpb24KLlJJICggc2lnaW5mbyApCm1heSBoYXZlIG5vIGVmZmVjdCBpbiBzb21l
IHB0cmFjZS1zdG9wcywgeWV0IHRoZSBjYWxsIG1heSBzdWNjZWVkCihyZXR1cm4gMCBhbmQgbm90
IHNldAouSVIgZXJybm8gKTsKcXVlcnlpbmcKLkIgUFRSQUNFX0dFVEVWRU5UTVNHCm1heSBzdWNj
ZWVkIGFuZCByZXR1cm4gc29tZSByYW5kb20gdmFsdWUgaWYgY3VycmVudCBwdHJhY2Utc3RvcApp
cyBub3QgZG9jdW1lbnRlZCBhcyByZXR1cm5pbmcgYSBtZWFuaW5nZnVsIGV2ZW50IG1lc3NhZ2Uu
Ci5MUApUaGUgY2FsbAoKICAgIHB0cmFjZShQVFJBQ0VfU0VUT1BUSU9OUywgcGlkLCAwLCBQVFJB
Q0VfT19mbGFncyk7CiAgICAKYWZmZWN0cyBvbmUgdHJhY2VlLgpUaGUgdHJhY2VlJ3MgY3VycmVu
dCBmbGFncyBhcmUgcmVwbGFjZWQuCkZsYWdzIGFyZSBpbmhlcml0ZWQgYnkgbmV3IHRyYWNlZXMg
Y3JlYXRlZCBhbmQgImF1dG8tYXR0YWNoZWQiIHZpYSBhY3RpdmUKLkJSIFBUUkFDRV9PX1RSQUNF
Rk9SSyAsCi5CUiBQVFJBQ0VfT19UUkFDRVZGT1JLICwKb3IKLkJSIFBUUkFDRV9PX1RSQUNFQ0xP
TkUKb3B0aW9ucy4KLkxQCkFub3RoZXIgZ3JvdXAgb2YgY29tbWFuZHMgbWFrZXMgdGhlIHB0cmFj
ZS1zdG9wcGVkIHRyYWNlZSBydW4uClRoZXkgaGF2ZSB0aGUgZm9ybToKLkxQCiAgICBwdHJhY2Uo
Y21kLCBwaWQsIDAsIHNpZyk7Ci5MUAp3aGVyZQouSSBjbWQKaXMKLkJSIFBUUkFDRV9DT05UICwK
LkJSIFBUUkFDRV9ERVRBQ0ggLAouQlIgUFRSQUNFX1NZU0NBTEwgLAouQlIgUFRSQUNFX1NJTkdM
RVNURVAgLAouQlIgUFRSQUNFX1NZU0VNVSAsCm9yCi5CUiBQVFJBQ0VfU1lTRU1VX1NJTkdMRVNU
RVAuCklmIHRoZSB0cmFjZWUgaXMgaW4gc2lnbmFsLWRlbGl2ZXJ5LXN0b3AsCi5JIHNpZwppcyB0
aGUgc2lnbmFsIHRvIGJlIGluamVjdGVkIChpZiBpdCBpcyBub256ZXJvKS4KT3RoZXJ3aXNlLAou
SSBzaWcKbWF5IGJlIGlnbm9yZWQuCihXaGVuIHJlc3RhcnRpbmcgYSB0cmFjZWUgZnJvbSBhIHB0
cmFjZS1zdG9wIG90aGVyIHRoYW4gc2lnbmFsLWRlbGl2ZXJ5LXN0b3AsCnJlY29tbWVuZGVkIHBy
YWN0aWNlIGlzIHRvIGFsd2F5cyBwYXNzIDAgaW4KLkkgc2lnIC4pCi5TUyBBdHRhY2hpbmcgYW5k
IGRldGFjaGluZwpBIHRocmVhZCBjYW4gYmUgYXR0YWNoZWQgdG8gdGhlIHRyYWNlciB1c2luZyB0
aGUgY2FsbAoKICAgIHB0cmFjZShQVFJBQ0VfQVRUQUNILCBwaWQsIDAsIDApOwoKVGhpcyBhbHNv
IHNlbmRzCi5CIFNJR1NUT1AKdG8gdGhpcyB0aHJlYWQuCklmIHRoZSB0cmFjZXIgd2FudHMgdGhp
cwouQiBTSUdTVE9QCnRvIGhhdmUgbm8gZWZmZWN0LCBpdCBuZWVkcyB0byBzdXBwcmVzcyBpdC4K
Tm90ZSB0aGF0IGlmIG90aGVyIHNpZ25hbHMgYXJlIGNvbmN1cnJlbnRseSBzZW50IHRvCnRoaXMg
dGhyZWFkIGR1cmluZyBhdHRhY2gsCnRoZSB0cmFjZXIgbWF5IHNlZSB0aGUgdHJhY2VlIGVudGVy
IHNpZ25hbC1kZWxpdmVyeS1zdG9wCndpdGggb3RoZXIgc2lnbmFsKHMpIGZpcnN0IQpUaGUgdXN1
YWwgcHJhY3RpY2UgaXMgdG8gcmVpbmplY3QgdGhlc2Ugc2lnbmFscyB1bnRpbAouQiBTSUdTVE9Q
CmlzIHNlZW4sIHRoZW4gc3VwcHJlc3MKLkIgU0lHU1RPUAppbmplY3Rpb24uClRoZSBkZXNpZ24g
YnVnIGhlcmUgaXMgdGhhdCBhIHB0cmFjZSBhdHRhY2ggYW5kIGEgY29uY3VycmVudGx5IGRlbGl2
ZXJlZAouQiBTSUdTVE9QCm1heSByYWNlIGFuZCB0aGUgY29uY3VycmVudAouQiBTSUdTVE9QCm1h
eSBiZSBsb3N0LgouXCIKLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dpbmcgY29tbWVudCBzZWVt
cyB0byBiZSB1bnJlc29sdmVkPwouXCIJICAgRG8geW91IHdhbnQgdG8gYWRkIGFueSB0ZXh0Pwou
XCIKLlwiICAgICAgRGVzY3JpYmUgaG93IHRvIGF0dGFjaCB0byBhIHRocmVhZCB3aGljaCBpcyBh
bHJlYWR5IGdyb3VwLXN0b3BwZWQuCi5MUApTaW5jZSBhdHRhY2hpbmcgc2VuZHMKLkIgU0lHU1RP
UAphbmQgdGhlIHRyYWNlciB1c3VhbGx5IHN1cHByZXNzZXMgaXQsIHRoaXMgbWF5IGNhdXNlIGEg
c3RyYXkKLkkgRUlOVFIKcmV0dXJuIGZyb20gdGhlIGN1cnJlbnRseSBleGVjdXRpbmcgc3lzdGVt
IGNhbGwgaW4gdGhlIHRyYWNlZSwKYXMgZGVzY3JpYmVkIGluIHRoZSAic2lnbmFsIGluamVjdGlv
biBhbmQgc3VwcHJlc3Npb24iIHNlY3Rpb24uCi5MUApUaGUgcmVxdWVzdAoKICAgIHB0cmFjZShQ
VFJBQ0VfVFJBQ0VNRSwgMCwgMCwgMCk7Cgp0dXJucyB0aGUgY2FsbGluZyB0aHJlYWQgaW50byBh
IHRyYWNlZS4KVGhlIHRocmVhZCBjb250aW51ZXMgdG8gcnVuIChkb2Vzbid0IGVudGVyIHB0cmFj
ZS1zdG9wKS4KQSBjb21tb24gcHJhY3RpY2UgaXMgdG8gZm9sbG93IHRoZQouQiBQVFJBQ0VfVFJB
Q0VNRQp3aXRoCgogICAgcmFpc2UoU0lHU1RPUCk7CgphbmQgYWxsb3cgdGhlIHBhcmVudCAod2hp
Y2ggaXMgb3VyIHRyYWNlciBub3cpIHRvIG9ic2VydmUgb3VyCnNpZ25hbC1kZWxpdmVyeS1zdG9w
LgouTFAKSWYgdGhlIAouQlIgUFRSQUNFX09fVFJBQ0VGT1JLICwKLkJSIFBUUkFDRV9PX1RSQUNF
VkZPUksgLApvcgouQlIgUFRSQUNFX09fVFJBQ0VDTE9ORQpvcHRpb25zIGFyZSBpbiBlZmZlY3Qs
IHRoZW4gY2hpbGRyZW4gY3JlYXRlZCBieSwgcmVzcGVjdGl2ZWx5LAouQlIgdmZvcmsgKDIpCm9y
Ci5CUiBjbG9uZSAoMikKd2l0aCB0aGUKLkIgQ0xPTkVfVkZPUksKZmxhZywKLkJSIGZvcmsgKDIp
Cm9yCi5CUiBjbG9uZSAoMikKd2l0aCB0aGUgZXhpdCBzaWduYWwgc2V0IHRvCi5CUiBTSUdDSExE
ICwKYW5kIG90aGVyIGtpbmRzIG9mCi5CUiBjbG9uZSAoMiksCmFyZSBhdXRvbWF0aWNhbGx5IGF0
dGFjaGVkIHRvIHRoZSBzYW1lIHRyYWNlciB3aGljaCB0cmFjZWQgdGhlaXIgcGFyZW50LgouQiBT
SUdTVE9QCmlzIGRlbGl2ZXJlZCB0byB0aGUgY2hpbGRyZW4sIGNhdXNpbmcgdGhlbSB0byBlbnRl
cgpzaWduYWwtZGVsaXZlcnktc3RvcCBhZnRlciB0aGV5IGV4aXQgdGhlIHN5c3RlbSBjYWxsIHdo
aWNoIGNyZWF0ZWQgdGhlbS4KLkxQCkRldGFjaGluZyBvZiB0aGUgdHJhY2VlIGlzIHBlcmZvcm1l
ZCBieToKCiAgICBwdHJhY2UoUFRSQUNFX0RFVEFDSCwgcGlkLCAwLCBzaWcpOwoKLkIgUFRSQUNF
X0RFVEFDSAppcyBhIHJlc3RhcnRpbmcgb3BlcmF0aW9uOwp0aGVyZWZvcmUgaXQgcmVxdWlyZXMg
dGhlIHRyYWNlZSB0byBiZSBpbiBwdHJhY2Utc3RvcC4KSWYgdGhlIHRyYWNlZSBpcyBpbiBzaWdu
YWwtZGVsaXZlcnktc3RvcCwgYSBzaWduYWwgY2FuIGJlIGluamVjdGVkLgpPdGhlcndpc2UsIHRo
ZQouSSBzaWcKcGFyYW1ldGVyIG1heSBiZSBzaWxlbnRseSBpZ25vcmVkLgouTFAKSWYgdGhlIHRy
YWNlZSBpcyBydW5uaW5nIHdoZW4gdGhlIHRyYWNlciB3YW50cyB0byBkZXRhY2ggaXQsCnRoZSB1
c3VhbCBzb2x1dGlvbiBpcyB0byBzZW5kCi5CIFNJR1NUT1AKKHVzaW5nCi5CUiB0Z2tpbGwgKDIp
LAp0byBtYWtlIHN1cmUgaXQgZ29lcyB0byB0aGUgY29ycmVjdCB0aHJlYWQpLAp3YWl0IGZvciB0
aGUgdHJhY2VlIHRvIHN0b3AgaW4gc2lnbmFsLWRlbGl2ZXJ5LXN0b3AgZm9yCi5CIFNJR1NUT1AK
YW5kIHRoZW4gZGV0YWNoIGl0IChzdXBwcmVzc2luZwouQiBTSUdTVE9QCmluamVjdGlvbikuCkEg
ZGVzaWduIGJ1ZyBpcyB0aGF0IHRoaXMgY2FuIHJhY2Ugd2l0aCBjb25jdXJyZW50Ci5CUiBTSUdT
VE9QIHMuCkFub3RoZXIgY29tcGxpY2F0aW9uIGlzIHRoYXQgdGhlIHRyYWNlZSBtYXkgZW50ZXIg
b3RoZXIgcHRyYWNlLXN0b3BzCmFuZCBuZWVkcyB0byBiZSByZXN0YXJ0ZWQgYW5kIHdhaXRlZCBm
b3IgYWdhaW4sIHVudGlsCi5CIFNJR1NUT1AKaXMgc2Vlbi4KWWV0IGFub3RoZXIgY29tcGxpY2F0
aW9uIGlzIHRvIGJlIHN1cmUgdGhhdAp0aGUgdHJhY2VlIGlzIG5vdCBhbHJlYWR5IHB0cmFjZS1z
dG9wcGVkLApiZWNhdXNlIG5vIHNpZ25hbCBkZWxpdmVyeSBoYXBwZW5zIHdoaWxlIGl0IGlzXChl
bW5vdCBldmVuCi5CUiBTSUdTVE9QIC4KLlwiIEZJWE1FOiBtdGs6IHRoZSBmb2xsb3dpbmcgY29t
bWVudCBzZWVtcyB0byBiZSB1bnJlc29sdmVkPwouXCIgICAgICAgRG8geW91IHdhbnQgdG8gYWRk
IGFueXRoaW5nPwouXCIKLlwiICAgICBEZXNjcmliZSBob3cgdG8gZGV0YWNoIGZyb20gYSBncm91
cC1zdG9wcGVkIHRyYWNlZSBzbyB0aGF0IGl0Ci5cIiAgICAgZG9lc24ndCBydW4sIGJ1dCBjb250
aW51ZXMgdG8gd2FpdCBmb3IgU0lHQ09OVC4KLlwiCi5MUApJZiB0aGUgdHJhY2VyIGRpZXMsIGFs
bCB0cmFjZWVzIGFyZSBhdXRvbWF0aWNhbGx5IGRldGFjaGVkIGFuZCByZXN0YXJ0ZWQsCnVubGVz
cyB0aGV5IHdlcmUgaW4gZ3JvdXAtc3RvcC4KSGFuZGxpbmcgb2YgcmVzdGFydCBmcm9tIGdyb3Vw
LXN0b3AgaXMKLlwiIEZJWE1FOiBEZWZpbmUgY3VycmVudGx5CmN1cnJlbnRseSBidWdneSwgYnV0
IHRoZQouXCIgRklYTUU6IFBsYW5uZWQgZm9yIHdoZW4/IEFuZCBzaG91bGQgYXBwbGljYXRpb25z
IGJlIGRlc2lnbmVkCi5cIiBpbiBzb21lIHdheSBzbyBhcyB0byBhbGxvdyBmb3IgdGhpcyBmdXR1
cmUgY2hhbmdlPwoiYXMgcGxhbm5lZCIgYmVoYXZpb3IgaXMgdG8gbGVhdmUgdHJhY2VlIHN0b3Bw
ZWQgYW5kIHdhaXRpbmcgZm9yCi5CUiBTSUdDT05UIC4KSWYgdGhlIHRyYWNlZSBpcyByZXN0YXJ0
ZWQgZnJvbSBzaWduYWwtZGVsaXZlcnktc3RvcCwKdGhlIHBlbmRpbmcgc2lnbmFsIGlzIGluamVj
dGVkLgouU1MgZXhlY3ZlKDIpIHVuZGVyIHB0cmFjZQouXCIgY2xvbmUoMikgVEhSRUFEX0NMT05F
IHNheXM6Ci5cIiAgICAgSWYgIGFueSAgb2YgdGhlIHRocmVhZHMgaW4gYSB0aHJlYWQgZ3JvdXAg
cGVyZm9ybXMgYW4gZXhlY3ZlKDIpLAouXCIgICAgIHRoZW4gYWxsIHRocmVhZHMgb3RoZXIgdGhh
biB0aGUgdGhyZWFkIGdyb3VwIGxlYWRlciBhcmUgdGVybWluYXRlZCwKLlwiICAgICBhbmQgdGhl
IG5ldyBwcm9ncmFtIGlzIGV4ZWN1dGVkIGluIHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyLiAgCi5c
IgpXaGVuIG9uZSB0aHJlYWQgaW4gYSBtdWx0aXRocmVhZGVkIHByb2Nlc3MgY2FsbHMKLkJSIGV4
ZWN2ZSAoMiksCnRoZSBrZXJuZWwgZGVzdHJveXMgYWxsIG90aGVyIHRocmVhZHMgaW4gdGhlIHBy
b2Nlc3MsCi5cIiBJbiBrZXJuZWwgMy4xIHNvdXJjZXMsIHNlZSBmcy9leGVjLmM6OmRlX3RocmVh
ZCgpCmFuZCByZXNldHMgdGhlIHRocmVhZCBJRCBvZiB0aGUgZXhlY2luZyB0aHJlYWQgdG8gdGhl
CnRocmVhZCBncm91cCBJRCAocHJvY2VzcyBJRCkuCihPciwgdG8gcHV0IHRoaW5ncyBhbm90aGVy
IHdheSwgd2hlbiBhIG11bHRpdGhyZWFkZWQgcHJvY2VzcyBkb2VzIGFuCi5CUiBleGVjdmUgKDIp
LAphdCBjb21wbGV0aW9uIG9mIHRoZSBjYWxsLCBpdCBhcHBlYXJzIGFzIHRob3VnaCB0aGUKLkJS
IGV4ZWN2ZSAoMikKb2NjdXJyZWQgaW4gdGhlIHRocmVhZCBncm91cCBsZWFkZXIsIHJlZ2FyZGxl
c3Mgb2Ygd2hpY2ggdGhyZWFkIGRpZCB0aGUKLkJSIGV4ZWN2ZSAoMikuKQpUaGlzIHJlc2V0dGlu
ZyBvZiB0aGUgdGhyZWFkIElEIGxvb2tzIHZlcnkgY29uZnVzaW5nIHRvIHRyYWNlcnM6Ci5JUCAq
IDMKQWxsIG90aGVyIHRocmVhZHMgc3RvcCBpbgouQiBQVFJBQ0VfRVZFTlRfRVhJVApzdG9wLApp
ZiB0aGUKLkJSIFBUUkFDRV9PX1RSQUNFRVhJVApvcHRpb24gd2FzIHR1cm5lZCBvbi4KVGhlbiBh
bGwgb3RoZXIgdGhyZWFkcyBleGNlcHQgdGhlIHRocmVhZCBncm91cCBsZWFkZXIgcmVwb3J0CmRl
YXRoIGFzIGlmIHRoZXkgZXhpdGVkIHZpYQouQlIgX2V4aXQgKDIpCndpdGggZXhpdCBjb2RlIDAu
ClRoZW4gYQouQiBQVFJBQ0VfRVZFTlRfRVhFQwpzdG9wIGhhcHBlbnMsIGlmIHRoZQouQlIgUFRS
QUNFX09fVFJBQ0VFWEVDCm9wdGlvbiB3YXMgdHVybmVkIG9uLgouXCIgRklYTUU6IG10azogdGhl
IGZvbGxvd2luZyBjb21tZW50IHNlZW1zIHRvIGJlIHVucmVzb2x2ZWQ/Ci5cIiAgICAgICAob24g
d2hpY2ggdHJhY2VlIC0gbGVhZGVyPyBleGVjdmUtaW5nIG9uZT8pCi5cIiAKLlwiIEZJWE1FOiBQ
bGVhc2UgY2hlY2s6IGF0IHZhcmlvdXMgcGxhY2VzIGluIHRoZSBmb2xsb3dpbmcsCi5cIiAgICAg
ICAgSSBoYXZlIGNoYW5nZWQgInBpZCIgdG8gIlt0aGUgdHJhY2VlJ3NdIHRoZWFkIElEIgouXCIg
ICAgICAgIElzIHRoYXQgb2theT8KLklQICoKVGhlIGV4ZWNpbmcgdHJhY2VlIGNoYW5nZXMgaXRz
IHRocmVhZCBJRCB3aGlsZSBpdCBpcyBpbiB0aGUKLkJSIGV4ZWN2ZSAoMikuCihSZW1lbWJlciwg
dW5kZXIgcHRyYWNlLCB0aGUgInBpZCIgcmV0dXJuZWQgZnJvbQouQlIgd2FpdHBpZCAoMiksCm9y
IGZlZCBpbnRvIHB0cmFjZSBjYWxscywgaXMgdGhlIHRyYWNlZSdzIHRocmVhZCBJRC4pClRoYXQg
aXMsIHRoZSB0cmFjZWUncyB0aHJlYWQgSUQgaXMgcmVzZXQgdG8gYmUgdGhlIHNhbWUgYXMgaXRz
IHByb2Nlc3MgSUQsCndoaWNoIGlzIHRoZSBzYW1lIGFzIHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVy
J3MgdGhyZWFkIElELgouSVAgKgpJZiB0aGUgdGhyZWFkIGdyb3VwIGxlYWRlciBoYXMgcmVwb3J0
ZWQgaXRzIGRlYXRoIGJ5IHRoaXMgdGltZSwKaXQgYXBwZWFycyB0byB0aGUgdHJhY2VyIHRoYXQK
dGhlIGRlYWQgdGhyZWFkIGxlYWRlciAicmVhcHBlYXJzIGZyb20gbm93aGVyZSIuCklmIHRoZSB0
aHJlYWQgZ3JvdXAgbGVhZGVyIHdhcyBzdGlsbCBhbGl2ZSwKZm9yIHRoZSB0cmFjZXIgdGhpcyBt
YXkgbG9vayBhcyBpZiB0aHJlYWQgZ3JvdXAgbGVhZGVyCnJldHVybnMgZnJvbSBhIGRpZmZlcmVu
dCBzeXN0ZW0gY2FsbCB0aGFuIGl0IGVudGVyZWQsCm9yIGV2ZW4gInJldHVybmVkIGZyb20gYSBz
eXN0ZW0gY2FsbCBldmVuIHRob3VnaAppdCB3YXMgbm90IGluIGFueSBzeXN0ZW0gY2FsbCIuCklm
IHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyIHdhcyBub3QgdHJhY2VkCihvciB3YXMgdHJhY2VkIGJ5
IGEgZGlmZmVyZW50IHRyYWNlciksIHRoZW4gZHVyaW5nCi5CUiBleGVjdmUgKDIpCml0IHdpbGwg
YXBwZWFyIGFzIGlmIGl0IGhhcyBiZWNvbWUgYSB0cmFjZWUgb2YKdGhlIHRyYWNlciBvZiB0aGUg
ZXhlY2luZyB0cmFjZWUuCi5MUApBbGwgb2YgdGhlIGFib3ZlIGVmZmVjdHMgYXJlIHRoZSBhcnRp
ZmFjdHMgb2YKdGhlIHRocmVhZCBJRCBjaGFuZ2UgaW4gdGhlIHRyYWNlZS4KLkxQClRoZQouQiBQ
VFJBQ0VfT19UUkFDRUVYRUMKb3B0aW9uIGlzIHRoZSByZWNvbW1lbmRlZCB0b29sIGZvciBkZWFs
aW5nIHdpdGggdGhpcyBzaXR1YXRpb24uCkl0IGVuYWJsZXMKLkIgUFRSQUNFX0VWRU5UX0VYRUMK
c3RvcCwgd2hpY2ggb2NjdXJzIGJlZm9yZQouQlIgZXhlY3ZlICgyKQpyZXR1cm5zLgouXCIgRklY
TUUgRm9sbG93aW5nIG9uIGZyb20gdGhlIHByZXZpb3VzIHNlbnRlbmNlcywKLlwiICAgICAgIGNh
bi9zaG91bGQgd2UgYWRkIGEgZmV3IG1vcmUgd29yZHMgb24gaG93Ci5cIiAgICAgICBQVFJBQ0Vf
RVZFTlRfRVhFQyBzdG9wIGhlbHBzIHVzIGRlYWwgd2l0aCB0aGlzIHNpdHVhdGlvbj8KLkxQClRo
ZSB0aHJlYWQgSUQgY2hhbmdlIGhhcHBlbnMgYmVmb3JlCi5CIFBUUkFDRV9FVkVOVF9FWEVDCnN0
b3AsIG5vdCBhZnRlci4KLkxQCldoZW4gdGhlIHRyYWNlciByZWNlaXZlcwouQiBQVFJBQ0VfRVZF
TlRfRVhFQwpzdG9wIG5vdGlmaWNhdGlvbiwKaXQgaXMgZ3VhcmFudGVlZCB0aGF0IGV4Y2VwdCB0
aGlzIHRyYWNlZSBhbmQgdGhlIHRocmVhZCBncm91cCBsZWFkZXIsCm5vIG90aGVyIHRocmVhZHMg
ZnJvbSB0aGUgcHJvY2VzcyBhcmUgYWxpdmUuCi5MUApPbiByZWNlaXZpbmcgdGhlCi5CIFBUUkFD
RV9FVkVOVF9FWEVDCnN0b3Agbm90aWZpY2F0aW9uLAp0aGUgdHJhY2VyIHNob3VsZCBjbGVhbiB1
cCBhbGwgaXRzIGludGVybmFsCmRhdGEgc3RydWN0dXJlcyBkZXNjcmliaW5nIHRoZSB0aHJlYWRz
IG9mIHRoaXMgcHJvY2VzcywKYW5kIHJldGFpbiBvbmx5IG9uZSBkYXRhIHN0cnVjdHVyZVwoZW1v
bmUgd2hpY2gKZGVzY3JpYmVzIHRoZSBzaW5nbGUgc3RpbGwgcnVubmluZyB0cmFjZWUsIHdpdGgK
CiAgICB0aHJlYWQgSUQgPT0gdGhyZWFkIGdyb3VwIElEID09IHByb2Nlc3MgaWQuCi5MUApDdXJy
ZW50bHksIHRoZXJlIGlzIG5vIHdheSB0byByZXRyaWV2ZSB0aGUgZm9ybWVyCnRocmVhZCBJRCBv
ZiB0aGUgZXhlY2luZyB0cmFjZWUuCklmIHRoZSB0cmFjZXIgZG9lc24ndCBrZWVwIHRyYWNrIG9m
IGl0cyB0cmFjZWVzJyB0aHJlYWQgZ3JvdXAgcmVsYXRpb25zLAppdCBtYXkgYmUgdW5hYmxlIHRv
IGtub3cgd2hpY2ggdHJhY2VlIGV4ZWNlZCBhbmQgdGhlcmVmb3JlIG5vIGxvbmdlcgpleGlzdHMg
dW5kZXIgdGhlIG9sZCB0aHJlYWQgSUQgZHVlIHRvIGEgdGhyZWFkIElEIGNoYW5nZS4KLkxQCkV4
YW1wbGU6IHR3byB0aHJlYWRzIGNhbGwKLkJSIGV4ZWN2ZSAoMikKYXQgdGhlIHNhbWUgdGltZToK
LkxQCi5uZgoqKiogd2UgZ2V0IHN5c2NhbGwtZW50cnktc3RvcCBpbiB0aHJlYWQgMTogKioKUElE
MSBleGVjdmUoIi9iaW4vZm9vIiwgImZvbyIgPHVuZmluaXNoZWQgLi4uPgoqKiogd2UgaXNzdWUg
UFRSQUNFX1NZU0NBTEwgZm9yIHRocmVhZCAxICoqCioqKiB3ZSBnZXQgc3lzY2FsbC1lbnRyeS1z
dG9wIGluIHRocmVhZCAyOiAqKgpQSUQyIGV4ZWN2ZSgiL2Jpbi9iYXIiLCAiYmFyIiA8dW5maW5p
c2hlZCAuLi4+CioqKiB3ZSBpc3N1ZSBQVFJBQ0VfU1lTQ0FMTCBmb3IgdGhyZWFkIDIgKioKKioq
IHdlIGdldCBQVFJBQ0VfRVZFTlRfRVhFQyBmb3IgUElEMCwgd2UgaXNzdWUgUFRSQUNFX1NZU0NB
TEwgKioKKioqIHdlIGdldCBzeXNjYWxsLWV4aXQtc3RvcCBmb3IgUElEMDogKioKUElEMCA8Li4u
IGV4ZWN2ZSByZXN1bWVkPiApICAgICAgICAgICAgID0gMAouZmkKLkxQCkluIHRoaXMgc2l0dWF0
aW9uLCB0aGVyZSBpcyBubyB3YXkgdG8ga25vdyB3aGljaAouQlIgZXhlY3ZlICgyKQpzdWNjZWVk
ZWQuCi5MUApJZiB0aGUKLkIgUFRSQUNFX09fVFJBQ0VFWEVDCm9wdGlvbiBpcwouSSBub3QKaW4g
ZWZmZWN0IGZvciB0aGUgZXhlY2luZyB0cmFjZWUsIHRoZSBrZXJuZWwgZGVsaXZlcnMgYW4gZXh0
cmEKLkIgU0lHVFJBUAp0byB0aGUgdHJhY2VlIGFmdGVyCi5CUiBleGVjdmUgKDIpCnJldHVybnMu
ClRoaXMgaXMgYW4gb3JkaW5hcnkgc2lnbmFsIChzaW1pbGFyIHRvIG9uZSB3aGljaCBjYW4gYmUK
Z2VuZXJhdGVkIGJ5Ci5JUiAia2lsbCAtVFJBUCIgKSwKbm90IGEgc3BlY2lhbCBraW5kIG9mIHB0
cmFjZS1zdG9wLgpFbXBsb3lpbmcKLkIgUFRSQUNFX0dFVFNJR0lORk8KZm9yIHRoaXMgc2lnbmFs
IHJldHVybnMKLkkgc2lfY29kZQpzZXQgdG8gMAouUkkgKCBTSV9VU0VSICkuClRoaXMgc2lnbmFs
IG1heSBiZSBibG9ja2VkIGJ5IHNpZ25hbCBtYXNrLAphbmQgdGh1cyBtYXkgYmUgZGVsaXZlcmVk
IChtdWNoKSBsYXRlci4KLkxQClVzdWFsbHksIHRoZSB0cmFjZXIgKGZvciBleGFtcGxlLAouQlIg
c3RyYWNlICgxKSkKd291bGQgbm90IHdhbnQgdG8gc2hvdyB0aGlzIGV4dHJhIHBvc3QtZXhlY3Zl
Ci5CIFNJR1RSQVAKc2lnbmFsIHRvIHRoZSB1c2VyLCBhbmQgd291bGQgc3VwcHJlc3MgaXRzIGRl
bGl2ZXJ5IHRvIHRoZSB0cmFjZWUgKGlmCi5CIFNJR1RSQVAKaXMgc2V0IHRvCi5CUiBTSUdfREZM
ICwKaXQgaXMgYSBraWxsaW5nIHNpZ25hbCkuCkhvd2V2ZXIsIGRldGVybWluaW5nIAouSSB3aGlj
aAouQiBTSUdUUkFQCnRvIHN1cHByZXNzIGlzIG5vdCBlYXN5LgpTZXR0aW5nIHRoZQouQiBQVFJB
Q0VfT19UUkFDRUVYRUMKb3B0aW9uIGFuZCB0aHVzIHN1cHByZXNzaW5nIHRoaXMgZXh0cmEKLkIg
U0lHVFJBUAppcyB0aGUgcmVjb21tZW5kZWQgYXBwcm9hY2guCi5TUyBSZWFsIHBhcmVudApUaGUg
cHRyYWNlIEFQSSAoYWIpdXNlcyB0aGUgc3RhbmRhcmQgVU5JWCBwYXJlbnQvY2hpbGQgc2lnbmFs
aW5nIG92ZXIKLkJSIHdhaXRwaWQgKDIpLgpUaGlzIHVzZWQgdG8gY2F1c2UgdGhlIHJlYWwgcGFy
ZW50IG9mIHRoZSBwcm9jZXNzIHRvIHN0b3AgcmVjZWl2aW5nCnNldmVyYWwga2luZHMgb2YKLkJS
IHdhaXRwaWQgKDIpCm5vdGlmaWNhdGlvbnMgd2hlbiB0aGUgY2hpbGQgcHJvY2VzcyBpcyB0cmFj
ZWQgYnkgc29tZSBvdGhlciBwcm9jZXNzLgouTFAKTWFueSBvZiB0aGVzZSBidWdzIGhhdmUgYmVl
biBmaXhlZCwgYnV0IGFzIG9mIExpbnV4IDIuNi4zOCBzZXZlcmFsIHN0aWxsCmV4aXN0OyBzZWUg
QlVHUyBiZWxvdy4KLkxQCkFzIG9mIExpbnV4IDIuNi4zOCwgdGhlIGZvbGxvd2luZyBpcyBiZWxp
ZXZlZCB0byB3b3JrIGNvcnJlY3RseToKLklQICogMwpleGl0L2RlYXRoIGJ5IHNpZ25hbCBpcyBy
ZXBvcnRlZCBmaXJzdCB0byB0aGUgdHJhY2VyLCB0aGVuLAp3aGVuIHRoZSB0cmFjZXIgY29uc3Vt
ZXMgdGhlCi5CUiB3YWl0cGlkICgyKQpyZXN1bHQsIHRvIHRoZSByZWFsIHBhcmVudCAodG8gdGhl
IHJlYWwgcGFyZW50IG9ubHkgd2hlbiB0aGUKd2hvbGUgbXVsdGl0aHJlYWRlZCBwcm9jZXNzIGV4
aXRzKS4KLlwiCi5cIiBGSVhNRSBtdGs6IFBsZWFzZSBjaGVjazogSW4gdGhlIG5leHQgbGluZSwg
Ci5cIiBJIGNoYW5nZWQgInRoZXkiIHRvICJ0aGUgdHJhY2VyIGFuZCB0aGUgcmVhbCBwYXJlbnQi
LiBPa2F5PwpJZiB0aGUgdHJhY2VyIGFuZCB0aGUgcmVhbCBwYXJlbnQgYXJlIHRoZSBzYW1lIHBy
b2Nlc3MsCnRoZSByZXBvcnQgaXMgc2VudCBvbmx5IG9uY2UuCi5TSCAiUkVUVVJOIFZBTFVFIgpP
biBzdWNjZXNzLAouQiBQVFJBQ0VfUEVFSyoKcmVxdWVzdHMgcmV0dXJuIHRoZSByZXF1ZXN0ZWQg
ZGF0YSwKd2hpbGUgb3RoZXIgcmVxdWVzdHMgcmV0dXJuIHplcm8uCk9uIGVycm9yLCBhbGwgcmVx
dWVzdHMgcmV0dXJuIFwtMSwgYW5kCi5JIGVycm5vCmlzIHNldCBhcHByb3ByaWF0ZWx5LgpTaW5j
ZSB0aGUgdmFsdWUgcmV0dXJuZWQgYnkgYSBzdWNjZXNzZnVsCi5CIFBUUkFDRV9QRUVLKgpyZXF1
ZXN0IG1heSBiZSBcLTEsIHRoZSBjYWxsZXIgbXVzdCBjbGVhcgouSSBlcnJubwpiZWZvcmUgdGhl
IGNhbGwsIGFuZCB0aGVuIGNoZWNrIGl0IGFmdGVyd2FyZAp0byBkZXRlcm1pbmUgd2hldGhlciBv
ciBub3QgYW4gZXJyb3Igb2NjdXJyZWQuCi5TSCBFUlJPUlMKLlRQCi5CIEVCVVNZCihpMzg2IG9u
bHkpIFRoZXJlIHdhcyBhbiBlcnJvciB3aXRoIGFsbG9jYXRpbmcgb3IgZnJlZWluZyBhIGRlYnVn
IHJlZ2lzdGVyLgouVFAKLkIgRUZBVUxUClRoZXJlIHdhcyBhbiBhdHRlbXB0IHRvIHJlYWQgZnJv
bSBvciB3cml0ZSB0byBhbiBpbnZhbGlkIGFyZWEgaW4KdGhlIHRyYWNlcidzIG9yIHRoZSB0cmFj
ZWUncyBtZW1vcnksCnByb2JhYmx5IGJlY2F1c2UgdGhlIGFyZWEgd2Fzbid0IG1hcHBlZCBvciBh
Y2Nlc3NpYmxlLgpVbmZvcnR1bmF0ZWx5LCB1bmRlciBMaW51eCwgZGlmZmVyZW50IHZhcmlhdGlv
bnMgb2YgdGhpcyBmYXVsdAp3aWxsIHJldHVybgouQiBFSU8Kb3IKLkIgRUZBVUxUCm1vcmUgb3Ig
bGVzcyBhcmJpdHJhcmlseS4KLlRQCi5CIEVJTlZBTApBbiBhdHRlbXB0IHdhcyBtYWRlIHRvIHNl
dCBhbiBpbnZhbGlkIG9wdGlvbi4KLlRQCi5CIEVJTwouSSByZXF1ZXN0CmlzIGludmFsaWQsIG9y
IGFuIGF0dGVtcHQgd2FzIG1hZGUgdG8gcmVhZCBmcm9tIG9yCndyaXRlIHRvIGFuIGludmFsaWQg
YXJlYSBpbiB0aGUgdHJhY2VyJ3Mgb3IgdGhlIHRyYWNlZSdzIG1lbW9yeSwKb3IgdGhlcmUgd2Fz
IGEgd29yZC1hbGlnbm1lbnQgdmlvbGF0aW9uLApvciBhbiBpbnZhbGlkIHNpZ25hbCB3YXMgc3Bl
Y2lmaWVkIGR1cmluZyBhIHJlc3RhcnQgcmVxdWVzdC4KLlRQCi5CIEVQRVJNClRoZSBzcGVjaWZp
ZWQgcHJvY2VzcyBjYW5ub3QgYmUgdHJhY2VkLgpUaGlzIGNvdWxkIGJlIGJlY2F1c2UgdGhlCnRy
YWNlciBoYXMgaW5zdWZmaWNpZW50IHByaXZpbGVnZXMgKHRoZSByZXF1aXJlZCBjYXBhYmlsaXR5
IGlzCi5CUiBDQVBfU1lTX1BUUkFDRSApOwp1bnByaXZpbGVnZWQgcHJvY2Vzc2VzIGNhbm5vdCB0
cmFjZSBwcm9jZXNzZXMgdGhhdCB0aGV5CmNhbm5vdCBzZW5kIHNpZ25hbHMgdG8gb3IgdGhvc2Ug
cnVubmluZwpzZXQtdXNlci1JRC9zZXQtZ3JvdXAtSUQgcHJvZ3JhbXMsIGZvciBvYnZpb3VzIHJl
YXNvbnMuCi5cIiAKLlwiIEZJWE1FIEkgcmV3b3JrZWQgdGhlIGRpc2N1c3Npb24gb2YgaW5pdCBi
ZWxvdyB0byBub3RlCi5cIiB0aGUga2VybmVsIHZlcnNpb24gKDIuNi4yNikgd2hlbiB0aGUgYmVo
YXZpb3IgY2hhbmdlZCBmb3IKLlwiIHRyYWNpbmcgaW5pdCg4KS4gT2theT8KQWx0ZXJuYXRpdmVs
eSwgdGhlIHByb2Nlc3MgbWF5IGFscmVhZHkgYmUgYmVpbmcgdHJhY2VkLApvciAob24ga2VybmVs
cyBiZWZvcmUgMi42LjI2KSBiZQouQlIgaW5pdCAoOCkKKFBJRCAxKS4KLlRQCi5CIEVTUkNIClRo
ZSBzcGVjaWZpZWQgcHJvY2VzcyBkb2VzIG5vdCBleGlzdCwgb3IgaXMgbm90IGN1cnJlbnRseSBi
ZWluZyB0cmFjZWQKYnkgdGhlIGNhbGxlciwgb3IgaXMgbm90IHN0b3BwZWQKKGZvciByZXF1ZXN0
cyB0aGF0IHJlcXVpcmUgYSBzdG9wcGVkIHRyYWNlZSkuCi5TSCAiQ09ORk9STUlORyBUTyIKU1Zy
NCwgNC4zQlNELgouU0ggTk9URVMKQWx0aG91Z2ggYXJndW1lbnRzIHRvCi5CUiBwdHJhY2UgKCkK
YXJlIGludGVycHJldGVkIGFjY29yZGluZyB0byB0aGUgcHJvdG90eXBlIGdpdmVuLApnbGliYyBj
dXJyZW50bHkgZGVjbGFyZXMKLkJSIHB0cmFjZSAoKQphcyBhIHZhcmlhZGljIGZ1bmN0aW9uIHdp
dGggb25seSB0aGUKLkkgcmVxdWVzdAphcmd1bWVudCBmaXhlZC4KVGhpcyBtZWFucyB0aGF0IHVu
bmVlZGVkIHRyYWlsaW5nIGFyZ3VtZW50cyBtYXkgYmUgb21pdHRlZCwKdGhvdWdoIGRvaW5nIHNv
IG1ha2VzIHVzZSBvZiB1bmRvY3VtZW50ZWQKLkJSIGdjYyAoMSkKYmVoYXZpb3IuCi5cIiBGSVhN
RSBQbGVhc2UgcmV2aWV3LiBJIHJlaW5zdGF0ZWQgdGhlIGZvbGxvd2luZywgbm90aW5nIHRoZQou
XCIga2VybmVsIHZlcnNpb24gbnVtYmVyIHdoZXJlIGl0IGNlYXNlZCB0byBiZSB0cnVlCi5MUApJ
biBMaW51eCBrZXJuZWxzIGJlZm9yZSAyLjYuMjYsCi5cIiBTZWUgY29tbWl0IDAwY2Q1YzM3YWZk
NWY0MzFhYzE4NmRkMTMxNzA1MDQ4YzBhMTFmZGIKLkJSIGluaXQgKDgpLAp0aGUgcHJvY2VzcyB3
aXRoIFBJRCAxLCBtYXkgbm90IGJlIHRyYWNlZC4KLkxQClRoZSBsYXlvdXQgb2YgdGhlIGNvbnRl
bnRzIG9mIG1lbW9yeSBhbmQgdGhlIFVTRVIgYXJlYSBhcmUKcXVpdGUgb3BlcmF0aW5nLXN5c3Rl
bS0gYW5kIGFyY2hpdGVjdHVyZS1zcGVjaWZpYy4KVGhlIG9mZnNldCBzdXBwbGllZCwgYW5kIHRo
ZSBkYXRhIHJldHVybmVkLAptaWdodCBub3QgZW50aXJlbHkgbWF0Y2ggd2l0aCB0aGUgZGVmaW5p
dGlvbiBvZgouSVIgInN0cnVjdCB1c2VyIiAuCi5cIiBTZWUgaHR0cDovL2xrbWwub3JnL2xrbWwv
MjAwOC81LzgvMzc1Ci5MUApUaGUgc2l6ZSBvZiBhICJ3b3JkIiBpcyBkZXRlcm1pbmVkIGJ5IHRo
ZSBvcGVyYXRpbmctc3lzdGVtIHZhcmlhbnQKKGUuZy4sIGZvciAzMi1iaXQgTGludXggaXQgaXMg
MzIgYml0cywgZXRjLikuCi5cIiBGSVhNRSBTbywgY2FuIHdlIGp1c3QgcmVtb3ZlIHRoZSBmb2xs
b3dpbmcgdGV4dCAocmF0aGVyIHRoYW4KLlwiIGp1c3QgY29tbWVudGluZyBpdCBvdXQpPwouXCIK
LlwiIENvdmVyZWQgaW4gbW9yZSBkZXRhaWxzIGFib3ZlOiAocmVtb3ZlZCBieSBkdikKLlwiIC5M
UAouXCIgVHJhY2luZyBjYXVzZXMgYSBmZXcgc3VidGxlIGRpZmZlcmVuY2VzIGluIHRoZSBzZW1h
bnRpY3Mgb2YKLlwiIHRyYWNlZCBwcm9jZXNzZXMuCi5cIiBGb3IgZXhhbXBsZSwgaWYgYSBwcm9j
ZXNzIGlzIGF0dGFjaGVkIHRvIHdpdGgKLlwiIC5CUiBQVFJBQ0VfQVRUQUNIICwKLlwiIGl0cyBv
cmlnaW5hbCBwYXJlbnQgY2FuIG5vIGxvbmdlciByZWNlaXZlIG5vdGlmaWNhdGlvbiB2aWEKLlwi
IC5CUiB3YWl0cGlkICgyKQouXCIgd2hlbiBpdCBzdG9wcywgYW5kIHRoZXJlIGlzIG5vIHdheSBm
b3IgdGhlIG5ldyBwYXJlbnQgdG8KLlwiIGVmZmVjdGl2ZWx5IHNpbXVsYXRlIHRoaXMgbm90aWZp
Y2F0aW9uLgouXCIgLkxQCi5cIiBXaGVuIHRoZSBwYXJlbnQgcmVjZWl2ZXMgYW4gZXZlbnQgd2l0
aAouXCIgLkIgUFRSQUNFX0VWRU5UXyoKLlwiIHNldCwKLlwiIHRoZSB0cmFjZWUgaXMgbm90IGlu
IHRoZSBub3JtYWwgc2lnbmFsIGRlbGl2ZXJ5IHBhdGguCi5cIiBUaGlzIG1lYW5zIHRoZSBwYXJl
bnQgY2Fubm90IGRvCi5cIiAuQlIgcHRyYWNlIChQVFJBQ0VfQ09OVCkKLlwiIHdpdGggYSBzaWdu
YWwgb3IKLlwiIC5CUiBwdHJhY2UgKFBUUkFDRV9LSUxMKS4KLlwiIC5CUiBraWxsICgyKQouXCIg
d2l0aCBhCi5cIiAuQiBTSUdLSUxMCi5cIiBzaWduYWwgY2FuIGJlIHVzZWQgaW5zdGVhZCB0byBr
aWxsIHRoZSB0cmFjZWUKLlwiIGFmdGVyIHJlY2VpdmluZyBvbmUgb2YgdGhlc2UgbWVzc2FnZXMu
Ci5cIiAuTFAKVGhpcyBwYWdlIGRvY3VtZW50cyB0aGUgd2F5IHRoZQouQlIgcHRyYWNlICgpCmNh
bGwgd29ya3MgY3VycmVudGx5IGluIExpbnV4LgpJdHMgYmVoYXZpb3IgZGlmZmVycyBub3RpY2Vh
Ymx5IG9uIG90aGVyIGZsYXZvcnMgb2YgVU5JWC4KSW4gYW55IGNhc2UsIHVzZSBvZgouQlIgcHRy
YWNlICgpCmlzIGhpZ2hseSBzcGVjaWZpYyB0byB0aGUgb3BlcmF0aW5nIHN5c3RlbSBhbmQgYXJj
aGl0ZWN0dXJlLgouU0ggQlVHUwpPbiBob3N0cyB3aXRoIDIuNiBrZXJuZWwgaGVhZGVycywKLkIg
UFRSQUNFX1NFVE9QVElPTlMKaXMgZGVjbGFyZWQgd2l0aCBhIGRpZmZlcmVudCB2YWx1ZSB0aGFu
IHRoZSBvbmUgZm9yIDIuNC4KVGhpcyBsZWFkcyB0byBhcHBsaWNhdGlvbnMgY29tcGlsZWQgd2l0
aCAyLjYga2VybmVsCmhlYWRlcnMgZmFpbGluZyB3aGVuIHJ1biBvbiAyLjQga2VybmVscy4KVGhp
cyBjYW4gYmUgd29ya2VkIGFyb3VuZCBieSByZWRlZmluaW5nCi5CIFBUUkFDRV9TRVRPUFRJT05T
CnRvCi5CUiBQVFJBQ0VfT0xEU0VUT1BUSU9OUyAsCmlmIHRoYXQgaXMgZGVmaW5lZC4KLkxQCkdy
b3VwLXN0b3Agbm90aWZpY2F0aW9ucyBhcmUgc2VudCB0byB0aGUgdHJhY2VyLCBidXQgbm90IHRv
IHJlYWwgcGFyZW50LgpMYXN0IGNvbmZpcm1lZCBvbiAyLjYuMzguNi4KLkxQCklmIGEgdGhyZWFk
IGdyb3VwIGxlYWRlciBpcyB0cmFjZWQgYW5kIGV4aXRzIGJ5IGNhbGxpbmcKLkJSIF9leGl0ICgy
KSwKLlwiIE5vdGUgZnJvbSBEZW55cyBWbGFzZW5rbzoKLlwiICAgICBIZXJlICJleGl0cyIgbWVh
bnMgYW55IGtpbmQgb2YgZGVhdGggLSBfZXhpdCwgZXhpdF9ncm91cCwKLlwiICAgICBzaWduYWwg
ZGVhdGguIFNpZ25hbCBkZWF0aCBhbmQgZXhpdF9ncm91cCBjYXNlcyBhcmUgdHJpdmlhbCwKLlwi
ICAgICB0aG91Z2g6IHNpbmNlIHNpZ25hbCBkZWF0aCBhbmQgZXhpdF9ncm91cCBraWxsIGFsbCBv
dGhlciB0aHJlYWRzCi5cIiAgICAgdG9vLCAidW50aWwgYWxsIG90aGVyIHRocmVhZHMgZXhpdCIg
dGhpbmcgaGFwcGVucyByYXRoZXIgc29vbgouXCIgICAgIGluIHRoZXNlIGNhc2VzLiBUaGVyZWZv
cmUsIG9ubHkgX2V4aXQgcHJlc2VudHMgb2JzZXJ2YWJseQouXCIgICAgIHB1enpsaW5nIGJlaGF2
aW9yIHRvIHB0cmFjZSB1c2VyczogdGhyZWFkIGxlYWRlciBfZXhpdCdzLAouXCIgICAgIGJ1dCBX
SUZFWElURUQgaXNuJ3QgcmVwb3J0ZWQhIFdlIGFyZSB0cnlpbmcgdG8gZXhwbGFpbiBoZXJlCi5c
IiAgICAgd2h5IGl0IGlzIHNvLgphCi5CIFBUUkFDRV9FVkVOVF9FWElUCnN0b3Agd2lsbCBoYXBw
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
--e89a8f50320c72af9704b9e25dc7--
