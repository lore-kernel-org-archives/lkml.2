Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab1IIUDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:03:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab1IIUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:03:15 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pedro Alves <pedro@codesourcery.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Fri, 9 Sep 2011 22:03:10 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <1315587343.5036.6.camel@dhcp-25-63.brq.redhat.com> <201109091809.57272.pedro@codesourcery.com>
In-Reply-To: <201109091809.57272.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109092203.10062.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 19:09, Pedro Alves wrote:
> > This would be a _very_ minor improvement, so tiny it's not worth
> > bothering with. Let me show you the real-world code (part of strace
> > source) which skips over unneeded PTRACE_EVENT_EXEC:
> > 
> >                 if ((status >> 16) != 0)
> >                         /* Ptrace event (we ignore all of them for now) */
> >                         goto restart_tracee_with_sig_0;
> > 
> > Yes. That is all.
> > It probably compiles into just two assembly instructions.
> 
> WTH?  I'm talking about _not forcing the tracee to stop_.  Let
> me repeat.  NOT FORCING THE TRACEE TO STOP.

No need to shout.

execve is such a rare syscall the one extra stop on it is not
going to be a problem.

> And about not needing to handle the magic unadorned SIGTRAP.
> The magic unadorned post-exec SIGTRAP does not have `status & 0xff00'
> set, it is not a ptrace event!

What SIGTRAP? With PTRACE_O_TRACEEXEC, there is no SIGTRAP.

> If we don't disable the magic SIGTRAP, there's no way for a
> tracer to do a very non-invasive SEIZE, say, a GDB mode that
> only cares to let the tracer run free to catch SIGSEGVs
> in some child, while later on during the run, the user remembers
> to set a breakpoint.  At that point the tracer needs to catch
> exec events, so it'd enable TRACE_O_EVENTEXEC.  Getting rid of
> the SIGTRAP gets rid of the spurious stops when TRACE_O_EVENTEXEC
> is not enabled.

This part I don't understand.

(btw, PTRACE_O_TRACEEXEC, not TRACE_O_EVENTEXEC).

-- 
vda
