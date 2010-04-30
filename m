Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0D3RD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:03:57 -0400
Received: from toq9-srv.bellnexxia.net ([209.226.175.116]:33522 "EHLO
	toq9-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab0D3RDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO+S2ktGGNqG/2dsb2JhbACdH3K+fYJmgiwE
Date: Fri, 30 Apr 2010 11:33:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow
	multiple splats
Message-ID: <20100430153334.GA19672@Krystal>
References: <20100421200150.GA3818@linux.vnet.ibm.com> <20100430100749.GC14202@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100430100749.GC14202@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:31:55 up 23 days,  1:25,  3 users,  load average: 0.51, 0.33,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This patchset contains four RCU lockdep splat fixes, courtesy of David 
> > Howells, Peter Zijlstra, and Trond Myklebust, [...]
> 
> I've applied #1 and #2 - but shouldnt #4 and #5 go via the NFS tree?
> 
> > [...] as well as an enhancement by Lai Jiangshan that permits collecting 
> > more than one RCU lockdep splat per boot.
> 
> Hm, this #3 patch i disagree with quite fundamentally: one of the big virtues 
> of lockdep is that it complains only once and then shuts up and lets the 
> system work. It allows distro debug kernels to have lockdep enabled, etc.
> 
> One bugreport per bootup per user is the most we can expect really. Not 
> disabling it risks getting a stream of repeat messages, annoyed testers and 
> gives us _less_ bugreports in the end.
> 
> Also, often the _first_ warning is the most reliable one - sometimes there's 
> interactions, and the first bug causing a second warning as well, etc. So 
> reporting just the highest-quality (i.e. first) issue we detect is the best 
> approach.

I recommend creating a kernel command line parameter that would tweak
the number of messages printed by lockdep. The default would indeed by 1
message, but people in a debugging marathon can specify a larger value
so they won't have to reboot between each individual lockdep error.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
