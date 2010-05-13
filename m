Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0ENAUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:20:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:51913 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0ENAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:20:52 -0400
Subject: Re: ftrace syscalls, PowerPC: Fixes and PowerPC raw syscall
 tracepoint implementation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: rostedt@goodmis.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@lists.ozlabs.org, Jason Baron <jbaron@redhat.com>
In-Reply-To: <1273766771.27703.1069.camel@gandalf.stny.rr.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
	 <1273766771.27703.1069.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 09:55:18 +1000
Message-ID: <1273794918.21352.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:06 -0400, Steven Rostedt wrote:
> Frederic,
> 
> I'm fine with these patches, but since you mainly did the syscall work,
> I'll let you take them.
> 
> The patches that touch the PowerPC code needs an acked-by from Ben or
> Paul.

Done :-)

Cheers,
Ben.

> -- Steve
> 
> 
> On Thu, 2010-05-13 at 17:43 +1000, Ian Munsie wrote:
> > This patch series implements raw system call tracepoints on PowerPC that can be
> > used with ftrace and perf. Some problems with the generic ftrace syscall
> > tracepoint code have also been addressed.
> > 
> > The patches are based upon Ben's powerpc/next tree merged with tip/tracing/core
> > 
> > Patch #1 removes all ftrace syscall events that fail to map the system call
> > name from the system call metadata with the system call's number, preventing
> > the events which will not work from showing up in perf list and removing them
> > from /sys/kernel/debug/tracing/events/syscalls.
> > 
> > Patches #2 and #3 allow for archs with unusual system call tables (#2) or
> > unusual symbol names (#3) to override the appropriate functions so that they
> > can still work with ftrace syscalls.
> > 
> > Patch #4 implements the actual raw system call tracepoints that ftrace syscalls
> > builds upon, allowing all of the system calls to be used with the raw_syscalls
> > events category and most to be used with the syscalls category.
> > 
> > 
> > Not all the raw_syscalls are currently mapped to ftrace syscalls - the syscalls
> > defined in /arch/powerpc/include/asm/syscalls.h do not use the SYSCALL_DEFINE
> > class of macros and as such have no meta data, likewise some of the ppc_*
> > syscalls have assembly wrappers. These are on their way, but I wanted to put
> > the work I have done so far out first.
> > 
> > Some of those syscalls have different return types than the __SYSCALL_DEFINE
> > macro uses (unsigned long, int, time_t) and some have different prefixes (ppc,
> > ppc64) - I didn't particularly want to change them straight over without asking
> > the list first, and I certainly don't want to change the return types. I see
> > that Jason Baron ran into similar issues, but his "add compat syscall support"
> > patches have yet to be merged, and do not tackle the differing return types.
> > 
> 


