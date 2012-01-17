Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2AQLXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 06:23:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab2AQLXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 06:23:05 -0500
Date: Tue, 17 Jan 2012 12:22:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 7/9] tracing: uprobes trace_event interface
Message-ID: <20120117112239.GA23859@elte.hu>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120117092838.GB10397@elte.hu>
 <20120117102231.GB15447@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117102231.GB15447@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Srikar, rebased commits like this one:

  c5af743: rcu: Introduce raw SRCU read-side primitives

are absolutely inacceptable:

 commit c5af7439f322db86e347991e184b95dd80676967
 Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 Date:   Sun Oct 9 15:13:11 2011 -0700

    rcu: Introduce raw SRCU read-side primitives

    ...

    Requested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

If you pull a commit from Paul into your tree then you must 
never rebase it. If you applied Paul's commit out of email then 
you should add a Signed-off-by, not a Tested-by tag at the end.

Also, please test whether it works when merged to latest -tip, 
there's been various RCU changes in this area. AFAICS these 
read-side primitives are already upstream via:

  0c53dd8b3140: rcu: Introduce raw SRCU read-side primitives

so pulling your tree would break the build.

Thanks,

	Ingo
