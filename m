Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1BGMZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:25:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:58126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1BGMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:25:07 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stefan Fritsch <sf@sfritsch.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, agl@google.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>
In-Reply-To: <alpine.DEB.1.10.1102051243480.26628@eru.sfritsch.de>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <1296665124.3145.17.camel@localhost.localdomain>
	 <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de>
	 <20110203231051.GA1840@nowhere>
	 <1296784230.3145.44.camel@localhost.localdomain>
	 <1296829915.26581.658.camel@laptop>
	 <1296836962.3145.75.camel@localhost.localdomain>
	 <20110204170448.GA1808@nowhere>
	 <alpine.DEB.1.10.1102051243480.26628@eru.sfritsch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 13:26:09 +0100
Message-ID: <1297081569.13327.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-05 at 12:51 +0100, Stefan Fritsch wrote:

> A really major use case is socketcall(2). All socket related syscalls 
> (accept, bind, connect, receivemsg, ...) are implemented as socketcall 
> with an appropriate argument. There will be many cases where you want a 
> sandboxed process to be able to do recvmsg(2) to receive new file 
> descriptors over an already open unix-domain socket from a broker process. 
> But you may want to disallow other socket operations, especially listen, 
> accept, and connect.
> 
> Of course one could also add some special case handling for socketcall 
> in seccomp instead of using the full filtering.

That looks like a perfect use-case for the LSM bits, attach some state
to both the fd object and the task object and if they don't match, don't
allow the action.



