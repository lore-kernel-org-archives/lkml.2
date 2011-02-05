Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1BELwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 06:52:00 -0500
Received: from eru.sfritsch.de ([188.40.99.202]:44442 "EHLO eru.sfritsch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1BELv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 06:51:58 -0500
Date: Sat, 5 Feb 2011 12:51:54 +0100 (CET)
From: Stefan Fritsch <sf@sfritsch.de>
X-X-Sender: stf@eru.sfritsch.de
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Eric Paris <eparis@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, agl@google.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
In-Reply-To: <20110204170448.GA1808@nowhere>
Message-ID: <alpine.DEB.1.10.1102051243480.26628@eru.sfritsch.de>
References: <1294867725.3237.230.camel@localhost.localdomain> <1296665124.3145.17.camel@localhost.localdomain> <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de> <20110203231051.GA1840@nowhere> <1296784230.3145.44.camel@localhost.localdomain>
 <1296829915.26581.658.camel@laptop> <1296836962.3145.75.camel@localhost.localdomain> <20110204170448.GA1808@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Frederic Weisbecker wrote:
> Note it's not about tracing here. It's about abstracting some tracing
> features to make them standalone and usable outside tracing.
>
> But yeah, now that I consider the fact that checks on pointers are
> racy until objects are resolved (got my first security lesson), such
> deep filtering up to dereferencing pointers is then pointless.
>
> Now there are still immediate values for which there is still a point
> (filtering fd, filtering opening mode, etc...).
>
>>  Do we have a user that can articulate a need for greater
>> flexibility in their use of such a hardening tool?
>
> So yeah, indeed we probably need to get more usecases to consider it.

A really major use case is socketcall(2). All socket related syscalls 
(accept, bind, connect, receivemsg, ...) are implemented as socketcall 
with an appropriate argument. There will be many cases where you want a 
sandboxed process to be able to do recvmsg(2) to receive new file 
descriptors over an already open unix-domain socket from a broker process. 
But you may want to disallow other socket operations, especially listen, 
accept, and connect.

Of course one could also add some special case handling for socketcall 
in seccomp instead of using the full filtering.

Cheers,
Stefan
