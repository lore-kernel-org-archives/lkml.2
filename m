Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0GHURt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:17:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0GHURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:17:47 -0400
Date: Thu, 8 Jul 2010 16:17:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv8 2.6.35-rc4-tip 0/12]  Uprobes Patches:
Message-ID: <20100708201704.GA30946@infradead.org>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't actually get perf to build with these patches applied ontop
of the -tip tree master branch:

    CC util/probe-finder.o
til/probe-finder.c: In function 'alloc_trace_arg_ref':
util/probe-finder.c:412: error: invalid application of 'sizeof' to incomplete type 'struct kprobe_trace_arg_ref' 
util/probe-finder.c:414: error: dereferencing pointer to incomplete type
cc1: warnings being treated as errors
util/probe-finder.c: In function 'convert_variable_location':
util/probe-finder.c:428: error: initialization from incompatible pointertype
util/probe-finder.c:444: error: dereferencing pointer to incomplete type
util/probe-finder.c:445: error: dereferencing pointer to incomplete type
util/probe-finder.c:447: error: dereferencing pointer to incomplete type
util/probe-finder.c:448: error: dereferencing pointer to incomplete type
util/probe-finder.c:449: error: dereferencing pointer to incomplete type
util/probe-finder.c:489: error: dereferencing pointer to incomplete type
util/probe-finder.c:490: error: dereferencing pointer to incomplete type
util/probe-finder.c:494: error: dereferencing pointer to incomplete type
util/probe-finder.c:495: error: dereferencing pointer to incomplete type
util/probe-finder.c: At top level:
util/probe-finder.c:503: error: 'struct kprobe_trace_arg' declared inside parameter list
util/probe-finder.c:503: error: its scope is only this definition or declaration, which is probably not what you want
util/probe-finder.c: In function 'convert_variable_type':
util/probe-finder.c:505: error: dereferencing pointer to incomplete type
util/probe-finder.c:513: error: dereferencing pointer to incomplete type
util/probe-finder.c:514: error: dereferencing pointer to incomplete type
util/probe-finder.c:541: error: dereferencing pointer to incomplete type
util/probe-finder.c:543: error: invalid application of 'sizeof' to incomplete type 'struct kprobe_trace_arg_ref' 
util/probe-finder.c:556: error: dereferencing pointer to incomplete type
util/probe-finder.c:557: error: dereferencing pointer to incomplete type
util/probe-finder.c:579: error: dereferencing pointer to incomplete type
util/probe-finder.c:580: error: dereferencing pointer to incomplete type
util/probe-finder.c: In function 'convert_variable_fields':
util/probe-finder.c:617: error: invalid application of 'sizeof' to incomplete type 'struct kprobe_trace_arg_ref' 
util/probe-finder.c: In function 'convert_variable':
util/probe-finder.c:718: error: passing argument 2 of 'convert_variable_type' from incompatible pointer type
util/probe-finder.c:501: note: expected 'struct kprobe_trace_arg *' but
argument is of type 'struct probe_trace_arg *'
make: *** [util/probe-finder.o] Error 1
hch@brick:~/work/linux-2.6-tip/tools/perf$  

