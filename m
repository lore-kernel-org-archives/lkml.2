Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935494Ab1ETJ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:27:40 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:38505 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935470Ab1ETJ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:27:39 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Fri, 20 May 2011 10:27:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105200000.18310.pedro@codesourcery.com> <20110520090718.GC31426@htj.dyndns.org>
In-Reply-To: <20110520090718.GC31426@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201027.36688.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 10:07:18, Tejun Heo wrote:
> Hello, Pedro.
> 
> On Fri, May 20, 2011 at 12:00:17AM +0100, Pedro Alves wrote:
> > > > UUIC, that opens a race where between SEIZEing and
> > > > SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
> > > > fork/vfork/clone/exec, without the tracer getting the
> > > > nice corresponding PTRACE_EVENT_ events.
> 
> Does it matter?  The order of execution isn't even well defined
> without synchronization border.  If you want full synchronization, you
> can INTERRUPT tracee.

The point I was trying to raise was not about the order of
execution, but about letting the old pre-nice PTRACE_EVENT_
events quirks stick through.

> 
> >  SEIZE,execvd,INTERRUPT (SETOPTS on interrupt)
> > 
> > will make the tracer see a SIGTRAP that 
> > 
> >  execvd,SEIZE,INTERRUPT
> > 
> > nor
> > 
> >  SEIZE,SETOPTS,execvd (SETOPTS on interrupt)
> > 
> > would cause, isn't it?
> 
> Yes, SIGTRAP on exec(2) is nasty but also is scheduled to be removed
> if SEIZED.

Okay, good to hear that.  Looks like the tracer can do:

 SEIZE,execve,SETOPTS,'readlink /proc/pid/exe'

and pretend it SEIZED after the execve.

I'm happy for now.

Thanks.

-- 
Pedro Alves
