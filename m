Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab0D3Sdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:33:40 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:46255 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030Ab0D3Sdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:33:33 -0400
Date: Fri, 30 Apr 2010 12:07:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow
 multiple splats
Message-ID: <20100430100749.GC14202@elte.hu>
References: <20100421200150.GA3818@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421200150.GA3818@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> This patchset contains four RCU lockdep splat fixes, courtesy of David 
> Howells, Peter Zijlstra, and Trond Myklebust, [...]

I've applied #1 and #2 - but shouldnt #4 and #5 go via the NFS tree?

> [...] as well as an enhancement by Lai Jiangshan that permits collecting 
> more than one RCU lockdep splat per boot.

Hm, this #3 patch i disagree with quite fundamentally: one of the big virtues 
of lockdep is that it complains only once and then shuts up and lets the 
system work. It allows distro debug kernels to have lockdep enabled, etc.

One bugreport per bootup per user is the most we can expect really. Not 
disabling it risks getting a stream of repeat messages, annoyed testers and 
gives us _less_ bugreports in the end.

Also, often the _first_ warning is the most reliable one - sometimes there's 
interactions, and the first bug causing a second warning as well, etc. So 
reporting just the highest-quality (i.e. first) issue we detect is the best 
approach.

Thanks,

	Ingo
