Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab0EMQGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:06:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0EMQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:06:13 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=NJ9r1kXiz5oA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=huCS_TsPItG8q3Y6WTUA:9 a=DqI_CeLOckSKhudgOXa0KVc6HgUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: ftrace syscalls, PowerPC: Fixes and PowerPC raw syscall
 tracepoint implementation
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>
In-Reply-To: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 12:06:11 -0400
Message-ID: <1273766771.27703.1069.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

I'm fine with these patches, but since you mainly did the syscall work,
I'll let you take them.

The patches that touch the PowerPC code needs an acked-by from Ben or
Paul.

-- Steve


On Thu, 2010-05-13 at 17:43 +1000, Ian Munsie wrote:
> This patch series implements raw system call tracepoints on PowerPC that can be
> used with ftrace and perf. Some problems with the generic ftrace syscall
> tracepoint code have also been addressed.
> 
> The patches are based upon Ben's powerpc/next tree merged with tip/tracing/core
> 
> Patch #1 removes all ftrace syscall events that fail to map the system call
> name from the system call metadata with the system call's number, preventing
> the events which will not work from showing up in perf list and removing them
> from /sys/kernel/debug/tracing/events/syscalls.
> 
> Patches #2 and #3 allow for archs with unusual system call tables (#2) or
> unusual symbol names (#3) to override the appropriate functions so that they
> can still work with ftrace syscalls.
> 
> Patch #4 implements the actual raw system call tracepoints that ftrace syscalls
> builds upon, allowing all of the system calls to be used with the raw_syscalls
> events category and most to be used with the syscalls category.
> 
> 
> Not all the raw_syscalls are currently mapped to ftrace syscalls - the syscalls
> defined in /arch/powerpc/include/asm/syscalls.h do not use the SYSCALL_DEFINE
> class of macros and as such have no meta data, likewise some of the ppc_*
> syscalls have assembly wrappers. These are on their way, but I wanted to put
> the work I have done so far out first.
> 
> Some of those syscalls have different return types than the __SYSCALL_DEFINE
> macro uses (unsigned long, int, time_t) and some have different prefixes (ppc,
> ppc64) - I didn't particularly want to change them straight over without asking
> the list first, and I certainly don't want to change the return types. I see
> that Jason Baron ran into similar issues, but his "add compat syscall support"
> patches have yet to be merged, and do not tackle the differing return types.
> 


