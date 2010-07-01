Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0GAIUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:20:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab0GAIUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:20:46 -0400
Date: Thu, 1 Jul 2010 10:19:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCHv7 2.6.35-rc3-tip 0/11]  Uprobes Patches:
Message-ID: <20100701081942.GA19826@elte.hu>
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6>
 <20100701050216.GI23231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701050216.GI23231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> I have addressed all comments to the uprobes patchset.  We have few todos 
> (most of them are features over the current code) which I plan to work in 
> the immediate future.
> 
> So would it be possible for this patchset to be picked into the tip tree. 
> Getting these patches merged into the tip tree would help in getting more 
> comments/feedback and testing.

If Masami-san, PeterZ and Arnaldo is happy with it being tried in its current 
form then we could try it.

Assuming everyone is reasonably happy about the code, here are some open areas 
as i see them, before we can think about pushing things from -tip towards 
upstream:

- One thing i havent seen is the ability to 'list' potential probe points:
  i.e. function names. Often the user will not know precisely where to look 
  and what to type. This leaves our probe capability under-utilized in 
  practice.

- On a similar note, it might also make sense to extend the Newt interface to 
  perf report to integrate probes: if a function looks high-overhead, then a 
  probe point could be inserted and the app could be traced straight away. We 
  already allow per function actions in the Newt interface, such as assembly 
  annotation - the adding of a probe point would be quite useful.

- [ Optional: Another interesting area to look at would be the scripting 
    engine: allow trace scripts to insert probes if they are not present yet. ]

- Plus the security model is an open question as well. Right now it's
  root-only, but it would make sense to allow users to insert probes into 
  their own apps. This brings up the next point:

- Proper syscall integration and more unification with kprobes and with the 
  TRACE_EVENT() universe. As far as API design goes, 
  /sys/kernel/debug/tracing/uprobe_events is quite sucky as a concept.

Thanks,

	Ingo
