Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1BDQhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:37:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1BDQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:37:22 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Eric Paris <eparis@redhat.com>
To: Stefan Fritsch <sf@sfritsch.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 04 Feb 2011 11:36:28 -0500
In-Reply-To: <201102032306.34251.sf@sfritsch.de>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <1296665124.3145.17.camel@localhost.localdomain>
	 <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296837393.3145.80.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 23:06 +0100, Stefan Fritsch wrote:

> - only allow syscalls in the mode (non-compat/compat) that the prctl 
> call was made in

This is what I was thinking.  If it was a compat task when it dropped
things from the set of syscalls we should implicitly deny all non-compat
syscalls, and vice versa.

> - deny exec of setuid/setgid binaries
> - deny exec of binaries with filesystem capabilities

I think both of these are wrong to try to address here.  The right way
to handle these is to

1) set prctl(SECBIT_NOROOT)
2) drop all caps from the bset, pP, pE, and pI
3) make sure the setuid(2) syscall (not to be confused with SETUID
filesystem bit) is not in the set of allowed syscalls.  Thus rendering
suid and file with fcaps irrelevant.

-Eric

