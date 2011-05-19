Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1ESXAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:00:23 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:53088 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1ESXAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:00:21 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Fri, 20 May 2011 00:00:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105192031.33569.pedro@codesourcery.com> <201105200042.12230.vda.linux@googlemail.com>
In-Reply-To: <201105200042.12230.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105200000.18310.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011 23:42:12, Denys Vlasenko wrote:
> On Thursday 19 May 2011 21:31, Pedro Alves wrote:
> > On Thursday 19 May 2011 15:17:28, Tejun Heo wrote:
> > > But making SEIZE not trigger INTERRUPT and SETOPTIONS without
> > > requiring TRACED don't seem too difficult.  Jan, would that be enough?
> > > Oleg, what do you think?
> > 
> > UUIC, that opens a race where between SEIZEing and
> > SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
> > fork/vfork/clone/exec, without the tracer getting the
> > nice corresponding PTRACE_EVENT_ events.
> 
> SEIZE,fork-in-tracee,INTERRUPT sequence is indistinguishable
> from SEIZE happening two microseconds later:
> 
> fork-in-tracee,SEIZE,INTERRUPT

 SEIZE,execvd,INTERRUPT (SETOPTS on interrupt)

will make the tracer see a SIGTRAP that 

 execvd,SEIZE,INTERRUPT

nor

 SEIZE,SETOPTS,execvd (SETOPTS on interrupt)

would cause, isn't it?

Now, if it were possible for the tracer to set the
default OPTS _before_ PTRACE_ATTACH/PTRACE_SEIZE...

> 
> > In GDBs case, GDB will want to poke at memory
> > right after attaching
> 
> ...where "right after attaching" is defined as "when the first ptrace-stop
> is reported". Which will happen very soon.

Hmm?  Why would it happen very soon?  Isn't the point of SEIZE not
interrupting that you'd not get any INTERRUPT or stop at all?
Where is the ptrace-stop coming from?

-- 
Pedro Alves
