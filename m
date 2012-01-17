Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2AQMG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:06:28 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35319 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2AQMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:06:25 -0500
Date: Tue, 17 Jan 2012 17:27:05 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
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
Message-ID: <20120117115705.GD15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120117092838.GB10397@elte.hu>
 <20120117102231.GB15447@linux.vnet.ibm.com>
 <20120117112239.GA23859@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120117112239.GA23859@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011712-6148-0000-0000-000002AFED0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Srikar, rebased commits like this one:
> 
>   c5af743: rcu: Introduce raw SRCU read-side primitives
> 
> are absolutely inacceptable:
> 

Okay, I wasnt sure whats the best way for me to expose a tree such that
people who just use my tree to try (without basing on any other trees
except Linus) can build and use uprobes but people who already have this
commit arent affected by me having this commit.

So couple of people did tell me that git was intelligent enuf that if
the commit was already in, it would create a empty commit. 

do you have suggestions on how to work around such situations in future?

>  commit c5af7439f322db86e347991e184b95dd80676967
>  Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  Date:   Sun Oct 9 15:13:11 2011 -0700
> 
>     rcu: Introduce raw SRCU read-side primitives
> 
>     ...
> 
>     Requested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> If you pull a commit from Paul into your tree then you must 
> never rebase it. If you applied Paul's commit out of email then 
> you should add a Signed-off-by, not a Tested-by tag at the end.

I actually cherry-picked commit from your tree i.e -tip. 
The Tested-by tag was added by Paul after I confirmed to him that it
works.  Even the commit 0c53dd8b3140: that you refer has the same tags.

> 
> Also, please test whether it works when merged to latest -tip, 
> there's been various RCU changes in this area. AFAICS these 
> read-side primitives are already upstream via:
> 
>   0c53dd8b3140: rcu: Introduce raw SRCU read-side primitives
> 
> so pulling your tree would break the build.

I had used v3.2 as a base for my tree and 0c53dd8b3140: was not part of
that tag. Now that its gone into mainline, I will drop the commit.

-- 
Thanks and Regards
Srikar

