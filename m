Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0HBJ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:29:35 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38922 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0HBJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:29:34 -0400
X-AuditID: b753bd60-a92d1ba000005dcc-e5-4c568ffa46ad
Message-ID: <4C568FF7.9070300@hitachi.com>
Date: Mon, 02 Aug 2010 18:29:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event interface
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6> <4C510BCE.4010704@hitachi.com> <20100802022055.GB5581@nowhere> <4C563F44.9080300@hitachi.com> <20100802074619.GA5292@nowhere> <20100802075637.GB24085@elte.hu> <20100802080032.GA12078@infradead.org>
In-Reply-To: <20100802080032.GA12078@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 02, 2010 at 09:56:37AM +0200, Ingo Molnar wrote:
>>>> Hmm, I disagree with it, because both Kprobes and Uprobes provides
>>>> APIs for modules too.
>>> I'm not sure there is a point in maintaining a leightweight version for out 
>>> of tree code. These modules could just select kprobes/uprobes events as 
>>> well.
>>>
>>> As you prefer, that was just a suggestion to make it more simple.
>> The upstream policy always was that out of tree code does not exist as far as 
>> the kernel is concerned. So it is wrong to make the kernel crappier while 
>> helping out of tree code.
> 
> Indeed.  In addition to that the current version of uprobes does not
> actually have any exported symbols.

Ah, indeed. :-(

And then, it conflicts with the description about uprobes in
Documentation/uprobes.txt:

> +Uprobes-based instrumentation can be packaged as a kernel
> +module.  In the simplest case, the module's init function installs
> +("registers") one or more probes, and the exit function unregisters
> +them.

So, that could be a bug.

Anyway, at least kprobes has some sample modules under samples/kprobes/.
Aren't they in-tree consumers of kprobes?

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
