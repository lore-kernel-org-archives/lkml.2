Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0GIOOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:14:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:53987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0GIOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:14:37 -0400
Date: Fri, 9 Jul 2010 11:13:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
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
Subject: Re: [PATCHv8 2.6.35-rc4-tip 12/12] perf: Show Potential probe points.
Message-ID: <20100709141335.GG5776@ghostprotocols.net>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171225.29165.28806.sendpatchset@localhost6.localdomain6>
 <20100708202057.GC30946@infradead.org>
 <20100709055644.GD26884@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709055644.GD26884@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 09, 2010 at 11:26:44AM +0530, Srikar Dronamraju escreveu:
> > > Show all potential probes in a process by pid 21106 across all dsos
> > > # perf probe -S -p 21106 | tail

> > Again, a file based interface would be much more useful.  E.g. what
> > possible probe points do I have in my qemu binary.

> Right, Currently perf probe needs -p option because it depend on
> thread->map_groups for listing the dsos and its functions.

> I am not sure if perf already has ability to list functions in a file
> esp if we dont have dwarf information in that file. If perf has the
> ability I will reuse it here or will try implementing one.

> Arnaldo, Do you know offhand if perf already has the ability to list
> functions in a file (with / without dwarf info).

Definetely, it actually doesn't use DWARF at all, its just the
symtabs that are used. It prefers -debuginfo packages because those have
richer symtabs, but if just the stripped file is used it will try to use
.dynsym, etc.

Look at tools/perf/builtin-test.c, it has a regression test for the
symbol lib, should be enough.

- Arnaldo
