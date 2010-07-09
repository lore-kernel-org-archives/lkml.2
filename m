Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0GIGEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:04:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53744 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0GIGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:04:31 -0400
Date: Fri, 9 Jul 2010 11:26:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv8 2.6.35-rc4-tip 12/12]  perf: Show Potential probe
 points.
Message-ID: <20100709055644.GD26884@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171225.29165.28806.sendpatchset@localhost6.localdomain6>
 <20100708202057.GC30946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100708202057.GC30946@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Show all potential probes in a process by pid 21106 across all dsos
> > # perf probe -S -p 21106 | tail
> 
> Again, a file based interface would be much more useful.  E.g. what
> possible probe points do I have in my qemu binary.

Right, Currently perf probe needs -p option because it depend on
thread->map_groups for listing the dsos and its functions.

I am not sure if perf already has ability to list functions in a file
esp if we dont have dwarf information in that file. If perf has the
ability I will reuse it here or will try implementing one.

Arnaldo, Do you know offhand if perf already has the ability to list
functions in a file (with / without dwarf info).

> 
> Btw, this doesn't mean I want to see the PID based variant removed, it
> can be very useful for debugging long running processes.  I just don't
> think it's the most important / conveniant one.

Agree. 

--
Thanks and Regards
Srikar
