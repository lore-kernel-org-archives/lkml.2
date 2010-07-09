Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab0GIHSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:18:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0GIHSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:18:35 -0400
Date: Fri, 9 Jul 2010 09:17:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100709071751.GC10743@elte.hu>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171225.29165.28806.sendpatchset@localhost6.localdomain6>
 <20100708202057.GC30946@infradead.org>
 <20100709055644.GD26884@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709055644.GD26884@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=BAYES_00,FS_TIP_DDD autolearn=no SpamAssassin version=3.2.5
	0.1 FS_TIP_DDD             Phrase: subject = tip ddd
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> 
> > > Show all potential probes in a process by pid 21106 across all dsos
> > > # perf probe -S -p 21106 | tail
> > 
> > Again, a file based interface would be much more useful.  E.g. what
> > possible probe points do I have in my qemu binary.
> 
> Right, Currently perf probe needs -p option because it depend on
> thread->map_groups for listing the dsos and its functions.
> 
> I am not sure if perf already has ability to list functions in a file esp if 
> we dont have dwarf information in that file. If perf has the ability I will 
> reuse it here or will try implementing one.

Excellent - this would increase usability very visibly.

People fundamentally like to work in the ASCII space: command names, function 
names, etc. People like to query these spaces to figure out what's available 
and use wildcards to define categories or limit queries.

PIDs and addresses are useful too - but it's mostly for computers or for 
odd-one-out cases: tools and the occasional need-something-on-the-PID-level 
lowlevel workflow.

Thanks,

	Ingo
